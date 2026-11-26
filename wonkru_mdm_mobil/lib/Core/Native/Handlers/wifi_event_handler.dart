import 'dart:async';

import 'package:wonkrumdm/Core/Logging/wlog.dart';
import 'package:wonkrumdm/Core/Native/Generated/wifi_api.g.dart';

const _tag = 'WifiEventHandler';

class WifiEventHandler extends WifiEventAPI {
  static final WifiEventHandler _instance = WifiEventHandler._internal();
  factory WifiEventHandler() => _instance;
  WifiEventHandler._internal();

  final _wifiController = StreamController<NativeWifiEvent>.broadcast();

  Stream<NativeWifiEvent> get wifiStream => _wifiController.stream;

  @override
  void onWifiChanged(NativeWifiEvent event) {
    WLog.v(
      _tag,
      'onWifiChanged action=${event.action} '
      'enabled=${event.wifiEnabled} connected=${event.connected} ssid=${event.ssid}',
    );
    _wifiController.add(event);
  }

  void dispose() {
    _wifiController.close();
  }
}