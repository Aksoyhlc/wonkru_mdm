import 'package:get/get.dart';
import 'package:wonkrumdm/Core/Interfaces/watchdog_interface.dart';
import 'package:wonkrumdm/Core/Managers/app_manager.dart';
import 'package:wonkrumdm/Core/Managers/audio_manager.dart';
import 'package:wonkrumdm/Core/Managers/battery_manager.dart';
import 'package:wonkrumdm/Core/Managers/display_manager.dart';
import 'package:wonkrumdm/Core/Managers/network_manager.dart';
import 'package:wonkrumdm/Core/Managers/storage_manager.dart';

class WatchdogController extends GetxController {
  static WatchdogController get to => Get.find<WatchdogController>();

  final List<IWatchdog> _watchdogs = [
    BatteryManager(),
    StorageManager(),
    AudioManager(),
    DisplayManager(),
    AppManager(),
    NetworkManager(),
  ];

  @override
  void onClose() {
    stopAll();
    super.onClose();
  }

  void startAll() {
    for (var watchdog in _watchdogs) {
      if (watchdog.initialDelay > Duration.zero) {
        Future.delayed(watchdog.initialDelay, () {
          if (!isClosed) {
            watchdog.startWatchdog();
          }
        });
      } else {
        watchdog.startWatchdog();
      }
    }
  }

  void stopAll() {
    for (var watchdog in _watchdogs) {
      watchdog.stopWatchdog();
    }
  }

  void start<T extends IWatchdog>() {
    _watchdogs.whereType<T>().firstOrNull?.startWatchdog();
  }

  void stop<T extends IWatchdog>() {
    _watchdogs.whereType<T>().firstOrNull?.stopWatchdog();
  }

  void restartAll() {
    stopAll();
    startAll();
  }
}