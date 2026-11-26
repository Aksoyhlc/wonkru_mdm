import 'package:wonkrumdm/Core/Constants/Enums/system_settings_key.dart';
import 'package:wonkrumdm/Core/Native/Bridges/base_bridge.dart';
import 'package:wonkrumdm/Core/Native/Generated/system_settings_api.g.dart';

class SystemSettingsBridge extends BaseBridge {
  static final SystemSettingsBridge _instance = SystemSettingsBridge._internal();
  factory SystemSettingsBridge() => _instance;
  SystemSettingsBridge._internal();

  final _api = SystemSettingsAPI();

  @override
  String get bridgeName => "SystemSettingsBridge";

  Future<int?> getIntSetting(SystemSettingsKey key, {String type = "system"}) async {
    final (success, data) = await mdmResultSafeCall<Object>(
      () async => await _api.getIntSetting(key.value, type),
      defaultValue: null,
    );

    if (success && data != null) {
      final map = data as Map<Object?, Object?>;
      return map['value'] as int?;
    }
    return null;
  }

  Future<String?> getStringSetting(SystemSettingsKey key, {String type = "system"}) async {
    final (success, data) = await mdmResultSafeCall<Object>(
      () async => await _api.getStringSetting(key.value, type),
      defaultValue: null,
    );

    if (success && data != null) {
      final map = data as Map<Object?, Object?>;
      return map['value'] as String?;
    }
    return null;
  }

  Future<bool> setIntSetting(SystemSettingsKey key, int value, {String type = "system"}) async {
    final (success, _) = await mdmResultSafeCall<Object>(
      () async => await _api.setIntSetting(key.value, value, type),
      logMessage: "$bridgeName: ${key.value} = $value ($type)",
    );

    return success;
  }

  Future<bool> setStringSetting(SystemSettingsKey key, String value, {String type = "system"}) async {
    final (success, _) = await mdmResultSafeCall<Object>(
      () async => await _api.setStringSetting(key.value, value, type),
      logMessage: "$bridgeName: ${key.value} = $value ($type)",
    );

    return success;
  }

  Future<bool> canWriteSettings() async {
    return await safeCall<bool>(() async => await _api.canWriteSettings(), defaultValue: false);
  }

  Future<bool> setTimeZone(String timeZone) async {
    final (success, _) = await mdmResultSafeCall<Object>(
      () async => await _api.setTimeZone(timeZone),
      logMessage: "$bridgeName: Timezone set -> $timeZone",
    );
    return success;
  }

  Future<bool> setAutoTimeRequired(bool required) async {
    final (success, _) = await mdmResultSafeCall<Object>(
      () async => await _api.setAutoTimeRequired(required),
      logMessage: "$bridgeName: Auto time required -> $required",
    );
    return success;
  }

  Future<bool> setLocationEnabled(bool enabled) async {
    final (success, _) = await mdmResultSafeCall<Object>(
      () async => await _api.setLocationEnabled(enabled),
      logMessage: "$bridgeName: Location enabled -> $enabled",
    );
    return success;
  }

  Future<bool> setAutoTime(bool enabled) async {
    final (success, _) = await mdmResultSafeCall<Object>(
      () async => await _api.setIntSetting("auto_time", enabled ? 1 : 0, "global"),
      logMessage: "$bridgeName: Auto time -> $enabled",
    );
    return success;
  }

  Future<bool> setAutoTimeZone(bool enabled) async {
    final (success, _) = await mdmResultSafeCall<Object>(
      () async => await _api.setIntSetting("auto_time_zone", enabled ? 1 : 0, "global"),
      logMessage: "$bridgeName: Auto timezone -> $enabled",
    );
    return success;
  }

  Future<bool> setTime1224(int hourFormat) async {
    if (hourFormat != 12 && hourFormat != 24) return false;

    final (success, _) = await mdmResultSafeCall<Object>(
      () async => await _api.setStringSetting(SystemSettingsKey.time1224.value, '$hourFormat', 'system'),
      logMessage: "$bridgeName: Time format (12/24) -> $hourFormat",
    );
    return success;
  }

  Future<Map<String, int>?> getStorageInfo() async {
    final (success, data) = await mdmResultSafeCall<Object>(
      () async => await _api.getStorageInfo(),
      defaultValue: null,
    );

    if (success && data != null) {
      final map = data as Map<Object?, Object?>;
      return {
        'totalBytes': (map['totalBytes'] as int?) ?? 0,
        'freeBytes': (map['freeBytes'] as int?) ?? 0,
        'usedBytes': (map['usedBytes'] as int?) ?? 0,
      };
    }
    return null;
  }

  Future<bool> isRooted() async {
    return await safeCall<bool>(() async => await _api.isRooted(), defaultValue: false);
  }

  Future<Map<String, dynamic>?> getRootInfo() async {
    return await safeCall<Map<String, dynamic>?>(() async {
      final result = await _api.getRootInfo();
      return result.map((key, value) => MapEntry(key, value));
    }, defaultValue: null);
  }

  Future<bool> hasManageExternalStoragePermission() async {
    return await safeCall<bool>(() async => await _api.hasManageExternalStoragePermission(), defaultValue: true);
  }

  Future<bool> isBatteryOptimizationIgnored() async {
    return await safeCall<bool>(() async => await _api.isBatteryOptimizationIgnored(), defaultValue: true);
  }

  Future<bool> openPowerSaveSettings() async {
    final (success, _) = await mdmResultSafeCall<Object>(
      () async => await _api.openPowerSaveSettings(),
      logMessage: "$bridgeName: Opening power save settings",
    );
    return success;
  }

  Future<void> reboot() async {
    
    await safeCall<void>(() async => await _api.reboot(), defaultValue: null);
  }

  Future<Map<String, dynamic>> getAdvancedSecurityInfo() async {
    return await safeCall<Map<String, dynamic>>(() async {
      final result = await _api.getAdvancedSecurityInfo();
      return result.cast<String, dynamic>();
    }, defaultValue: {});
  }

  Future<bool> launchIntent(Map<String, dynamic>? params) async {
    final map = _toStringMap(params);
    // Native success returns {success: true} with no 'data' key.
    final (success, _) = await mdmResultSafeCall<Object>(
      () async => await _api.launchIntent(map),
      logMessage: "$bridgeName: launchIntent -> ${map['intent_action'] ?? 'map'}",
    );
    return success;
  }

  static Map<String?, String?> _toStringMap(Map<String, dynamic>? m) {
    if (m == null || m.isEmpty) return {};
    return m.map((k, v) {
      if (v == null) return MapEntry<String?, String?>(k, null);
      final s = v is String ? v : v.toString();
      return MapEntry<String?, String?>(k, s.trim().isEmpty ? null : s);
    });
  }
}
