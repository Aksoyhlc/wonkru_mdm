import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:uuid/v7.dart';
import 'package:wonkrumdm/Core/Constants/Enums/log_level.dart';
import 'package:wonkrumdm/Data/DataSources/Remote/log_api.dart';
import 'package:wonkrumdm/Data/Models/Core/log_entry.dart';
import 'package:wonkrumdm/Data/Models/Core/wlog_config.dart';

class WLog with WidgetsBindingObserver {
  WLog._();

  static final WLog _instance = WLog._();

  static const _methodChannel = MethodChannel('wonkru/log');
  static const _eventChannel = EventChannel('wonkru/log/events');

  static late WLogConfig _config;
  static bool _initialized = false;
  static bool _flushing = false;
  static StreamSubscription<dynamic>? _eventSubscription;
  static final LogApi _logApi = LogApi();

  static final List<LogEntry> _ramRecentLogs = <LogEntry>[];
  static const int _ramRecentLogMax = 20;

  static Future<void> init({WLogConfig? config}) async {
    if (config == null) {
      config = WLogConfig();
    }

    WLog.updateConfig(config);

    if (_initialized) return;
    _config = config;
    _initialized = true;

    WidgetsBinding.instance.addObserver(_instance);

    _setupErrorHandlers();
    try {
      _listenEvents();
    } catch (e) {
      if (kDebugMode) debugPrint('[WLog] EventChannel init failed: $e');
    }

    if (_config.remoteEnabled) {
      await flush();
    }
  }

  static void updateConfig(WLogConfig config) {
    _config = config;
    if (_initialized) {
      try {
        _methodChannel.invokeMethod('updateConfig', config.toJson()).catchError((_) {});
      } catch (e) {
        if (kDebugMode) debugPrint('[WLog] updateConfig MethodChannel error: $e');
      }
    }
  }

  static WLogConfig get config => _config;

