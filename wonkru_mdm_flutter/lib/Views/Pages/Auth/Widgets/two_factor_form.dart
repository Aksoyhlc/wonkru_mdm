import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../Core/Constants/Enums/alert_enums.dart';
import '../../../../Core/Constants/Enums/button_enums.dart';
import '../../../../Core/L10n/L.dart';
import '../../../../Core/Theme/design.dart';
import '../../../../Logic/Controllers/auth_controller.dart';
import '../../../Widgets/Alert/app_toast.dart';
import '../../../Widgets/Button/app_button.dart';
import '../../../Widgets/Input/custom_text_field.dart';
import '../../../Widgets/Input/text_controllers_owner.dart';

/// Accepts a TOTP code or a recovery code.
class TwoFactorForm extends StatefulWidget {
  const TwoFactorForm({super.key, this.onFailure});

  final VoidCallback? onFailure;

  @override
  State<TwoFactorForm> createState() => _TwoFactorFormState();
}

class _TwoFactorFormState extends State<TwoFactorForm>
    with TextControllersOwner<TwoFactorForm> {
  late final _codeController = textController();
  bool _loading = false;

  Future<void> _submit() async {
    if (_loading) return;

    final code = _codeController.text.trim();
    if (code.isEmpty) {
      AppToast.show(L.common.enterVerificationCode, tone: UiAlertTone.warning);
      return;
    }

    setState(() => _loading = true);
    final auth = Get.find<AuthController>();
    final ok = await auth.verifyTotp(code);
    if (!mounted) return;
    setState(() => _loading = false);

    if (!ok) {
      widget.onFailure?.call();
      _codeController.clear();
      AppToast.show(
        auth.twoFactorError.value ?? L.common.codeInvalid,
        tone: UiAlertTone.danger,
      );
    }
  }

  Future<void> _cancel() async {
    await Get.find<AuthController>().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          L.common.twoFactorTitle,
          textAlign: TextAlign.center,
          style: AppText.pageTitle(
            context,
          ).copyWith(fontSize: 22, letterSpacing: -0.3),
        ),
        AppGap.v6,
        Text(
          L.common.twoFactorSubtitle,
          textAlign: TextAlign.center,
          style: AppText.bodyMuted(context),
        ),
        AppGap.v32,
        CustomTextField(
          name: 'login_totp_code',
          controller: _codeController,
          label: L.common.verificationCode,
          hint: '123456',
          enabled: !_loading,
          autofocus: true,
          prefixIcon: LucideIcons.shieldCheck,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9\-]')),
          ],
          onSubmitted: (_) => _submit(),
        ),
        AppGap.v24,
        AppButton(
          label: L.common.verify,
          expand: true,
          loading: _loading,
          onPressed: _loading ? null : _submit,
        ),
        AppGap.v8,
        AppButton(
          label: L.common.signInDifferentAccount,
          expand: true,
          variant: AppButtonVariant.ghost,
          onPressed: _loading ? null : _cancel,
        ),
      ],
    );
  }
}
