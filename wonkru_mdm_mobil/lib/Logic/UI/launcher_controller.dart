import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wonkrumdm/Core/Constants/Enums/launcher_mode_enums.dart';
import 'package:wonkrumdm/Core/Constants/Enums/storage_keys.dart';
import 'package:wonkrumdm/Core/Init/app_bootstrap.dart';
import 'package:wonkrumdm/Core/Logging/wlog.dart';
import 'package:wonkrumdm/Core/Managers/app_manager.dart';
import 'package:wonkrumdm/Core/Managers/battery_manager.dart';
import 'package:wonkrumdm/Core/Managers/network_manager.dart';
import 'package:wonkrumdm/Core/Managers/storage_manager.dart';
import 'package:wonkrumdm/Core/L10n/L.dart';
import 'package:wonkrumdm/Core/Native/Bridges/app_bridge.dart';
import 'package:wonkrumdm/Core/Native/Generated/app_api.g.dart';
import 'package:wonkrumdm/Core/Utils/storage_helper.dart';
import 'package:wonkrumdm/Data/Models/Features/launcher_config.dart';
import 'package:wonkrumdm/Data/Models/Features/launcher_item_display.dart';
import 'package:wonkrumdm/Data/Models/Features/header_widgets_config.dart';
import 'package:wonkrumdm/Data/Models/Features/launcher_background.dart';
import 'package:wonkrumdm/Data/Models/Features/launcher_design.dart';
import 'package:wonkrumdm/Data/Models/Features/managed_app.dart';
import 'package:wonkrumdm/Logic/Common/device_controller.dart';
import 'package:wonkrumdm/Views/Widgets/threshold_warning_dialog.dart';

const _tag = 'LauncherController';

class LauncherController extends GetxController {
  static LauncherController to = Get.find<LauncherController>();
  final _dc = DeviceController.to;
  final _appBridge = AppBridge();
  bool _initialized = false;
  final _st = StorageHelper.instance;
  static const _appsCacheTTL = Duration(minutes: 15);

  final currentTime = DateTime.now().obs;
  final batteryLevel = 0.obs;
  final isCharging = false.obs;
  final wifiConnected = false.obs;
  final installedApps = <NativeAppInfo>[].obs;

  final appIcons = <String, Uint8List>{}.obs;

  Timer? _clockTimer;
  StreamSubscription? _batterySubscription;
  StreamSubscription? _connectivitySubscription;
  StreamSubscription? _appStatusSub;
  StreamSubscription? _installResultSub;
  Timer? _appsRefreshDebounce;

  LauncherConfig? get launcherConfig => _dc.config.value.launcherConfig;

  LauncherDesign? get launcherDesign => launcherConfig?.design;

  HeaderWidgetsConfig? get headerWidgets => launcherConfig?.headerWidgets;

  LayoutType get layoutType => launcherDesign?.layoutType ?? LayoutType.grid;

  int get columns => launcherDesign?.columns ?? 4;

  int get rows => launcherDesign?.rows ?? 5;

  LauncherItemDisplay? get itemDisplay => launcherDesign?.itemDisplay;

  IconSize get iconSize => itemDisplay?.iconSize ?? IconSize.medium;

  bool get showLabel => itemDisplay?.showLabel ?? true;

  LauncherBackground? get background => launcherDesign?.background;

  Future<void> initialize() async {
    if (_initialized) return;
    _startClock();
    await _initBattery();
    await _initConnectivity();
    _initStorage();
    _bindAppEvents();
    await _loadInstalledApps();
    _initialized = true;
  }

  @override
  void onClose() {
    _clockTimer?.cancel();
    _batterySubscription?.cancel();
    _connectivitySubscription?.cancel();
    _appStatusSub?.cancel();
    _installResultSub?.cancel();
    _appsRefreshDebounce?.cancel();
    super.onClose();
  }

