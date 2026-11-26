import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../Core/Constants/Enums/alert_enums.dart';
import '../../../Core/Constants/Enums/button_enums.dart';
import '../../../Core/Constants/Enums/dialog_enums.dart';
import '../../../Core/Errors/server_error_message.dart';
import '../../../Core/L10n/L.dart';
import '../../../Core/Theme/design.dart';
import '../../../Logic/Controllers/profile_controller.dart';
import '../../Widgets/Alert/app_toast.dart';
import '../../Widgets/Button/app_button.dart';
import '../../Widgets/Button/app_icon_button.dart';
import '../../Widgets/Card/section_card.dart';
import '../../Widgets/Dialog/app_dialog_shell.dart';
import '../../Widgets/Input/custom_text_field.dart';
import '../../Widgets/Input/text_controllers_owner.dart';
import '../../Widgets/Page/page_header.dart';
import 'Widgets/two_factor_card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TextControllersOwner<ProfilePage> {
  late final ProfileController _controller = Get.find<ProfileController>();

  late final _currentEmail = textController();
  late final _currentPassword = textController();
  late final _newPassword = textController();
  late final _confirmPassword = textController();
  late final _emailPassword = textController();
  late final _newEmail = textController();

  @override
  void initState() {
    super.initState();
    _prefillEmail();
  }

  Future<void> _prefillEmail() async {
    final email = await _controller.currentEmail();
    if (!mounted || email == null) return;
    setState(() => _currentEmail.text = email);
  }

  Future<void> _submitPassword() async {
    final email = _currentEmail.text.trim();
    final currentPassword = _currentPassword.text;
    final newPassword = _newPassword.text;

    if (email.isEmpty) {
      AppToast.show(L.profile.enterCurrentEmail, tone: UiAlertTone.warning);
      return;
    }
    if (currentPassword.isEmpty) {
      AppToast.show(
        L.profile.enterCurrentPassword,
        tone: UiAlertTone.warning,
      );
      return;
    }
    if (newPassword.length < 6) {
      AppToast.show(L.profile.passwordTooShort, tone: UiAlertTone.warning);
      return;
    }
    if (newPassword != _confirmPassword.text) {
      AppToast.show(L.profile.passwordsMismatch, tone: UiAlertTone.warning);
      return;
    }

    try {
      await _controller.changePassword(
        email: email,
        currentPassword: currentPassword,
        newPassword: newPassword,
        requestTotpCode: _requestTotpCode,
      );
      if (!mounted) return;
      _currentPassword.clear();
      _newPassword.clear();
      _confirmPassword.clear();
      AppToast.show(L.profile.passwordChanged, tone: UiAlertTone.success);
    } catch (e) {
      if (!mounted) return;
      AppToast.show(
        serverErrorMessage(e),
        tone: UiAlertTone.danger,
      );
    }
  }

  Future<void> _submitEmail() async {
    final currentEmail = _currentEmail.text.trim();
    final password = _emailPassword.text;
    final newEmail = _newEmail.text.trim();

    if (currentEmail.isEmpty || !currentEmail.contains('@')) {
      AppToast.show(L.profile.enterCurrentEmail, tone: UiAlertTone.warning);
      return;
    }
    if (newEmail.isEmpty || !newEmail.contains('@')) {
      AppToast.show(L.profile.enterValidNewEmail, tone: UiAlertTone.warning);
      return;
    }
    if (newEmail.toLowerCase() == currentEmail.toLowerCase()) {
      AppToast.show(
        L.profile.emailSameAsCurrent,
        tone: UiAlertTone.warning,
      );
      return;
    }
    if (password.isEmpty) {
      AppToast.show(
        L.profile.enterCurrentPassword,
        tone: UiAlertTone.warning,
      );
      return;
    }

    try {
      await _controller.changeEmail(
        currentEmail: currentEmail,
        currentPassword: password,
        newEmail: newEmail,
        requestTotpCode: _requestTotpCode,
      );
      if (!mounted) return;
      _currentEmail.text = newEmail;
      _emailPassword.clear();
      _newEmail.clear();
      AppToast.show(L.profile.emailChanged, tone: UiAlertTone.success);
    } catch (e) {
      if (!mounted) return;
      AppToast.show(
        serverErrorMessage(e),
        tone: UiAlertTone.danger,
      );
    }
  }

  Future<String?> _requestTotpCode() => showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const _TotpPromptDialog(),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PageHeader(
          leading: AppIconButton.back(context),
          title: L.common.profile,
          subtitle: L.profile.subtitle,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: AppInsets.all20,
            child: Align(
              alignment: Alignment.topLeft,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: AppSpacing.s16,
                  children: [
                    _accountCard(context),
                    _passwordCard(context),
                    _emailCard(context),
                    const TwoFactorCard(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _accountCard(BuildContext context) {
    return SectionCard(
      title: L.common.account,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(
            name: 'profile_current_email',
            controller: _currentEmail,
            label: L.profile.currentEmail,
            hint: L.profile.currentEmailHint,
            keyboardType: TextInputType.emailAddress,
            showValidationError: false,
          ),
          AppGap.v8,
          Text(
            L.profile.verifyNote,
            style: AppText.caption(context, size: 12),
          ),
        ],
      ),
    );
  }

  Widget _passwordCard(BuildContext context) {
    return SectionCard(
      title: L.profile.changePasswordSection,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(
            name: 'profile_current_password',
            controller: _currentPassword,
            label: L.profile.currentPassword,
            obscureText: true,
            showValidationError: false,
          ),
          AppGap.v12,
          CustomTextField(
            name: 'profile_new_password',
            controller: _newPassword,
            label: L.profile.newPassword,
            hint: L.profile.passwordMinHint,
            obscureText: true,
            showValidationError: false,
          ),
          AppGap.v12,
          CustomTextField(
            name: 'profile_confirm_password',
            controller: _confirmPassword,
            label: L.profile.confirmPassword,
            obscureText: true,
            showValidationError: false,
          ),
          AppGap.v16,
          Align(
            alignment: Alignment.centerLeft,
            child: Obx(
              () => AppButton(
                label: L.profile.changePasswordAction,
                icon: LucideIcons.keyRound,
                compact: true,
                loading: _controller.savingPassword.value,
                onPressed: _submitPassword,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emailCard(BuildContext context) {
    return SectionCard(
      title: L.profile.changeEmailSection,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(
            name: 'profile_email_password',
            controller: _emailPassword,
            label: L.profile.currentPassword,
            obscureText: true,
            showValidationError: false,
          ),
          AppGap.v12,
          CustomTextField(
            name: 'profile_new_email',
            controller: _newEmail,
            label: L.profile.newEmail,
            hint: L.profile.newEmailHint,
            keyboardType: TextInputType.emailAddress,
            showValidationError: false,
          ),
          AppGap.v16,
          Align(
            alignment: Alignment.centerLeft,
            child: Obx(
              () => AppButton(
                label: L.profile.changeEmailAction,
                icon: LucideIcons.mail,
                compact: true,
                variant: AppButtonVariant.secondary,
                loading: _controller.savingEmail.value,
                onPressed: _submitEmail,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TotpPromptDialog extends StatefulWidget {
  const _TotpPromptDialog();

  @override
  State<_TotpPromptDialog> createState() => _TotpPromptDialogState();
}

class _TotpPromptDialogState extends State<_TotpPromptDialog>
    with TextControllersOwner<_TotpPromptDialog> {
  late final _codeController = textController();

  void _submit() {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      AppToast.show(
        L.common.enterVerificationCode,
        tone: UiAlertTone.warning,
      );
      return;
    }
    Navigator.pop(context, code);
  }

  @override
  Widget build(BuildContext context) {
    return AppDialogShell(
      title: L.profile.totpPromptTitle,
      description: L.profile.totpPromptDescription,
      size: AppDialogSize.sm,
      actions: [
        AppButton.cancel(context),
        AppButton(label: L.common.verify, onPressed: _submit),
      ],
      child: CustomTextField(
        name: 'profile_totp_change_code',
        controller: _codeController,
        label: L.common.verificationCode,
        hint: '123456',
        autofocus: true,
        showValidationError: false,
        onSubmitted: (_) => _submit(),
      ),
    );
  }
}
