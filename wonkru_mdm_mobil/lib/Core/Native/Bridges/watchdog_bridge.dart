import 'package:flutter/services.dart';

class WatchdogBridge {
  WatchdogBridge._();
  static const _channel = MethodChannel('com.wonkrumdm/watchdog');

  static Future<void> startWatchdog() => _channel.invokeMethod<void>('startWatchdog');

  static Future<void> stopWatchdog() => _channel.invokeMethod<void>('stopWatchdog');

  static Future<void> runWatchdogCheckNow() =>
      _channel.invokeMethod<void>('runWatchdogCheckNow');

}