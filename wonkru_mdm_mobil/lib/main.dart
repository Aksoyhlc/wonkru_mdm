import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wonkrumdm/Core/Constants/Enums/global.dart';
import 'package:wonkrumdm/Core/Logging/wlog.dart';
import 'package:wonkrumdm/Core/Utils/basic_storage.dart';
import 'package:wonkrumdm/Core/Utils/storage_helper.dart';
import 'package:wonkrumdm/Views/Home/home_page.dart';
import 'package:wonkrumdm/Views/Widgets/full_screen_message.dart';

import 'Core/Constants/Enums/storage_keys.dart';
import 'Core/Init/app_bootstrap.dart';
import 'Core/L10n/L.dart';
import 'Core/L10n/Language.dart';
import 'Core/Services/heart_beat.dart';
import 'Core/Theme/wonkru_theme.dart';
import 'Logic/Common/device_controller.dart';
import 'Views/Install/install_page.dart';
import 'Views/PermissionsSetup/permission_setup.dart';

const _tag = 'Main';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WLog.init();
  AppBootstrap.setUpNativeEventHandlers();
  WLog.i(_tag, 'Starting application...');

  await StorageHelper.instance.init();
  await BasicStorage.instance.init();
  WLog.d(_tag, 'Storage ready');

  BasicStorage.instance.setBool(Sk.watchdog_service_enabled.name, true);

  await HeartbeatService.start();
  WLog.d(_tag, 'Heartbeat started');

  WLog.i(_tag, 'Starting runApp');
  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> headlessMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  WLog.init();
  WLog.i(_tag, 'Starting application in headless mode...');

  AppBootstrap.setUpNativeEventHandlers();

  await StorageHelper.instance.init();
  await BasicStorage.instance.init();
  if (BasicStorage.instance.getInt(Sk.installTime.name) == null) {
    WLog.w(_tag, 'Device not registered, cannot continue in headless mode');
    return;
  }

  await HeartbeatService.start();
  await AppBootstrap.firstInit(headless: true);
  await AppBootstrap.servicesInit(headless: true);
  WLog.d(_tag, 'Headless bootstrap complete');

  DeviceController.to.applyLatestConfig(applyConfiguration: true);
  WLog.i(_tag, 'Headless mode startup complete');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      child: GetMaterialApp(
        theme: WonkruTheme.data,
        darkTheme: WonkruTheme.data,
        translations: AppTranslations(),
        locale: AppTranslations.initialLocale,
        fallbackLocale: AppTranslations.en,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppTranslations.supportedLocales.toList(),
        debugShowCheckedModeBanner: false,
        title: L.app_title,
        home: const ControlPage(),
      ),
    );
  }
}

class ControlPage extends StatefulWidget {
  const ControlPage({super.key});

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  Rx<ActionStatus> status = ActionStatus.idle.obs;
  RxString statusMessage = L.status_starting.obs;
  int? installTime;
  int? permissionsCompletedAt;
  String global = '0';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchData();
    });
  }

  fetchData() async {
    installTime = BasicStorage.instance.getInt(Sk.installTime.name);
    permissionsCompletedAt = BasicStorage.instance.getInt(Sk.permissionsCompletedAt.name);

    if (permissionsCompletedAt == null) {
      WLog.i(_tag, 'Permission setup required, redirecting to PermissionsSetup page');
      status.value = ActionStatus.action;
      statusMessage.value = L.permission_setup_required;
      return;
    }

    if (installTime == null) {
      WLog.i(_tag, 'Device registration required, redirecting to Install page');
      status.value = ActionStatus.action;
      statusMessage.value = L.device_registration_required;
      return;
    }

    status.value = ActionStatus.loading;
    statusMessage.value = L.preparing;
    WLog.d(_tag, 'Applying bootstrap and config...');
    await Future.delayed(const Duration(milliseconds: 20));
    try {
      await AppBootstrap.firstInit();
      await Future.delayed(Duration.zero);
      await AppBootstrap.servicesInit();
      await Future.delayed(Duration.zero);
      DeviceController.to.applyLatestConfig(applyConfiguration: true);

      if (DeviceController.to.config.value.name == null) {
        WLog.w(_tag, 'Config received but device name is missing (config may not be assigned on server)');
        status.value = ActionStatus.error;
        statusMessage.value = L.device_registration_checked_no_config;
        return;
      }

      status.value = ActionStatus.success;
      statusMessage.value = L.all_operations_done_redirecting;
      WLog.i(_tag, 'Bootstrap complete, redirecting to home page');
    } catch (e, st) {
      WLog.e(_tag, 'Bootstrap/config initialization error', error: e, stackTrace: st);
      status.value = ActionStatus.error;
      statusMessage.value = L.device_registration_checked_other_failed + '\n${L.errorWithMessage(e.toString())}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (status.value == ActionStatus.loading || status.value == ActionStatus.idle) {
        return FullScreenMessage(message: statusMessage.value, isLoading: status.value == ActionStatus.loading);
      }

      if (status.value == ActionStatus.error) {
        return FullScreenMessage(message: statusMessage.value, type: MessageType.error);
      }

      if (status.value == ActionStatus.action) {
        if (permissionsCompletedAt == null) {
          return const PermissionsSetupPage();
        }

        if (installTime == null) {
          return const InstallPage();
        }
      }

      return const HomePage();
    });
  }
}