import 'dart:typed_data';

import 'package:wonkrumdm/Core/Native/Bridges/base_bridge.dart';
import 'package:wonkrumdm/Core/Native/Generated/app_api.g.dart';

class AppBridge extends BaseBridge {
  static final AppBridge _instance = AppBridge._internal();

  factory AppBridge() => _instance;

  AppBridge._internal();

  final _api = AppApi();

  @override
  String get bridgeName => "AppBridge";

  Future<List<NativeAppInfo>> getInstalledApps({
    bool includeSystemApps = false,
    List<String>? filterPackages,
  }) async {
    final (success, data) = await mdmResultSafeCall<List<Object?>>(
      () async =>
          await _api.getInstalledApps(includeSystemApps, filterPackages),
      logMessage: "$bridgeName: App list retrieved.",
      defaultValue: [],
    );

    if (success && data != null) {
      return (data as List)
          .cast<NativeAppInfo?>()
          .whereType<NativeAppInfo>()
          .toList();
    }
    return [];
  }

  Future<Uint8List?> getAppIcon(String packageName) async {
    return await safeCall<Uint8List?>(
      () async => await _api.getAppIcon(packageName),
      defaultValue: null,
    );
  }

  Future<bool> installApk(String apkPath) async {
    final (success, _) = await mdmResultSafeCall<Object>(
      () async => await _api.installApk(apkPath),
      logMessage: "$bridgeName: APK install started -> $apkPath",
    );
    return success;
  }

  Future<bool> uninstallApp(String packageName) async {
    final (success, _) = await mdmResultSafeCall<Object>(
      () async => await _api.uninstallApp(packageName),
      logMessage: "$bridgeName: App uninstall started -> $packageName",
    );
    return success;
  }

  Future<bool> launchApp(String packageName) async {
    final (success, _) = await mdmResultSafeCall<Object>(
      () async => await _api.launchApp(packageName),
      logMessage: "$bridgeName: App launched -> $packageName",
    );
    return success;
  }

  Future<bool> clearAppData(String packageName) async {
    final (success, _) = await mdmResultSafeCall<Object>(
      () async => await _api.clearAppData(packageName),
      logMessage: "$bridgeName: App data cleared -> $packageName",
    );
    return success;
  }

  Future<bool> setUninstallBlocked(
    String packageName, {
    required bool blocked,
  }) async {
    final (success, _) = await mdmResultSafeCall<Object>(
      () async => await _api.setUninstallBlocked(packageName, blocked),
      logMessage: "$bridgeName: Uninstall block -> $packageName ($blocked)",
    );
    return success;
  }

  Future<bool> openAppSettings(String packageName) async {
    final (success, _) = await mdmResultSafeCall<Object>(
      () async => await _api.openAppSettings(packageName),
      logMessage: "$bridgeName: App settings opened -> $packageName",
    );
    return success;
  }
}
