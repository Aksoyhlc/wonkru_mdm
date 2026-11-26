import 'package:flutter/material.dart';

import '../../../../Core/Constants/Enums/dialog_enums.dart';
import '../../../../Core/L10n/L.dart';
import '../../../Widgets/Button/app_button.dart';
import '../../../Widgets/Dialog/app_dialog_shell.dart';
import '../../ProvisioningProfiles/Widgets/provisioning_qr_preview.dart';

/// Shows the enrollment QR an agent can scan during setup.
class EnrollmentKeyQrDialog extends StatelessWidget {
  const EnrollmentKeyQrDialog({super.key, required this.payload});

  final String payload;

  static Future<void> show(BuildContext context, String payload) =>
      showDialog<void>(
        context: context,
        builder: (_) => EnrollmentKeyQrDialog(payload: payload),
      );

  @override
  Widget build(BuildContext context) {
    return AppDialogShell(
      title: L.settings.enrollmentKeyQrTitle,
      description: L.settings.enrollmentKeyQrHint,
      size: AppDialogSize.md,
      actions: [AppButton.cancel(context, compact: true)],
      child: ProvisioningQrPreview(payload: payload),
    );
  }
}
