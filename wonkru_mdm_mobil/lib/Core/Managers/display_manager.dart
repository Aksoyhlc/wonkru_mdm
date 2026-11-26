import 'dart:async';

import 'package:wonkrumdm/Core/Constants/Enums/on_off.dart';
import 'package:wonkrumdm/Core/Constants/Enums/restriction.dart';
import 'package:wonkrumdm/Core/Constants/Enums/screen_orientation.dart';
import 'package:wonkrumdm/Core/Constants/Enums/system_settings_key.dart';
import 'package:wonkrumdm/Core/Init/app_bootstrap.dart';
import 'package:wonkrumdm/Core/Interfaces/watchdog_interface.dart';
import 'package:wonkrumdm/Core/Logging/wlog.dart';
import 'package:wonkrumdm/Core/Managers/base_manager.dart';
import 'package:wonkrumdm/Core/Native/Bridges/display_bridge.dart';
import 'package:wonkrumdm/Core/Native/Bridges/restriction_bridge.dart';
import 'package:wonkrumdm/Core/Native/Bridges/system_settings_bridge.dart';
import 'package:wonkrumdm/Core/Utils/brightness_utils.dart';
import 'package:wonkrumdm/Data/Models/Features/display_config.dart';
import 'package:wonkrumdm/Logic/Common/device_controller.dart';

const _tag = 'DisplayManager';

class DisplayManager extends BaseManager<DisplayConfig> implements IWatchdog {
  static final DisplayManager _instance = DisplayManager._internal();

  factory DisplayManager() => _instance;

  DisplayManager._internal() {}

  @override
  Future<Map<String, dynamic>> getData() async {
    return await safeCall<Map<String, dynamic>>(() async {
      final brightness = await getBrightness();
      final autoBrightness = await isAutoBrightnessEnabled();
      final timeout = await getScreenTimeout();
      final rotationStatus = await getRotationStatus();
      final hasWriteSettings = await hasWriteSettingsPermission();
      final displayInfo = AppBootstrap.isHeadless ? {} : await getDisplayInfo();

      return {
        'brightness': brightness,
        'autoBrightnessEnabled': autoBrightness,
        'screenTimeoutMs': timeout,
        'rotation': rotationStatus,
        'hasWriteSettingsPermission': hasWriteSettings,
        'info': displayInfo,
      };
    }, defaultValue: {});
  }

  final _displayBridge = DisplayBridge();
  final _restrictionBridge = RestrictionBridge();
  final _systemSettings = SystemSettingsBridge();

  DisplayConfig? get _currentConfig => DeviceController.to.config.value.displaySettings;
  StreamSubscription? _watchdogSubscription;

  bool _isApplyingValue = false;

  @override
  bool get isWatchdogRunning => _watchdogSubscription != null;

  @override
  Duration get initialDelay => Duration.zero;

  @override
  Future<void> checkNow() async {
    final raw = await _getBrightnessRaw();
    if (raw != null) await _checkAndRevertBrightness(raw);
    final timeout = await getScreenTimeout();
    if (timeout != null) await _checkAndRevertTimeout(timeout);
  }

  Stream<int> get brightnessStream => _displayBridge.settingsStream
      .where((event) => event.type == 'brightness')
      .map((event) => BrightnessUtils.rawToPercent(event.value!.toInt()));

  Stream<int> get timeoutStream =>
      _displayBridge.settingsStream.where((event) => event.type == 'timeout').map((event) => event.value!.toInt());

  Stream<bool> get autoRotationStream => _displayBridge.settingsStream
      .where((event) => event.type == 'auto_rotation')
      .map((event) => event.value!.toInt() == 1);

  Stream<int> get userRotationStream => _displayBridge.settingsStream
      .where((event) => event.type == 'user_rotation')
      .map((event) => event.value!.toInt());

  Future<int?> getBrightness() async {
    final raw = await _getBrightnessRaw();
    return raw != null ? BrightnessUtils.rawToPercent(raw) : null;
  }

  Future<int?> _getBrightnessRaw() async {
    final result = await _systemSettings.getIntSetting(SystemSettingsKey.screenBrightness, type: "system");
    return result;
  }

