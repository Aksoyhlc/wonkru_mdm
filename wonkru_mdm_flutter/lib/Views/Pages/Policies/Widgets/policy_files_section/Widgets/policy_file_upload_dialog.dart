import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../../../../Core/Constants/Enums/alert_enums.dart';
import '../../../../../../Core/L10n/L.dart';
import '../../../../../../Core/Theme/design.dart';
import '../../../../../Widgets/Alert/app_toast.dart';
import '../../../../../Widgets/Button/app_button.dart';
import '../../../../../Widgets/Dialog/app_dialog_shell.dart';
import '../../../../../Widgets/Input/app_file_upload/app_file_upload.dart';
import '../../../../../Widgets/Input/custom_text_field.dart';
import '../../../../../Widgets/Input/text_controllers_owner.dart';
import '../../../../../Widgets/Input/uploaded_file.dart';
import '../policy_file_operations.dart';
import 'upload_result.dart';

/// Uploads a new file for [operation] and asks for an optional device path.
class PolicyFileUploadDialog extends StatefulWidget {
  const PolicyFileUploadDialog({super.key, required this.operation});

  final FileOperationType operation;

  @override
  State<PolicyFileUploadDialog> createState() => _PolicyFileUploadDialogState();
}

class _PolicyFileUploadDialogState extends State<PolicyFileUploadDialog>
    with TextControllersOwner<PolicyFileUploadDialog> {
  late final _destinationPath = textController();
  UploadedFile? _uploaded;

  void _submit() {
    final uploaded = _uploaded;
    if (uploaded == null) {
      AppToast.show(L.policies.selectFileFirst, tone: UiAlertTone.warning);
      return;
    }

    final destination = _destinationPath.text.trim();
    Navigator.pop(
      context,
      UploadResult(
        uploaded: uploaded,
        destinationPath: destination.isEmpty ? null : destination,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final label =
        (policyOperationLabels[widget.operation] ?? widget.operation.name).tr;
    return AppDialogShell(
      title: L.policies.uploadFileTitle.trParams({'operation': label}),
      maxWidth: 560,
      actions: [
        AppButton.cancel(context),
        AppButton(label: L.policies.uploadAndAdd, onPressed: _submit),
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppFileUpload(
            purpose: 'file',
            label: L.policies.file,
            helper: L.policies.fileDropHelper,
            onUploaded: (file) async => setState(() => _uploaded = file),
            onRemoved: () => setState(() => _uploaded = null),
          ),
          AppGap.v14,
          CustomTextField(
            name: 'policy.file.uploadDestinationPath',
            controller: _destinationPath,
            label: widget.operation == FileOperationType.delete
                ? L.policies.deletePath
                : L.policies.destinationPath,
            hint: '/sdcard/Download',
            showValidationError: false,
          ),
        ],
      ),
    );
  }
}
