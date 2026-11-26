import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../Core/Constants/Enums/alert_enums.dart';
import '../../../../Core/Constants/Enums/button_enums.dart';
import '../../../../Core/Constants/Enums/notification_enums.dart';
import '../../../../Core/Errors/server_error_message.dart';
import '../../../../Core/L10n/L.dart';
import '../../../../Core/Theme/design.dart';
import '../../../../Logic/Controllers/notifications_controller.dart';
import '../../../Widgets/Alert/app_toast.dart';
import '../../../Widgets/Button/app_button.dart';
import '../../../Widgets/Button/app_icon_button.dart';
import '../../../Widgets/Dialog/app_dialog_shell.dart';
import '../../../Widgets/Dialog/device_picker_dialog.dart';
import '../../../Widgets/Input/app_dropdown.dart';
import '../../../Widgets/Input/custom_text_field.dart';
import '../../../Widgets/Input/text_controllers_owner.dart';

Future<bool> showNotificationCreateDialog(
  BuildContext context, {
  required NotificationsController controller,
}) async {
  final created = await showDialog<bool>(
    context: context,
    builder: (_) => _NotificationCreateDialog(controller: controller),
  );

  return created ?? false;
}

class _NotificationCreateDialog extends StatefulWidget {
  const _NotificationCreateDialog({required this.controller});

  final NotificationsController controller;

  @override
  State<_NotificationCreateDialog> createState() =>
      _NotificationCreateDialogState();
}

class _NotificationCreateDialogState extends State<_NotificationCreateDialog>
    with TextControllersOwner<_NotificationCreateDialog> {
  late final _title = textController();
  late final _message = textController();

  final _extraRows = <_ExtraRow>[];
  final _deviceIds = <int>{};

  String _type = NotificationType.normal.name;
  bool _saving = false;

  @override
  void dispose() {
    for (final row in _extraRows) {
      row.dispose();
    }
    super.dispose();
  }

  void _addExtraRow() => setState(() => _extraRows.add(_ExtraRow()));

  void _removeExtraRow(int index) {
    setState(() {
      _extraRows.removeAt(index).dispose();
    });
  }

  Future<void> _pickDevices() async {
    final selected = await showDevicePickerDialog(
      context,
      initial: _deviceIds,
    );
    if (selected == null) return;
    setState(() {
      _deviceIds
        ..clear()
        ..addAll(selected);
    });
  }

  Future<void> _save() async {
    if (_title.text.trim().isEmpty) {
      AppToast.show(L.notifications.titleRequired, tone: UiAlertTone.warning);
      return;
    }
    if (_message.text.trim().isEmpty) {
      AppToast.show(
        L.notifications.messageRequired,
        tone: UiAlertTone.warning,
      );
      return;
    }
    if (_deviceIds.isEmpty) {
      AppToast.show(
        L.notifications.pickDeviceRequired,
        tone: UiAlertTone.warning,
      );
      return;
    }

    final request = NotificationsController.buildCreateRequest(
      title: _title.text,
      message: _message.text,
      type: _type,
      extra: {
        for (final row in _extraRows)
          if (row.key.text.trim().isNotEmpty) row.key.text: row.value.text,
      },
      deviceIds: _deviceIds.toList(),
    );

    setState(() => _saving = true);
    try {
      final count = await widget.controller.create(request);
      if (!mounted) return;
      AppToast.show(
        (count == 1 ? L.notifications.sentToOne : L.notifications.sentToMany)
            .trParams({'count': '$count'}),
        tone: UiAlertTone.success,
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      AppToast.show(
        L.notifications.sendFailed.trParams({'error': serverErrorMessage(e)}),
        tone: UiAlertTone.danger,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppDialogShell(
      title: L.notifications.newNotification,
      maxWidth: 600,
      actions: [
        AppButton.cancel(context, result: false, enabled: !_saving),
        AppButton(
          label: L.common.send,
          loading: _saving,
          onPressed: _saving ? null : _save,
        ),
      ],
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 520),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                name: 'notification_title',
                controller: _title,
                label: L.common.title,
                hint: L.notifications.titleHint,
                autofocus: true,
                showValidationError: false,
              ),
              AppGap.v12,
              CustomTextField(
                name: 'notification_message',
                controller: _message,
                label: L.common.message,
                hint: L.notifications.messageHint,
                maxLines: 4,
                showValidationError: false,
              ),
              AppGap.v12,
              AppDropdown<String>(
                value: _type,
                items: notificationTypeKeyValues,
                label: L.common.type,
                onChanged: (value) => setState(
                  () => _type = value ?? NotificationType.normal.name,
                ),
              ),
              AppGap.v16,
              _extraSection(context),
              AppGap.v16,
              _deviceSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _extraSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                L.notifications.extraData,
                style: AppText.cellPrimary(context),
              ),
            ),
            AppButton(
              label: L.notifications.addRow,
              compact: true,
              variant: AppButtonVariant.secondary,
              icon: LucideIcons.plus,
              onPressed: _addExtraRow,
            ),
          ],
        ),
        for (var i = 0; i < _extraRows.length; i++)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.s8),
            child: Row(
              spacing: AppSpacing.s8,
              children: [
                Expanded(
                  flex: 2,
                  child: CustomTextField(
                    name: 'notification_extra_key_$i',
                    controller: _extraRows[i].key,
                    hint: L.notifications.extraKeyHint,
                    dense: true,
                    showValidationError: false,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: CustomTextField(
                    name: 'notification_extra_value_$i',
                    controller: _extraRows[i].value,
                    hint: L.notifications.extraValueHint,
                    dense: true,
                    showValidationError: false,
                  ),
                ),
                AppIconButton(
                  icon: LucideIcons.trash2,
                  tooltip: L.notifications.removeRow,
                  onPressed: () => _removeExtraRow(i),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _deviceSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          L.notifications.targetDevices,
          style: AppText.cellPrimary(context),
        ),
        AppGap.v8,
        Row(
          children: [
            Expanded(
              child: Text(
                _deviceIds.isEmpty
                    ? L.notifications.noDevicesSelected
                    : (_deviceIds.length == 1
                              ? L.notifications.devicesSelectedOne
                              : L.notifications.devicesSelectedMany)
                          .trParams({'count': '${_deviceIds.length}'}),
                style: _deviceIds.isEmpty
                    ? AppText.bodyMuted(context)
                    : AppText.body(context),
              ),
            ),
            AppButton(
              label: L.common.selectDevice,
              compact: true,
              icon: LucideIcons.smartphone,
              onPressed: _pickDevices,
            ),
          ],
        ),
      ],
    );
  }
}

class _ExtraRow {
  final key = TextEditingController();
  final value = TextEditingController();

  void dispose() {
    key.dispose();
    value.dispose();
  }
}
