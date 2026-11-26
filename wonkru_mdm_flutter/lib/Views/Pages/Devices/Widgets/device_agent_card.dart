import 'package:flutter/material.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../../Core/Extensions/datetime.dart';
import '../../../../Core/L10n/L.dart';
import '../../../Widgets/Card/section_card.dart';
import '../../../Widgets/Form/detail_field.dart';
import 'device_detail_format.dart';
import 'device_flag_badges.dart';

class DeviceAgentCard extends StatelessWidget {
  const DeviceAgentCard({
    super.key,
    required this.device,
    required this.state,
  });

  final Device device;
  final DeviceStateCache? state;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: L.devices.agentKioskStatus,
      child: Column(
        children: [
          DetailField(
            label: L.devices.agentVersion,
            value: DeviceDetailFormat.join([
              device.agentVersionName,
              device.agentVersionCode == null
                  ? null
                  : '(${device.agentVersionCode})',
            ]),
          ),
          DetailField(
            label: L.devices.launcherMode,
            child: DeviceFlagBadges(
              flags: [
                (
                  'Launcher',
                  state?.launcherModeEnabled ?? device.isLauncherMode,
                  false,
                ),
                ('Watchdog', state?.watchdogServiceEnabled, false),
              ],
            ),
          ),
          DetailField(
            label: L.devices.agentHeartbeat,
            value: state?.flutterAliveAt?.formatDateTime(),
          ),
          DetailField(
            label: L.devices.lastPolicyUpdate,
            value: (state?.lastPolicyUpdateAt ?? device.lastPolicyUpdate)
                ?.formatDateTime(),
          ),
          DetailField(
            label: L.devices.restrictionCount,
            value: state?.restrictionCount?.toString(),
          ),
          DetailField(
            label: L.devices.applications,
            value: DeviceDetailFormat.appCounts(state),
            divider: false,
          ),
        ],
      ),
    );
  }
}
