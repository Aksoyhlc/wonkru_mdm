import 'package:flutter/material.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../../Core/Extensions/datetime.dart';
import '../../../../Core/L10n/L.dart';
import '../../../../Core/Theme/design.dart';
import '../../../../Core/Utils/pretty_json.dart';
import '../../../Widgets/Button/app_button.dart';
import '../../../Widgets/Dialog/app_dialog_shell.dart';
import '../../../Widgets/Form/detail_field.dart';

class AdminActivityDetailDialog {
  const AdminActivityDetailDialog._();

  static Future<void> show(BuildContext context, AdminActivity row) {
    return showDialog<void>(
      context: context,
      builder: (_) => _AdminActivityDetail(row: row),
    );
  }
}

class _AdminActivityDetail extends StatelessWidget {
  const _AdminActivityDetail({required this.row});

  final AdminActivity row;

  @override
  Widget build(BuildContext context) {
    return AppDialogShell(
      title: L.activity.detailTitle,
      maxWidth: 640,
      scrollable: true,
      actions: [
        AppButton.cancel(context, label: L.common.close),
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DetailField(
            label: L.common.time,
            value: row.createdAt.formatDateTime(),
          ),
          DetailField(label: L.activity.columnActor, value: _actor()),
          DetailField(
            label: L.common.action,
            value: row.action,
            mono: true,
          ),
          DetailField(label: L.activity.columnTarget, value: _target()),
          DetailField(
            label: L.activity.columnIp,
            value: row.ipAddress,
            divider: false,
          ),
          AppGap.v14,
          Text(L.activity.detailData, style: AppText.fieldLabel(context)),
          AppGap.v6,
          _dataBlock(context),
        ],
      ),
    );
  }

  String _actor() {
    final name = row.actorName?.trim();
    final email = row.actorEmail?.trim();
    if (name != null && name.isNotEmpty) {
      return email != null && email.isNotEmpty ? '$name <$email>' : name;
    }
    if (email != null && email.isNotEmpty) return email;

    return L.activity.system;
  }

  String? _target() {
    final type = row.targetType?.trim();
    if (type == null || type.isEmpty) return null;
    final id = row.targetId?.trim();

    return id == null || id.isEmpty ? type : '$type #$id';
  }

  Widget _dataBlock(BuildContext context) {
    final data = row.data;
    if (data == null || data.trim().isEmpty) {
      return Text(L.activity.detailNoData, style: AppText.bodyMuted(context));
    }

    final colors = context.appColors;

    return Container(
      padding: AppInsets.all8,
      decoration: colors.outlined(fill: colors.workshop, radius: AppRadius.r6),
      child: SelectableText(
        prettyJson(data),
        style: AppText.mono(colors.carbon, size: 12.5),
      ),
    );
  }
}
