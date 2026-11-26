import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/Core/Native/Generated/wifi_api.g.dart',
    dartOptions: DartOptions(),
    kotlinOut: 'android/app/src/main/kotlin/com/wonkrumdm/api/WifiApi.g.kt',
    kotlinOptions: KotlinOptions(package: 'com.wonkrumdm.api.wifi'),
  ),
)
class NativeWifiInfo {
  String? ssid;
  String? bssid;
  String? macAddress;
  String? ipAddress;
  int? rssi;
  int? linkSpeed;
  int? frequency;
  String? networkState;
}

class NativeWifiEvent {
  String? action;
  bool? wifiEnabled;
  bool? connected;
  String? ssid;
  String? bssid;
  int? rssi;
  int? timestampMs;
}

@HostApi()
abstract class WifiAPI {
  @async
  Map<String, Object?> setWifiEnabled(bool enabled);

  @async
  Map<String, Object?> isWifiEnabled();

  @async
  Map<String, Object?> getConnectionInfo();

}

@FlutterApi()
abstract class WifiEventAPI {
  void onWifiChanged(NativeWifiEvent event);
}