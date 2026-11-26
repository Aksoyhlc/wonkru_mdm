import 'package:flutter/material.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../../Core/Constants/Enums/alert_enums.dart';
import '../../../../Core/L10n/L.dart';
import '../../../Widgets/Badge/status_badge.dart';

class DeviceCommandStatusBadge extends StatelessWidget {
  const DeviceCommandStatusBadge({super.key, required this.status});

  final DeviceCommandStatus status;

  static Map<DeviceCommandStatus, String> get _labels =>
      <DeviceCommandStatus, String>{
        DeviceCommandStatus.pending: L.common.statusPending,
        DeviceCommandStatus.sent: L.common.statusSent,
        DeviceCommandStatus.acked: L.devices.commandsAcked,
        DeviceCommandStatus.timeout: L.devices.commandsTimeout,
        DeviceCommandStatus.error: L.common.statusError,
      };

  static bool isPending(DeviceCommandStatus status) =>
      status == DeviceCommandStatus.pending ||
      status == DeviceCommandStatus.sent;

  static String labelFor(DeviceCommandStatus status) => _labels[status] ?? '—';

  static UiAlertTone toneFor(DeviceCommandStatus status) => switch (status) {
    DeviceCommandStatus.acked => UiAlertTone.success,
    DeviceCommandStatus.error => UiAlertTone.danger,
    DeviceCommandStatus.timeout => UiAlertTone.warning,
    DeviceCommandStatus.pending || DeviceCommandStatus.sent => UiAlertTone.info,
  };

  @override
  Widget build(BuildContext context) {
    return StatusBadge(label: labelFor(status), tone: toneFor(status));
  }
}
