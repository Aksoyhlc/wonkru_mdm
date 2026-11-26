import 'package:get/get.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../Core/Errors/server_error_message.dart';
import '../../Core/L10n/L.dart';
import '../../Data/Models/list_query.dart';
import '../../Data/Repositories/application_repository.dart';
import '../../Data/Repositories/certificate_repository.dart';
import '../../Data/Repositories/file_repository.dart';
import '../../Data/Repositories/policy_repository.dart';
import '../../Data/Repositories/restriction_catalog_repository.dart';

class PolicyEditorController extends GetxController {
  PolicyEditorController({this.policyId});

  final int? policyId;

  final loading = true.obs;
  final saving = false.obs;
  final policy = Rxn<Policy>();
  final error = RxnString();

  final optionsError = RxnString();

  final pivotsError = RxnString();

  final applications = <PolicyApplication>[].obs;
  final files = <PolicyFile>[].obs;
  final certificates = <PolicyCertificate>[].obs;

  final applicationOptions = <Application>[].obs;

  final applicationVersionCounts = <int, int>{}.obs;
  final fileOptions = <FileAsset>[].obs;
  final certificateOptions = <Certificate>[].obs;

  bool get isNew => policyId == null;

  Future<void> load() async {
    loading.value = true;
    error.value = null;
    optionsError.value = null;
    pivotsError.value = null;
    try {
      policy.value = policyId != null ? await PolicyRepository.get(policyId!) : Policy(name: '');
    } catch (e) {
      error.value = serverErrorMessage(e);
      loading.value = false;
      return;
    }

    // Options and pivots load independently: a failure in one still lets the
    // other load, with errors reported separately.
    await _loadOptions();
    await _loadPivots();
    loading.value = false;
  }

  Future<void> save(Policy value) async {
    saving.value = true;
    try {
      policy.value = isNew
          ? await PolicyRepository.create(value.copyWith(id: null))
          : await PolicyRepository.update(value);
    } finally {
      saving.value = false;
    }
  }

  Future<void> setDefault() async {
    final id = policy.value?.id;
    if (id == null) return;
    await PolicyRepository.setDefault(id);
  }

  Future<Policy> duplicate(String? newName) async {
    final id = policyId;
    if (id == null) {
      throw StateError(L.common.policyDuplicateUnsaved);
    }
    return PolicyRepository.duplicate(id, newName: newName);
  }

  Future<void> _loadOptions() async {
    try {
      final (applications, versionCounts) = await PolicyRepository.applications();
      final files = FileRepository.lookup();
      final certificates = CertificateRepository.lookup();

      applicationOptions.assignAll(applications);
      applicationVersionCounts.assignAll(versionCounts);
      fileOptions.assignAll(await files);
      certificateOptions.assignAll(await certificates);
    } catch (e) {
      optionsError.value = serverErrorMessage(e);
    }
  }

  Future<void> _loadPivots() async {
    if (policyId == null) {
      applications.clear();
      files.clear();
      certificates.clear();
      return;
    }

    try {
      await Future.wait([
        _reloadApplications(),
        _reloadFiles(),
        _reloadCertificates(),
      ]);
    } catch (e) {
      pivotsError.value = serverErrorMessage(e);
    }
  }

  Future<void> _reloadApplications() async {
    final id = policyId;
    if (id == null) return;
    applications.assignAll(await PolicyRepository.applicationsForPolicy(id));
  }

  Future<void> _reloadFiles() async {
    final id = policyId;
    if (id == null) return;
    files.assignAll(await PolicyRepository.filesForPolicy(id));
  }

  Future<void> _reloadCertificates() async {
    final id = policyId;
    if (id == null) return;
    certificates.assignAll(await PolicyRepository.certificatesForPolicy(id));
  }

  Future<List<ApplicationVersion>> applicationVersions(
    int applicationId,
  ) async {
    final page = await ApplicationRepository.listVersions(
      applicationId,
      AdminListRequest(perPage: lookupPageSize),
    );
    return page.items;
  }

