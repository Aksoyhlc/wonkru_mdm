import 'dart:typed_data';

import 'package:wonkrumdm/Core/Native/Bridges/base_bridge.dart';
import 'package:wonkrumdm/Core/Native/Generated/certificate_api.g.dart';

class CertificateBridge extends BaseBridge {
  static final CertificateBridge _instance = CertificateBridge._internal();

  factory CertificateBridge() => _instance;

  CertificateBridge._internal();

  final _api = CertificateAPI();

  @override
  String get bridgeName => "CertificateBridge";

  Future<bool> installCaCertificate(Uint8List certData) async {
    final (success, _) = await mdmResultSafeCall<Object>(
      () async => await _api.installCaCertificate(certData),
      logMessage: "$bridgeName: CA certificate installed",
    );
    return success;
  }

  Future<List<NativeCertificateInfo>> getInstalledCaCertificates() async {
    

    final (success, data) = await mdmResultSafeCall<Object>(
      () async => await _api.getInstalledCaCertificates(),
      defaultValue: null,
    );

    if (!success || data == null || data is! List) return [];

    final list = data;
    return list.map(_certInfoFromReply).whereType<NativeCertificateInfo>().toList();
  }

  static NativeCertificateInfo? _certInfoFromReply(Object? e) {
    if (e == null) return null;
    if (e is NativeCertificateInfo) return e;
    if (e is List) {
      try {
        return NativeCertificateInfo.decode(e);
      } catch (_) {
        return null;
      }
    }
    if (e is Map) {
      try {
        final m = Map<String, Object?>.from(e as Map<Object?, Object?>);
        return NativeCertificateInfo(
          alias: m['alias'] as String?,
          subject: m['subject'] as String?,
          issuer: m['issuer'] as String?,
          validFrom: (m['validFrom'] as num?)?.toInt(),
          validTo: (m['validTo'] as num?)?.toInt(),
          isCa: m['isCa'] as bool?,
        );
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  Future<bool> installUserKeyPair(Uint8List p12Data, String password, String alias, bool isWifi) async {
    final (success, _) = await mdmResultSafeCall<Object>(
      () async => await _api.installUserKeyPair(p12Data, password, alias, isWifi),
      logMessage: "$bridgeName: KeyPair installed -> $alias",
    );
    return success;
  }

  Future<bool> removeKeyPair(String alias) async {
    final (success, _) = await mdmResultSafeCall<Object>(
      () async => await _api.removeKeyPair(alias),
      logMessage: "$bridgeName: KeyPair deleted -> $alias",
    );
    return success;
  }
}
