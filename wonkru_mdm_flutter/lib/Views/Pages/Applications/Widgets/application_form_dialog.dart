import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../../Core/Constants/Enums/alert_enums.dart';
import '../../../../Core/L10n/L.dart';
import '../../../../Core/Theme/design.dart';
import '../../../../Core/Utils/apk_manifest_parser.dart';
import '../../../Widgets/Alert/app_toast.dart';
import '../../../Widgets/Button/app_button.dart';
import '../../../Widgets/Dialog/app_dialog_shell.dart';
import '../../../Widgets/Input/app_file_upload/app_file_upload.dart';
import '../../../Widgets/Input/custom_text_field.dart';
import '../../../Widgets/Input/text_controllers_owner.dart';
import '../../../Widgets/Input/uploaded_file.dart';
import '../../../Widgets/Switch/ui_switch.dart';
import 'application_form_result.dart';

Future<ApplicationFormResult?> showApplicationFormDialog(
  BuildContext context, {
  Application? application,
}) {
  return showDialog<ApplicationFormResult>(
    context: context,
    builder: (_) => _ApplicationFormDialog(application: application),
  );
}

class _ApplicationFormDialog extends StatefulWidget {
  const _ApplicationFormDialog({this.application});

  final Application? application;

  @override
  State<_ApplicationFormDialog> createState() => _ApplicationFormDialogState();
}

