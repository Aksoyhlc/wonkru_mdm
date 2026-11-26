import 'package:flutter/material.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../../Core/Extensions/datetime.dart';
import '../../../../Core/L10n/L.dart';
import '../../../Widgets/Card/section_card.dart';
import '../../../Widgets/Form/detail_field.dart';
import 'device_detail_format.dart';

class DeviceInfoCard extends StatelessWidget {
  const DeviceInfoCard({
    super.key,
    required this.device,
    required this.state,
    required this.policyName,
  });

  final Device device;
  final DeviceStateCache? state;
  final String? policyName;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: L.devices.infoTitle,
      child: Column(
        children: [
          DetailField(label: L.common.code, value: device.code),
          DetailField(label: 'UUID', value: device.uuid, mono: true),
          DetailField(label: L.devices.serialNo, value: device.serialNo),
          DetailField(
            label: L.devices.brandModel,
            value: DeviceDetailFormat.join([
              state?.brand ?? device.brand,
              state?.model ?? device.model,
            ]),
          ),
          DetailField(
            label: L.devices.manufacturer,
            value: state?.manufacturer ?? device.manufacturer,
          ),
          DetailField(
            label: 'Android / SDK',
            value: DeviceDetailFormat.join([
              state?.androidVersion ?? device.androidVersion,
              (state?.sdkInt ?? device.sdkVersion)?.toString(),
            ], separator: ' · SDK '),
          ),
          DetailField(
            label: L.devices.securityPatch,
            value: state?.securityPatch,
          ),
          DetailField(
            label: L.devices.fingerprint,
            value: state?.buildFingerprint,
            mono: true,
          ),
          DetailField(
            label: L.devices.screen,
            value: DeviceDetailFormat.screen(state),
          ),
          DetailField(label: L.common.policy, value: policyName),
          DetailField(
            label: L.devices.policyVersion,
            value: device.policyVersion?.toString(),
          ),
          DetailField(
            label: L.devices.firstSeen,
            value: device.firstSeenAt?.formatDateTime(),
            divider: false,
          ),
        ],
      ),
    );
  }
}
