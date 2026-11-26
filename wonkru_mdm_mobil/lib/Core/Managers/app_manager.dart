import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:wonkrumdm/Core/Constants/Enums/app_enums.dart';
import 'package:wonkrumdm/Core/Constants/Enums/auto_update_policy.dart';
import 'package:wonkrumdm/Core/Constants/Enums/on_off.dart';
import 'package:wonkrumdm/Core/Constants/Enums/storage_keys.dart';
import 'package:wonkrumdm/Core/Constants/const.dart';
import 'package:wonkrumdm/Core/Init/app_bootstrap.dart';
import 'package:wonkrumdm/Core/Interfaces/watchdog_interface.dart';
import 'package:wonkrumdm/Core/Logging/wlog.dart';
import 'package:wonkrumdm/Core/Managers/base_manager.dart';
import 'package:wonkrumdm/Core/Managers/system_settings_manager.dart';
import 'package:wonkrumdm/Core/Native/Bridges/app_bridge.dart';
import 'package:wonkrumdm/Core/Native/Generated/app_api.g.dart';
import 'package:wonkrumdm/Core/Utils/basic_storage.dart';
import 'package:wonkrumdm/Data/DataSources/Remote/app_download_api.dart';
import 'package:wonkrumdm/Data/Models/Features/app_config.dart';
import 'package:wonkrumdm/Data/Models/Features/managed_app.dart';
import 'package:wonkrumdm/Logic/Common/device_controller.dart';
import 'package:wonkrumdm/Logic/UI/launcher_controller.dart';

const _tag = 'AppManager';

class AppManager extends BaseManager<AppConfig> implements IWatchdog {
  static final AppManager _instance = AppManager._internal();

  static AppManager get instance => _instance;

  factory AppManager() => _instance;

  AppManager._internal() {}

  @override
  Future<Map<String, dynamic>> getData() async {
    return await safeCall<Map<String, dynamic>>(() async {
      if (_installedAppsMap.isEmpty) {
        await refreshInstalledAppsCache();
      }

      final systemApps = _installedAppsMap.values
          .where((app) => app.isSystemApp == true)
          .toList();
      final userApps = _installedAppsMap.values
          .where((app) => app.isSystemApp != true)
          .toList();
      var allApps = _installedAppsMap.values.toList();

      var apps = allApps
          .map(
            (e) => {
              "packageName": e.packageName,
              "appName": e.appName,
              "versionName": e.versionName,
              "versionCode": e.versionCode,
              "isSystemApp": e.isSystemApp,
              "isUninstallBlocked": e.isUninstallBlocked,
              "isPowerSaveWhitelisted": e.isPowerSaveWhitelisted,
            },
          )
          .toList();

      return {
        'totalInstalled': _installedAppsMap.length,
        'systemAppsCount': systemApps.length,
        'userAppsCount': userApps.length,
        'userApps': apps,
        'managedAppsCount': _currentConfig?.managedApps?.length ?? 0,
      };
    }, defaultValue: {});
  }

  final _appBridge = AppBridge();
  final _basicStorage = BasicStorage.instance;
  final _systemSettings = SystemSettingsManager();

  String? _ownPackageNameCache;

  final _appDownloadApi = AppDownloadApi();

  Map<String, NativeAppInfo> _installedAppsMap = {};

  Map<String, NativeAppInfo> get installedAppsMap => _installedAppsMap;

  Future<List<Map<String, dynamic>>> getInstalledAppsList({
    bool includeSystemApps = false,
  }) async {
    await refreshInstalledAppsCache(includeSystemApps: includeSystemApps);
    return _installedAppsMap.values
        .map(
          (e) => {
            "packageName": e.packageName,
            "appName": e.appName,
            "versionName": e.versionName,
            "versionCode": e.versionCode,
            "isSystemApp": e.isSystemApp,
            "isUninstallBlocked": e.isUninstallBlocked,
            "isPowerSaveWhitelisted": e.isPowerSaveWhitelisted,
          },
        )
        .toList();
  }

  AppConfig? get _currentConfig => DeviceController.to.config.value.appSettings;

