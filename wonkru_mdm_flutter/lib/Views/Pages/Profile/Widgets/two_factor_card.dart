import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../../Core/Constants/Enums/alert_enums.dart';
import '../../../../Core/Constants/Enums/button_enums.dart';
import '../../../../Core/Constants/Enums/dialog_enums.dart';
import '../../../../Core/Errors/server_error_message.dart';
import '../../../../Core/L10n/L.dart';
import '../../../../Core/Theme/design.dart';
import '../../../../Logic/Controllers/profile_controller.dart';
import '../../../Widgets/Alert/app_toast.dart';
import '../../../Widgets/Button/app_button.dart';
import '../../../Widgets/Card/section_card.dart';
import '../../../Widgets/Dialog/app_dialog_shell.dart';
import '../../../Widgets/Input/custom_text_field.dart';
import '../../../Widgets/Input/text_controllers_owner.dart';

/// Recovery codes are shown only once, immediately after setup confirmation.
class TwoFactorCard extends StatefulWidget {
  const TwoFactorCard({super.key});

  @override
  State<TwoFactorCard> createState() => _TwoFactorCardState();
}

class _TwoFactorCardState extends State<TwoFactorCard> {
  late final ProfileController _controller = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    _controller.loadTwoFactor();
  }

  Future<void> _startSetup() async {
    try {
      final setup = await _controller.startTotpSetup();
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => _SetupDialog(setup: setup),
      );
    } catch (e) {
      if (!mounted) return;
      AppToast.show(
        serverErrorMessage(e),
        tone: UiAlertTone.danger,
      );
    }
  }

  Future<void> _disable() async {
    final code = await showDialog<String>(
      context: context,
      builder: (_) => const _DisableDialog(),
    );
    if (code == null || !mounted) return;

    try {
      await _controller.disableTotp(code);
      if (!mounted) return;
      AppToast.show(L.profile.twoFactorDisabled, tone: UiAlertTone.success);
    } catch (e) {
      if (!mounted) return;
      AppToast.show(
        serverErrorMessage(e),
        tone: UiAlertTone.danger,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final enabled = _controller.totpEnabled.value;

      return SectionCard(
        title: L.profile.twoFactorTitle,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              enabled
                  ? L.profile.twoFactorEnabledDesc
                  : L.profile.twoFactorDisabledDesc,
              style: AppText.caption(context, size: 12),
            ),
            AppGap.v16,
            Align(
              alignment: Alignment.centerLeft,
              child: enabled
                  ? AppButton(
                      label: L.profile.disable2fa,
                      icon: LucideIcons.shieldOff,
                      compact: true,
                      variant: AppButtonVariant.danger,
                      loading: _controller.totpBusy.value,
                      onPressed: _disable,
                    )
                  : AppButton(
                      label: L.profile.setup2fa,
                      icon: LucideIcons.shieldCheck,
                      compact: true,
                      onPressed: _startSetup,
                    ),
            ),
          ],
        ),
      );
    });
  }
}

class _SetupDialog extends StatefulWidget {
  const _SetupDialog({required this.setup});

  final AdminTotpSetup setup;

  @override
  State<_SetupDialog> createState() => _SetupDialogState();
}

class _SetupDialogState extends State<_SetupDialog>
    with TextControllersOwner<_SetupDialog> {
  final _controller = Get.find<ProfileController>();
  late final _codeController = textController();

  bool _saving = false;
  List<String>? _recoveryCodes;

  Future<void> _confirm() async {
    if (_saving) return;

    final code = _codeController.text.trim();
    if (code.isEmpty) {
      AppToast.show(
        L.common.enterVerificationCode,
        tone: UiAlertTone.warning,
      );
      return;
    }

    setState(() => _saving = true);
    try {
      final codes = await _controller.confirmTotpSetup(code);
      if (!mounted) return;
      setState(() {
        _saving = false;
        _recoveryCodes = codes;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      AppToast.show(
        serverErrorMessage(e),
        tone: UiAlertTone.danger,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final codes = _recoveryCodes;
    if (codes != null) {
      return AppDialogShell(
        scrollable: true,
        title: L.profile.recoveryCodesTitle,
        description: L.profile.recoveryCodesDescription,
        size: AppDialogSize.md,
        actions: [
          AppButton(
            label: L.profile.ok,
            onPressed: () => Navigator.pop(context),
          ),
        ],
        child: _recoveryList(context, codes),
      );
    }

    return AppDialogShell(
      scrollable: true,
      title: L.profile.setup2fa,
      description: L.profile.setupDescription,
      size: AppDialogSize.md,
      actions: [
        AppButton.cancel(context),
        AppButton(
          label: L.common.verify,
          loading: _saving,
          onPressed: _confirm,
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              padding: AppInsets.all10,
              decoration: context.appColors.outlined(fill: Colors.white),
              child: QrImageView(
                data: widget.setup.otpauthUri,
                version: QrVersions.auto,
                size: 200,
                backgroundColor: Colors.white,
                eyeStyle: const QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: Colors.black,
                ),
                dataModuleStyle: const QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          AppGap.v16,
          Text(
            L.profile.manualSecret,
            style: AppText.caption(context, size: 12),
          ),
          AppGap.v6,
          Container(
            padding: AppInsets.all8,
            decoration: context.appColors.outlined(
              fill: context.appColors.muted,
            ),
            child: SelectableText(
              widget.setup.secret,
              style: AppText.mono(context.appColors.carbon),
              textAlign: TextAlign.center,
            ),
          ),
          AppGap.v24,
          CustomTextField(
            name: 'profile_totp_setup_code',
            controller: _codeController,
            label: L.profile.setupCodeLabel,
            hint: '123456',
            enabled: !_saving,
            autofocus: true,
            prefixIcon: LucideIcons.shieldCheck,
            showValidationError: false,
            onSubmitted: (_) => _confirm(),
          ),
        ],
      ),
    );
  }

  Widget _recoveryList(BuildContext context, List<String> codes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          decoration: context.appColors.outlined(fill: context.appColors.muted),
          child: Wrap(
            spacing: AppSpacing.s16,
            runSpacing: AppSpacing.s8,
            children: [
              for (final code in codes)
                SelectableText(
                  code,
                  style: AppText.mono(context.appColors.carbon),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DisableDialog extends StatefulWidget {
  const _DisableDialog();

  @override
  State<_DisableDialog> createState() => _DisableDialogState();
}

class _DisableDialogState extends State<_DisableDialog>
    with TextControllersOwner<_DisableDialog> {
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
      title: L.profile.disable2fa,
      description: L.profile.disableDescription,
      size: AppDialogSize.sm,
      actions: [
        AppButton.cancel(context),
        AppButton(
          label: L.profile.disable2faConfirm,
          variant: AppButtonVariant.danger,
          onPressed: _submit,
        ),
      ],
      child: CustomTextField(
        name: 'profile_totp_disable_code',
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