  Future<bool> isAutoBrightnessEnabled() async {
    final mode = await _systemSettings.getIntSetting(SystemSettingsKey.screenBrightnessMode, type: "system");
    return mode == 1;
  }

  Future<int?> getScreenTimeout() async {
    return await _systemSettings.getIntSetting(SystemSettingsKey.screenOffTimeout, type: "system");
  }

  Future<bool> isAutoRotateEnabled() async {
    final mode = await _systemSettings.getIntSetting(SystemSettingsKey.accelerometerRotation, type: "system");
    return mode == 1;
  }

  Future<int?> getUserRotation() async {
    return await _systemSettings.getIntSetting(SystemSettingsKey.userRotation, type: "system");
  }

  Future<Map<String, dynamic>> getRotationStatus() async {
    final isAutoRotate = await isAutoRotateEnabled();
    final userRotation = await getUserRotation();
    return {'isAutoRotate': isAutoRotate, 'userRotation': userRotation, 'rotationLocked': !isAutoRotate};
  }

  DisplayConfig? get currentConfig => _currentConfig;

  Future<bool> hasWriteSettingsPermission() async {
    return await _displayBridge.hasWriteSettingsPermission();
  }

  Future<void> requestWriteSettingsPermission() async {
    await _displayBridge.requestWriteSettingsPermission();
  }

  Future<Map<String, dynamic>> getDisplayInfo() async {
    return await _displayBridge.getDisplayInfo();
  }

  @override
  Future<void> applyConfiguration(DisplayConfig config) async {
    WLog.d(
      _tag,
      'applyConfiguration: lockScreenMessage=${config.lockScreenMessage != null}, screenCapturePolicy=${config.screenCapturePolicy}, brightnessLevel=${config.brightnessLevel}, screenTimeoutMs=${config.screenTimeoutMs}, rotationPolicy=${config.rotationPolicy}, lockedOrientation=${config.lockedOrientation}',
    );
    await safeExecute(() async {
      await setLockScreenMessage(config.lockScreenMessage);
      await setScreenCapturePolicy(config.screenCapturePolicy);
      await setBrightnessConfiguration(
        level: config.brightnessLevel,
        minBrightness: config.minBrightness,
        maxBrightness: config.maxBrightness,
        autoBrightnessPolicy: config.autoBrightnessPolicy,
        restriction: OnOff.fromRestrictionBool(config.brightnessConfigRestriction),
      );
      await setScreenTimeoutConfiguration(
        timeoutMs: config.screenTimeoutMs,
        restriction: OnOff.fromRestrictionBool(config.screenTimeoutConfigRestriction),
      );
      await setScreenRotationConfiguration(
        rotationPolicy: config.rotationPolicy,
        lockedOrientation: config.lockedOrientation,
      );
      WLog.i(_tag, 'Advanced display settings applied');
    }, logMessage: "DisplayManager: Advanced display settings applied");
  }

  Future<void> setLockScreenMessage(String? message) async {
    WLog.d(
      _tag,
      'setLockScreenMessage: message=${message == null ? "null" : (message.isEmpty ? "(empty, clearing)" : message)}',
    );
    await safeExecute(() async {
      if (message != null) {
        final value = message.isEmpty ? null : message;
        await _displayBridge.setLockScreenMessage(value);
      }
    }, logMessage: "DisplayManager: Lock screen message set");
  }

  Future<void> setScreenCapturePolicy(OnOff? policy) async {
    WLog.d(_tag, 'setScreenCapturePolicy: policy=$policy');
    await safeExecute(() async {
      if (policy != null) {
        await applyRestriction(policy, (val) => _displayBridge.setScreenCaptureDisabled(val));
      }
    }, logMessage: "DisplayManager: Screen capture policy set");
  }

