import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:wonkrumdm/Core/Constants/Enums/report_type.dart';
import 'package:wonkrumdm/Core/Constants/Enums/storage_keys.dart';
import 'package:wonkrumdm/Core/Interfaces/watchdog_interface.dart';
import 'package:wonkrumdm/Core/Logging/wlog.dart';
import 'package:wonkrumdm/Core/Managers/Stream/device_stream_manager.dart';
import 'package:wonkrumdm/Core/Managers/base_manager.dart';
import 'package:wonkrumdm/Core/Native/Bridges/wifi_bridge.dart';
import 'package:wonkrumdm/Core/Native/Generated/wifi_api.g.dart';
import 'package:wonkrumdm/Core/Utils/basic_storage.dart';
import 'package:wonkrumdm/Core/Utils/network_address_helper.dart';
import 'package:wonkrumdm/Data/DataSources/Remote/report_api.dart';
import 'package:wonkrumdm/Data/Models/Features/other_settings_config.dart';

const _tag = 'NetworkManager';

class NetworkManager extends BaseManager<OtherSettingsConfig> implements IWatchdog {
  static final NetworkManager instance = NetworkManager._internal();

  factory NetworkManager() => instance;

  NetworkManager._internal();

  final _wifiBridge = WifiBridge();
  final _reportApi = ReportRemoteDataSource();
  final connectivity = Connectivity();

  Timer? _watchdogTimer;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  Timer? _connectivityDebounce;
  String? _lastReportedWifiSignature;

  OtherSettingsConfig? _currentConfig;

  @override
  bool get isWatchdogRunning => _watchdogTimer != null;

  @override
  Duration get initialDelay => const Duration(seconds: 20);

  @override
  Future<void> checkNow() async => await _checkAndEnforcePolicy();

  @override
  Future<Map<String, dynamic>> getData() async {
    return await safeCall<Map<String, dynamic>>(() async {
      final isOnlineStatus = await isOnline();
      final connectionTypes = await getConnectionTypes();
      final wifiInfo = await getDetailedWifiInfo();

      final networkInfo = NetworkInfo();
      final ipBundle = await Future.wait<Object?>([
        networkInfo.getWifiIP(),
        networkInfo.getWifiIPv6(),
        networkInfo.getWifiSubmask(),
        networkInfo.getWifiBroadcast(),
        networkInfo.getWifiGatewayIP(),
        networkInfo.getWifiName(),
        networkInfo.getWifiBSSID(),
        NetworkAddressHelper.getPreferredIPv4(),
        NetworkAddressHelper.getPreferredIPv6(),
        NetworkAddressHelper.getLocalLanIPv4(),
        // Do not let the public-IP call block data collection: continue with null on timeout (a 12s public-IP timeout caused an opening ANR).
        NetworkAddressHelper.getPublicIPv4().timeout(
          const Duration(seconds: 2),
          onTimeout: () => null,
        ),
      ]);
      final ipResults = ipBundle.sublist(0, 7);
      final preferredV4 = ipBundle[7] as String?;
      final preferredV6 = ipBundle[8] as String?;
      final ipv4Local = ipBundle[9] as String?;
      final ipv4Public = ipBundle[10] as String?;

      return {
        'isOnline': isOnlineStatus,
        'connectionTypes': connectionTypes.map((c) => c.name).toList(),
        'wifi': wifiInfo != null
            ? {
                'ssid': wifiInfo.ssid,
                'bssid': wifiInfo.bssid,
                'rssi': wifiInfo.rssi,
                'linkSpeed': wifiInfo.linkSpeed,
                'frequency': wifiInfo.frequency,
              }
            : null,
        'ipInfo': {
          'wifiName': ipResults[5],
          'wifiBSSID': ipResults[6],
          'ipv4': preferredV4 ?? ipResults[0],
          'ipv4Local': ipv4Local ?? ipResults[0],
          'ipv4Public': ipv4Public,
          'ipv6': preferredV6 ?? ipResults[1],
          'subnetMask': ipResults[2],
          'broadcast': ipResults[3],
          'gateway': ipResults[4],
        },
      };
    }, defaultValue: {});
  }

  Stream<List<ConnectivityResult>> get onConnectivityChanged => connectivity.onConnectivityChanged;

