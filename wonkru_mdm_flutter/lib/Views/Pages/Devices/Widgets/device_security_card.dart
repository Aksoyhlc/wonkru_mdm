import 'package:flutter/material.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../../Core/L10n/L.dart';
import '../../../Widgets/Card/section_card.dart';
import '../../../Widgets/Form/detail_field.dart';
import 'device_flag_badges.dart';

class DeviceSecurityCard extends StatelessWidget {
  const DeviceSecurityCard({
    super.key,
    required this.device,
    required this.state,
  });

  final Device device;
  final DeviceStateCache? state;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: L.common.security,
      child: Column(
        children: [
          DetailField(
            label: L.devices.deviceIntegrity,
            child: DeviceFlagBadges(
              flags: [
                ('Root', state?.isRooted ?? device.isRooted, true),
                ('ADB', state?.adbEnabled, true),
                (L.devices.flagDeveloper, state?.developerOptionsEnabled, true),
                (
                  L.devices.flagUnknownSources,
                  state?.unknownSourcesAllowed,
                  true,
                ),
              ],
            ),
          ),
          DetailField(
            label: L.devices.encryption,
            value: state?.encryptionStatus,
          ),
          DetailField(
            label: L.devices.protection,
            child: DeviceFlagBadges(
              flags: [
                ('Play Protect', state?.playProtectStatus, false),
                (L.devices.screenLock, state?.hasSecureLock, false),
                ('Device Owner', state?.isDeviceOwner, false),
              ],
            ),
          ),
          DetailField(
            label: L.devices.passwordPolicy,
            child: DeviceFlagBadges(
              flags: [
                (
                  L.devices.passwordSufficient,
                  state?.passwordIsSufficient,
                  false,
                ),
              ],
            ),
          ),
          DetailField(
            label: L.devices.caCertificates,
            value: state?.installedCaCertCount?.toString(),
          ),
          DetailField(
            label: 'Wonkru CA',
            divider: false,
            child: DeviceFlagBadges(
              flags: [
                ('MDM CA', state?.hasWonkruMdmCa, false),
                ('Local CA', state?.hasWonkruLocalCa, false),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