  void _startClock() {
    currentTime.value = DateTime.now();
    _clockTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      currentTime.value = DateTime.now();
    });
  }

  Future<void> _initBattery() async {
    final batteryManager = BatteryManager();

    final info = await batteryManager.getBatteryInfo();
    batteryLevel.value = info.level;
    isCharging.value = info.isCharging;

    batteryManager.startWatchdog();

    _batterySubscription = batteryManager.batteryStream.listen((info) {
      batteryLevel.value = info.level;
      isCharging.value = info.isCharging;
    });

    batteryManager.lowBatteryStream.listen((info) {
      showThresholdWarning(
        title: L.lowBatteryTitle,
        message: L.lowBatteryMessage('${info.level}'),
        icon: Icons.battery_alert,
        color: Colors.orange,
      );
    });

    batteryManager.criticalBatteryStream.listen((info) {
      showThresholdWarning(
        title: L.criticalBatteryTitle,
        message: L.criticalBatteryMessage('${info.level}'),
        icon: Icons.battery_alert,
        color: Colors.red,
      );
    });
  }

  void _initStorage() {
    final storageManager = StorageManager();

    storageManager.checkNow();

    storageManager.warningStream.listen((freePercent) {
      showThresholdWarning(
        title: L.storageWarningTitle,
        message: L.storageWarningMessage(freePercent.toStringAsFixed(1)),
        icon: Icons.sd_storage_outlined,
        color: Colors.orange,
      );
    });

    storageManager.criticalStream.listen((freePercent) {
      showThresholdWarning(
        title: L.storageCriticalTitle,
        message: L.storageCriticalMessage(freePercent.toStringAsFixed(1)),
        icon: Icons.storage_rounded,
        color: Colors.red,
      );
    });
  }

  Future<void> _initConnectivity() async {
    final networkManager = NetworkManager.instance;
    try {
      wifiConnected.value = await networkManager.isWifiConnected();

      _connectivitySubscription = networkManager.onWifiChanged.listen((isWifi) {
        wifiConnected.value = isWifi;
      });
    } catch (e) {}
  }

  Future<void> _loadInstalledApps() async {
    try {
      final cached = _st.getJson(Sk.installedAppsCache.name);
      if (cached != null && cached['apps'] is List) {
        final List<dynamic> items = cached['apps'] as List<dynamic>;
        final cachedApps = items.map((e) {
          final m = Map<String, dynamic>.from(e as Map);
          return NativeAppInfo(packageName: m['packageName'] as String?, appName: m['appName'] as String?);
        }).toList();
        final filteredCachedApps = cachedApps.where(_shouldShowCachedApp).toList();
        installedApps.value = filteredCachedApps;
        _loadAppIcons(filteredCachedApps);
      }

      final appManager = AppManager();
      final cacheWasCleared = cached == null;
      if (appManager.installedAppsMap.isEmpty || cacheWasCleared) {
        await appManager.refreshInstalledAppsCache();
      }

      final installedMap = appManager.installedAppsMap;
      final List<NativeAppInfo> filteredApps = [];

      final managedAppsRaw = _dc.config.value.appSettings?.managedApps ?? [];
      final managedAppsSorted = _managedAppsBySortOrder(managedAppsRaw);

      for (final managedApp in managedAppsSorted) {
        if (_shouldShowManagedApp(managedApp)) {
          final app = installedMap[managedApp.packageName!];
          if (app != null) filteredApps.add(app);
        }
      }

      _loadAppIcons(filteredApps);
      installedApps.value = filteredApps;

      final cachePayload = {
        'apps': filteredApps.map((a) => {'packageName': a.packageName, 'appName': a.appName}).toList(),
        'updatedAt': DateTime.now().toIso8601String(),
      };
      _st.setJsonWithTTL(Sk.installedAppsCache.name, cachePayload, _appsCacheTTL);
    } catch (e, s) {
      WLog.e(_tag, 'Error loading apps: $e', error: e, stackTrace: s);
    }
  }

  bool _shouldShowManagedApp(ManagedApp app) {
    return app.packageName != null && app.showLauncher != false;
  }

  bool _shouldShowCachedApp(NativeAppInfo app) {
    final packageName = app.packageName;
    if (packageName == null) return false;
    final managedApp = _dc.config.value.appSettings?.managedApps
        ?.where((element) => element.packageName == packageName)
        .firstOrNull;
    return managedApp != null && _shouldShowManagedApp(managedApp);
  }

  List<ManagedApp> _managedAppsBySortOrder(List<ManagedApp> list) {
    final copy = List<ManagedApp>.from(list);
    copy.sort((a, b) {
      final sortA = a.sort ?? 999;
      final sortB = b.sort ?? 999;
      final c = sortA.compareTo(sortB);
      if (c != 0) return c;
      return (a.appName ?? '').compareTo(b.appName ?? '');
    });
    return copy;
  }

  void _bindAppEvents() {
    _appStatusSub = appEventHandler.appStatusStream.listen((event) {
      _scheduleAppsRefresh();
    });
    _installResultSub = appEventHandler.installResultStream.listen((event) {
      if (event.success) {
        _scheduleAppsRefresh();
      }
    });
  }

  void _scheduleAppsRefresh() {
    _st.remove(Sk.installedAppsCache.name);
    _appsRefreshDebounce?.cancel();
    _appsRefreshDebounce = Timer(const Duration(seconds: 1), () async {
      await refreshApps();
    });
  }

  Future<void> _loadAppIcons(List<NativeAppInfo> apps) async {
    for (final app in apps) {
      if (app.packageName != null && !appIcons.containsKey(app.packageName)) {
        final icon = await _appBridge.getAppIcon(app.packageName!);
        if (icon != null) {
          appIcons[app.packageName!] = icon;
        }
      }
    }
  }

  Future<void> launchApp(NativeAppInfo app) async {
    if (app.packageName != null) {
      await _appBridge.launchApp(app.packageName!);
    }
  }

  Future<void> openAppSettings(NativeAppInfo app) async {
    if (app.packageName != null) {
      await AppManager().openAppSettings(app.packageName!);
    }
  }

  Future<void> refreshApps() async {
    await _loadInstalledApps();
  }

  Uint8List? getAppIcon(String packageName) {
    return appIcons[packageName];
  }
}
