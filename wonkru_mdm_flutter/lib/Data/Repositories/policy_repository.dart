import 'dart:typed_data';

import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../Client/serverpod_client.dart';
import '../Models/list_query.dart';

class PolicyRepository {
  const PolicyRepository._();

  static Future<PolicyPage> list(PolicyListRequest request) =>
      serverpodClient.adminPolicy.list(request);

  /// CSV of every policy matching the filter, not just the current page.
  static Future<ByteData> export(PolicyListRequest request) =>
      serverpodClient.adminPolicy.export(request);

  /// Queues an `update_policy` command to devices using this policy.
  static Future<int> sendToDevices(int policyId) =>
      serverpodClient.adminPolicy.sendToDevices(policyId);

  static Future<Policy> get(int policyId) =>
      serverpodClient.adminPolicy.get(policyId);

  static Future<Policy> create(Policy policy) =>
      serverpodClient.adminPolicy.create(policy);

  static Future<Policy> update(Policy policy) =>
      serverpodClient.adminPolicy.update(policy);

  static Future<void> delete(int policyId) =>
      serverpodClient.adminPolicy.delete(policyId);

  static Future<Policy> duplicate(int policyId, {String? newName}) =>
      serverpodClient.adminPolicy.duplicate(policyId, newName: newName);

  /// Makes this the only default; clears the flag on the others.
  static Future<void> setDefault(int policyId) =>
      serverpodClient.adminPolicy.setDefault(policyId);

  static Future<String> preview(int policyId) =>
      serverpodClient.adminPolicy.preview(policyId);

  static Future<PolicyApplication> attachApplication(PolicyApplication entry) =>
      serverpodClient.adminPolicy.attachApplication(entry);

  static Future<PolicyApplication> updateApplication(PolicyApplication entry) =>
      serverpodClient.adminPolicy.updateApplication(entry);

  static Future<void> detachApplication(int entryId) =>
      serverpodClient.adminPolicy.detachApplication(entryId);

  static Future<void> reorderApplications(int policyId, List<int> entryIds) =>
      serverpodClient.adminPolicy.reorderApplications(policyId, entryIds);

  static Future<PolicyFile> attachFile(PolicyFile entry) =>
      serverpodClient.adminPolicy.attachFile(entry);

  static Future<PolicyFile> updateFile(PolicyFile entry) =>
      serverpodClient.adminPolicy.updateFile(entry);

  static Future<void> detachFile(int entryId) =>
      serverpodClient.adminPolicy.detachFile(entryId);

  static Future<PolicyCertificate> attachCertificate(PolicyCertificate entry) =>
      serverpodClient.adminPolicy.attachCertificate(entry);

  static Future<PolicyCertificate> updateCertificate(PolicyCertificate entry) =>
      serverpodClient.adminPolicy.updateCertificate(entry);

  static Future<void> detachCertificate(int entryId) =>
      serverpodClient.adminPolicy.detachCertificate(entryId);

  static Future<List<PolicyApplication>> applicationsForPolicy(int policyId) =>
      serverpodClient.adminPolicy.applications(policyId);

  static Future<List<PolicyFile>> filesForPolicy(int policyId) =>
      serverpodClient.adminPolicy.files(policyId);

  static Future<List<PolicyCertificate>> certificatesForPolicy(int policyId) =>
      serverpodClient.adminPolicy.certificates(policyId);

  /// Loads all pages for the application picker and returns each app's total
  /// version count (`versionCounts`). 200 is only the request size.
  static Future<(List<Application>, Map<int, int>)> applications() async {
    final applications = <Application>[];
    final versionCounts = <int, int>{};
    var nextPage = 1;
    while (true) {
      final page = await serverpodClient.adminApplication.listApplications(
        ApplicationListRequest(page: nextPage, perPage: 200),
      );
      applications.addAll(page.items);
      versionCounts.addAll(page.versionCounts ?? const <int, int>{});
      if (page.items.isEmpty || page.page * page.perPage >= page.total) {
        return (applications, versionCounts);
      }
      nextPage = page.page + 1;
    }
  }

  static Future<List<Policy>> lookup({bool all = false}) async {
    final policies = <Policy>[];
    var nextPage = 1;
    while (true) {
      final page = await list(
        PolicyListRequest(page: nextPage, perPage: lookupPageSize),
      );
      policies.addAll(page.items);
      if (!all ||
          page.items.isEmpty ||
          page.page * page.perPage >= page.total) {
        return policies;
      }
      nextPage = page.page + 1;
    }
  }
}
