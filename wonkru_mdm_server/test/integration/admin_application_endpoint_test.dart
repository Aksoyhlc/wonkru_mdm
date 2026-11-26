import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:wonkru_core_server/wonkru_core_server.dart'
    show PolicyApplicationAction;
import 'package:wonkru_mdm_server/src/endpoints/admin/admin_application_endpoint.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';

import '../support/apk_fixtures.dart';
import 'support/matchers.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given AdminApplicationEndpoint', (
    sessionBuilder,
    endpoints,
  ) {
    const adminUserId = '44444444-4444-4444-8444-444444444444';

    final adminBuilder = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        adminUserId,
        {Scope('admin')},
      ),
    );

    Future<void> createAdminProfile() async {
      final session = sessionBuilder.build();
      await AdminProfile.db.insertRow(
        session,
        AdminProfile(
          userId: UuidValue.fromString(adminUserId),
          status: AdminAccountStatus.active,
        ),
      );
    }

    Future<Application> createApplication(
      String packageName, {
      String? appName,
    }) async {
      final session = sessionBuilder.build();
      return Application.db.insertRow(
        session,
        Application(packageName: packageName, appName: appName ?? packageName),
      );
    }

    Future<Policy> createPolicy(String name, {int version = 1}) async {
      final session = sessionBuilder.build();
      return Policy.db.insertRow(
        session,
        Policy(name: name, version: version),
      );
    }

    Future<ApplicationVersion> createVersion(
      Application application, {
      required String name,
      required int code,
      bool isDefault = false,
    }) async {
      final session = sessionBuilder.build();
      return ApplicationVersion.db.insertRow(
        session,
        ApplicationVersion(
          applicationId: application.id!,
          versionName: name,
          versionCode: code,
          isDefault: isDefault,
        ),
      );
    }

    AdminApplicationVersionUploadRequest uploadRequest({
      required int applicationId,
      required int versionCode,
      String versionName = '1.0.0',
      String fileName = 'release.apk',
      String body = 'apk payload',
      Uint8List? apkBytes,
      Map<String, String>? permissions,
      int? minSdkVersion,
      int? targetSdkVersion,
    }) {
      return AdminApplicationVersionUploadRequest(
        applicationId: applicationId,
        fileName: fileName,
        byteData: ByteData.sublistView(
          apkBytes ?? Uint8List.fromList(utf8.encode(body)),
        ),
        versionName: versionName,
        versionCode: versionCode,
        permissions: permissions,
        minSdkVersion: minSdkVersion,
        targetSdkVersion: targetSdkVersion,
      );
    }

    Future<String> storeApk(
      Uint8List bytes, {
      String name = 'stored.apk',
    }) async {
      final session = sessionBuilder.build();
      final path = 'applications/$name';
      await session.storage.storeFile(
        storageId: 'public',
        path: path,
        byteData: ByteData.sublistView(bytes),
      );
      return path;
    }

    group('applications', () {
      test('when applications exist then the requested page is '
          'returned.', () async {
        await createAdminProfile();
        for (final name in ['com.a', 'com.b', 'com.c']) {
          await createApplication(name);
        }

        final page = await endpoints.adminApplication.listApplications(
          adminBuilder,
          ApplicationListRequest(
            page: 2,
            perPage: 2,
            sortBy: 'packageName',
          ),
        );

        expect(page.total, 3);
        expect(page.page, 2);
        expect(page.perPage, 2);
        expect(page.items.map((item) => item.packageName), ['com.c']);
      });

      Future<List<String>> searchPackages(String search) async {
        final page = await endpoints.adminApplication.listApplications(
          adminBuilder,
          ApplicationListRequest(search: search),
        );
        return page.items.map((item) => item.packageName).toList();
      }

      test('when a search is given then the package name and the app name are '
          'each matched on their own.', () async {
        await createAdminProfile();
        // Package name and app name deliberately differ so a dropped match
        // would show up as an empty result.
        await createApplication('com.vendor.pos', appName: 'Kasa');
        await createApplication('com.vendor.kiosk', appName: 'Vitrin');

        expect(await searchPackages('kasa'), ['com.vendor.pos']);
        expect(await searchPackages('KIOSK'), ['com.vendor.kiosk']);
        expect(await searchPackages('yok-boyle'), isEmpty);
      });

      test('when the search contains LIKE wildcards then they are matched '
          'literally.', () async {
        await createAdminProfile();
        await createApplication('com.a_b.app');
        await createApplication('com.axb.app');
        await createApplication('com.yuzde100%.app');

        expect(await searchPackages('a_b'), ['com.a_b.app']);
        expect(await searchPackages('%'), ['com.yuzde100%.app']);
        expect(await searchPackages(r'\'), isEmpty);
      });

      test('when an application is created then an id is '
          'assigned.', () async {
        await createAdminProfile();

        final created = await endpoints.adminApplication.createApplication(
          adminBuilder,
          Application(packageName: 'com.example.new', appName: 'New'),
        );

        expect(created.id, isNotNull);
        expect(created.packageName, 'com.example.new');
      });

      test('when the package name is already used then a conflict carrying '
          'the existing application is returned.', () async {
        await createAdminProfile();
        final existing = await createApplication('com.example.dupe');

        await expectLater(
          endpoints.adminApplication.createApplication(
            adminBuilder,
            Application(packageName: 'com.example.dupe', appName: 'Dupe'),
          ),
          throwsA(
            isA<ApplicationConflictException>().having(
              (e) => e.existingApplication?.id,
              'existingApplication.id',
              existing.id,
            ),
          ),
        );
      });

      test('when an application changes then every policy referencing it is '
          'bumped.', () async {
        await createAdminProfile();
        final application = await createApplication('com.example.used');
        final policy = await createPolicy('Uses app', version: 5);

        final session = sessionBuilder.build();
        await PolicyApplication.db.insertRow(
          session,
          PolicyApplication(
            policyId: policy.id!,
            applicationId: application.id!,
            action: PolicyApplicationAction.install,
          ),
        );
        final untouched = await createPolicy('Untouched', version: 5);

        await endpoints.adminApplication.updateApplication(
          adminBuilder,
          application.copyWith(appName: 'Renamed'),
        );

        expect((await Policy.db.findById(session, policy.id!))!.version, 6);
        expect((await Policy.db.findById(session, untouched.id!))!.version, 5);
      });

      test('when the application does not exist then the update is '
          'rejected.', () async {
        await createAdminProfile();

        await expectLater(
          endpoints.adminApplication.updateApplication(
            adminBuilder,
            Application(id: 424242, packageName: 'com.ghost', appName: 'Ghost'),
          ),
          throwsExceptionWith('Application 424242 does not exist.'),
        );
      });

      test('when an application is deleted then its policy entries go with it '
          'and the policies are bumped.', () async {
        await createAdminProfile();
        final application = await createApplication('com.example.doomed');
        final policy = await createPolicy('Loses app', version: 2);

        final session = sessionBuilder.build();
        final entry = await PolicyApplication.db.insertRow(
          session,
          PolicyApplication(
            policyId: policy.id!,
            applicationId: application.id!,
            action: PolicyApplicationAction.install,
          ),
        );

        await endpoints.adminApplication.deleteApplication(
          adminBuilder,
          application.id!,
        );

        expect(await Application.db.findById(session, application.id!), isNull);
        expect(await PolicyApplication.db.findById(session, entry.id!), isNull);
        expect((await Policy.db.findById(session, policy.id!))!.version, 3);
      });

      test('when filters are given then only the matching applications are '
          'returned.', () async {
        await createAdminProfile();
        final session = sessionBuilder.build();
        await Application.db.insertRow(
          session,
          Application(
            packageName: 'com.play',
            appName: 'Play One',
            sourceType: AppSourceType.play_store,
            category: 'tools',
          ),
        );
        await Application.db.insertRow(
          session,
          Application(
            packageName: 'com.apk',
            appName: 'Apk One',
            sourceType: AppSourceType.apk,
            category: 'games',
            isSystemApp: true,
          ),
        );

        final bySource = await endpoints.adminApplication.listApplications(
          adminBuilder,
          ApplicationListRequest(sourceType: 'play_store'),
        );
        expect(bySource.total, 1);
        expect(bySource.items.single.packageName, 'com.play');

        final byCategory = await endpoints.adminApplication.listApplications(
          adminBuilder,
          ApplicationListRequest(category: 'games'),
        );
        expect(byCategory.total, 1);
        expect(byCategory.items.single.packageName, 'com.apk');

        final systemOnly = await endpoints.adminApplication.listApplications(
          adminBuilder,
          ApplicationListRequest(isSystemApp: true),
        );
        expect(systemOnly.total, 1);
        expect(systemOnly.items.single.packageName, 'com.apk');

        final userOnly = await endpoints.adminApplication.listApplications(
          adminBuilder,
          ApplicationListRequest(isSystemApp: false),
        );
        expect(userOnly.total, 1);
        expect(userOnly.items.single.packageName, 'com.play');
      });

      test('when several applications are deleted then all of them and their '
          'policy entries go.', () async {
        await createAdminProfile();
        final first = await createApplication('com.bulk.a');
        final second = await createApplication('com.bulk.b');
        final untouched = await createApplication('com.bulk.c');
        final policy = await createPolicy('Bulk delete', version: 4);

        final session = sessionBuilder.build();
        await PolicyApplication.db.insertRow(
          session,
          PolicyApplication(
            policyId: policy.id!,
            applicationId: first.id!,
            action: PolicyApplicationAction.install,
          ),
        );

        final deleted = await endpoints.adminApplication.deleteApplications(
          adminBuilder,
          [first.id!, second.id!, second.id!],
        );

        expect(deleted, 2);
        expect(await Application.db.findById(session, first.id!), isNull);
        expect(await Application.db.findById(session, second.id!), isNull);
        expect(
          await Application.db.findById(session, untouched.id!),
          isNotNull,
        );
        expect(
          await PolicyApplication.db.count(
            session,
            where: (t) => t.applicationId.equals(first.id!),
          ),
          0,
        );
        expect((await Policy.db.findById(session, policy.id!))!.version, 5);
      });

      test('when the list is exported then the CSV holds the header and the '
          'matching rows.', () async {
        await createAdminProfile();
        final session = sessionBuilder.build();
        await Application.db.insertRow(
          session,
          Application(
            packageName: 'com.export',
            appName: 'Export',
            developerName: 'Dev',
            category: 'tools',
            sourceType: AppSourceType.apk,
          ),
        );

        final data = await endpoints.adminApplication.export(
          adminBuilder,
          ApplicationListRequest(),
        );
        final csv = utf8.decode(
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
        );

        expect(
          csv.split('\n').first,
          'id,packageName,appName,developerName,category,sourceType,isSystemApp',
        );
        expect(csv, contains('com.export'));
        expect(csv, contains('Export'));
      });
    });

    group('versions', () {
      test('when the first version is created then it becomes the '
          'default.', () async {
        await createAdminProfile();
        final application = await createApplication('com.example.first');

        final created = await endpoints.adminApplication.createVersion(
          adminBuilder,
          ApplicationVersion(
            applicationId: application.id!,
            versionName: '1.0.0',
            versionCode: 1,
          ),
        );

        expect(created.isDefault, isTrue);
      });

      test('when the version code already exists then a conflict is '
          'returned.', () async {
        await createAdminProfile();
        final application = await createApplication('com.example.dupcode');
        await createVersion(application, name: '1.0.0', code: 1);

        await expectLater(
          endpoints.adminApplication.createVersion(
            adminBuilder,
            ApplicationVersion(
              applicationId: application.id!,
              versionName: '1.0.1',
              versionCode: 1,
            ),
          ),
          throwsA(
            isA<ApplicationConflictException>().having(
              (e) => e.existingApplication,
              'existingApplication',
              isNull,
            ),
          ),
        );
      });

      test('when a later version is created without asking for the default '
          'then it stays out of the way.', () async {
        await createAdminProfile();
        final application = await createApplication('com.example.second');
        await createVersion(
          application,
          name: '1.0.0',
          code: 1,
          isDefault: true,
        );

        final created = await endpoints.adminApplication.createVersion(
          adminBuilder,
          ApplicationVersion(
            applicationId: application.id!,
            versionName: '2.0.0',
            versionCode: 2,
          ),
        );

        expect(created.isDefault, isFalse);
      });

      test('when a version is created as the default then the previous one '
          'steps down.', () async {
        await createAdminProfile();
        final application = await createApplication('com.example.promote');
        final previous = await createVersion(
          application,
          name: '1.0.0',
          code: 1,
          isDefault: true,
        );

        final created = await endpoints.adminApplication.createVersion(
          adminBuilder,
          ApplicationVersion(
            applicationId: application.id!,
            versionName: '2.0.0',
            versionCode: 2,
            isDefault: true,
          ),
        );

        final session = sessionBuilder.build();
        expect(created.isDefault, isTrue);
        expect(
          (await ApplicationVersion.db.findById(
            session,
            previous.id!,
          ))!.isDefault,
          isFalse,
        );
      });

      test('when the default version is retired then the newest remaining '
          'version takes over.', () async {
        await createAdminProfile();
        final application = await createApplication('com.example.retire');
        final retired = await createVersion(
          application,
          name: '1.0.0',
          code: 1,
          isDefault: true,
        );
        final promoted = await createVersion(
          application,
          name: '2.0.0',
          code: 2,
        );

        await endpoints.adminApplication.updateVersion(
          adminBuilder,
          retired.copyWith(isDefault: false),
        );

        final session = sessionBuilder.build();
        expect(
          (await ApplicationVersion.db.findById(
            session,
            retired.id!,
          ))!.isDefault,
          isFalse,
        );
        expect(
          (await ApplicationVersion.db.findById(
            session,
            promoted.id!,
          ))!.isDefault,
          isTrue,
        );
      });

      test('when a version is deleted then the entries pinning it are '
          'unpinned and the policy is bumped.', () async {
        await createAdminProfile();
        final application = await createApplication('com.example.pinned');
        final version = await createVersion(
          application,
          name: '1.0.0',
          code: 1,
        );
        final policy = await createPolicy('Pins version', version: 7);

        final session = sessionBuilder.build();
        final entry = await PolicyApplication.db.insertRow(
          session,
          PolicyApplication(
            policyId: policy.id!,
            applicationId: application.id!,
            targetVersionId: version.id!,
            action: PolicyApplicationAction.install,
          ),
        );

        await endpoints.adminApplication.deleteVersion(
          adminBuilder,
          version.id!,
        );

        expect(
          await ApplicationVersion.db.findById(session, version.id!),
          isNull,
        );
        expect(
          (await PolicyApplication.db.findById(
            session,
            entry.id!,
          ))!.targetVersionId,
          isNull,
        );
        expect((await Policy.db.findById(session, policy.id!))!.version, 8);
      });

      test('when versions are listed then only those of the application are '
          'returned.', () async {
        await createAdminProfile();
        final application = await createApplication('com.example.scoped');
        final other = await createApplication('com.example.other');
        await createVersion(application, name: '1.0.0', code: 1);
        await createVersion(application, name: '2.0.0', code: 2);
        await createVersion(other, name: '9.0.0', code: 9);

        final page = await endpoints.adminApplication.listVersions(
          adminBuilder,
          application.id!,
          AdminListRequest(sortBy: 'versionCode'),
        );

        expect(page.total, 2);
        expect(page.items.map((item) => item.versionCode), [1, 2]);
      });

      test('when the stored APK is for another package then the version is '
          'rejected.', () async {
        await createAdminProfile();
        final application = await createApplication('com.x.y');
        final path = await storeApk(minimalApk(packageName: 'com.a.b'));

        await expectLater(
          endpoints.adminApplication.createVersion(
            adminBuilder,
            ApplicationVersion(
              applicationId: application.id!,
              versionName: '1.0.0',
              versionCode: 1,
              filePath: path,
            ),
          ),
          throwsExceptionWith(
            'The uploaded APK is for "com.a.b", but this application is '
            '"com.x.y".',
          ),
        );
      });

      test('when the stored APK is for the same package then the version is '
          'created.', () async {
        await createAdminProfile();
        final application = await createApplication('com.x.y');
        final path = await storeApk(minimalApk(packageName: 'com.x.y'));

        final created = await endpoints.adminApplication.createVersion(
          adminBuilder,
          ApplicationVersion(
            applicationId: application.id!,
            versionName: '1.0.0',
            versionCode: 1,
            filePath: path,
          ),
        );

        expect(created.id, isNotNull);
        expect(created.filePath, path);
      });

      test('when the stored file is not a readable APK then the version is '
          'created.', () async {
        await createAdminProfile();
        final application = await createApplication('com.x.y');
        final path = await storeApk(
          Uint8List.fromList(utf8.encode('not an apk')),
        );

        final created = await endpoints.adminApplication.createVersion(
          adminBuilder,
          ApplicationVersion(
            applicationId: application.id!,
            versionName: '1.0.0',
            versionCode: 1,
            filePath: path,
          ),
        );

        expect(created.id, isNotNull);
      });
    });

    group('upload', () {
      test('when an APK is uploaded then it is stored and the first version '
          'becomes the default.', () async {
        await createAdminProfile();
        final application = await createApplication('com.example.upload');
        const body = 'apk payload';

        final uploaded = await endpoints.adminApplication.uploadVersion(
          adminBuilder,
          uploadRequest(
            applicationId: application.id!,
            versionCode: 12,
            versionName: '3.4.5',
            permissions: {'CAMERA': 'allow', 'LOCATION': 'ask'},
            minSdkVersion: 24,
            targetSdkVersion: 34,
          ),
        );

        expect(uploaded.id, isNotNull);
        expect(uploaded.isDefault, isTrue);
        expect(uploaded.versionCode, 12);
        expect(uploaded.minSdkVersion, 24);
        expect(uploaded.targetSdkVersion, 34);
        expect(uploaded.fileSizeBytes, utf8.encode(body).length);
        expect(
          uploaded.checksumSha256,
          sha256.convert(utf8.encode(body)).toString(),
        );
        expect(uploaded.filePath, startsWith('applications/'));
        expect(uploaded.filePath, endsWith('.apk'));
        expect(jsonDecode(uploaded.permissions!), {
          'CAMERA': 'allow',
          'LOCATION': 'ask',
        });

        final session = sessionBuilder.build();
        final stored = await session.storage.retrieveFile(
          storageId: 'public',
          path: uploaded.filePath!,
        );
        expect(
          utf8.decode(
            stored.buffer.asUint8List(
              stored.offsetInBytes,
              stored.lengthInBytes,
            ),
          ),
          body,
        );
      });

      test('when the same version code is uploaded again then the existing '
          'version is replaced.', () async {
        await createAdminProfile();
        final application = await createApplication('com.example.upsert');

        final first = await endpoints.adminApplication.uploadVersion(
          adminBuilder,
          uploadRequest(
            applicationId: application.id!,
            versionCode: 5,
            body: 'first build',
          ),
        );

        final second = await endpoints.adminApplication.uploadVersion(
          adminBuilder,
          uploadRequest(
            applicationId: application.id!,
            versionCode: 5,
            versionName: '1.0.1',
            body: 'second build',
          ),
        );

        final session = sessionBuilder.build();
        expect(second.id, first.id);
        expect(second.versionName, '1.0.1');
        expect(second.filePath, isNot(first.filePath));
        expect(second.fileSizeBytes, utf8.encode('second build').length);
        expect(await ApplicationVersion.db.count(session), 1);
      });

      test('when the uploaded APK is for another package then it is '
          'rejected.', () async {
        await createAdminProfile();
        final application = await createApplication('com.x.y');

        await expectLater(
          endpoints.adminApplication.uploadVersion(
            adminBuilder,
            uploadRequest(
              applicationId: application.id!,
              versionCode: 1,
              apkBytes: minimalApk(packageName: 'com.a.b'),
            ),
          ),
          throwsExceptionWith(
            'The uploaded APK is for "com.a.b", but this application is '
            '"com.x.y".',
          ),
        );
      });

      test('when the uploaded APK is for the same package then it is '
          'accepted.', () async {
        await createAdminProfile();
        final application = await createApplication('com.x.y');

        final uploaded = await endpoints.adminApplication.uploadVersion(
          adminBuilder,
          uploadRequest(
            applicationId: application.id!,
            versionCode: 1,
            apkBytes: minimalApk(packageName: 'com.x.y'),
          ),
        );

        expect(uploaded.id, isNotNull);
        expect(uploaded.filePath, startsWith('applications/'));
      });

      test('when the application does not exist then the upload is '
          'rejected.', () async {
        await createAdminProfile();

        await expectLater(
          endpoints.adminApplication.uploadVersion(
            adminBuilder,
            uploadRequest(applicationId: 987654, versionCode: 1),
          ),
          throwsExceptionWith('Application 987654 does not exist.'),
        );
      });

      test('when perPage is above the maximum then it is clamped.', () async {
        await createAdminProfile();

        final page = await endpoints.adminApplication.listApplications(
          adminBuilder,
          ApplicationListRequest(perPage: 100000),
        );

        expect(page.perPage, AdminApplicationEndpoint.maxPerPage);
      });
    });
  });
}