  List<String>? get _allowedAccessibilityApps => DeviceController
      .to
      .config
      .value
      .securitySettings
      ?.allowedAccessibilityApps;

  StreamSubscription? _watchdogSubscription;
  StreamSubscription<List<String>>? _accessibilitySubscription;

  @override
  bool get isWatchdogRunning =>
      _watchdogSubscription != null && _accessibilitySubscription != null;

  @override
  Duration get initialDelay => Duration.zero;

  @override
  Future<void> checkNow() async {
    await refreshInstalledAppsCache();
  }

  @override
  void startWatchdog() {
    if (_watchdogSubscription != null) return;
    _watchdogSubscription = appEventHandler.appStatusStream.listen((event) {
      _handleAppStatusChange(event.packageName, event.eventType);
    });
    _accessibilitySubscription = systemSettingsEventHandler
        .accessibilityEnabledPackagesStream
        .listen((pkgs) {
          unawaited(_enforceAccessibilityAllowlistForPackages(pkgs));
        });
    WLog.d(_tag, "Watchdog started (app events + accessibility)");
  }

  @override
  void stopWatchdog() {
    _watchdogSubscription?.cancel();
    _watchdogSubscription = null;
    _accessibilitySubscription?.cancel();
    _accessibilitySubscription = null;
    WLog.d(_tag, "Watchdog stopped");
  }

  @override
  Future<void> applyConfiguration(AppConfig config) async {
    WLog.d(_tag, "[applyConfiguration] Started.");
    await safeExecute(
      () async {
        final managedCount = config.managedApps?.length ?? 0;
        WLog.d(_tag, '[applyConfiguration] Summary: managedApps=$managedCount');

        WLog.d(_tag, 'Applying app policies...');

        WLog.d(_tag, '[applyConfiguration] Step 1: Refreshing cache...');
        await refreshInstalledAppsCache();
        await Future.delayed(Duration(milliseconds: 250));
        WLog.d(_tag, '[applyConfiguration] Step 1 complete.');

        WLog.d(
          _tag,
          '[applyConfiguration] Step 2: Processing managed apps ($managedCount apps)...',
        );
        if (config.managedApps != null) {
          for (var i = 0; i < config.managedApps!.length; i++) {
            final app = config.managedApps![i];
            WLog.d(
              _tag,
              '[applyConfiguration] ManagedApp ${i + 1}/$managedCount: ${app.packageName} action=${app.action?.name}',
            );
            await _processManagedApp(app);
            await Future.delayed(Duration.zero);
          }
        }
        WLog.d(_tag, '[applyConfiguration] Step 2 complete.');

        WLog.d(
          _tag,
          '[applyConfiguration] Checking accessibility allowlist (Secure setting)...',
        );
        await _enforceAccessibilityAllowlistFromSettings();
      },
      logMessage: "AppManager: App configuration completed",
      onError: () {
        WLog.w(_tag, 'App configuration failed (applyConfiguration)');
      },
      onFinalliy: () {
        if (Get.isRegistered<LauncherController>()) {
          LauncherController.to.refreshApps();
        }
      },
    );
    WLog.d(_tag, '[applyConfiguration] Done.');
  }

  Future<void> refreshInstalledAppsCache({
    bool includeSystemApps = true,
    List<String>? filterPackages,
  }) async {
    WLog.d(_tag, '[refreshInstalledAppsCache] Started.');
    final apps = await _appBridge.getInstalledApps(
      includeSystemApps: includeSystemApps,
      filterPackages: filterPackages,
    );
    _installedAppsMap = {
      for (var app in apps)
        if (app.packageName != null) app.packageName!: app,
    };
    WLog.d(
      _tag,
      '[refreshInstalledAppsCache] Done. Total ${_installedAppsMap.length} apps (raw=${apps.length}).',
    );

    await _enforceAccessibilityAllowlistFromSettings();
  }

