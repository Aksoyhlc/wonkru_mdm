import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../Client/serverpod_client.dart';
import '../Models/list_query.dart';

class CertificateRepository {
  const CertificateRepository._();

  static Future<CertificatePage> list(AdminListRequest request) =>
      serverpodClient.adminCertificate.list(request);

  static Future<Certificate> get(int certificateId) =>
      serverpodClient.adminCertificate.get(certificateId);

  /// [password] is only used for PKCS#12 (`.p12`/`.pfx`) files.
  static Future<CertificateInfo> parse(
    String certificateData, {
    String? password,
  }) => serverpodClient.adminCertificate.parse(
    certificateData,
    password: password,
  );

  static Future<Certificate> create(Certificate certificate) =>
      serverpodClient.adminCertificate.create(certificate);

  static Future<Certificate> update(Certificate certificate) =>
      serverpodClient.adminCertificate.update(certificate);

  static Future<int> delete(List<int> certificateIds) =>
      serverpodClient.adminCertificate.delete(certificateIds);

  static Future<String?> downloadUrl(int certificateId) =>
      serverpodClient.adminCertificate.downloadUrl(certificateId);

  static Future<List<Certificate>> lookup() async {
    final page = await serverpodClient.adminCertificate.list(
      AdminListRequest(perPage: lookupPageSize),
    );
    return page.items;
  }
}
