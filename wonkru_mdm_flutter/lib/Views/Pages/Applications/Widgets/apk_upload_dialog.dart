import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../../Core/Constants/Enums/alert_enums.dart';
import '../../../../Core/Errors/server_error_message.dart';
import '../../../../Core/L10n/L.dart';
import '../../../../Core/Theme/design.dart';
import '../../../../Core/Utils/apk_manifest_parser.dart';
import '../../../../Logic/Controllers/application_versions_controller.dart';
import '../../../Widgets/Alert/app_toast.dart';
import '../../../Widgets/Alert/ui_alert.dart';
import '../../../Widgets/Button/app_button.dart';
import '../../../Widgets/Dialog/app_dialog_shell.dart';
import '../../../Widgets/Input/app_file_upload/app_file_upload.dart';
import '../../../Widgets/Input/custom_text_field.dart';
import '../../../Widgets/Input/text_controllers_owner.dart';
import '../../../Widgets/Input/uploaded_file.dart';
import '../../../Widgets/Switch/ui_switch.dart';

Future<ApplicationVersion?> showApkUploadDialog(
  BuildContext context, {
  required Application application,
  required ApplicationVersionsController controller,
}) {
  return showDialog<ApplicationVersion>(
    context: context,
    builder: (_) => _ApkUploadDialog(application: application, controller: controller),
  );
}

class _ApkUploadDialog extends StatefulWidget {
  const _ApkUploadDialog({required this.application, required this.controller});

  final Application application;
  final ApplicationVersionsController controller;

  @override
  State<_ApkUploadDialog> createState() => _ApkUploadDialogState();
}

class _ApkUploadDialogState extends State<_ApkUploadDialog> with TextControllersOwner<_ApkUploadDialog> {
  late final _versionName = textController();
  late final _versionCode = textController();
  late final _minSdk = textController();
  late final _targetSdk = textController();

  UploadedFile? _uploaded;

  Map<String, String>? _permissions;

  String? _parseNote;

  /// While set, upload is blocked; the server performs the same check.
  String? _packageMismatch;

  bool _uploading = false;
  bool _isActive = true;
  bool _isDefault = false;

  Future<void> _onUploaded(UploadedFile file) async {
    final manifest = parseApkManifest(file.bytes);
    final expected = widget.application.packageName;
    final apkPackage = manifest?.packageName;
    final mismatch = apkPackage != null && apkPackage != expected;

    setState(() {
      _uploaded = file;
      _packageMismatch = mismatch
          ? L.applications.apkPackageMismatch.trParams({'apk': apkPackage, 'expected': expected})
          : null;

      if (mismatch) {
        _permissions = null;
        _parseNote = null;
        return;
      }

      _permissions = manifest?.permissions;

      final filled = <String>[];
      void fill(TextEditingController field, String? value, String label) {
        if (field.text.trim().isNotEmpty || value == null || value.isEmpty) {
          return;
        }
        field.text = value;
        filled.add(label);
      }

      if (manifest != null) {
        fill(_versionName, manifest.versionName, L.applications.fieldVersionName);
        fill(_versionCode, manifest.versionCode?.toString(), L.applications.fieldVersionCode);
        fill(_minSdk, manifest.minSdkVersion?.toString(), L.applications.fieldMinSdk);
        fill(_targetSdk, manifest.targetSdkVersion?.toString(), L.applications.fieldTargetSdk);
      }

      if (_versionName.text.trim().isEmpty) {
        _versionName.text = _baseName(file.fileName);
      }

      _parseNote = _noteFor(manifest, filled);
    });
  }

  String _noteFor(ApkManifest? manifest, List<String> filled) {
    if (manifest == null) {
      return L.applications.manifestUnreadable;
    }

    final parts = <String>[
      if (filled.isNotEmpty) L.applications.fieldsFilled.trParams({'fields': filled.join(', ')}),
      if (_permissions?.isNotEmpty ?? false)
        L.applications.permissionsReadCount.trParams({'count': '${_permissions!.length}'}),
    ];

    if (parts.isEmpty) {
      return L.applications.manifestReadNoFields;
    }

    return L.applications.fromManifest.trParams({'details': parts.join(' · ')});
  }

  String _baseName(String fileName) {
    final dot = fileName.lastIndexOf('.');
    return dot > 0 ? fileName.substring(0, dot) : fileName;
  }

  int? _intOrNull(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : int.tryParse(trimmed);
  }