  Future<bool> isOnline() async {
    final result = await connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  Future<List<ConnectivityResult>> getConnectionTypes() async {
    return await connectivity.checkConnectivity();
  }

  Future<bool> isWifiConnected() async {
    final result = await connectivity.checkConnectivity();
    return result.contains(ConnectivityResult.wifi);
  }

  Stream<bool> get onWifiChanged => onConnectivityChanged.map((r) => r.contains(ConnectivityResult.wifi));

  Future<NativeWifiInfo?> getDetailedWifiInfo() async {
    return await _wifiBridge.getConnectionInfo();
  }

  @override
  Future<void> applyConfiguration(OtherSettingsConfig config) async {
    _currentConfig = config;
    await safeExecute(() async {
      if (config.requiredWifi != true) return;

      final isEnabled = await _wifiBridge.isWifiEnabled();
      if (shouldReEnableWifi(
        requiredWifi: config.requiredWifi ?? false,
        isWifiEnabled: isEnabled,
        operatorOverride: operatorWifiOverride,
      )) {
        await _wifiBridge.setWifiEnabled(true);
      }
    }, logMessage: 'NetworkManager: Network configuration applied');
  }

  @override
  void startWatchdog() {
    stopWatchdog();

    _watchdogTimer = Timer.periodic(const Duration(seconds: 150), (timer) async {
      await _checkAndEnforcePolicy();
    });

    _connectivitySubscription = connectivity.onConnectivityChanged.listen((_) {
      _connectivityDebounce?.cancel();
      _connectivityDebounce = Timer(const Duration(seconds: 6), () async {
        await _checkAndEnforcePolicy();
      });
    });

    WLog.i(_tag, 'Watchdog started (150s interval + connectivity debounced)');
  }

  @override
  void stopWatchdog() {
    _watchdogTimer?.cancel();
    _watchdogTimer = null;
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
    _connectivityDebounce?.cancel();
    _connectivityDebounce = null;
  }

  Future<void> _checkAndEnforcePolicy() async {
    final cfg = _currentConfig;
    if (cfg == null) return;

    final wifiInfo = await _wifiBridge.getConnectionInfo();
    await _reportWifiChangeIfNeeded(wifiInfo);

    DeviceStreamManager.to.checkConnectionOrReconnect();

    if (cfg.requiredWifi ?? false) {
      final isEnabled = await _wifiBridge.isWifiEnabled();
      if (isEnabled) return;

      if (shouldReEnableWifi(
        requiredWifi: cfg.requiredWifi ?? false,
        isWifiEnabled: isEnabled,
        operatorOverride: operatorWifiOverride,
      )) {
        WLog.i(_tag, 'Watchdog: Wi-Fi was off, re-enabling');
        await _wifiBridge.setWifiEnabled(true);
      } else {
        WLog.i(_tag, 'Watchdog: Wi-Fi disabled by operator command, not re-enabling');
      }
    }
  }

  static String _normalizeSsid(String? ssid) {
    if (ssid == null || ssid.isEmpty) return '';
    final cleaned = ssid.replaceAll('"', '').trim();
    final lower = cleaned.toLowerCase();
    if (lower.isEmpty || lower == '<unknown ssid>' || lower == 'unknown ssid') {
      return '';
    }
    return cleaned;
  }

  Future<void> _reportWifiChangeIfNeeded(NativeWifiInfo? wifiInfo) async {
    final currentSsid = _normalizeSsid(wifiInfo?.ssid);
    final currentBssid = (wifiInfo?.bssid ?? '').trim().toLowerCase();
    final currentSignature = currentSsid.isEmpty ? 'disconnected' : '$currentSsid|$currentBssid';

    if (_lastReportedWifiSignature == null) {
      _lastReportedWifiSignature = currentSignature;
      return;
    }
    if (_lastReportedWifiSignature == currentSignature) return;

    final previousSignature = _lastReportedWifiSignature;
    _lastReportedWifiSignature = currentSignature;

    final payload = <String, dynamic>{
      'state': currentSsid.isEmpty ? 'disconnected' : 'connected',
      'ssid': currentSsid.isEmpty ? null : currentSsid,
      'bssid': currentBssid.isEmpty ? null : currentBssid,
      'previous_network': previousSignature,
      'current_network': currentSignature,
      'occurred_at': DateTime.now().toUtc().toIso8601String(),
    }..removeWhere((_, value) => value == null);

    final (ok, message) = await _reportApi.sendReport(type: ReportType.wifiNetworkChanged, payload: payload);
    if (!ok) {
      _lastReportedWifiSignature = previousSignature;
      WLog.w(_tag, 'Failed to send Wi-Fi change report: $message');
      return;
    }

    WLog.i(_tag, 'Wi-Fi change reported: $currentSignature');
  }

  Future<bool> toggleWifi(bool enable) async {
    final ok = await (wifiToggleOverride ?? _wifiBridge.setWifiEnabled)(enable);
    if (ok) {
      // An operator enable/disable command is persistent against the watchdog:
      // once disabled it is not re-enabled, and an enable clears the override.
      operatorWifiOverride = !enable;
    }
    return ok;
  }

  static bool shouldReEnableWifi({
    required bool requiredWifi,
    required bool isWifiEnabled,
    required bool operatorOverride,
  }) => requiredWifi && !isWifiEnabled && !operatorOverride;

  @visibleForTesting
  Future<bool> Function(bool enable)? wifiToggleOverride;

  bool? _operatorWifiOverrideCache;

  /// Persisted across restarts; only an explicit enable clears it.
  bool get operatorWifiOverride =>
      _operatorWifiOverrideCache ??= _readOperatorWifiOverride();

  set operatorWifiOverride(bool value) {
    _operatorWifiOverrideCache = value;
    try {
      BasicStorage.instance.setBool(Sk.wifiOperatorOverride.name, value);
    } catch (_) {
      // If storage is not ready (early startup/test), keep the value in memory only.
    }
  }

  bool _readOperatorWifiOverride() {
    try {
      return BasicStorage.instance.getBool(Sk.wifiOperatorOverride.name) ??
          false;
    } catch (_) {
      return false;
    }
  }
}
