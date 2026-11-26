import 'package:flutter/material.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../../Core/L10n/L.dart';
import '../../../../Core/Theme/design.dart';
import '../../../../Logic/Controllers/device_logs_controller.dart';
import '../../../Widgets/Badge/status_badge.dart';
import '../../../Widgets/Button/app_button.dart';
import '../../../Widgets/Dialog/app_dialog_shell.dart';

class DeviceLogDetailDialog extends StatelessWidget {
  const DeviceLogDetailDialog({super.key, required this.row});

  final DeviceLogRow row;

  static Future<void> show(BuildContext context, DeviceLogRow row) {
    return showDialog<void>(
      context: context,
      builder: (_) => DeviceLogDetailDialog(row: row),
    );
  }

  @override
  Widget build(BuildContext context) {
    final log = row.log;
    final maxHeight = MediaQuery.of(context).size.height * 0.7;

    return AppDialogShell(
      title: L.deviceLogs.detailTitle,
      maxWidth: 720,
      actions: [
        AppButton.cancel(context, label: L.common.close),
      ],
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              _field(context, L.common.level, _levelBadge(log.level)),
              _field(
                context,
                L.common.device,
                row.deviceLabel ?? '#${log.deviceId}',
              ),
              _field(context, L.common.tag, log.tag ?? '—'),
              _field(context, L.common.time, _formatMoment(log.loggedAt)),
              _field(context, L.deviceLogs.session, log.sessionId ?? '—'),
              _field(context, L.deviceLogs.entryUuid, log.entryUuid ?? '—'),
              AppGap.v8,
              _codeBlock(
                context,
                title: L.common.message,
                value: log.message,
              ),
              if (log.stacktrace?.isNotEmpty == true) ...[
                AppGap.v16,
                _codeBlock(
                  context,
                  title: L.deviceLogs.stacktrace,
                  value: log.stacktrace!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _levelBadge(int level) {
    return Align(
      alignment: Alignment.centerLeft,
      child: StatusBadge(
        label: DeviceLogsController.levelLabel(level),
        tone: DeviceLogsController.levelTone(level),
      ),
    );
  }

  Widget _field(BuildContext context, String label, Object value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 110, child: _label(context, label)),
          Expanded(
            child: value is Widget ? value : _text(context, value as String),
          ),
        ],
      ),
    );
  }

  Widget _label(BuildContext context, String value) {
    return Text(
      value,
      style: AppText.caption(context, size: 12.5),
    );
  }

  Widget _text(BuildContext context, String value) {
    return Text(
      value,
      style: AppText.body(context),
    );
  }

  Widget _codeBlock(
    BuildContext context, {
    required String title,
    required String value,
  }) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _label(context, title),
        AppGap.v6,
        Container(
          constraints: const BoxConstraints(maxHeight: 220),
          padding: AppInsets.all12,
          decoration: colors.outlined(fill: colors.muted),
          child: SingleChildScrollView(
            child: SelectableText(
              value,
              style: AppText.body(context).copyWith(fontSize: 12.5),
            ),
          ),
        ),
      ],
    );
  }

  /// Server timestamps are UTC and are shown without conversion to local time.
  static String _formatMoment(DateTime? moment) {
    if (moment == null) return '—';

    String two(int value) => value.toString().padLeft(2, '0');

    return '${two(moment.day)}.${two(moment.month)}.${moment.year} '
        '${two(moment.hour)}:${two(moment.minute)}:${two(moment.second)}';
  }
}
