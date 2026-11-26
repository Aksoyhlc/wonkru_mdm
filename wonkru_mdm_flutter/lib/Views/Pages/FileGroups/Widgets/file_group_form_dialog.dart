import 'package:flutter/material.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../../Core/Constants/Enums/alert_enums.dart';
import '../../../../Core/L10n/L.dart';
import '../../../../Core/Theme/design.dart';
import '../../../Widgets/Alert/app_toast.dart';
import '../../../Widgets/Button/app_button.dart';
import '../../../Widgets/Dialog/app_dialog_shell.dart';
import '../../../Widgets/Input/custom_text_field.dart';
import '../../../Widgets/Input/text_controllers_owner.dart';
import '../../../Widgets/Switch/ui_switch.dart';

Future<FileGroup?> showFileGroupFormDialog(
  BuildContext context, {
  FileGroup? group,
}) {
  return showDialog<FileGroup>(
    context: context,
    builder: (_) => _FileGroupFormDialog(group: group),
  );
}

class _FileGroupFormDialog extends StatefulWidget {
  const _FileGroupFormDialog({this.group});

  final FileGroup? group;

  @override
  State<_FileGroupFormDialog> createState() => _FileGroupFormDialogState();
}

class _FileGroupFormDialogState extends State<_FileGroupFormDialog>
    with TextControllersOwner<_FileGroupFormDialog> {
  late final _name = textController(widget.group?.name ?? '');
  late final _description = textController(widget.group?.description ?? '');
  late final _color = textController(widget.group?.color ?? '');

  late bool _isActive = widget.group?.isActive ?? true;

  bool get _isEditing => widget.group != null;

  String? _nullable(TextEditingController controller) {
    final value = controller.text.trim();
    return value.isEmpty ? null : value;
  }

  void _save() {
    final name = _name.text.trim();
    if (name.isEmpty) {
      AppToast.show(L.files.groupNameRequired, tone: UiAlertTone.warning);
      return;
    }

    final description = _nullable(_description);
    final color = _nullable(_color);
    final current = widget.group;

    Navigator.pop(
      context,
      current == null
          ? FileGroup(
              name: name,
              description: description,
              color: color,
              isActive: _isActive,
            )
          : current.copyWith(
              name: name,
              description: description,
              color: color,
              isActive: _isActive,
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppDialogShell(
      scrollable: true,
      title: _isEditing ? L.files.editGroup : L.files.newGroup,
      maxWidth: 520,
      actions: [
        AppButton.cancel(context),
        AppButton(label: L.common.save, onPressed: _save),
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(
            name: 'file_group_name',
            controller: _name,
            label: L.common.name,
            hint: L.files.groupNameHint,
            autofocus: _isEditing,
            showValidationError: false,
          ),
          AppGap.v12,
          CustomTextField(
            name: 'file_group_description',
            controller: _description,
            label: L.common.description,
            hint: L.common.optional,
            maxLines: 2,
            showValidationError: false,
          ),
          AppGap.v12,
          CustomTextField(
            name: 'file_group_color',
            controller: _color,
            label: L.files.color,
            hint: L.files.colorHint,
            showValidationError: false,
          ),
          AppGap.v6,
          Text(
            L.files.colorHelp,
            style: AppText.caption(context, size: 11),
          ),
          AppGap.v12,
          UiSwitch(
            title: L.common.active,
            value: _isActive,
            onChanged: (value) => setState(() => _isActive = value),
          ),
        ],
      ),
    );
  }
}
