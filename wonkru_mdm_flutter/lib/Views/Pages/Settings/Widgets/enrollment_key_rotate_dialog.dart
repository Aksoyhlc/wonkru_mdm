import 'package:flutter/material.dart';

import '../../../../Core/Constants/Enums/button_enums.dart';
import '../../../../Core/Constants/Enums/dialog_enums.dart';
import '../../../../Core/L10n/L.dart';
import '../../../../Core/Theme/design.dart';
import '../../../Widgets/Button/app_button.dart';
import '../../../Widgets/Dialog/app_dialog_shell.dart';

class EnrollmentKeyRotateDialog extends StatelessWidget {
  const EnrollmentKeyRotateDialog({super.key});

  static Future<bool> show(BuildContext context) async =>
      await showDialog<bool>(
        context: context,
        builder: (_) => const EnrollmentKeyRotateDialog(),
      ) ??
      false;

  @override
  Widget build(BuildContext context) {
    return AppDialogShell(
      title: L.settings.enrollmentKeyRotateTitle,
      size: AppDialogSize.sm,
      actions: [
        AppButton.cancel(context, result: false, compact: true),
        AppButton(
          label: L.settings.enrollmentKeyRotate,
          variant: AppButtonVariant.danger,
          compact: true,
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
      child: Text(
        L.settings.enrollmentKeyRotateMessage,
        style: AppText.body(context),
      ),
    );
  }
}
