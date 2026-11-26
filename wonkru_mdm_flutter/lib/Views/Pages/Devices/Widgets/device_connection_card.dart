import 'package:flutter/material.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../../Core/Extensions/datetime.dart';
import '../../../../Core/L10n/L.dart';
import '../../../Widgets/Card/section_card.dart';
import '../../../Widgets/Form/detail_field.dart';
import 'device_detail_format.dart';
import 'device_flag_badges.dart';

class DeviceConnectionCard extends StatelessWidget {
  const DeviceConnectionCard({
    super.key,
    required this.device,
    required this.state,
  });

  final Device device;
  final DeviceStateCache? state;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: L.devices.connectionStatus,
      child: Column(
        children: [
          DetailField(
            label: L.devices.lastSync,
            value: state?.collectedAt.formatDateTime(),
          ),
          DetailField(
            label: L.devices.lastSeen,
            value: device.lastSeenAt?.formatDateTime(),
          ),
          DetailField(
            label: L.devices.networkStatus,
            child: DeviceFlagBadges(
              flags: [
                (L.common.online, state?.isOnline, false),
                (L.devices.powerSave, state?.isPowerSaveMode, false),
              ],
            ),
          ),
          DetailField(
            label: L.common.battery,
            value: DeviceDetailFormat.battery(state, device),
          ),
          DetailField(
            label: L.devices.ipAddress,
            value: state?.ipv4 ?? device.ipAddress,
            mono: true,
          ),
          DetailField(label: 'IPv6', value: state?.ipv6, mono: true),
          DetailField(
            label: L.devices.gateway,
            value: DeviceDetailFormat.join(
              [state?.gateway, state?.subnetMask],
              separator: ' / ',
            ),
            mono: true,
          ),
          DetailField(label: L.devices.wifiNetwork, value: state?.currentSsid),
          DetailField(
            label: 'WiFi BSSID',
            value: state?.currentBssid,
            mono: true,
          ),
          DetailField(
            label: L.devices.wifiDetails,
            value: DeviceDetailFormat.wifi(state),
            divider: false,
          ),
        ],
      ),
    );
  }
}
