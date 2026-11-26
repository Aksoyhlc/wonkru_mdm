import 'dart:async';

import 'package:intl/date_symbol_data_local.dart';
import 'package:wonkrumdm/Core/Init/dependency_injection.dart';
import 'package:wonkrumdm/Core/Managers/Stream/device_stream_manager.dart';
import 'package:wonkrumdm/Core/Native/Generated/app_api.g.dart';
import 'package:wonkrumdm/Core/Native/Generated/audio_api.g.dart';
import 'package:wonkrumdm/Core/Native/Generated/display_api.g.dart';
import 'package:wonkrumdm/Core/Native/Generated/wifi_api.g.dart';
import 'package:wonkrumdm/Core/Native/Handlers/app_event_handler.dart';
import 'package:wonkrumdm/Core/Native/Handlers/audio_event_handler.dart';
import 'package:wonkrumdm/Core/Native/Handlers/display_event_handler.dart';
import 'package:wonkrumdm/Core/Native/Generated/system_settings_api.g.dart';
import 'package:wonkrumdm/Core/Native/Handlers/system_settings_event_handler.dart';
import 'package:wonkrumdm/Core/Native/Handlers/wifi_event_handler.dart';
import 'package:wonkrumdm/Core/Services/sync_scheduler_service.dart';
import 'package:wonkrumdm/Core/Utils/device_identity_helper.dart';
import 'package:wonkrumdm/Data/DataSources/Remote/serverpod_gateway.dart';
import 'package:wonkrumdm/Logic/Common/device_controller.dart';
import 'package:wonkrumdm/Logic/Common/watchdog_controller.dart';
import 'package:wonkrumdm/Logic/UI/launcher_controller.dart';

final appEventHandler = AppEventHandler();
final displayEventHandler = DisplayEventHandler();
final audioEventHandler = AudioEventHandler();
final wifiEventHandler = WifiEventHandler();
final systemSettingsEventHandler = SystemSettingsEventHandler.instance;

class AppBootstrap {
  static bool isHeadless = false;

  static void setUpNativeEventHandlers() {
    SystemSettingsEventAPI.setUp(systemSettingsEventHandler);
    AppEventApi.setUp(appEventHandler);
    DisplayEventAPI.setUp(displayEventHandler);
    AudioEventAPI.setUp(audioEventHandler);
    WifiEventAPI.setUp(wifiEventHandler);
  }

  static Future<void> permissionsInit() async {
    return;
  }

  static Future<void> firstInit({bool headless = false}) async {
    isHeadless = headless;
    await Future.wait([
      initializeDateFormatting('tr_TR', null),
      initializeDateFormatting('en_US', null),
    ]);
    SystemSettingsEventAPI.setUp(systemSettingsEventHandler);
    AppEventApi.setUp(appEventHandler);
    DisplayEventAPI.setUp(displayEventHandler);
    AudioEventAPI.setUp(audioEventHandler);
    WifiEventAPI.setUp(wifiEventHandler);

    DependencyInjection().init(headless: headless);
  }

  static Future<void> servicesInit({bool headless = false}) async {
    isHeadless = headless;

    // A registered device with a token initializes the Serverpod client here.
    // The register flow only inits on a fresh enroll, so a cold start of an
    // already-registered device would run no RPC at all.
    if (DeviceIdentityHelper.getToken()?.isNotEmpty ?? false) {
      ServerpodGateway.instance.init();
    }

    DeviceController.to.loadFromLocal();
    if (!headless) {
      Future.microtask(() => LauncherController.to.initialize());
    }
    unawaited(
      Future.wait([
        DeviceStreamManager.to.connect(),
        SyncSchedulerService.to.startSchedules(),
      ]),
    );
    Future.microtask(() => WatchdogController.to.startAll());
  }
}
