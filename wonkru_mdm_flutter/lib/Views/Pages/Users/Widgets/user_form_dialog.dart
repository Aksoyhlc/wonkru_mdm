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

/// A null password means keep the existing one when editing.
typedef UserFormData = ({
  String? name,
  String email,
  String? password,
  AdminAccountStatus status,
  bool blocked,
});

Future<UserFormData?> showUserFormDialog(
  BuildContext context, {
  AdminUserRow? user,
}) {
  return showDialog<UserFormData>(
    context: context,
    builder: (_) => _UserFormDialog(user: user),
  );
}

class _UserFormDialog extends StatefulWidget {
  const _UserFormDialog({this.user});

  final AdminUserRow? user;

  @override
  State<_UserFormDialog> createState() => _UserFormDialogState();
}

class _UserFormDialogState extends State<_UserFormDialog>
    with TextControllersOwner<_UserFormDialog> {
  late final _name = textController(widget.user?.name ?? '');
  late final _email = textController(widget.user?.email ?? '');
  late final _password = textController();

  late bool _blocked = widget.user?.blocked ?? false;

  bool get _isEditing => widget.user != null;

  void _save() {
    final email = _email.text.trim();
    final password = _password.text;

    if (email.isEmpty || !email.contains('@')) {
      AppToast.show(L.users.validEmail, tone: UiAlertTone.warning);
      return;
    }
    if (!_isEditing && password.isEmpty) {
      AppToast.show(L.users.passwordRequired, tone: UiAlertTone.warning);
      return;
    }

    final name = _name.text.trim();
    Navigator.pop(context, (
      name: name.isEmpty ? null : name,
      email: email,
      password: password.isEmpty ? null : password,
      status: AdminAccountStatus.active,
      blocked: _blocked,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AppDialogShell(
      scrollable: true,
      title: _isEditing ? L.users.editTitle : L.users.newUser,
      maxWidth: 560,
      actions: [
        AppButton.cancel(context),
        AppButton(label: L.common.save, onPressed: _save),
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(
            name: 'user_name',
            controller: _name,
            label: L.common.name,
            hint: L.common.optional,
            autofocus: true,
            showValidationError: false,
          ),
          AppGap.v12,
          CustomTextField(
            name: 'user_email',
            controller: _email,
            label: L.common.email,
            hint: L.users.emailHint,
            keyboardType: TextInputType.emailAddress,
            showValidationError: false,
          ),
          AppGap.v12,
          CustomTextField(
            name: 'user_password',
            controller: _password,
            label: _isEditing ? L.profile.newPassword : L.common.password,
            hint: _isEditing ? L.users.passwordKeepHint : L.users.required,
            obscureText: true,
            showValidationError: false,
          ),
          AppGap.v8,
          UiSwitch(
            title: L.users.blocked,
            subtitle: L.users.blockedHint,
            value: _blocked,
            onChanged: (value) => setState(() => _blocked = value),
          ),
        ],
      ),
    );
  }
}