  Future<void> _processManagedApp(ManagedApp app) async {
    if (app.packageName == null) {
      WLog.d(_tag, "[_processManagedApp] packageName null, skipping.");
      return;
    }
    final pkg = app.packageName!;
    WLog.d(
      _tag,
      '[_processManagedApp] Started: $pkg action=${app.action?.name} updatePolicy=${app.updatePolicy?.name}',
    );

    if (app.action == AppAction.remove) {
      WLog.d(_tag, "[_processManagedApp] REMOVE action -> uninstalling: $pkg");
      await uninstallApp(pkg);
      WLog.d(_tag, "[_processManagedApp] Done (REMOVE): $pkg");
      return;
    }

    final existingApp = _installedAppsMap[pkg];
    bool needInstall = false;

    if (existingApp == null) {
      WLog.d(
        _tag,
        "[_processManagedApp] App not installed -> install required: $pkg",
      );
      needInstall = true;
    } else {
      final newVersionCode = app.applicationVersion?.versionCode;
      final currentVersionCode = existingApp.versionCode;
      WLog.d(
        _tag,
        "[_processManagedApp] Version: current=$currentVersionCode, target=$newVersionCode",
      );

      if (newVersionCode != null && currentVersionCode != null) {
        if (newVersionCode > currentVersionCode) {
          if (app.updatePolicy == AutoUpdatePolicy.never) {
            WLog.d(_tag, "Update skipped (policy: never) -> $pkg");
          } else if (app.updatePolicy == AutoUpdatePolicy.wifiOnly) {
            final connectivity = await Connectivity().checkConnectivity();
            if (connectivity.contains(ConnectivityResult.wifi)) {
              WLog.d(
                _tag,
                'Update required (policy: wifi_only, Wifi connected) ($pkg): v$currentVersionCode -> v$newVersionCode',
              );
              needInstall = true;
            } else {
              WLog.d(
                _tag,
                "Update skipped (policy: wifi_only, no Wifi) -> $pkg",
              );
            }
          } else {
            WLog.d(
              _tag,
              "Update required ($pkg): v$currentVersionCode -> v$newVersionCode",
            );
            needInstall = true;
          }
        } else {
          WLog.d(
            _tag,
            "[_processManagedApp] Update not needed (version adequate): $pkg",
          );
        }
      }
    }

    bool isReadyForConfig = true;

    if (needInstall) {
      final isFirstInstall = existingApp == null;
      WLog.d(
        _tag,
        "[_processManagedApp] Starting install process: $pkg (isFirstInstall=$isFirstInstall)",
      );
      final installSuccess = await _installAppAndWait(
        pkg,
        app,
        isFirstInstall: isFirstInstall,
      );

      if (!installSuccess) {
        WLog.d(_tag, "Install failed, skipping configuration -> $pkg");
        isReadyForConfig = false;
      } else {
        WLog.d(_tag, "Install succeeded, proceeding -> $pkg");
      }
    } else if (!needInstall) {
      WLog.d(
        _tag,
        '[_processManagedApp] Install skipped (needInstall=false), applying policy directly: $pkg',
      );
    }

    if (isReadyForConfig) {
      WLog.d(_tag, "[_processManagedApp] Applying policy: $pkg");
      await _applyAllPolicies(pkg, app);
    } else {
      WLog.d(
        _tag,
        "[_processManagedApp] Policy skipped (isReadyForConfig=false): $pkg",
      );
    }
    WLog.d(_tag, "[_processManagedApp] Done: $pkg");
  }

