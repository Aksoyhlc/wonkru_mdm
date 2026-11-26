import 'dart:async';

import 'package:wonkrumdm/Core/Constants/Enums/config_apply_result.dart';
import 'package:wonkrumdm/Core/Constants/Enums/storage_keys.dart';
import 'package:wonkrumdm/Core/Logging/wlog.dart';
import 'package:wonkrumdm/Core/Managers/app_manager.dart';
import 'package:wonkrumdm/Core/Managers/audio_manager.dart';
import 'package:wonkrumdm/Core/Managers/base_manager.dart';
import 'package:wonkrumdm/Core/Managers/battery_manager.dart';
import 'package:wonkrumdm/Core/Managers/certificate_manager.dart';
import 'package:wonkrumdm/Core/Managers/display_manager.dart';
import 'package:wonkrumdm/Core/Managers/file_manager.dart';
import 'package:wonkrumdm/Core/Managers/launcher_mode_manager.dart';
import 'package:wonkrumdm/Core/Managers/network_manager.dart';
import 'package:wonkrumdm/Core/Managers/other_settings_manager.dart';
import 'package:wonkrumdm/Core/Managers/restriction_manager.dart';
import 'package:wonkrumdm/Core/Managers/security_manager.dart';
import 'package:wonkrumdm/Core/Services/sync_scheduler_service.dart';
import 'package:wonkrumdm/Data/Models/Core/wlog_config.dart';
import 'package:wonkrumdm/Data/Models/Features/config.dart';
import 'package:wonkrumdm/Logic/Common/watchdog_controller.dart';

const _tag = 'ConfigManager';

class ConfigManager extends BaseManager<DeviceConfig> {
  static final ConfigManager _instance = ConfigManager._internal();

  factory ConfigManager() => _instance;

  ConfigManager._internal();

  static bool isWithinActiveTimeRange(Map<String, String>? timeRanges) {
    if (timeRanges == null || timeRanges.isEmpty) {
      return true;
    }

    final now = DateTime.now();
    final currentMinutes = now.hour * 60 + now.minute;

    for (final entry in timeRanges.entries) {
      final startParts = entry.key.split(':');
      final endParts = entry.value.split(':');

      if (startParts.length != 2 || endParts.length != 2) continue;

      final startMinutes = (int.tryParse(startParts[0]) ?? 0) * 60 + (int.tryParse(startParts[1]) ?? 0);
      final endMinutes = (int.tryParse(endParts[0]) ?? 0) * 60 + (int.tryParse(endParts[1]) ?? 0);

      if (endMinutes <= startMinutes) {
        if (currentMinutes >= startMinutes || currentMinutes < endMinutes) {
          return true;
        }
      } else {
        if (currentMinutes >= startMinutes && currentMinutes < endMinutes) {
          return true;
        }
      }
    }

    return false;
  }

  static bool isConfigActive(DeviceConfig? config) {
    if (config == null) return false;
    if (!config.isActive) return false;
    return isWithinActiveTimeRange(config.activeTimeRanges);
  }

  final _securityManager = SecurityManager();
  final _networkManager = NetworkManager();
  final _certificateManager = CertificateManager();
  final _displayManager = DisplayManager();
  final _fileManager = FileManager();
  final _audioManager = AudioManager();
  final _batteryManager = BatteryManager();
  final _appManager = AppManager();
  final _restrictionManager = RestrictionManager();
  final _otherSettingsManager = OtherSettingsManager();
  final _launcherModeManager = LauncherModeManager();

  DeviceConfig? _lastConfig;

  bool _isApplying = false;

  Completer<void>? _applyDone;

  final List<String> _failedManagers = [];

  DeviceConfig? get lastConfig => _lastConfig;

  static const Duration _duplicateApplyThrottleWindow = Duration(seconds: 45);
  String? _lastAppliedPolicyKey;
  DateTime? _lastAppliedPolicyAt;
  String? _lastSyncSettingsSignature;

  @override
  Future<Map<String, dynamic>> getData() async {
    return {'lastConfigId': _lastConfig?.id, 'lastConfigVersion': _lastConfig?.version};
  }

  @override
  Future<void> applyConfiguration(DeviceConfig config) async {
    await applyConfigurationWithOptions(config);
  }

