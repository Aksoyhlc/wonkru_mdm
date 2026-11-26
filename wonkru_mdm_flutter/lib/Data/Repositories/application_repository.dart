import 'dart:typed_data';

import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../Client/serverpod_client.dart';

class ApplicationRepository {
  const ApplicationRepository._();

  static Future<ApplicationPage> list(ApplicationListRequest request) =>
      serverpodClient.adminApplication.listApplications(request);

  static Future<List<Application>> lookup() async {
    final applications = <Application>[];
    var nextPage = 1;
    while (true) {
      final page = await list(
        ApplicationListRequest(page: nextPage, perPage: 100, sortBy: 'appName'),
      );
      applications.addAll(page.items);
      if (page.items.isEmpty || applications.length >= page.total) {
        return applications;
      }
      nextPage = page.page + 1;
    }
  }

  /// CSV of every application matching the filter, not just the current page.
  static Future<ByteData> export(ApplicationListRequest request) =>
      serverpodClient.adminApplication.export(request);

  static Future<Application> get(int applicationId) =>
      serverpodClient.adminApplication.getApplication(applicationId);

  static Future<Application> create(Application application) =>
      serverpodClient.adminApplication.createApplication(application);

  static Future<Application> update(Application application) =>
      serverpodClient.adminApplication.updateApplication(application);

  static Future<void> delete(int applicationId) =>
      serverpodClient.adminApplication.deleteApplication(applicationId);

  static Future<int> deleteMany(List<int> applicationIds) =>
      serverpodClient.adminApplication.deleteApplications(applicationIds);

  static Future<ApplicationVersionPage> listVersions(
    int applicationId,
    AdminListRequest request,
  ) => serverpodClient.adminApplication.listVersions(applicationId, request);

  static Future<ApplicationVersion> getVersion(int versionId) =>
      serverpodClient.adminApplication.getVersion(versionId);

  static Future<ApplicationVersion> createVersion(
    ApplicationVersion version,
  ) => serverpodClient.adminApplication.createVersion(version);

  static Future<ApplicationVersion> updateVersion(
    ApplicationVersion version,
  ) => serverpodClient.adminApplication.updateVersion(version);

  static Future<void> deleteVersion(int versionId) =>
      serverpodClient.adminApplication.deleteVersion(versionId);
}