class _ApplicationFormDialogState extends State<_ApplicationFormDialog>
    with TextControllersOwner<_ApplicationFormDialog> {
  late final _appName = textController(widget.application?.appName ?? '');
  late final _packageName = textController(
    widget.application?.packageName ?? '',
  );
  late final _developerName = textController(
    widget.application?.developerName ?? '',
  );
  late final _category = textController(widget.application?.category ?? '');

  late final _versionName = textController();
  late final _versionCode = textController();
  late final _minSdk = textController();
  late final _targetSdk = textController();

  UploadedFile? _apk;
  Map<String, String>? _parsedPermissions;
  String? _apkParseNote;

  String? _apkPackageName;

  late bool _isSystemApp = widget.application?.isSystemApp ?? false;

  bool get _isEditing => widget.application != null;

  Future<void> _onUploaded(UploadedFile file) async {
    final manifest = parseApkManifest(file.bytes);

    setState(() {
      _apk = file;
      _parsedPermissions = manifest?.permissions;
      _apkPackageName = manifest?.packageName;
      _apkParseNote = null;

      final filled = <String>[];
      if (manifest == null) {
        _apkParseNote = L.applications.manifestUnreadableVersions;
      } else {
        if (_appName.text.trim().isEmpty &&
            (manifest.appName?.isNotEmpty ?? false)) {
          _appName.text = manifest.appName!;
          filled.add(L.applications.fieldAppName);
        }
        if (_packageName.text.trim().isEmpty &&
            (manifest.packageName?.isNotEmpty ?? false)) {
          _packageName.text = manifest.packageName!;
          filled.add(L.applications.fieldPackageName);
        }
        if (_versionName.text.trim().isEmpty &&
            (manifest.versionName?.isNotEmpty ?? false)) {
          _versionName.text = manifest.versionName!;
          filled.add(L.applications.fieldVersionName);
        }
        if (_versionCode.text.trim().isEmpty && manifest.versionCode != null) {
          _versionCode.text = '${manifest.versionCode}';
          filled.add(L.applications.fieldVersionCode);
        }
        if (_minSdk.text.trim().isEmpty && manifest.minSdkVersion != null) {
          _minSdk.text = '${manifest.minSdkVersion}';
          filled.add(L.applications.fieldMinSdk);
        }
        if (_targetSdk.text.trim().isEmpty &&
            manifest.targetSdkVersion != null) {
          _targetSdk.text = '${manifest.targetSdkVersion}';
          filled.add(L.applications.fieldTargetSdk);
        }

        final permissionCount = manifest.permissions.length;
        if (filled.isEmpty && permissionCount == 0) {
          _apkParseNote = L.applications.manifestReadNoFields;
        } else {
          final parts = <String>[...filled];
          if (permissionCount > 0) {
            parts.add(
              L.applications.permissionsCount.trParams({
                'count': '$permissionCount',
              }),
            );
          }
          _apkParseNote = L.applications.filledFromApk.trParams({
            'fields': parts.join(', '),
          });
        }
      }

      if (_versionName.text.trim().isEmpty) {
        final dot = file.fileName.lastIndexOf('.');
        _versionName.text = dot > 0
            ? file.fileName.substring(0, dot)
            : file.fileName;
      }
    });
  }

  int? _intOrNull(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : int.tryParse(trimmed);
  }

  void _save() {
    final appName = _appName.text.trim();
    final packageName = _packageName.text.trim();

    if (appName.isEmpty) {
      AppToast.show(
        L.applications.appNameRequired,
        tone: UiAlertTone.warning,
      );
      return;
    }
    if (packageName.isEmpty) {
      AppToast.show(
        L.applications.packageNameRequired,
        tone: UiAlertTone.warning,
      );
      return;
    }

    // The server rejects a mismatched package too.
    final apkPackage = _apkPackageName;
    if (apkPackage != null && apkPackage != packageName) {
      AppToast.show(
        L.applications.apkPackageMismatch.trParams({
          'apk': apkPackage,
          'expected': packageName,
        }),
        tone: UiAlertTone.danger,
      );
      return;
    }

    final apk = _apk;
    if (!_isEditing && apk != null) {
      if (_versionName.text.trim().isEmpty) {
        AppToast.show(
          L.applications.versionNameRequired,
          tone: UiAlertTone.warning,
        );
        return;
      }
      if (int.tryParse(_versionCode.text.trim()) == null) {
        AppToast.show(
          L.applications.versionCodeNumber,
          tone: UiAlertTone.warning,
        );
        return;
      }
    }

    final developerName = _developerName.text.trim();
    final category = _category.text.trim();
    final existing = widget.application;

    final application = Application(
      id: existing?.id,
      appName: appName,
      packageName: packageName,
      developerName: developerName.isEmpty ? null : developerName,
      category: category.isEmpty ? null : category,
      iconUrl: existing?.iconUrl,
      sourceType: existing?.sourceType,
      isSystemApp: _isSystemApp,
      createdAt: existing?.createdAt,
      updatedAt: existing?.updatedAt,
      deletedAt: existing?.deletedAt,
    );

    if (apk == null) {
      Navigator.pop(context, ApplicationFormResult(application: application));
      return;
    }

    Navigator.pop(
      context,
      ApplicationFormResult(
        application: application,
        apkPath: apk.path,
        apkSizeBytes: apk.sizeBytes,
        apkChecksumSha256: apk.checksumSha256,
        versionName: _versionName.text.trim(),
        versionCode: int.tryParse(_versionCode.text.trim()),
        minSdkVersion: _intOrNull(_minSdk.text),
        targetSdkVersion: _intOrNull(_targetSdk.text),
        permissions: _parsedPermissions == null || _parsedPermissions!.isEmpty
            ? null
            : jsonEncode(_parsedPermissions),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return AppDialogShell(
      title: _isEditing
          ? L.applications.editTitle
          : L.applications.newApplication,
      maxWidth: 640,
      actions: [
        AppButton.cancel(context),
        AppButton(
          label: _isEditing ? L.common.save : L.applications.create,
          icon: _isEditing ? LucideIcons.save : LucideIcons.plus,
          onPressed: _save,
        ),
      ],
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 520),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!_isEditing) ...[
                AppFileUpload(
                  purpose: 'apk',
                  label: L.applications.apkFile,
                  helper: L.applications.apkFileHelperCreate,
                  accept: const ['apk'],
                  onUploaded: _onUploaded,
                  onRemoved: () => setState(() {
                    _apk = null;
                    _parsedPermissions = null;
                    _apkPackageName = null;
                    _apkParseNote = null;
                  }),
                ),
                if (_apkParseNote != null) ...[
                  AppGap.v8,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(LucideIcons.info, size: 14, color: colors.graphite),
                      AppGap.h6,
                      Expanded(
                        child: Text(
                          _apkParseNote!,
                          style: AppText.cellSecondary(context),
                        ),
                      ),
                    ],
                  ),
                ],
                if (_apk != null) ...[
                  AppGap.v16,
                  _sectionLabel(context, L.applications.firstVersionSection),
                  AppGap.v8,
                  CustomTextField(
                    name: 'create_version_name',
                    controller: _versionName,
                    label: L.applications.versionName,
                    hint: L.applications.versionNameHint,
                    showValidationError: false,
                  ),
                  AppGap.v12,
                  CustomTextField(
                    name: 'create_version_code',
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
                          name: 'create_min_sdk',
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
                          name: 'create_target_sdk',
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
                ],
                AppGap.v20,
                _sectionLabel(context, L.applications.infoSection),
                AppGap.v8,
              ],
              CustomTextField(
                name: 'application_app_name',
                controller: _appName,
                label: L.applications.appName,
                hint: L.applications.appNameHint,
                autofocus: _isEditing,
                showValidationError: false,
              ),
              AppGap.v12,
              CustomTextField(
                name: 'application_package_name',
                controller: _packageName,
                label: L.applications.packageName,
                hint: 'com.example.app',
                enabled: !_isEditing,
                showValidationError: false,
              ),
              if (_isEditing)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.s4),
                  child: Text(
                    L.applications.packageNameFixed,
                    style: AppText.caption(context, size: 11),
                  ),
                ),
              AppGap.v12,
              CustomTextField(
                name: 'application_developer_name',
                controller: _developerName,
                label: L.applications.developer,
                hint: L.common.optional,
                showValidationError: false,
              ),
              AppGap.v12,
              CustomTextField(
                name: 'application_category',
                controller: _category,
                label: L.applications.category,
                hint: L.common.optional,
                showValidationError: false,
              ),
              AppGap.v8,
              UiSwitch(
                title: L.applications.systemAppSwitch,
                subtitle: L.applications.systemAppSwitchSubtitle,
                value: _isSystemApp,
                onChanged: (value) => setState(() => _isSystemApp = value),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(BuildContext context, String text) {
    return Text(
      text,
      style: AppText.columnHeader(context),
    );
  }
}
