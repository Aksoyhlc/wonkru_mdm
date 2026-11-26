import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:wonkru_core_server/wonkru_core_server.dart'
    show CertificateFormat, CertificateType;
import 'package:wonkru_mdm_server/src/generated/protocol.dart';
import 'package:wonkru_mdm_server/src/service/device_service.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given the admin write paths', (sessionBuilder, endpoints) {
    const adminUserId = '11111111-1111-4111-8111-111111111111';

    final adminBuilder = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        adminUserId,
        {Scope('admin')},
      ),
    );

    Future<void> createProfile() async {
      final session = sessionBuilder.build();
      await AdminProfile.db.insertRow(
        session,
        AdminProfile(
          userId: UuidValue.fromString(adminUserId),
          status: AdminAccountStatus.active,
        ),
      );
    }

    final previousCreatedAt = DateTime.utc(2020, 1, 1);
    final previousUpdatedAt = DateTime.utc(2020, 1, 2);

    // A client can send this back on update; the server must keep the stored
    // value so neither the panel nor an attacker can rewrite history.
    final tamperedCreatedAt = DateTime.utc(1999, 1, 1);

    group('policy', () {
      test('when a policy is created then both timestamps are set.', () async {
        await createProfile();

        final created = await endpoints.adminPolicy.create(
          adminBuilder,
          Policy(name: 'Timestamps'),
        );

        expect(created.createdAt, isNotNull);
        expect(created.updatedAt, isNotNull);
      });

      test(
        'when a policy is edited then only the update time moves.',
        () async {
          await createProfile();

          final created = await endpoints.adminPolicy.create(
            adminBuilder,
            Policy(name: 'Timestamps'),
          );

          final saved = await endpoints.adminPolicy.update(
            adminBuilder,
            created.copyWith(name: 'Renamed', createdAt: tamperedCreatedAt),
          );

          expect(saved.createdAt, created.createdAt);
          expect(saved.updatedAt!.isAfter(created.updatedAt!), isTrue);
        },
      );
    });

    group('application', () {
      test(
        'when an application is created then both timestamps are set.',
        () async {
          await createProfile();

          final created = await endpoints.adminApplication.createApplication(
            adminBuilder,
            Application(
              packageName: 'com.timestamps.app',
              appName: 'Timestamps',
            ),
          );

          expect(created.createdAt, isNotNull);
          expect(created.updatedAt, isNotNull);
        },
      );

      test(
        'when an application is edited then only the update time moves.',
        () async {
          await createProfile();

          final created = await endpoints.adminApplication.createApplication(
            adminBuilder,
            Application(
              packageName: 'com.timestamps.app',
              appName: 'Timestamps',
            ),
          );

          final saved = await endpoints.adminApplication.updateApplication(
            adminBuilder,
            created.copyWith(appName: 'Renamed', createdAt: tamperedCreatedAt),
          );

          expect(saved.createdAt, created.createdAt);
          expect(saved.updatedAt!.isAfter(created.updatedAt!), isTrue);
        },
      );

      test('when a version is created then both timestamps are set.', () async {
        await createProfile();

        final application = await endpoints.adminApplication.createApplication(
          adminBuilder,
          Application(
            packageName: 'com.timestamps.versioned',
            appName: 'Versioned',
          ),
        );

        final version = await endpoints.adminApplication.createVersion(
          adminBuilder,
          ApplicationVersion(
            applicationId: application.id!,
            versionName: '1.0.0',
            versionCode: 1,
            filePath: 'applications/app.apk',
            fileSizeBytes: 10,
          ),
        );

        expect(version.createdAt, isNotNull);
        expect(version.updatedAt, isNotNull);
      });
    });

    group('certificate', () {
      test(
        'when a certificate is created then both timestamps are set.',
        () async {
          await createProfile();

          final created = await endpoints.adminCertificate.create(
            adminBuilder,
            Certificate(
              name: 'Timestamps',
              certificateType: CertificateType.CA,
              certificateData: 'cert',
              format: CertificateFormat.PEM,
            ),
          );

          expect(created.createdAt, isNotNull);
          expect(created.updatedAt, isNotNull);
        },
      );

      test(
        'when a certificate is edited then only the update time moves.',
        () async {
          await createProfile();

          final created = await endpoints.adminCertificate.create(
            adminBuilder,
            Certificate(
              name: 'Timestamps',
              certificateType: CertificateType.CA,
              certificateData: 'cert',
              format: CertificateFormat.PEM,
            ),
          );

          final saved = await endpoints.adminCertificate.update(
            adminBuilder,
            created.copyWith(name: 'Renamed', createdAt: tamperedCreatedAt),
          );

          expect(saved.createdAt, created.createdAt);
          expect(saved.updatedAt!.isAfter(created.updatedAt!), isTrue);
        },
      );
    });

    group('device group', () {
      test('when a group is created then both timestamps are set.', () async {
        await createProfile();

        final created = await endpoints.adminDeviceGroup.create(
          adminBuilder,
          DeviceGroup(name: 'Timestamps'),
        );

        expect(created.createdAt, isNotNull);
        expect(created.updatedAt, isNotNull);
      });

      test('when a group is edited then only the update time moves.', () async {
        await createProfile();

        final created = await endpoints.adminDeviceGroup.create(
          adminBuilder,
          DeviceGroup(name: 'Timestamps'),
        );

        final saved = await endpoints.adminDeviceGroup.update(
          adminBuilder,
          created.copyWith(name: 'Renamed', createdAt: tamperedCreatedAt),
        );

        expect(saved.createdAt, created.createdAt);
        expect(saved.updatedAt!.isAfter(created.updatedAt!), isTrue);
      });
    });

    group('file group', () {
      test('when a group is created then both timestamps are set.', () async {
        await createProfile();

        final created = await endpoints.adminFileGroup.create(
          adminBuilder,
          FileGroup(name: 'Timestamps'),
        );

        expect(created.createdAt, isNotNull);
        expect(created.updatedAt, isNotNull);
      });

      test('when a group is edited then only the update time moves.', () async {
        await createProfile();

        final created = await endpoints.adminFileGroup.create(
          adminBuilder,
          FileGroup(name: 'Timestamps'),
        );

        final saved = await endpoints.adminFileGroup.update(
          adminBuilder,
          created.copyWith(name: 'Renamed', createdAt: tamperedCreatedAt),
        );

        expect(saved.createdAt, created.createdAt);
        expect(saved.updatedAt!.isAfter(created.updatedAt!), isTrue);
      });
    });

    group('file', () {
      test('when a file is created then both timestamps are set.', () async {
        await createProfile();

        final created = await endpoints.adminFile.create(
          adminBuilder,
          FileAsset(name: 'timestamps', filePath: 'files/x', sizeBytes: 1),
        );

        expect(created.createdAt, isNotNull);
        expect(created.updatedAt, isNotNull);
      });

      test('when a file is edited then only the update time moves.', () async {
        await createProfile();

        final created = await endpoints.adminFile.create(
          adminBuilder,
          FileAsset(name: 'timestamps', filePath: 'files/x', sizeBytes: 1),
        );

        final saved = await endpoints.adminFile.update(
          adminBuilder,
          created.copyWith(name: 'renamed', createdAt: tamperedCreatedAt),
        );

        expect(saved.createdAt, created.createdAt);
        expect(saved.updatedAt!.isAfter(created.updatedAt!), isTrue);
      });
    });

    group('device', () {
      test('when a device is saved for the first time then the creation time '
          'is filled in.', () async {
        final session = sessionBuilder.build();

        final device = Device(code: 'TS-1');
        await DeviceService.applySavingDefaults(session, device);

        expect(device.createdAt, isNotNull);
        expect(device.updatedAt, isNotNull);
      });

      test('when a stored device is saved again then its creation time is '
          'kept and the update time moves.', () async {
        final session = sessionBuilder.build();

        final stored = await Device.db.insertRow(
          session,
          Device(
            code: 'TS-2',
            uuid: 'ts-2',
            createdAt: previousCreatedAt,
            updatedAt: previousUpdatedAt,
          ),
        );

        await DeviceService.applySavingDefaults(session, stored);

        expect(stored.createdAt, previousCreatedAt);
        expect(stored.updatedAt!.isAfter(previousUpdatedAt), isTrue);
      });
    });
  });
}
