import 'dart:async';

import 'package:wonkrumdm/Core/Interfaces/watchdog_interface.dart';
import 'package:wonkrumdm/Core/Logging/wlog.dart';
import 'package:wonkrumdm/Core/Managers/base_manager.dart';
import 'package:wonkrumdm/Core/Native/Bridges/system_settings_bridge.dart';
import 'package:wonkrumdm/Data/Models/Features/storage_policy.dart';
import 'package:wonkrumdm/Logic/Common/device_controller.dart';

const String _tag = 'StorageManager';

class StorageManager extends BaseManager<StoragePolicy> implements IWatchdog {
  static final StorageManager _instance = StorageManager._internal();
  factory StorageManager() => _instance;
  StorageManager._internal();

  final _systemBridge = SystemSettingsBridge();

  StoragePolicy? get _currentPolicy => DeviceController.to.config.value.storageSettings;
  Timer? _watchdogTimer;

  bool _hasShownWarningThreshold = false;
  bool _hasShownCriticalThreshold = false;

  final _storageInfoController = StreamController<Map<String, dynamic>>.broadcast();
  final _warningThresholdController = StreamController<double>.broadcast();
  final _criticalThresholdController = StreamController<double>.broadcast();

  Stream<Map<String, dynamic>> get storageStream => _storageInfoController.stream;
  Stream<double> get warningStream => _warningThresholdController.stream;
  Stream<double> get criticalStream => _criticalThresholdController.stream;

  Map<String, int>? _cachedInfo;
  DateTime? _cacheTime;
  static const _cacheDuration = Duration(minutes: 3);

  @override
  bool get isWatchdogRunning => _watchdogTimer != null;

  @override
  Duration get initialDelay => const Duration(seconds: 30);

  Future<Map<String, int>?> _getStorageInfo({bool force = false}) async {
    final now = DateTime.now();

    if (!force && _cachedInfo != null && _cacheTime != null) {
      if (now.difference(_cacheTime!) < _cacheDuration) {
        return _cachedInfo;
      }
    }

    final info = await _systemBridge.getStorageInfo();
    if (info != null) {
      _cachedInfo = info;
      _cacheTime = now;
    }
    return _cachedInfo;
  }

  Future<void> refreshCache() async {
    await _getStorageInfo(force: true);
  }

  StoragePolicy? get currentPolicy => _currentPolicy;

  Future<int> get totalStorage async {
    final info = await _getStorageInfo();
    return info?['totalBytes'] ?? 0;
  }

  Future<int> get freeStorage async {
    final info = await _getStorageInfo();
    return info?['freeBytes'] ?? 0;
  }

  Future<double> get usagePercentage async {
    final info = await _getStorageInfo();
    if (info == null) return 0;
    final total = info['totalBytes'] ?? 0;
    final used = info['usedBytes'] ?? 0;
    if (total == 0) return 0;
    return (used / total) * 100;
  }

  Future<double> get freePercentage async {
    final info = await _getStorageInfo();
    if (info == null) return 0;
    final total = info['totalBytes'] ?? 0;
    final free = info['freeBytes'] ?? 0;
    if (total == 0) return 0;
    return (free / total) * 100;
  }

  @override
  Future<void> applyConfiguration(StoragePolicy config) async {
    await safeExecute(() async {
      WLog.d(_tag, "Applying storage policy");
    }, logMessage: "StorageManager: Policy applied");
  }

  @override
  void startWatchdog() {
    stopWatchdog();

    if (currentPolicy == null || !currentPolicy!.enabled) {
      WLog.d(_tag, "Watchdog not started: policy disabled");
      return;
    }

    _watchdogTimer = Timer.periodic(const Duration(minutes: 3), (timer) async {
      await _checkStorageThresholds();
    });

    WLog.d(_tag, "Watchdog started (3 min interval)");
    _checkStorageThresholds();
  }

  @override
  void stopWatchdog() {
    _watchdogTimer?.cancel();
    _watchdogTimer = null;
    WLog.d(_tag, "Watchdog stopped");
  }

  void watchDogStartStop() => startWatchdog();

  Future<void> _checkStorageThresholds() async {
    if (_currentPolicy == null || !_currentPolicy!.enabled) return;

    final info = await _getStorageInfo(force: true);
    if (info == null) return;

    final total = info['totalBytes'] ?? 0;
    final free = info['freeBytes'] ?? 0;
    if (total == 0) return;

    final freePercent = (free / total) * 100;
    final usagePercent = 100 - freePercent;

    _storageInfoController.add(await getData());

    if (usagePercent < (_currentPolicy!.warningThreshold - 5)) {
      _hasShownWarningThreshold = false;
      _hasShownCriticalThreshold = false;
    }

    if (usagePercent >= _currentPolicy!.criticalThreshold) {
      if (!_hasShownCriticalThreshold) {
        _criticalThresholdController.add(freePercent);
        _hasShownCriticalThreshold = true;
        WLog.w(_tag, "Critical storage threshold exceeded (%${usagePercent.toStringAsFixed(1)})");
      }
    } else if (usagePercent >= _currentPolicy!.warningThreshold) {
      if (!_hasShownWarningThreshold) {
        _warningThresholdController.add(freePercent);
        _hasShownWarningThreshold = true;
        WLog.w(_tag, "Warning storage threshold exceeded (%${usagePercent.toStringAsFixed(1)})");
      }
    }
  }

  Future<void> checkNow() async => await _checkStorageThresholds();

  void resetThresholdWarnings() {
    _hasShownWarningThreshold = false;
    _hasShownCriticalThreshold = false;
    WLog.d(_tag, "Storage threshold warnings reset");
  }

  @override
  Future<Map<String, dynamic>> getData() async {
    final info = await _getStorageInfo();

    final total = info?['totalBytes'] ?? 0;
    final free = info?['freeBytes'] ?? 0;
    final used = info?['usedBytes'] ?? 0;

    final usedPercent = total > 0 ? (used / total) * 100 : 0.0;
    final freePercent = total > 0 ? (free / total) * 100 : 0.0;

    return {
      'totalStorageBytes': total,
      'freeStorageBytes': free,
      'usedStorageBytes': used,
      'usagePercentage': usedPercent,
      'freePercentage': freePercent,
      'totalStorageGB': (total / (1024 * 1024 * 1024)).toStringAsFixed(2),
      'freeStorageGB': (free / (1024 * 1024 * 1024)).toStringAsFixed(2),
    };
  }

  void dispose() {
    stopWatchdog();
    _storageInfoController.close();
    _warningThresholdController.close();
    _criticalThresholdController.close();
  }
}