  Future<void> setBrightnessConfiguration({
    int? level,
    int? minBrightness,
    int? maxBrightness,
    OnOff? autoBrightnessPolicy,
    OnOff? restriction,
  }) async {
    WLog.i(
      _tag,
      'setBrightnessConfiguration: level=$level%, min=$minBrightness%, max=$maxBrightness%, autoBrightnessPolicy=$autoBrightnessPolicy, restriction=$restriction',
    );
    await safeExecute(() async {
      if (level != null) {
        await _systemSettings.setIntSetting(SystemSettingsKey.screenBrightnessMode, 0, type: "system");

        final minRaw = minBrightness != null ? BrightnessUtils.percentToRaw(minBrightness) : BrightnessUtils.rawMin;
        final maxRaw = maxBrightness != null ? BrightnessUtils.percentToRaw(maxBrightness) : BrightnessUtils.rawMax;
        final levelRaw = BrightnessUtils.percentToRaw(level);
        final clampedLevel = _clamp(levelRaw, minRaw, maxRaw);
        WLog.i(
          _tag,
          'setBrightnessConfiguration: screenBrightness=$clampedLevel (0-255, ${BrightnessUtils.rawToPercent(clampedLevel)}%)',
        );
        await _systemSettings.setIntSetting(SystemSettingsKey.screenBrightness, clampedLevel, type: "system");
      }

      if (autoBrightnessPolicy != null && autoBrightnessPolicy != OnOff.def) {
        final mode = autoBrightnessPolicy == OnOff.on ? 1 : 0;
        await _systemSettings.setIntSetting(SystemSettingsKey.screenBrightnessMode, mode, type: "system");
      }
    }, logMessage: "DisplayManager: Brightness settings applied");
  }

  Future<void> setBrightnessLevel(int level, {int? minBrightness, int? maxBrightness}) async {
    await setBrightnessConfiguration(level: level, minBrightness: minBrightness, maxBrightness: maxBrightness);
  }

  Future<void> setScreenTimeoutConfiguration({int? timeoutMs, OnOff? restriction}) async {
    WLog.d(_tag, 'setScreenTimeoutConfiguration: timeoutMs=$timeoutMs, restriction=$restriction');
    await safeExecute(() async {
      if (timeoutMs != null) {
        if (timeoutMs == 0) {
          await _systemSettings.setIntSetting(SystemSettingsKey.screenOffTimeout, 2147483647, type: "system");
        } else if (timeoutMs > 0) {
          await _systemSettings.setIntSetting(SystemSettingsKey.screenOffTimeout, timeoutMs, type: "system");
        }
      }

      if (restriction != null) {
        await applyRestriction(
          restriction,
          (val) => _restrictionBridge.setRestriction(Restriction.DISALLOW_CONFIG_SCREEN_TIMEOUT.value, val),
        );
      }
    }, logMessage: "DisplayManager: Screen timeout settings applied");
  }

  Future<void> setScreenRotationConfiguration({
    RotationPolicy? rotationPolicy,
    ScreenOrientation? lockedOrientation,
  }) async {
    WLog.d(
      _tag,
      'setScreenRotationConfiguration: rotationPolicy=$rotationPolicy, lockedOrientation=$lockedOrientation',
    );
    await safeExecute(() async {
      if (rotationPolicy != null) {
        switch (rotationPolicy) {
          case RotationPolicy.free:
            await _systemSettings.setIntSetting(SystemSettingsKey.accelerometerRotation, 1, type: "system");
            break;
          case RotationPolicy.locked:
            if (lockedOrientation != null && lockedOrientation != ScreenOrientation.auto) {
              await _systemSettings.setIntSetting(SystemSettingsKey.accelerometerRotation, 0, type: "system");
              await _systemSettings.setIntSetting(
                SystemSettingsKey.userRotation,
                lockedOrientation.value,
                type: "system",
              );
            } else {
              await _systemSettings.setIntSetting(SystemSettingsKey.accelerometerRotation, 0, type: "system");
            }
            break;
          case RotationPolicy.systemDefault:
            break;
        }
      }
    }, logMessage: "DisplayManager: Screen rotation settings applied");
  }

  Future<bool> lockDeviceNow() async {
    return await _displayBridge.lockNow();
  }

  @override
  void startWatchdog() {
    WLog.d(_tag, 'Starting watchdog...');

    _displayBridge.startListening();

    _watchdogSubscription?.cancel();
    _watchdogSubscription = _displayBridge.settingsStream.listen((event) async {
      if (_currentConfig == null) return;
      if (event.value == null) return;
      if (_isApplyingValue) return;

      final type = event.type;
      final value = event.value!.toInt();

      switch (type) {
        case 'brightness':
          await _checkAndRevertBrightness(value);
          break;
        case 'timeout':
          await _checkAndRevertTimeout(value);
          break;
        case 'auto_rotation':
          await _checkAndRevertAutoRotation(value);
          break;
        case 'user_rotation':
          await _checkAndRevertRotation(value);
          break;
      }
    });

    WLog.i(_tag, 'Watchdog active');
  }