  static void v(String tag, String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.verbose, tag, message, error: error, stackTrace: stackTrace);
  }

  static void d(String tag, String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.debug, tag, message, error: error, stackTrace: stackTrace);
  }

  static void i(String tag, String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.info, tag, message, error: error, stackTrace: stackTrace);
  }

  static void w(String tag, String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.warning, tag, message, error: error, stackTrace: stackTrace);
  }

  static void e(String tag, String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.error, tag, message, error: error, stackTrace: stackTrace);
  }

  static void fatal(String tag, String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.fatal, tag, message, error: error, stackTrace: stackTrace);
  }

  static Future<void> flush({bool force = false}) async {
    if (!_initialized) return;
    if (!_config.remoteEnabled && !force) return;
    if (_flushing) return;

    _flushing = true;
    try {
      final entries = await _getUnsynced();
      if (entries.isEmpty) return;

      final success = await _logApi.sendLogs(
        entries: entries,
        authToken: _config.remoteAuthToken,
        maxRetries: _config.remoteMaxRetries,
      );

      if (success) {
        final ids = entries.map((e) => e.id).toList();
        await _markSynced(ids);
        await _deleteOldSynced();
      }
    } catch (e) {
      if (kDebugMode) debugPrint('[WLog] flush error: $e');
    } finally {
      _flushing = false;
    }
  }

  static Future<void> clear() async {
    if (!_initialized) return;
    try {
      await _methodChannel.invokeMethod('deleteOldSynced');
    } catch (e) {
      if (kDebugMode) debugPrint('[WLog] clear error: $e');
    }
  }

  static Future<void> deleteAllLocal() async {
    if (!_initialized) return;
    try {
      await _methodChannel.invokeMethod('deleteAll');
    } catch (e) {
      if (kDebugMode) debugPrint('[WLog] deleteAllLocal error: $e');
    }
  }

  static List<LogEntry> get recentRamLogs => List<LogEntry>.unmodifiable(_ramRecentLogs);

  static Future<List<LogEntry>> getRecent({LogLevel? minLevel, int limit = 400}) async {
    if (!_initialized) return [];
    try {
      final result = await _methodChannel.invokeMethod<List<dynamic>>('getRecent', {
        'minLevel': (minLevel ?? LogLevel.verbose).value,
        'limit': limit.clamp(1, 2000),
      });
      if (result == null) return [];
      return result.whereType<Map>().map((m) => LogEntry.fromMap(m.cast<String, dynamic>())).toList();
    } catch (e) {
      if (kDebugMode) debugPrint('[WLog] getRecent error: $e');
      return [];
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      flush();
    }
  }

  static void _log(LogLevel level, String tag, String message, {Object? error, StackTrace? stackTrace}) {
    if (!_initialized) return;

    if (kDebugMode && level.value >= _config.consoleMinLevel.value) {
      final prefix = _levelPrefix(level);
      debugPrint('$prefix [$tag] $message');
      if (error != null) debugPrint('  Error: $error');
      if (stackTrace != null) debugPrint('  Stack: $stackTrace');
    }

    final entry = LogEntry(
      id: UuidV7().generate(),
      timestamp: DateTime.now().toUtc().toIso8601String(),
      level: level.value,
      tag: tag,
      message: message,
      stacktrace: _formatStackTrace(error, stackTrace),
    );

    _appendToRamRingBuffer(entry);

    try {
      _methodChannel.invokeMethod('log', entry.toMap()).catchError((_) {});
    } catch (e) {
      if (kDebugMode) debugPrint('[WLog] MethodChannel error: $e');
    }
  }

  static void _setupErrorHandlers() {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details.exception is MissingPluginException) return;
      fatal('FlutterError', details.exceptionAsString(), error: details.exception, stackTrace: details.stack);
    };

    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      if (error is MissingPluginException) return true;
      fatal('PlatformError', error.toString(), error: error, stackTrace: stack);
      return true;
    };
  }

  static void _listenEvents() {
    _eventSubscription?.cancel();
    try {
      _eventSubscription = _eventChannel.receiveBroadcastStream().listen(
        (event) {
          if (event is Map) {
            final eventType = event['event'] as String?;
            switch (eventType) {
              case 'onFatal':
              case 'onIdleTimeout':
              case 'onFlushThreshold':
                flush();
            }
          }
        },
        onError: (e) {
          if (kDebugMode) debugPrint('[WLog] EventChannel error: $e');
        },
      );
    } catch (e) {
      if (kDebugMode) debugPrint('[WLog] EventChannel init failed (plugin missing): $e');
    }
  }

  static Future<List<LogEntry>> _getUnsynced() async {
    try {
      final result = await _methodChannel.invokeMethod<List<dynamic>>('getUnsynced', {
        'minLevel': _config.remoteMinLevel.value,
      });
      if (result == null) return [];
      return result.whereType<Map>().map((m) => LogEntry.fromMap(m.cast<String, dynamic>())).toList();
    } catch (e) {
      if (kDebugMode) debugPrint('[WLog] getUnsynced error: $e');
      return [];
    }
  }

  static Future<void> _markSynced(List<String> ids) async {
    try {
      await _methodChannel.invokeMethod('markSynced', {'ids': ids});
    } catch (e) {
      if (kDebugMode) debugPrint('[WLog] markSynced error: $e');
    }
  }

  static Future<void> _deleteOldSynced() async {
    try {
      await _methodChannel.invokeMethod('deleteOldSynced');
    } catch (e) {
      if (kDebugMode) debugPrint('[WLog] deleteOldSynced error: $e');
    }
  }

  static String? _formatStackTrace(Object? error, StackTrace? stackTrace) {
    if (stackTrace != null) return stackTrace.toString();
    if (error is Error && error.stackTrace != null) {
      return error.stackTrace.toString();
    }
    return null;
  }

  static String _levelPrefix(LogLevel level) => switch (level) {
    LogLevel.verbose => 'V',
    LogLevel.debug => 'D',
    LogLevel.info => 'I',
    LogLevel.warning => 'W',
    LogLevel.error => 'E',
    LogLevel.fatal => 'F',
  };

  static void _appendToRamRingBuffer(LogEntry entry) {
    for (final existing in _ramRecentLogs) {
      if (_isRamDuplicateInSameUtcSecond(existing, entry)) {
        return;
      }
    }
    _ramRecentLogs.add(entry);
    while (_ramRecentLogs.length > _ramRecentLogMax) {
      _ramRecentLogs.removeAt(0);
    }
  }

  static bool _isRamDuplicateInSameUtcSecond(LogEntry a, LogEntry b) {
    if (a.level != b.level || a.tag != b.tag || a.message != b.message) {
      return false;
    }

    final secA = _utcSecondBucket(a.timestamp);
    final secB = _utcSecondBucket(b.timestamp);
    final delta = secB - secA;
    return delta >= 0 && delta <= 1;
  }

  static int _utcSecondBucket(String isoUtc) {
    final t = DateTime.parse(isoUtc).toUtc();
    return DateTime.utc(t.year, t.month, t.day, t.hour, t.minute, t.second).millisecondsSinceEpoch ~/ 1000;
  }

}