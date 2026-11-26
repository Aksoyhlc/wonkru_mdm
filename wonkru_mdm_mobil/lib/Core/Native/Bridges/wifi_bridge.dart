import 'package:wonkrumdm/Core/Native/Bridges/base_bridge.dart';
import 'package:wonkrumdm/Core/Native/Generated/wifi_api.g.dart';

class WifiBridge extends BaseBridge {
  static final WifiBridge _instance = WifiBridge._internal();

  factory WifiBridge() => _instance;

  WifiBridge._internal();

  final _api = WifiAPI();

  @override
  String get bridgeName => "WifiBridge";

  Future<bool> setWifiEnabled(bool enabled) async {
    final (success, _) = await mdmResultSafeCall<Object>(
      () async => await _api.setWifiEnabled(enabled),
      logMessage: "$bridgeName: WiFi ${enabled ? 'enabled' : 'disabled'}",
    );
    return success;
  }

  Future<bool> isWifiEnabled() async {
    final (success, data) = await mdmResultSafeCall<Object>(() async => await _api.isWifiEnabled(), defaultValue: null);

    if (success && data != null) {
      final map = data as bool;
      return map;
    }
    return false;
  }

  Future<NativeWifiInfo?> getConnectionInfo() async {
    final (success, data) = await mdmResultSafeCall<Object>(
      () async => await _api.getConnectionInfo(),
      defaultValue: null,
    );

    if (success && data != null) {
      return data as NativeWifiInfo;
    }
    return null;
  }
}