  /// Applies a policy and returns the real result.
  ///
  /// [waitIfBusy]: if another apply is running, wait for it instead of skipping
  /// (for explicit commands; otherwise the command would be acked as success
  /// without being applied).
  Future<ConfigApplyResult> applyConfigurationWithOptions(
    DeviceConfig config, {
    bool bypassThrottle = false,
    bool waitIfBusy = false,
  }) async {
    while (_isApplying) {
      if (!waitIfBusy) {
        WLog.w(_tag, 'Already applying, skipping (ID: ${config.id}, v${config.version})');
        return ConfigApplyResult.busy;
      }
      WLog.d(_tag, 'Already applying, waiting (ID: ${config.id}, v${config.version})');
      await _applyDone?.future;
    }
    final policyKey = _toPolicyKey(config);
    final now = DateTime.now();
    if (!bypassThrottle &&
        policyKey != null &&
        _lastAppliedPolicyKey == policyKey &&
        _lastAppliedPolicyAt != null &&
        now.difference(_lastAppliedPolicyAt!) < _duplicateApplyThrottleWindow) {
      WLog.w(
        _tag,
        'Same policy received within throttle window, skipping (ID: ${config.id}, v${config.version}, window=${_duplicateApplyThrottleWindow.inSeconds}s)',
      );
      return ConfigApplyResult.throttled;
    }
    _lastAppliedPolicyKey = policyKey;
    _lastAppliedPolicyAt = now;
    _isApplying = true;
    _applyDone = Completer<void>();
    _failedManagers.clear();
    var inactive = false;
    try {
      await Future.delayed(const Duration(milliseconds: 50));
      final ok = await safeExecute(() async {
        if (config.wlogConfig != null) {
          WLogConfig.saveLocal(config.wlogConfig!);
          WLog.updateConfig(config.wlogConfig!);
        }

        WLog.i(_tag, 'Applying policy (ID: ${config.id}, v${config.version})');

        if (!isConfigActive(config)) {
          WLog.w(_tag, 'Policy not active (outside time range or inactive), skipping');
          inactive = true;
          return;
        }

        _lastConfig = config;
        final currentSyncSettingsSignature = _toSyncSettingsSignature(config);
        final shouldRestartSyncScheduler =
            _lastSyncSettingsSignature == null || _lastSyncSettingsSignature != currentSyncSettingsSignature;
        _lastSyncSettingsSignature = currentSyncSettingsSignature;

        await _runPhase('Security+Network+Certificate', [
          _applyIfNotNull('SecurityManager', config.securitySettings, _securityManager.applyConfiguration),
          _applyIfNotNull('NetworkManager', config.otherSettings, _networkManager.applyConfiguration),
          _applyIfNotNull('CertificateManager', config.certificateSettings, _certificateManager.applyConfiguration),
        ]);

        await _runPhase('Audio+Battery+OtherSettings+File', [
          _applyIfNotNull('AudioManager', config.audioSettings, _audioManager.applyConfiguration),
          _applyIfNotNull('BatteryManager', config.batterySettings, _batteryManager.applyConfiguration),
          _applyIfNotNull('OtherSettingsManager', config.otherSettings, _otherSettingsManager.applyConfiguration),
          _applyIfNotNull('FileManager', config.fileSettings, _fileManager.applyConfiguration),
        ]);

        await _runPhase('AppManager', [
          _applyIfNotNull('AppManager', config.appSettings, _appManager.applyConfiguration),
        ]);

        await _runPhase('LauncherMode+Display', [
          _launcherModeManager.applyConfiguration(config.launcherConfig),
          _applyIfNotNull('DisplayManager', config.displaySettings, _displayManager.applyConfiguration),
        ]);

        await _runPhase('RestrictionManager', [
          _applyIfNotNull('RestrictionManager', config.restrictionSettings, _restrictionManager.applyConfiguration),
        ]);

        st.setInt(Sk.lastPolicyUpdate.name, DateTime.now().millisecondsSinceEpoch);
        final policyVersionOrId = config.version ?? config.id;
        if (policyVersionOrId != null) {
          st.setInt(Sk.lastPolicyVersion.name, policyVersionOrId);
        }

        Future.delayed(Duration(seconds: 2), () {
          WatchdogController.to.stopAll();
          WatchdogController.to.startAll();
          if (shouldRestartSyncScheduler) {
            SyncSchedulerService.to.startSchedules();
          } else {
            WLog.d(_tag, 'SyncScheduler restart skipped (syncSettings unchanged)');
          }
        });

        WLog.i(_tag, 'All policies applied successfully');
      }, logMessage: 'ConfigManager: Configuration completed');
      if (!ok) return ConfigApplyResult.failed;
      if (inactive) return ConfigApplyResult.inactive;
      if (_failedManagers.isNotEmpty) return ConfigApplyResult.partial;
      return ConfigApplyResult.applied;
    } finally {
      _isApplying = false;
      _applyDone?.complete();
      _applyDone = null;
    }
  }

  List<String> get lastFailedManagers => List.unmodifiable(_failedManagers);

  Future<void> _runPhase(String phaseName, List<Future<void>> tasks) async {
    WLog.d(_tag, '$phaseName starting...');
    await Future.wait(tasks, eagerError: false);
    WLog.d(_tag, '$phaseName completed');
    await Future.delayed(Duration(milliseconds: 100));
  }

  Future<void> _applyIfNotNull<T>(String managerName, T? config, Future<void> Function(T) applyFn) async {
    if (config == null) {
      WLog.d(_tag, '$managerName -> config null, skipping');
      return;
    }
    try {
      final now = DateTime.now();
      WLog.v(_tag, '$managerName -> start ${now.toIso8601String()}');
      await applyFn(config);
      final elapsed = DateTime.now().difference(now).inMilliseconds;
      WLog.d(_tag, '$managerName -> completed (${elapsed} ms)');
    } catch (e, stack) {
      _failedManagers.add(managerName);
      WLog.e(_tag, '$managerName -> apply error', error: e, stackTrace: stack);
    }
  }

  String? _toPolicyKey(DeviceConfig config) {
    if (config.id == null || config.version == null) return null;
    return '${config.id}:${config.version}';
  }

  String _toSyncSettingsSignature(DeviceConfig config) {
    final syncSettings = config.syncSettings;
    if (syncSettings == null) return 'null';
    return [syncSettings.fullSyncCron ?? '', syncSettings.maxIntervalMinutes.toString()].join('|');
  }
}
