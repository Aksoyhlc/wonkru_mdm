import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../Data/Models/list_query.dart';
import '../../Data/Models/list_query_request.dart';
import '../../Data/Models/paged_result.dart';
import '../../Data/Repositories/certificate_repository.dart';
import 'Base/paged_table_controller.dart';

class CertificatesController extends PagedTableController<Certificate> {
  CertificatesController() : super(pageSize: 25);

  @override
  Future<PagedResult<Certificate>> fetch(ListQuery query) async {
    final page = await CertificateRepository.list(
      query.toAdminListRequest(),
    );

    return PagedResult(items: page.items, total: page.total);
  }

  Future<Certificate> createCertificate(Certificate certificate) =>
      reloadAfter(() => CertificateRepository.create(certificate));

  Future<Certificate> updateCertificate(Certificate certificate) =>
      reloadAfter(() => CertificateRepository.update(certificate));

  Future<void> deleteCertificate(int certificateId) =>
      reloadAfter(() => CertificateRepository.delete([certificateId]));

  Future<int> deleteSelected() => applyToSelected(CertificateRepository.delete);

  Future<String?> downloadUrl(int certificateId) =>
      CertificateRepository.downloadUrl(certificateId);

  /// [password] is only used for PKCS#12 files.
  Future<CertificateInfo> parse(String certificateData, {String? password}) =>
      CertificateRepository.parse(certificateData, password: password);
}
