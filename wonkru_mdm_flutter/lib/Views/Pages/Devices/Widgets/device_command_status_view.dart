import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../../Core/Constants/Enums/alert_enums.dart';
import '../../../../Core/Constants/Enums/device_action.dart';
import '../../../../Core/L10n/L.dart';
import '../../../../Core/Theme/design.dart';
import '../../../Widgets/Badge/status_badge.dart';
import '../../../Widgets/Button/app_icon_button.dart';
import '../../../Widgets/Card/section_card.dart';
import '../../../Widgets/Loading/app_loader.dart';
import '../../../Widgets/Table/Cells/cell_meter.dart';
import 'device_command_response_view.dart';

/// Bulk command progress panel shown after a command is sent: overall status,
/// progress meter, per-state counts and the per-device responses.
class DeviceCommandStatusView extends StatelessWidget {
  const DeviceCommandStatusView({
    super.key,
    required this.bulkStatus,
    required this.loading,
    required this.error,
    required this.commands,
    required this.deviceLabels,
    required this.onRefresh,
  });

  final DeviceCommandBulkStatus? bulkStatus;
  final bool loading;
  final String? error;
  final List<DeviceCommand> commands;
  final Map<int, String> deviceLabels;
  final VoidCallback onRefresh;

  BulkCommandStatus? get _overallStatus {
    final status = bulkStatus;
    if (status == null) return null;
    return BulkCommandStatus.overallFrom(
      totalCount: status.total,
      pendingCount: status.pending,
      sentCount: status.sent,
      ackedCount: status.acked,
      timeoutCount: status.timeout,
      errorCount: status.error,
    );
  }

  @override
  Widget build(BuildContext context) {
    final status = bulkStatus;

    return SingleChildScrollView(
      child: SectionCard(
        title: L.devices.commandsBulkProgress,
        trailing: loading
            ? const AppLoader(size: 16)
            : AppIconButton(
                icon: LucideIcons.refreshCw,
                tooltip: L.common.refresh,
                onPressed: onRefresh,
              ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (error != null)
              _statusMessage(
                context,
                L.devices.commandsStatusError.trParams({'error': error!}),
              )
            else if (status == null)
              _statusMessage(
                context,
                loading
                    ? L.devices.commandsLoadingProgress
                    : L.devices.commandsNoProgress,
              )
            else if (status.total == 0)
              _statusMessage(context, L.devices.commandsNoQueued)
            else ...[
              _overallRow(context, status),
              AppGap.v12,
              _progressMeter(context, status),
              AppGap.v16,
              _countsGrid(context, status),
              if (commands.isNotEmpty) ...[
                AppGap.v20,
                _sectionTitle(context, L.devices.commandsResponses),
                AppGap.v8,
                for (final command in commands)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.s8),
                    child: DeviceCommandResponseView(
                      command: command,
                      title:
                          deviceLabels[command.deviceId] ??
                          '#${command.deviceId}',
                    ),
                  ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _statusMessage(BuildContext context, String message) {
    return Text(message, style: AppText.caption(context, size: 12.5));
  }

  Widget _overallRow(BuildContext context, DeviceCommandBulkStatus status) {
    final overall = _overallStatus!;
    final done = status.acked + status.timeout + status.error;

    return Row(
      children: [
        StatusBadge(label: overall.label, tone: _overallTone(overall)),
        AppGap.h8,
        Expanded(
          child: Text(
            L.devices.commandsDevicesDone.trParams({
              'count': '${status.total}',
              'done': '$done',
            }),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.cellSecondary(context),
          ),
        ),
      ],
    );
  }

  Widget _progressMeter(BuildContext context, DeviceCommandBulkStatus status) {
    final done = status.acked + status.timeout + status.error;
    final percent = status.total == 0 ? 0.0 : done * 100 / status.total;

    return CellMeter(
      percent: percent,
      label: L.devices.commandsProgress.trParams({
        'done': '$done',
        'total': '${status.total}',
      }),
      tone: _meterTone(status),
      width: double.infinity,
    );
  }

  Widget _countsGrid(BuildContext context, DeviceCommandBulkStatus status) {
    final stats = <(String, int)>[
      (L.common.statusPending, status.pending),
      (L.common.statusSent, status.sent),
      (L.devices.commandsAcked, status.acked),
      (L.devices.commandsTimeout, status.timeout),
      (L.common.error, status.error),
    ];

    return Wrap(
      spacing: 20,
      runSpacing: 12,
      children: [
        for (final (label, value) in stats) _stat(context, label, value),
      ],
    );
  }

  Widget _stat(BuildContext context, String label, int value) {
    return SizedBox(
      width: 84,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppText.caption(context)),
          AppGap.v2,
          Text('$value', style: AppText.cellPrimary(context)),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Text(title, style: AppText.columnHeader(context));
  }

  static UiAlertTone _overallTone(BulkCommandStatus status) => switch (status) {
    BulkCommandStatus.completed ||
    BulkCommandStatus.success => UiAlertTone.success,
    BulkCommandStatus.error => UiAlertTone.danger,
    BulkCommandStatus.noResponse => UiAlertTone.warning,
    BulkCommandStatus.pending || BulkCommandStatus.running => UiAlertTone.info,
  };

  static UiAlertTone _meterTone(DeviceCommandBulkStatus status) {
    if (status.pending + status.sent > 0) return UiAlertTone.info;
    if (status.error > 0) return UiAlertTone.danger;
    if (status.timeout > 0) return UiAlertTone.warning;
    return UiAlertTone.success;
  }
}
