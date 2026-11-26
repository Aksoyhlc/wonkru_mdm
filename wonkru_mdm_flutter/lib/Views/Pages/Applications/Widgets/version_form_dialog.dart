import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../../Core/Constants/Enums/alert_enums.dart';
import '../../../../Core/L10n/L.dart';
import '../../../../Core/Theme/design.dart';
import '../../../Widgets/Alert/app_toast.dart';
import '../../../Widgets/Button/app_button.dart';
import '../../../Widgets/Dialog/app_dialog_shell.dart';
import '../../../Widgets/Input/custom_text_field.dart';
import '../../../Widgets/Input/permission_list.dart';
import '../../../Widgets/Input/text_controllers_owner.dart';
import '../../../Widgets/Switch/ui_switch.dart';

Future<ApplicationVersion?> showVersionFormDialog(
  BuildContext context, {
  required ApplicationVersion version,
}) {
  return showDialog<ApplicationVersion>(
    context: context,
    builder: (_) => _VersionFormDialog(version: version),
  );
}

class _VersionFormDialog extends StatefulWidget {
  const _VersionFormDialog({required this.version});

  final ApplicationVersion version;

  @override
  State<_VersionFormDialog> createState() => _VersionFormDialogState();
}

class _VersionFormDialogState extends State<_VersionFormDialog>
    with TextControllersOwner<_VersionFormDialog> {
  late final _versionName = textController(widget.version.versionName);
  late final _versionCode = textController('${widget.version.versionCode}');
  late final _minSdk = textController(
    widget.version.minSdkVersion?.toString() ?? '',
  );
  late final _targetSdk = textController(
    widget.version.targetSdkVersion?.toString() ?? '',
  );

  late bool _isActive = widget.version.isActive;
  late bool _isDefault = widget.version.isDefault;

  void _save() {
    final versionName = _versionName.text.trim();
    final versionCode = int.tryParse(_versionCode.text.trim());

    if (versionName.isEmpty) {
      AppToast.show(
        L.applications.versionNameRequired,
        tone: UiAlertTone.warning,
      );
      return;
    }
    if (versionCode == null) {
      AppToast.show(
        L.applications.versionCodeNumber,
        tone: UiAlertTone.warning,
      );
      return;
    }

    final source = widget.version;
    Navigator.pop(
      context,
      ApplicationVersion(
        id: source.id,
        applicationId: source.applicationId,
        application: source.application,
        versionName: versionName,
        versionCode: versionCode,
        filePath: source.filePath,
        fileSizeBytes: source.fileSizeBytes,
        checksumSha256: source.checksumSha256,
        minSdkVersion: _intOrNull(_minSdk.text),
        targetSdkVersion: _intOrNull(_targetSdk.text),
        isActive: _isActive,
        permissions: source.permissions,
        isDefault: _isDefault,
        createdAt: source.createdAt,
        updatedAt: source.updatedAt,
      ),
    );
  }

  int? _intOrNull(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : int.tryParse(trimmed);
  }

  @override
  Widget build(BuildContext context) {
    return AppDialogShell(
      title: L.applications.editVersionTitle,
      maxWidth: 560,
      actions: [
        AppButton.cancel(context),
        AppButton(label: L.common.save, onPressed: _save),
      ],
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 460),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                name: 'version_name',
                controller: _versionName,
                label: L.applications.versionName,
                hint: L.applications.versionNameHint,
                autofocus: true,
                showValidationError: false,
              ),
              AppGap.v12,
              CustomTextField(
                name: 'version_code',
                controller: _versionCode,
                label: L.applications.versionCode,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                showValidationError: false,
              ),
              AppGap.v12,
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      name: 'version_min_sdk',
                      controller: _minSdk,
                      label: L.applications.minSdk,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      showValidationError: false,
                    ),
                  ),
                  AppGap.h12,
                  Expanded(
                    child: CustomTextField(
                      name: 'version_target_sdk',
                      controller: _targetSdk,
                      label: L.applications.targetSdk,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      showValidationError: false,
                    ),
                  ),
                ],
              ),
              AppGap.v16,
              PermissionList(value: widget.version.permissions),
              AppGap.v8,
              UiSwitch(
                title: L.common.active,
                value: _isActive,
                onChanged: (value) => setState(() => _isActive = value),
              ),
              UiSwitch(
                title: L.applications.defaultVersion,
                subtitle: L.applications.defaultVersionSubtitle,
                value: _isDefault,
                onChanged: (value) => setState(() => _isDefault = value),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
