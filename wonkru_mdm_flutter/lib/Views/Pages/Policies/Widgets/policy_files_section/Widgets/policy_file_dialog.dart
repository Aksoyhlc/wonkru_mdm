import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../../../../Core/Constants/Enums/alert_enums.dart';
import '../../../../../../Core/L10n/L.dart';
import '../../../../../../Core/Theme/design.dart';
import '../../../../../../Core/Utils/device_path.dart';
import '../../../../../Widgets/Alert/app_toast.dart';
import '../../../../../Widgets/Button/app_button.dart';
import '../../../../../Widgets/Dialog/app_dialog_shell.dart';
import '../../../../../Widgets/Input/app_dropdown.dart';
import '../../../../../Widgets/Input/custom_text_field.dart';
import '../../../../../Widgets/Input/text_controllers_owner.dart';
import '../../../../../Widgets/Switch/ui_switch.dart';
import '../policy_file_operations.dart';

class PolicyFileDialog extends StatefulWidget {
  const PolicyFileDialog({
    super.key,
    required this.policyId,
    required this.fileId,
    required this.fileLabel,
    this.initialUsageType,
    this.entry,
  });

  final int policyId;

  /// `null` for path-only (delete) rows.
  final int? fileId;
  final String? fileLabel;
  final FileOperationType? initialUsageType;
  final PolicyFile? entry;

  @override
  State<PolicyFileDialog> createState() => _PolicyFileDialogState();
}

class _PolicyFileDialogState extends State<PolicyFileDialog>
    with TextControllersOwner<PolicyFileDialog> {
  late FileOperationType _usageType =
      widget.entry?.usageType ??
      widget.initialUsageType ??
      FileOperationType.download;
  late bool _replaceIfExists = widget.entry?.replaceIfExists ?? true;
  late bool _openAfterDownload = widget.entry?.openAfterDownload ?? false;

  late final _destinationPath = textController(
    widget.entry?.destinationPath ?? '',
  );

  bool get _isEdit => widget.entry != null;

  void _submit() {
    final base = widget.entry;
    final destination = _destinationPath.text.trim();

    if (destination.isNotEmpty && !isAbsoluteDevicePath(destination)) {
      AppToast.show(
        L.policies.destinationPathAbsoluteRequired,
        tone: UiAlertTone.danger,
      );
      return;
    }

    final destinationPath = destination.isEmpty ? null : destination;

    final value = base == null
        ? PolicyFile(
            policyId: widget.policyId,
            fileId: widget.fileId,
            usageType: _usageType,
            destinationPath: destinationPath,
            replaceIfExists: _replaceIfExists,
            openAfterDownload: _openAfterDownload,
          )
        : base.copyWith(
            usageType: _usageType,
            destinationPath: destinationPath,
            replaceIfExists: _replaceIfExists,
            openAfterDownload: _openAfterDownload,
          );

    Navigator.pop(context, value);
  }

  @override
  Widget build(BuildContext context) {
    return AppDialogShell(
      title: _isEdit ? L.policies.editFile : L.policies.addFile,
      maxWidth: 560,
      actions: [
        AppButton.cancel(context),
        AppButton(
          label: _isEdit ? L.common.save : L.common.add,
          onPressed: _submit,
        ),
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.fileLabel ?? L.policies.deletePath,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.sectionTitle(context).copyWith(fontSize: 14),
          ),
          AppGap.v12,
          AppDropdown<FileOperationType>(
            label: L.policies.operation,
            value: _usageType,
            items: policyOperationLabels.map(
              (key, value) => MapEntry(key, value.tr),
            ),
            onChanged: (value) =>
                setState(() => _usageType = value ?? _usageType),
          ),
          AppGap.v12,
          CustomTextField(
            name: 'policy.file.destinationPath',
            controller: _destinationPath,
            label: _usageType == FileOperationType.delete
                ? L.policies.deletePath
                : L.policies.destinationPath,
            hint: '/sdcard/Download',
            showValidationError: false,
          ),
          AppGap.v12,
          UiSwitch(
            title: L.policies.flagReplaceIfExists,
            value: _replaceIfExists,
            onChanged: (value) => setState(() => _replaceIfExists = value),
          ),
          UiSwitch(
            title: L.policies.openAfterDownload,
            value: _openAfterDownload,
            onChanged: (value) => setState(() => _openAfterDownload = value),
          ),
        ],
      ),
    );
  }
}
