import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/Core/Native/Generated/system_settings_api.g.dart',
    dartOptions: DartOptions(),
    kotlinOut:
        'android/app/src/main/kotlin/com/wonkrumdm/api/SystemSettingsApi.g.kt',
    kotlinOptions: KotlinOptions(package: 'com.wonkrumdm.api.settings'),
  ),
)
class SystemSettingsChangeEvent {
  String? key;

  String? value;
}

class AccessibilityServicesChangeEvent {
  List<String?>? enabledPackageNames;
}

@HostApi()
abstract class SystemSettingsAPI {
  @async
  Map<String, Object?> getIntSetting(String key, String type);

  @async
  Map<String, Object?> getStringSetting(String key, String type);

  @async
  Map<String, Object?> setIntSetting(String key, int value, String type);

  @async
  Map<String, Object?> setStringSetting(String key, String value, String type);

  @async
  bool canWriteSettings();

  @async
  Map<String, Object?> setTimeZone(String timeZone);

  @async
  Map<String, Object?> setAutoTimeRequired(bool required);

  @async
  Map<String, Object?> setLocationEnabled(bool enabled);

  @async
  Map<String, Object?> getStorageInfo();

  @async
  bool isRooted();

  @async
  Map<String, Object?> getRootInfo();

  @async
  bool hasManageExternalStoragePermission();

  @async
  bool isBatteryOptimizationIgnored();

  @async
  Map<String, Object?> openPowerSaveSettings();

  @async
  void reboot();

  @async
  Map<String, Object?> getAdvancedSecurityInfo();

  @async
  Map<String, Object?> launchIntent(Map<String?, String?> params);
}

@FlutterApi()
abstract class SystemSettingsEventAPI {
  void onSettingChanged(SystemSettingsChangeEvent event);

  void onAccessibilityServicesChanged(AccessibilityServicesChangeEvent event);
}
