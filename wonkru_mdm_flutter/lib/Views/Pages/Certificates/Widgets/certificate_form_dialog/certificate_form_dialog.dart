import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../../../Core/Constants/Enums/alert_enums.dart';
import '../../../../../Core/Constants/Enums/button_enums.dart';
import '../../../../../Core/L10n/L.dart';
import '../../../../../Core/Logging/wlog.dart';
import '../../../../../Core/Theme/design.dart';
import '../../../../../Logic/Controllers/certificates_controller.dart';
import '../../../../Widgets/Alert/app_toast.dart';
import '../../../../Widgets/Button/app_button.dart';
import '../../../../Widgets/Dialog/app_dialog_shell.dart';
import '../../../../Widgets/Input/app_dropdown.dart';
import '../../../../Widgets/Input/app_file_upload/app_file_upload.dart';
import '../../../../Widgets/Input/custom_text_field.dart';
import '../../../../Widgets/Input/text_controllers_owner.dart';
import '../../../../Widgets/Input/uploaded_file.dart';
import '../../../../Widgets/Switch/ui_switch.dart';
import 'Widgets/certificate_date_field.dart';

/// Returns the certificate to persist, or `null` when cancelled; saving is the
/// caller's job.
Future<Certificate?> showCertificateFormDialog(
  BuildContext context, {
  Certificate? certificate,
}) {
  return showDialog<Certificate>(
    context: context,
    builder: (_) => _CertificateFormDialog(certificate: certificate),
  );
}

class _CertificateFormDialog extends StatefulWidget {
  const _CertificateFormDialog({this.certificate});

  final Certificate? certificate;

  @override
  State<_CertificateFormDialog> createState() => _CertificateFormDialogState();
}

