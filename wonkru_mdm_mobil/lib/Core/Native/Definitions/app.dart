import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/Core/Native/Generated/app_api.g.dart',
    dartOptions: DartOptions(),
    kotlinOut: 'android/app/src/main/kotlin/com/wonkrumdm/api/AppApi.g.kt',
    kotlinOptions: KotlinOptions(package: 'com.wonkrumdm.api.app'),
  ),
)
class NativeAppInfo {
  String? packageName;
  String? appName;
  String? versionName;
  int? versionCode;
  bool? isSystemApp;

  bool? isUninstallBlocked;

  bool? isPowerSaveWhitelisted;
}

@HostApi()
abstract class AppApi {
  @async
  Map<String, Object?> getInstalledApps(
    bool includeSystemApps,
    List<String>? filterPackages,
  );

  @async
  Uint8List? getAppIcon(String packageName);

  @async
  Map<String, Object?> installApk(String apkPath);

  @async
  Map<String, Object?> uninstallApp(String packageName);

  @async
  Map<String, Object?> launchApp(String packageName);

  @async
  Map<String, Object?> clearAppData(String packageName);

  @async
  Map<String, Object?> setUninstallBlocked(String packageName, bool blocked);

  @async
  Map<String, Object?> openAppSettings(String packageName);
}

@FlutterApi()
abstract class AppEventApi {
  void onAppStatusChanged(String packageName, String eventType);

  void onInstallResult(String packageName, bool success, String message);
}