  Future<void> attachApplication(PolicyApplication entry) async {
    await PolicyRepository.attachApplication(entry);
    await _reloadApplications();
  }

  Future<void> updateApplicationEntry(PolicyApplication entry) async {
    await PolicyRepository.updateApplication(entry);
    await _reloadApplications();
  }

  Future<void> detachApplicationEntry(int entryId) async {
    await PolicyRepository.detachApplication(entryId);
    await _reloadApplications();
  }

  Future<void> moveApplication(int entryId, int delta) async {
    final id = policyId;
    if (id == null) return;

    final list = List<PolicyApplication>.of(applications);
    final index = list.indexWhere((entry) => entry.id == entryId);
    if (index < 0) return;

    final target = index + delta;
    if (target < 0 || target >= list.length) return;

    final entry = list.removeAt(index);
    list.insert(target, entry);

    await PolicyRepository.reorderApplications(id, [
      for (final item in list) item.id!,
    ]);
    await _reloadApplications();
  }

  /// Creates the asset and adds it to the options list; it is NOT attached to
  /// the policy — the caller does that with [attachFile].
  Future<FileAsset> createFileAsset(FileAsset file) async {
    final created = await FileRepository.create(file);
    if (!fileOptions.any((option) => option.id == created.id)) {
      fileOptions.add(created);
    }
    return created;
  }

  Future<void> attachFile(PolicyFile entry) async {
    await PolicyRepository.attachFile(entry);
    await _reloadFiles();
  }

  Future<void> updateFileEntry(PolicyFile entry) async {
    await PolicyRepository.updateFile(entry);
    await _reloadFiles();
  }

  Future<void> detachFileEntry(int entryId) async {
    await PolicyRepository.detachFile(entryId);
    await _reloadFiles();
  }

  /// Creates the certificate and adds it to the options list; it is NOT
  /// attached to the policy — the caller does that with [attachCertificate].
  Future<Certificate> createCertificate(Certificate certificate) async {
    final created = await CertificateRepository.create(certificate);
    if (!certificateOptions.any((option) => option.id == created.id)) {
      certificateOptions.add(created);
    }
    return created;
  }

  Future<void> attachCertificate(PolicyCertificate entry) async {
    await PolicyRepository.attachCertificate(entry);
    await _reloadCertificates();
  }

  Future<void> updateCertificateEntry(PolicyCertificate entry) async {
    await PolicyRepository.updateCertificate(entry);
    await _reloadCertificates();
  }

  Future<void> detachCertificateEntry(int entryId) async {
    await PolicyRepository.detachCertificate(entryId);
    await _reloadCertificates();
  }

  Application? _application(int id) =>
      applications
          .firstWhereOrNull(
            (entry) => entry.applicationId == id && entry.application != null,
          )
          ?.application ??
      applicationOptions.firstWhereOrNull((option) => option.id == id);

  String applicationLabel(int id) {
    final application = _application(id);
    if (application == null) return '#$id';
    return application.appName.isNotEmpty ? application.appName : application.packageName;
  }

  String applicationPackage(int id) => _application(id)?.packageName ?? '';

  FileAsset? _file(int id) => fileOptions.firstWhereOrNull((file) => file.id == id);

  String fileLabel(int id) {
    final file = _file(id);
    return file == null ? '#$id' : file.customName ?? file.name;
  }

  String? filePublicUrl(int id) => _file(id)?.publicUrl;

  String certificateLabel(int id) =>
      certificateOptions.firstWhereOrNull((certificate) => certificate.id == id)?.name ?? '#$id';

  Future<List<RestrictionCatalogEntry>> restrictionCatalog() => RestrictionCatalogRepository.load();

  List<RestrictionCatalogEntry> get cachedRestrictionCatalog => RestrictionCatalogRepository.cached;
}