  Future<bool> _installAppAndWait(
    String packageName,
    ManagedApp app, {
    required bool isFirstInstall,
  }) async {
    WLog.d(_tag, "[_installAppAndWait] Started: $packageName");
    if (app.applicationVersion == null) {
      WLog.e(_tag, "Version info missing, cannot download -> $packageName");
      return false;
    }

    WLog.d(_tag, "[_installAppAndWait] Download starting: $packageName");
    final (downloadOk, savePath) = await _appDownloadApi.downloadApp(
      packageName: packageName,
      appVersion: app.applicationVersion!,
    );

    WLog.d(
      _tag,
      "[_installAppAndWait] Download result: ok=$downloadOk path=$savePath",
    );
    await Future.delayed(Duration.zero);

    if (!downloadOk || savePath == null) {
      WLog.d(
        _tag,
        "[_installAppAndWait] Download failed or no path, exiting: $packageName",
      );
      return false;
    }

    final completer = Completer<bool>();
    StreamSubscription? subscription;
    StreamSubscription? statusSubscription;

    appEventHandler.registerPendingInstall(packageName, completer);

    statusSubscription = appEventHandler.appStatusStream.listen((statusEvent) {
      if (statusEvent.packageName == packageName && !completer.isCompleted) {
        if (statusEvent.eventType == 'INSTALLED' ||
            statusEvent.eventType == 'UPDATED') {
          WLog.i(
            _tag,
            "[_installAppAndWait] appStatus fallback -> $packageName (${statusEvent.eventType})",
          );
          completer.complete(true);
        }
      }
    });

    final timeoutTimer = Timer(const Duration(minutes: 5), () {
      if (!completer.isCompleted) {
        WLog.d(_tag, "Install timed out -> $packageName");
        appEventHandler.unregisterPendingInstall(packageName);
        completer.complete(false);
      }
    });

    subscription = appEventHandler.installResultStream.listen((event) {
      if (event.packageName == packageName && !completer.isCompleted) {
        WLog.d(
          _tag,
          "Native response received (stream) -> $packageName Success: ${event.success}",
        );
        completer.complete(event.success);
      }
    });

    WLog.d(_tag, "[_installAppAndWait] Triggering APK install: $packageName");
    try {
      final triggered = await _appBridge.installApk(savePath);
      WLog.d(_tag, "[_installAppAndWait] Trigger result: triggered=$triggered");

      if (!triggered) {
        completer.complete(false);
      }
    } catch (e) {
      WLog.d(_tag, "Install trigger error -> $packageName: $e");
      if (!completer.isCompleted) completer.complete(false);
    }

    final result = await completer.future;
    WLog.d(
      _tag,
      "[_installAppAndWait] Install result: success=$result -> $packageName",
    );

    appEventHandler.unregisterPendingInstall(packageName);
    subscription.cancel();
    statusSubscription.cancel();
    timeoutTimer.cancel();

    try {
      final file = File(savePath);
      if (await file.exists()) await file.delete();
    } catch (_) {}

    WLog.d(_tag, "[_installAppAndWait] Done: $packageName");

    _updateAppCache(packageName);

    if ((app.launchAfterInstall ?? false) && isFirstInstall) {
      await Future.delayed(Duration(seconds: appLaunchAfterInstallTimeout));
      _appBridge.launchApp(packageName);
    }

    return result;
  }

  Future<void> _applyAllPolicies(String pkg, ManagedApp app) async {
    // Exclude the agent itself to avoid making its uninstall protection permanent.
    if (pkg == await _getOwnPackageName()) {
      WLog.w(_tag, '[_applyAllPolicies] Skipping own package: $pkg');
      return;
    }

    WLog.d(_tag, '[_applyAllPolicies] Started: $pkg');
    if (app.runOnBoot != null && app.runOnBoot != OnOff.def) {
      WLog.d(
        _tag,
        "[_applyAllPolicies] runOnBoot -> ${app.runOnBoot!.isEnabled}: $pkg",
      );
      _setBootStartupEnabled(pkg, app.runOnBoot!.isEnabled);
    }

    await _appBridge.setUninstallBlocked(pkg, blocked: app.uninstallBlock);
    WLog.d(
      _tag,
      "[_applyAllPolicies] setUninstallBlocked(${app.uninstallBlock}) completed: $pkg",
    );

    WLog.d(_tag, "[_applyAllPolicies] Done: $pkg");
  }