  Future<void> _upload() async {
    final uploaded = _uploaded;
    if (uploaded == null) {
      AppToast.show(L.applications.selectApkFirst, tone: UiAlertTone.warning);
      return;
    }

    final mismatch = _packageMismatch;
    if (mismatch != null) {
      AppToast.show(mismatch, tone: UiAlertTone.danger);
      return;
    }

    final versionName = _versionName.text.trim();
    final versionCode = int.tryParse(_versionCode.text.trim());
    if (versionName.isEmpty) {
      AppToast.show(L.applications.versionNameRequired, tone: UiAlertTone.warning);
      return;
    }
    if (versionCode == null) {
      AppToast.show(L.applications.versionCodeNumber, tone: UiAlertTone.warning);
      return;
    }

    final applicationId = widget.application.id;
    if (applicationId == null) {
      AppToast.show(L.applications.applicationIdMissing, tone: UiAlertTone.danger);
      return;
    }

    setState(() => _uploading = true);
    try {
      final saved = await widget.controller.createVersion(
        ApplicationVersion(
          applicationId: applicationId,
          versionName: versionName,
          versionCode: versionCode,
          filePath: uploaded.path,
          fileSizeBytes: uploaded.sizeBytes,
          checksumSha256: uploaded.checksumSha256,
          minSdkVersion: _intOrNull(_minSdk.text),
          targetSdkVersion: _intOrNull(_targetSdk.text),
          permissions: _permissions == null || _permissions!.isEmpty ? null : jsonEncode(_permissions),
          isActive: _isActive,
          isDefault: _isDefault,
        ),
      );
      AppToast.show(L.applications.apkUploaded.trParams({'version': saved.versionName}), tone: UiAlertTone.success);
      if (mounted) Navigator.pop(context, saved);
    } on ApplicationConflictException catch (e) {
      AppToast.show(
        e.existingApplication == null
            ? L.applications.versionCodeExists.trParams({'code': _versionCode.text.trim()})
            : e.message,
        tone: UiAlertTone.danger,
      );
    } catch (e) {
      AppToast.show(L.applications.uploadFailed.trParams({'error': serverErrorMessage(e)}), tone: UiAlertTone.danger);
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppDialogShell(
      title: L.applications.uploadApk,
      maxWidth: 560,
      actions: [
        AppButton.cancel(context, enabled: !_uploading),
        AppButton(label: L.applications.upload, icon: LucideIcons.upload, loading: _uploading, onPressed: _upload),
      ],
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 460),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppFileUpload(
                purpose: 'apk',
                label: L.applications.apkFile,
                helper: L.applications.apkFileHelper,
                accept: const ['apk'],
                enabled: !_uploading,
                onUploaded: _onUploaded,
                onRemoved: () => setState(() {
                  _uploaded = null;
                  _permissions = null;
                  _parseNote = null;
                  _packageMismatch = null;
                }),
              ),
              if (_packageMismatch != null) ...[
                AppGap.v8,
                UiAlert(message: _packageMismatch!, tone: UiAlertTone.danger),
              ] else if (_parseNote != null) ...[
                AppGap.v8,
                UiAlert(message: _parseNote!, tone: _permissions == null ? UiAlertTone.warning : UiAlertTone.info),
              ],
              AppGap.v16,
              CustomTextField(
                name: 'upload_version_name',
                controller: _versionName,
                label: L.applications.versionName,
                hint: L.applications.versionNameHint,
                enabled: !_uploading,
                showValidationError: false,
              ),
              AppGap.v12,
              CustomTextField(
                name: 'upload_version_code',
                controller: _versionCode,
                label: L.applications.versionCode,
                keyboardType: TextInputType.number,
                enabled: !_uploading,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                showValidationError: false,
              ),
              AppGap.v12,
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      name: 'upload_min_sdk',
                      controller: _minSdk,
                      label: L.applications.minSdk,
                      keyboardType: TextInputType.number,
                      enabled: !_uploading,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      showValidationError: false,
                    ),
                  ),
                  AppGap.h12,
                  Expanded(
                    child: CustomTextField(
                      name: 'upload_target_sdk',
                      controller: _targetSdk,
                      label: L.applications.targetSdk,
                      keyboardType: TextInputType.number,
                      enabled: !_uploading,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      showValidationError: false,
                    ),
                  ),
                ],
              ),
              AppGap.v16,
              UiSwitch(
                title: L.common.active,
                value: _isActive,
                onChanged: _uploading ? null : (value) => setState(() => _isActive = value),
              ),
              UiSwitch(
                title: L.applications.defaultVersion,
                subtitle: L.applications.defaultVersionSubtitle,
                value: _isDefault,
                onChanged: _uploading ? null : (value) => setState(() => _isDefault = value),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
