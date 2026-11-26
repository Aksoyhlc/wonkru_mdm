import 'package:get/get.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../../Core/L10n/L.dart';

class DeviceDetailFormat {
  const DeviceDetailFormat._();

  /// Joins the non-empty [parts] with [separator]; null when nothing is left.
  static String? join(List<String?> parts, {String separator = ' '}) {
    final kept = [
      for (final part in parts)
        if (part != null && part.trim().isNotEmpty) part.trim(),
    ];
    return kept.isEmpty ? null : kept.join(separator);
  }

  static String? battery(DeviceStateCache? state, Device device) {
    final level = state?.batteryLevel ?? device.batteryLevel;
    if (level == null) return null;
    final status = state?.batteryState;
    return status == null ? '%$level' : '%$level · $status';
  }

  static String? screen(DeviceStateCache? state) {
    final width = state?.screenWidthPx;
    final height = state?.screenHeightPx;
    if (width == null || height == null) return null;
    return '$width × $height px';
  }

  static String? wifi(DeviceStateCache? state) {
    final parts = [
      if (state?.wifiRssi != null) '${state!.wifiRssi} dBm',
      if (state?.wifiLinkSpeed != null) '${state!.wifiLinkSpeed} Mbps',
      if (state?.wifiFrequency != null) '${state!.wifiFrequency} MHz',
    ];
    return parts.isEmpty ? null : parts.join(' · ');
  }

  static String? appCounts(DeviceStateCache? state) {
    if (state?.totalInstalledApps == null) return null;
    final parts = [
      L.devices.countTotal.trParams({'count': '${state!.totalInstalledApps}'}),
      if (state.userAppsCount != null)
        L.devices.countUser.trParams({'count': '${state.userAppsCount}'}),
      if (state.systemAppsCount != null)
        L.devices.countSystem.trParams({'count': '${state.systemAppsCount}'}),
    ];
    return parts.join(' · ');
  }
}
