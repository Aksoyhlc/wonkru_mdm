import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wonkrumdm/Core/Constants/Enums/global.dart';
import 'package:wonkrumdm/Core/Constants/Enums/storage_keys.dart';
import 'package:wonkrumdm/Core/Constants/const.dart';
import 'package:wonkrumdm/Core/Extensions/num.dart';
import 'package:wonkrumdm/Core/L10n/L.dart';
import 'package:wonkrumdm/Core/Logging/wlog.dart';
import 'package:wonkrumdm/Core/Managers/certificate_manager.dart';
import 'package:wonkrumdm/Core/Theme/wonkru_theme.dart';
import 'package:wonkrumdm/Core/Utils/basic_storage.dart';
import 'package:wonkrumdm/Data/DataSources/Remote/device_register.dart';
import 'package:wonkrumdm/Logic/UI/input_controller.dart';

const _tag = 'BootstrapCaInstallerSheet';
const bootstrapCaInputKey = 'bootstrap_ca_server_url';

/// The `scheme` constant may be `https`, so the `https://…` prefill must be
/// accepted as valid.
bool isValidBootstrapCaUrl(String value) {
  final uri = Uri.tryParse(value.trim());
  return uri != null &&
      (uri.scheme == 'http' || uri.scheme == 'https') &&
      uri.host.isNotEmpty;
}

class BootstrapCaInstallerSheet extends StatefulWidget {
  const BootstrapCaInstallerSheet({super.key});

  static Future<void> show(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: WonkruColors.bg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        side: BorderSide(color: Colors.white12),
      ),
      builder: (_) => const BootstrapCaInstallerSheet(),
    );
  }

  @override
  State<BootstrapCaInstallerSheet> createState() =>
      _BootstrapCaInstallerSheetState();
}

class _BootstrapCaInstallerSheetState extends State<BootstrapCaInstallerSheet> {
  final _status = ActionStatus.idle.obs;
  final _statusMessage = ''.obs;
  late final TextEditingController _urlController;
  final _fingerprintController = TextEditingController();

  String _defaultBootstrapCaUrl() {
    final url = resolveBootstrapCaUri(base: serverUrl);
    if (url == null || url.scheme == 'http') {
      return url?.toString() ?? '';
    }
    return Uri(scheme: 'http', host: url.host, path: url.path).toString();
  }

  bool _isValidUrl(String value) => isValidBootstrapCaUrl(value);

  @override
  void initState() {
    super.initState();
    final existing = InputController.to.getController(
      bootstrapCaInputKey,
      createIfNull: false,
    );
    if (existing != null) {
      _urlController = existing;
      return;
    }
    _urlController = InputController.to.getController(
      bootstrapCaInputKey,
      defaultValue: _defaultBootstrapCaUrl(),
    )!;
  }

  @override
  void dispose() {
    _fingerprintController.dispose();
    super.dispose();
  }

  Future<void> _downloadAndInstall(Uri url, String? fingerprint) async {
    _status.value = ActionStatus.loading;
    _statusMessage.value = L.bootstrap_ca_status_downloading;
    WLog.i(_tag, 'Bootstrap CA download step started');

    final Uint8List? certBytes;
    try {
      certBytes = await DeviceRegister().downloadBootstrapCa(
        url,
        expectedFingerprint: fingerprint,
      );
    } on BootstrapCaFingerprintException {
      _status.value = ActionStatus.error;
      _statusMessage.value = L.bootstrap_ca_fingerprint_mismatch;
      return;
    }
    if (certBytes == null || certBytes.isEmpty) {
      _status.value = ActionStatus.error;
      _statusMessage.value = L.bootstrap_ca_status_download_failed;
      WLog.w(_tag, 'Bootstrap CA could not be downloaded');
      return;
    }

    BasicStorage.instance.setString(
      Sk.bootstrap_ca_cert_b64.name,
      base64Encode(certBytes),
    );

    _statusMessage.value = L.bootstrap_ca_status_installing;
    final installed = await CertificateManager().installCaCertificate(
      certBytes,
    );
    if (!installed) {
      _status.value = ActionStatus.error;
      _statusMessage.value = L.bootstrap_ca_status_install_failed;
      WLog.w(_tag, 'Bootstrap CA could not be installed');
      return;
    }

    _status.value = ActionStatus.success;
    _statusMessage.value = L.bootstrap_ca_status_install_success;
    WLog.i(_tag, 'Bootstrap CA installed successfully');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Alert(
            title: L.bootstrap_ca_prereq_title,
            message: L.bootstrapCaPrereqMessage(host),
            icon: Icons.info_outline_rounded,
            color: WonkruColors.red,
          ),
          12.hh,
          CustomTextField(
            controller: _urlController,
            hint: L.bootstrapCaUrlHint(host),
            prefixIcon: Icons.link_rounded,
            keyboardType: TextInputType.url,
          ),
          12.hh,
          CustomTextField(
            controller: _fingerprintController,
            hint: L.bootstrap_ca_fingerprint_hint,
            prefixIcon: Icons.fingerprint_rounded,
          ),
          14.hh,
          CustomButton(
            label: L.bootstrap_ca_install_btn,
            variant: ButtonVariant.primary,
            icon: Icons.download_rounded,
            onTap: () async {
              if (_status.value == ActionStatus.loading) return;
              final value = _urlController.text.trim();
              if (!_isValidUrl(value)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(L.bootstrapCaInvalidUrlSnackbar(host)),
                  ),
                );
                return;
              }
              final url = resolveBootstrapCaUri(
                base: serverUrl,
                userValue: value,
              )!;
              final fingerprint = _fingerprintController.text.trim();
              if ((url.scheme == 'http' || fingerprint.isNotEmpty) &&
                  normalizeBootstrapCaFingerprint(fingerprint) == null) {
                _status.value = ActionStatus.error;
                _statusMessage.value = L.bootstrap_ca_fingerprint_required;
                return;
              }
              InputController.to.setValue(bootstrapCaInputKey, value);
              await _downloadAndInstall(
                url,
                fingerprint.isEmpty ? null : fingerprint,
              );
            },
          ),
          10.hh,
          Obx(() {
            if (_status.value == ActionStatus.idle)
              return const SizedBox.shrink();
            return Alert(
              title: _status.value == ActionStatus.loading
                  ? L.bootstrap_ca_status_title_downloading
                  : (_status.value == ActionStatus.success
                        ? L.bootstrap_ca_status_title_success
                        : L.bootstrap_ca_status_title_failed),
              message: _statusMessage.value,
              icon: _status.value == ActionStatus.loading
                  ? Icons.downloading_rounded
                  : Icons.info_outline_rounded,
              color: _status.value == ActionStatus.success
                  ? WonkruColors.accent
                  : (_status.value == ActionStatus.loading
                        ? WonkruColors.cream
                        : WonkruColors.red),
            );
          }),
        ],
      ),
    );
  }
}
