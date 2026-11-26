import 'package:get/get.dart';
import 'package:wonkrumdm/Core/Managers/Stream/device_stream_manager.dart';
import 'package:wonkrumdm/Core/Services/sync_scheduler_service.dart';
import 'package:wonkrumdm/Logic/Common/device_controller.dart';
import 'package:wonkrumdm/Logic/Common/watchdog_controller.dart';
import 'package:wonkrumdm/Logic/UI/input_controller.dart';
import 'package:wonkrumdm/Logic/UI/launcher_controller.dart';

class DependencyInjection {
  init({bool headless = false}) {
    getOrCreate(() => DeviceController(), fenix: true);
    getOrCreate(() => SyncSchedulerService());
    getOrCreate(() => InputController());
    getOrCreate(() => LauncherController());
    getOrCreate(() => DeviceStreamManager());
    getOrCreate(() => WatchdogController(), fenix: true);
  }

  static T getOrCreate<T>(T Function() builder, {bool fenix = true}) {
    if (!Get.isRegistered<T>()) {
      Get.lazyPut<T>(() => builder(), fenix: fenix);
    }
    return Get.find<T>();
  }
}