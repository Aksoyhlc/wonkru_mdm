import 'package:wonkrumdm/Core/Constants/Enums/system_settings_key.dart';
import 'package:wonkrumdm/Core/Logging/wlog.dart';
import 'package:wonkrumdm/Core/Managers/base_manager.dart';
import 'package:wonkrumdm/Core/Native/Bridges/system_settings_bridge.dart';
import 'package:wonkrumdm/Core/Utils/brightness_utils.dart';

const _tag = 'SystemSettingsManager';

class SystemSettingsManager extends BaseManager<void> {
  static final SystemSettingsManager _instance =
      SystemSettingsManager._internal();
  factory SystemSettingsManager() => _instance;
  SystemSettingsManager._internal();

  final _bridge = SystemSettingsBridge();

  Future<bool> setBrightness(int value) async {
    final raw = BrightnessUtils.percentToRaw(value);
    final success = await _bridge.setIntSetting(
      SystemSettingsKey.screenBrightness,
      raw,
    );
    WLog.d(_tag, "Brightness -> $value% (raw=$raw, ${success ? 'OK' : 'FAIL'})");
    return success;
  }

  Future<int?> getBrightness() async {
    final raw = await _bridge.getIntSetting(SystemSettingsKey.screenBrightness);
    return raw != null ? BrightnessUtils.rawToPercent(raw) : null;
  }

  Future<bool> setAutoBrightness(bool enabled) async {
    final success = await _bridge.setIntSetting(
      SystemSettingsKey.screenBrightnessMode,
      enabled ? 1 : 0,
    );
    WLog.d(_tag, "Auto-brightness -> $enabled (${success ? 'OK' : 'FAIL'})");
    return success;
  }

  Future<bool> setScreenTimeout(int ms) async {
    final success = await _bridge.setIntSetting(
      SystemSettingsKey.screenOffTimeout,
      ms,
    );
    WLog.d(_tag, "Screen timeout -> ${ms}ms (${success ? 'OK' : 'FAIL'})");
    return success;
  }

  Future<int?> getScreenTimeout() async {
    return await _bridge.getIntSetting(SystemSettingsKey.screenOffTimeout);
  }

  Future<bool> setAutoRotation(bool enabled) async {
    final success = await _bridge.setIntSetting(
      SystemSettingsKey.accelerometerRotation,
      enabled ? 1 : 0,
    );
    WLog.d(_tag, "Auto-rotation -> $enabled (${success ? 'OK' : 'FAIL'})");
    return success;
  }

  Future<bool> setPowerSaveMode(bool enabled) async {
    return await setGlobalInt("low_power_mode", enabled ? 1 : 0);
  }

  Future<bool> openPowerSaveSettings() async {
    return await _bridge.openPowerSaveSettings();
  }

  Future<bool> setGlobalInt(String key, int value) async {
    return await _bridge.setIntSetting(
      SystemSettingsKey.fromString(key, createIfMissing: true)!,
      value,
      type: "global",
    );
  }

  Future<bool> setSecureInt(String key, int value) async {
    return await _bridge.setIntSetting(
      SystemSettingsKey.fromString(key, createIfMissing: true)!,
      value,
      type: "secure",
    );
  }

  Future<bool> setSystemInt(String key, int value) async {
    return await _bridge.setIntSetting(
      SystemSettingsKey.fromString(key, createIfMissing: true)!,
      value,
      type: "system",
    );
  }

  Future<String?> getGlobalString(String key) async {
    return await _bridge.getStringSetting(
      SystemSettingsKey.fromString(key, createIfMissing: true)!,
      type: "global",
    );
  }

  Future<String?> getSecureString(String key) async {
    return await _bridge.getStringSetting(
      SystemSettingsKey.fromString(key, createIfMissing: true)!,
      type: "secure",
    );
  }

  Future<bool> setTimeZone(String timeZone) async {
    return await _bridge.setTimeZone(timeZone);
  }

  Future<bool> setAutoTimeZone(bool enabled) async {
    return await _bridge.setAutoTimeZone(enabled);
  }

  Future<bool> setAutoTimeRequired(bool required) async {
    return await _bridge.setAutoTimeRequired(required);
  }

  Future<bool> setLocationEnabled(bool enabled) async {
    return await _bridge.setLocationEnabled(enabled);
  }

  Future<Map<String, int>?> getStorageInfo() async {
    return await _bridge.getStorageInfo();
  }

  Future<bool> canWriteSettings() async {
    return await _bridge.canWriteSettings();
  }

  @override
  Future<void> applyConfiguration(void config) async {
  }

  Future<void> reboot() async {
    await _bridge.reboot();
  }

  Future<bool> launchIntent(Map<String, dynamic>? params) async {
    return await _bridge.launchIntent(params);
  }

  @override
  Future<Map<String, dynamic>> getData() async {
    return await safeCall<Map<String, dynamic>>(() async {
      final brightness = await getBrightness();
      final timeout = await getScreenTimeout();
      final storage = await getStorageInfo();
      final canWrite = await canWriteSettings();
      final rootInfo = await _bridge.getRootInfo();
      final isRooted = await _bridge.isRooted();
      final hasExternalStoragePermission = await _bridge
          .hasManageExternalStoragePermission();
      final advancedSecurity = await _bridge.getAdvancedSecurityInfo();

      return {
        'screen': {'brightness': brightness, 'screenTimeout': timeout},
        'storage': storage,
        'permissions': {
          'canWriteSettings': canWrite,
          'hasManageExternalStorage': hasExternalStoragePermission,
        },
        'security': {
          'isRooted': isRooted,
          'rootInfo': rootInfo,
          'adbEnabled': advancedSecurity['adbEnabled'],
          'developerOptionsEnabled':
              advancedSecurity['developerOptionsEnabled'],
          'unknownSourcesAllowed': advancedSecurity['unknownSourcesAllowed'],
          'encryptionStatus': advancedSecurity['encryptionStatus'],
          'playProtectStatus': advancedSecurity['playProtectStatus'],
          'enabledAccessibilityApps':
              advancedSecurity['enabledAccessibilityApps'],
        },
      };
    }, defaultValue: {});
  }
}