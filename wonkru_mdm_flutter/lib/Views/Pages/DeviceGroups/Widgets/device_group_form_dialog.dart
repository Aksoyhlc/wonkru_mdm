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

Future<DeviceGroup?> showDeviceGroupFormDialog(
  BuildContext context, {
  DeviceGroup? group,
}) {
  return showDialog<DeviceGroup>(
    context: context,
    builder: (_) => _DeviceGroupFormDialog(group: group),
  );
}

class _DeviceGroupFormDialog extends StatefulWidget {
  const _DeviceGroupFormDialog({this.group});

  final DeviceGroup? group;

  @override
  State<_DeviceGroupFormDialog> createState() => _DeviceGroupFormDialogState();
}

class _DeviceGroupFormDialogState extends State<_DeviceGroupFormDialog>
    with TextControllersOwner<_DeviceGroupFormDialog> {
  late final _name = textController(widget.group?.name ?? '');
  late final _description = textController(widget.group?.description ?? '');

  bool get _isEditing => widget.group != null;

  void _save() {
    final name = _name.text.trim();
    if (name.isEmpty) {
      AppToast.show(
        L.deviceGroups.nameRequired,
        tone: UiAlertTone.warning,
      );
      return;
    }

    final description = _description.text.trim();
    final current = widget.group;

    Navigator.pop(
      context,
      current == null
          ? DeviceGroup(
              name: name,
              description: description.isEmpty ? null : description,
            )
          : current.copyWith(
              name: name,
              description: description.isEmpty ? null : description,
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppDialogShell(
      scrollable: true,
      title: _isEditing ? L.deviceGroups.editTitle : L.deviceGroups.newGroup,
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
            name: 'device_group_name',
            controller: _name,
            label: L.common.name,
            hint: L.deviceGroups.nameHint,
            autofocus: _isEditing,
            showValidationError: false,
          ),
          AppGap.v12,
          CustomTextField(
            name: 'device_group_description',
            controller: _description,
            label: L.common.description,
            hint: L.common.optional,
            maxLines: 3,
            showValidationError: false,
          ),
        ],
      ),
    );
  }
}
