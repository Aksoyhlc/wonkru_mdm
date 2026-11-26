import 'package:flutter/material.dart';

import '../../../../../../Core/L10n/L.dart';
import '../../../../../../Core/Theme/design.dart';
import '../../../../../Widgets/Button/app_button.dart';
import '../../../../../Widgets/Dialog/app_dialog_shell.dart';
import '../../../../../Widgets/Input/custom_text_field.dart';
import '../../../../../Widgets/Input/text_controllers_owner.dart';

/// Asks for a single absolute device path (the "delete path" attachment row).
class AddPathDialog extends StatefulWidget {
  const AddPathDialog({super.key});

  @override
  State<AddPathDialog> createState() => _AddPathDialogState();
}

class _AddPathDialogState extends State<AddPathDialog>
    with TextControllersOwner<AddPathDialog> {
  late final _path = textController();

  @override
  Widget build(BuildContext context) {
    return AppDialogShell(
      title: L.policies.addPath,
      maxWidth: 480,
      actions: [
        AppButton.cancel(context),
        AppButton(
          label: L.common.add,
          onPressed: () => Navigator.pop(context, _path.text),
        ),
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            L.policies.deletePathHint,
            style: AppText.caption(context, size: 12.5),
          ),
          AppGap.v12,
          CustomTextField(
            name: 'policy.file.deletePath',
            controller: _path,
            label: L.policies.deletePath,
            hint: '/sdcard/Download/dosya.pdf',
            autofocus: true,
            showValidationError: false,
          ),
        ],
      ),
    );
  }
}