  List<String> _getBootStartupApps() {
    final raw = _basicStorage.getString(Sk.bootStartupApps.name);
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw) as List;
      return decoded
          .map((e) => e.toString())
          .where((e) => e.isNotEmpty)
          .toList();
    } catch (_) {
      return [];
    }
  }

  void _setBootStartupEnabled(String packageName, bool enabled) {
    final current = _getBootStartupApps().toSet();
    final before = current.contains(packageName);
    if (enabled) {
      current.add(packageName);
    } else {
      current.remove(packageName);
    }
    _basicStorage.setString(
      Sk.bootStartupApps.name,
      jsonEncode(current.toList()),
    );
    WLog.d(
      _tag,
      '[_setBootStartupEnabled] $packageName enabled=$enabled (previous=$before, list=${current.length} apps)',
    );
  }

  Future<void> _handleAppStatusChange(
    String packageName,
    String eventType,
  ) async {
    WLog.d(_tag, "App status changed -> $packageName: $eventType");

    switch (eventType) {
      case 'INSTALLED':
        await _updateAppCache(packageName);
        await _enforceAccessibilityAllowlistFromSettings();
        break;

      case 'UPDATED':
      case 'SUSPENDED':
        await _updateAppCache(packageName);
        break;

      case 'UNINSTALLED':
        await _updateAppCache(packageName);
        break;

      default:
        WLog.d(_tag, "Unknown event type -> $eventType");
    }
  }

  Future<String> _getOwnPackageName() async {
    if (_ownPackageNameCache != null) return _ownPackageNameCache!;
    final info = await PackageInfo.fromPlatform();
    _ownPackageNameCache = info.packageName;
    return _ownPackageNameCache!;
  }

  static List<String> parseEnabledAccessibilityPackages(String? raw) {
    if (raw == null || raw.trim().isEmpty) return [];
    final out = <String>[];
    for (final segment in raw.split(':')) {
      final s = segment.trim();
      if (s.isEmpty) continue;
      final slash = s.indexOf('/');
      final pkg = (slash > 0 ? s.substring(0, slash) : s).trim();
      if (pkg.isNotEmpty) out.add(pkg);
    }
    return out;
  }

  bool get _hasAccessibilityAllowlistPolicy {
    final a = _allowedAccessibilityApps;
    return a != null && a.isNotEmpty;
  }

  Future<void> _enforceAccessibilityAllowlistFromSettings() async {
    if (!_hasAccessibilityAllowlistPolicy) return;
    try {
      final raw = await _systemSettings.getSecureString(
        'enabled_accessibility_services',
      );
      await _enforceAccessibilityAllowlistForPackages(
        parseEnabledAccessibilityPackages(raw),
      );
    } catch (e) {
      WLog.w(_tag, 'Failed to read accessibility setting: $e');
    }
  }

  Future<void> _enforceAccessibilityAllowlistForPackages(
    List<String> enabledPackages,
  ) async {
    if (!_hasAccessibilityAllowlistPolicy) return;

    final allow = _allowedAccessibilityApps!.toSet();
    final own = await _getOwnPackageName();

    for (final pkg in enabledPackages.toSet()) {
      if (pkg == own) continue;
      if (allow.contains(pkg)) continue;

      WLog.w(_tag, 'Accessibility allowlist violation: $pkg');
      await uninstallApp(pkg);
    }
  }

  Future<void> _updateAppCache(String packageName) async {
    try {
      final apps = await _appBridge.getInstalledApps(
        includeSystemApps: true,
        filterPackages: [packageName],
      );

      if (apps.isNotEmpty) {
        _installedAppsMap[packageName] = apps.first;
        WLog.d(_tag, "Cache updated -> $packageName");
      } else {
        _installedAppsMap.remove(packageName);
        WLog.d(
          _tag,
          "App not found/uninstalled -> $packageName removed from map",
        );
      }
    } catch (e) {
      WLog.d(_tag, "Cache update error -> $packageName: $e");
    }
  }

  void dispose() {
    stopWatchdog();
  }

  Future<void> launchApp(String packageName) async {
    await _appBridge.launchApp(packageName);
  }

  Future<void> uninstallApp(String packageName) async {
    await _appBridge.uninstallApp(packageName);
    _installedAppsMap.remove(packageName);
  }

  Future<void> openAppSettings(String packageName) async {
    await _appBridge.openAppSettings(packageName);
  }

  Future<bool> clearAppData(String packageName) async {
    return await _appBridge.clearAppData(packageName);
  }
}