class _CertificateFormDialogState extends State<_CertificateFormDialog>
    with TextControllersOwner<_CertificateFormDialog> {
  static const _types = <CertificateType, String>{
    CertificateType.CA: 'CA',
    CertificateType.CLIENT: 'Client',
    CertificateType.SERVER: 'Server',
    CertificateType.USER: 'User',
    CertificateType.PKCS12: 'PKCS12',
  };

  static const _formats = <CertificateFormat, String>{
    CertificateFormat.PEM: 'PEM',
    CertificateFormat.DER: 'DER',
    CertificateFormat.PKCS12: 'PKCS12',
    CertificateFormat.PKCS7: 'PKCS7',
  };

  late final _name = textController(widget.certificate?.name ?? '');
  late final _description = textController(
    widget.certificate?.description ?? '',
  );
  late final _issuer = textController(widget.certificate?.issuer ?? '');
  late final _subject = textController(widget.certificate?.subject ?? '');
  late final _serialNumber = textController(
    widget.certificate?.serialNumber ?? '',
  );
  late final _fingerprint = textController(
    widget.certificate?.fingerprintSha256 ?? '',
  );
  late final _certificateData = textController(
    widget.certificate?.certificateData ?? '',
  );
  late final _privateKeyData = textController(
    widget.certificate?.privateKeyData ?? '',
  );
  late final _password = textController(widget.certificate?.password ?? '');

  late CertificateType _certificateType =
      widget.certificate?.certificateType ?? CertificateType.CA;
  late CertificateFormat _format =
      widget.certificate?.format ?? CertificateFormat.PEM;
  late bool _isActive = widget.certificate?.isActive ?? true;

  late String? _filePath = widget.certificate?.filePath;
  late String? _fileHash = widget.certificate?.fileHash;

  /// Retained because the password field visibility and re-parsing both depend
  /// on the selected file.
  String? _fileName;
  Uint8List? _fileBytes;

  late DateTime? _validFrom = widget.certificate?.validFrom;
  late DateTime? _validUntil = widget.certificate?.validUntil;

  bool _saving = false;
  bool _parsing = false;

  bool get _isEditing => widget.certificate != null;

  bool get _needsPassword {
    final fileName = _fileName;
    if (fileName != null) {
      final extension = fileName.split('.').last.toLowerCase();
      return extension == 'p12' || extension == 'pfx';
    }

    return widget.certificate?.format == CertificateFormat.PKCS12;
  }

  Future<void> _onUploaded(UploadedFile file) async {
    final hash = crypto.sha256.convert(file.bytes).toString();
    setState(() {
      _filePath = file.path;
      _fileHash = hash;
      _fileName = file.fileName;
      _fileBytes = file.bytes;
    });

    await _parse();
  }

  Future<void> _parse() async {
    final fileBytes = _fileBytes;
    final certificateData = fileBytes != null
        ? base64.encode(fileBytes)
        : _certificateData.text.trim();
    if (certificateData.isEmpty) {
      AppToast.show(
        L.certificates.enterDataFirst,
        tone: UiAlertTone.warning,
      );
      return;
    }

    final password = _password.text.trim();
    if (_needsPassword && password.isEmpty) {
      AppToast.show(
        L.certificates.passwordRequired,
        tone: UiAlertTone.warning,
      );
      return;
    }

    setState(() => _parsing = true);
    try {
      final info = await Get.find<CertificatesController>().parse(
        certificateData,
        password: password.isEmpty ? null : password,
      );
      if (!mounted) return;

      setState(() {
        _issuer.text = info.issuer ?? '';
        _subject.text = info.subject ?? '';
        _serialNumber.text = info.serialNumber ?? '';
        _fingerprint.text = info.fingerprintSha256 ?? '';
        final parsedFormat = _formatFromName(info.format);
        if (parsedFormat != null) {
          _format = parsedFormat;
        }
        final parsedType = _typeFromName(info.certificateType);
        if (parsedType != null) {
          _certificateType = parsedType;
        }
        final certificatePem = info.certificatePem;
        if (certificatePem != null && certificatePem.isNotEmpty) {
          _certificateData.text = certificatePem;
        }
        _validFrom = info.validFrom;
        _validUntil = info.validUntil;
      });
      AppToast.show(L.certificates.infoFetched, tone: UiAlertTone.success);
    } on CertificateParseException catch (error) {
      if (mounted) {
        AppToast.show(error.message, tone: UiAlertTone.danger);
      }
    } catch (_) {
      if (mounted) {
        AppToast.show(L.certificates.readFailed, tone: UiAlertTone.danger);
      }
    } finally {
      if (mounted) setState(() => _parsing = false);
    }
  }

  Future<void> _pickDate({required bool from}) async {
    final current = from ? _validFrom : _validUntil;
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? now,
      firstDate: DateTime(1970),
      lastDate: DateTime(now.year + 50),
    );
    if (picked == null || !mounted) return;

    final time = current ?? now;
    final value = DateTime(
      picked.year,
      picked.month,
      picked.day,
      time.hour,
      time.minute,
    );
    setState(() {
      if (from) {
        _validFrom = value;
      } else {
        _validUntil = value;
      }
    });
  }

  String? _nullable(TextEditingController controller) {
    final value = controller.text.trim();
    return value.isEmpty ? null : value;
  }

  static CertificateFormat? _formatFromName(String? name) {
    if (name == null) return null;
    for (final format in CertificateFormat.values) {
      if (format.name == name) return format;
    }
    return null;
  }

  static CertificateType? _typeFromName(String? name) {
    if (name == null) return null;
    for (final type in CertificateType.values) {
      if (type.name == name) return type;
    }
    return null;
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    final certificateData = _certificateData.text.trim();

    if (name.isEmpty) {
      AppToast.show(L.certificates.nameRequired, tone: UiAlertTone.warning);
      return;
    }
    if (certificateData.isEmpty) {
      AppToast.show(L.certificates.dataRequired, tone: UiAlertTone.warning);
      return;
    }

    setState(() => _saving = true);
    try {
      final source = widget.certificate;
      final certificate = Certificate(
        id: source?.id,
        name: name,
        description: _nullable(_description),
        certificateType: _certificateType,
        certificateData: certificateData,
        privateKeyData: _nullable(_privateKeyData),
        format: _format,
        issuer: _nullable(_issuer),
        subject: _nullable(_subject),
        serialNumber: _nullable(_serialNumber),
        fingerprintSha256: _nullable(_fingerprint),
        validFrom: _validFrom,
        validUntil: _validUntil,
        isActive: _isActive,
        createdAt: source?.createdAt,
        updatedAt: source?.updatedAt,
        deletedAt: source?.deletedAt,
        filePath: _filePath,
        fileHash: _fileHash,
        password: _nullable(_password),
      );

      if (mounted) Navigator.pop(context, certificate);
    } catch (e) {
      WLog.e('CertificateForm', 'certificate save failed', error: e);
      AppToast.show(
        L.certificates.saveFailedRetry,
        tone: UiAlertTone.danger,
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppDialogShell(
      title: _isEditing
          ? L.certificates.editCertificate
          : L.certificates.newCertificate,
      maxWidth: 640,
      actions: [
        AppButton.cancel(context, enabled: !_saving),
        AppButton(
          label: L.common.save,
          loading: _saving,
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
              AppFileUpload(
                purpose: 'certificate',
                label: L.certificates.fileLabel,
                helper: L.certificates.fileHelper,
                accept: const [
                  'pem',
                  'crt',
                  'cer',
                  'der',
                  'p12',
                  'pfx',
                  'p7b',
                  'p7c',
                ],
                enabled: !_saving,
                onUploaded: _onUploaded,
                onRemoved: () => setState(() {
                  _filePath = null;
                  _fileHash = null;
                  _fileName = null;
                  _fileBytes = null;
                }),
              ),
              if (_filePath != null) ...[
                AppGap.v6,
                Text(
                  L.certificates.savedFile.trParams({'path': '$_filePath'}),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.caption(context, size: 11),
                ),
              ],
              AppGap.v14,
              CustomTextField(
                name: 'certificate_name',
                controller: _name,
                label: L.certificates.nameLabel,
                hint: L.certificates.nameHint,
                enabled: !_saving,
                autofocus: true,
                showValidationError: false,
              ),
              AppGap.v12,
              CustomTextField(
                name: 'certificate_description',
                controller: _description,
                label: L.common.description,
                hint: L.common.optional,
                maxLines: 2,
                enabled: !_saving,
                showValidationError: false,
              ),
              AppGap.v12,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AppDropdown<CertificateType>(
                      label: L.certificates.type,
                      value: _certificateType,
                      items: _types,
                      enabled: !_saving,
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => _certificateType = value);
                      },
                    ),
                  ),
                  AppGap.h12,
                  Expanded(
                    child: AppDropdown<CertificateFormat>(
                      label: 'Format',
                      value: _format,
                      items: _formats,
                      enabled: !_saving,
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => _format = value);
                      },
                    ),
                  ),
                ],
              ),
              AppGap.v12,
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      name: 'certificate_issuer',
                      controller: _issuer,
                      label: 'Issuer',
                      hint: L.common.optional,
                      enabled: !_saving,
                      showValidationError: false,
                    ),
                  ),
                  AppGap.h12,
                  Expanded(
                    child: CustomTextField(
                      name: 'certificate_subject',
                      controller: _subject,
                      label: 'Subject',
                      hint: L.common.optional,
                      enabled: !_saving,
                      showValidationError: false,
                    ),
                  ),
                ],
              ),
              AppGap.v12,
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      name: 'certificate_serial_number',
                      controller: _serialNumber,
                      label: L.certificates.serialNumber,
                      hint: L.common.optional,
                      enabled: !_saving,
                      showValidationError: false,
                    ),
                  ),
                  AppGap.h12,
                  Expanded(
                    child: CustomTextField(
                      name: 'certificate_fingerprint',
                      controller: _fingerprint,
                      label: L.certificates.fingerprint,
                      hint: L.common.optional,
                      enabled: !_saving,
                      showValidationError: false,
                    ),
                  ),
                ],
              ),
              AppGap.v12,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CertificateDateField(
                      name: 'certificate_valid_from',
                      label: L.certificates.validFrom,
                      value: _validFrom,
                      enabled: !_saving,
                      onPick: () => _pickDate(from: true),
                      onClear: () => setState(() => _validFrom = null),
                    ),
                  ),
                  AppGap.h12,
                  Expanded(
                    child: CertificateDateField(
                      name: 'certificate_valid_until',
                      label: L.certificates.validUntil,
                      value: _validUntil,
                      enabled: !_saving,
                      onPick: () => _pickDate(from: false),
                      onClear: () => setState(() => _validUntil = null),
                    ),
                  ),
                ],
              ),
              AppGap.v12,
              CustomTextField(
                name: 'certificate_data',
                controller: _certificateData,
                label: L.certificates.dataLabel,
                hint: '-----BEGIN CERTIFICATE-----',
                maxLines: 5,
                enabled: !_saving,
                showValidationError: false,
              ),
              AppGap.v8,
              Align(
                alignment: Alignment.centerRight,
                child: AppButton(
                  label: L.certificates.fetchInfo,
                  icon: LucideIcons.refreshCw,
                  variant: AppButtonVariant.secondary,
                  compact: true,
                  loading: _parsing,
                  onPressed: _saving || _parsing ? null : _parse,
                ),
              ),
              AppGap.v12,
              CustomTextField(
                name: 'certificate_private_key',
                controller: _privateKeyData,
                label: L.certificates.privateKey,
                hint: L.common.optional,
                maxLines: 4,
                enabled: !_saving,
                showValidationError: false,
              ),
              if (_needsPassword) ...[
                AppGap.v12,
                CustomTextField(
                  name: 'certificate_password',
                  controller: _password,
                  label: L.certificates.password,
                  hint: L.common.optional,
                  obscureText: true,
                  enabled: !_saving,
                  showValidationError: false,
                ),
              ],
              AppGap.v8,
              UiSwitch(
                title: L.common.active,
                value: _isActive,
                onChanged: (value) => setState(() => _isActive = value),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