  @override
  void stopWatchdog() {
    _watchdogSubscription?.cancel();
    _watchdogSubscription = null;
    _displayBridge.stopListening();
  }

  Future<void> _checkAndRevertBrightness(int currentValueRaw) async {
    if (_currentConfig == null) return;

    if (_currentConfig!.brightnessLevel != null && (_currentConfig?.brightnessConfigRestriction ?? false)) {
      final targetRaw = BrightnessUtils.percentToRaw(_currentConfig!.brightnessLevel!);
      if ((currentValueRaw - targetRaw).abs() > 10) {
        WLog.w(
          _tag,
          'Watchdog: fixed brightness violation (${BrightnessUtils.rawToPercent(currentValueRaw)}%), enforcing -> ${_currentConfig!.brightnessLevel}%',
        );
        await _applyWatchdogChange(
          () => _systemSettings.setIntSetting(SystemSettingsKey.screenBrightness, targetRaw, type: "system"),
        );
      }
    }

    if (_currentConfig!.minBrightness != null || _currentConfig!.maxBrightness != null) {
      final minRaw = BrightnessUtils.percentToRaw(_currentConfig!.minBrightness ?? 0);
      final maxRaw = BrightnessUtils.percentToRaw(_currentConfig!.maxBrightness ?? 100);
      final clamped = _clamp(currentValueRaw, minRaw, maxRaw);

      if (clamped != currentValueRaw) {
        WLog.w(
          _tag,
          'Watchdog: brightness out of range (${BrightnessUtils.rawToPercent(currentValueRaw)}%), correcting -> ${BrightnessUtils.rawToPercent(clamped)}%',
        );
        await _applyWatchdogChange(
          () => _systemSettings.setIntSetting(SystemSettingsKey.screenBrightness, clamped, type: "system"),
        );
        return;
      }
    }
  }

  Future<void> _checkAndRevertTimeout(int currentValue) async {
    if (_currentConfig?.screenTimeoutMs == null) return;

    final target = _currentConfig!.screenTimeoutMs == 0 ? 2147483647 : _currentConfig!.screenTimeoutMs!;

    if (currentValue != target) {
      WLog.w(_tag, 'Watchdog: timeout changed ($currentValue), enforcing -> $target');
      await _applyWatchdogChange(
        () => _systemSettings.setIntSetting(SystemSettingsKey.screenOffTimeout, target, type: "system"),
      );
    }
  }

  Future<void> _checkAndRevertAutoRotation(int currentValue) async {
    if (_currentConfig?.rotationPolicy != RotationPolicy.locked) return;
    if (currentValue != 1) return;
    WLog.w(_tag, 'Watchdog: auto-rotation enabled while policy locked, disabling');
    await _applyWatchdogChange(
      () => _systemSettings.setIntSetting(SystemSettingsKey.accelerometerRotation, 0, type: "system"),
    );
  }

  Future<void> _checkAndRevertRotation(int currentValue) async {
    if (_currentConfig?.rotationPolicy != RotationPolicy.locked) return;
    if (_currentConfig?.lockedOrientation == null || _currentConfig?.lockedOrientation == ScreenOrientation.auto)
      return;

    final targetOrientation = _currentConfig!.lockedOrientation!.value;

    if (currentValue != targetOrientation) {
      WLog.w(_tag, 'Watchdog: orientation violation ($currentValue), enforcing -> $targetOrientation');
      await _applyWatchdogChange(
        () => _systemSettings.setIntSetting(SystemSettingsKey.userRotation, targetOrientation, type: "system"),
      );
    }
  }

  Future<void> _applyWatchdogChange(Future<void> Function() action) async {
    _isApplyingValue = true;
    try {
      await action();
      await Future.delayed(Duration(milliseconds: 700));
    } finally {
      _isApplyingValue = false;
    }
  }

  int _clamp(int value, int min, int max) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
  }

  void dispose() {
    _watchdogSubscription?.cancel();
    _displayBridge.stopListening();
  }
}
