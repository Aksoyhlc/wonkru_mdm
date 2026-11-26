import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wonkrumdm/Core/Constants/Enums/certificate_action.dart';
import 'package:wonkrumdm/Core/Constants/Enums/certificate_type.dart';
import 'package:wonkrumdm/Core/Logging/wlog.dart';
import 'package:wonkrumdm/Core/Managers/base_manager.dart';
import 'package:wonkrumdm/Core/Native/Bridges/certificate_bridge.dart';
import 'package:wonkrumdm/Core/Native/Generated/certificate_api.g.dart';
import 'package:wonkrumdm/Core/Utils/hash_helper.dart';
import 'package:wonkrumdm/Data/DataSources/Remote/file_api.dart';
import 'package:wonkrumdm/Data/Models/Features/certificate_config.dart';
import 'package:wonkrumdm/Data/Models/Features/certificate_policy.dart';

const _tag = 'CertificateManager';

class CertificateManager extends BaseManager<CertificateSettings> {
  static final CertificateManager _instance = CertificateManager._internal();
  factory CertificateManager() => _instance;
  CertificateManager._internal();

  final _certBridge = CertificateBridge();

  @override
  Future<void> applyConfiguration(CertificateSettings config) async {
    await safeExecute(() async {
      if (config.isEmpty) {
        WLog.d(_tag, 'Certificate list empty');
        return;
      }

      for (final policy in config.policies) {
        await _applyPolicy(policy);
      }

      WLog.i(_tag, '${config.length} certificates processed');
    }, logMessage: 'CertificateManager: Certificate policies applied');
  }

  Future<void> _applyPolicy(CertificatePolicy policy) async {
    switch (policy.action) {
      case CertificateAction.install:
        await _installCertificate(policy);
        break;
      case CertificateAction.uninstall:
        await _removeCertificate(policy);
        break;
    }
  }

  Future<void> _installCertificate(CertificatePolicy policy) async {
    if (policy.downloadUrl == null || policy.downloadUrl!.isEmpty) {
      WLog.w(_tag, '${policy.name} -> no download_url, skipping');
      return;
    }

    final tempDir = await getTemporaryDirectory();
    final fileName = 'cert_${policy.id}_${DateTime.now().millisecondsSinceEpoch}';
    final tempPath = '${tempDir.path}/$fileName';

    final (success, result) = await FileApi().downloadFile(policy.downloadUrl!, tempPath);
    if (!success) {
      WLog.w(_tag, 'Download failed -> $result');
      return;
    }

    try {
      if (policy.fileHash != null && policy.fileHash!.isNotEmpty) {
        final actualHash = await HashHelper.calculateFileHash(tempPath);
        if (actualHash.toLowerCase() != policy.fileHash!.toLowerCase()) {
          WLog.w(_tag, 'Hash verification failed. Expected: ${policy.fileHash}, Got: $actualHash');
          return;
        }
        WLog.d(_tag, 'Hash verification passed');
      }

      final file = File(tempPath);
      final certBytes = await file.readAsBytes();

      switch (policy.certificateType) {
        case CertificateType.ca:
          final ok = await installCaCertificate(certBytes);
          WLog.d(_tag, 'CA ${policy.name} -> ${ok ? "OK" : "FAIL"}');
          break;

        case CertificateType.client:
        case CertificateType.server:
        case CertificateType.user:
        case CertificateType.pkcs12:
          final alias = policy.name ?? 'mdm_cert_${policy.id}';
          final ok = await installUserKeyPair(certBytes, policy.password ?? '', alias);
          if (ok) {
            WLog.d(_tag, '${policy.certificateType.value} $alias -> OK');
          } else {
            WLog.w(_tag, '${policy.certificateType.value} $alias install failed; not falling back to CA');
          }
          break;
      }
    } catch (e, st) {
      WLog.e(_tag, 'Certificate install error (policy.id=${policy.id}, name=${policy.name})', error: e, stackTrace: st);
    } finally {
      if (await File(tempPath).exists()) {
        await File(tempPath).delete();
      }
    }
  }

  Future<void> _removeCertificate(CertificatePolicy policy) async {
    if (policy.name == null && policy.id == null) {
      WLog.w(_tag, 'Cannot derive alias for removal (policy.name and policy.id are null)');
      return;
    }
    final alias = policy.name ?? 'mdm_cert_${policy.id}';

    final success = await removeCertificate(alias);
    WLog.d(_tag, '$alias removed -> ${success ? "OK" : "FAIL"}');
  }

  Future<bool> installCaCertificate(Uint8List certData) async {
    return await _certBridge.installCaCertificate(certData);
  }

  Future<bool> installUserKeyPair(Uint8List p12Data, String password, String alias) async {
    return await _certBridge.installUserKeyPair(p12Data, password, alias, true);
  }

  Future<bool> removeCertificate(String alias) async {
    return await _certBridge.removeKeyPair(alias);
  }

  Future<List<NativeCertificateInfo>> getInstalledCaCertificates() async {
    return await _certBridge.getInstalledCaCertificates();
  }

  @override
  Future<Map<String, dynamic>> getData() async {
    final installedCerts = await getInstalledCaCertificates();
    return {
      'installedCaCertificateCount': installedCerts.length,
      'installedCaCertificates': installedCerts.map((c) => c.alias ?? 'unknown').toList(),
    };
  }
}
