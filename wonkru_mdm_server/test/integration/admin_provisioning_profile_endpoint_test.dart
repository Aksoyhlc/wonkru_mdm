import 'dart:convert';
import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:wonkru_mdm_server/src/config/app_config.dart';
import 'package:wonkru_mdm_server/src/endpoints/admin/admin_provisioning_profile_endpoint.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';

import 'support/matchers.dart';
import 'package:wonkru_mdm_server/src/service/enrollment_key_service.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given AdminProvisioningProfileEndpoint', (
    sessionBuilder,
    endpoints,
  ) {
    const adminUserId = '11111111-1111-4111-8111-111111111111';
    const outsiderUserId = '22222222-2222-4222-8222-222222222222';

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

    ProvisioningProfile profile({
      int? id,
      String name = 'Factory reset',
      String config = '{"a":1}',
      bool isActive = true,
      UuidValue? createdById,
    }) {
      return ProvisioningProfile(
        id: id,
        name: name,
        config: config,
        isActive: isActive,
        createdById: createdById,
      );
    }

    group('list', () {
      test('when profiles exist then the requested page is returned in '
          'order.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final base = DateTime.now().toUtc();
        for (var index = 1; index <= 5; index++) {
          await ProvisioningProfile.db.insertRow(
            session,
            ProvisioningProfile(
              name: 'Profile $index',
              config: '{}',
              createdAt: base.add(Duration(seconds: index)),
            ),
          );
        }

        final page = await endpoints.adminProvisioningProfile.list(
          adminBuilder,
          AdminListRequest(page: 2, perPage: 2, sortBy: 'createdAt'),
        );

        expect(page.total, 5);
        expect(page.page, 2);
        expect(page.perPage, 2);
        expect(page.items.map((row) => row.name), [
          'Profile 3',
          'Profile 4',
        ]);
      });

      test('when a search is given then the name is matched.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        await ProvisioningProfile.db.insertRow(
          session,
          ProvisioningProfile(name: 'Warehouse tablets', config: '{}'),
        );
        await ProvisioningProfile.db.insertRow(
          session,
          ProvisioningProfile(name: 'Office phones', config: '{}'),
        );

        final page = await endpoints.adminProvisioningProfile.list(
          adminBuilder,
          AdminListRequest(search: 'Warehouse'),
        );

        expect(page.total, 1);
        expect(page.items.single.name, 'Warehouse tablets');
      });

      test('when perPage is above the maximum then it is clamped.', () async {
        await createProfile();

        final page = await endpoints.adminProvisioningProfile.list(
          adminBuilder,
          AdminListRequest(perPage: 100000),
        );

        expect(page.perPage, AdminProvisioningProfileEndpoint.maxPerPage);
      });
    });

    group('get', () {
      test('when the profile exists then it is returned.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final stored = await ProvisioningProfile.db.insertRow(
          session,
          ProvisioningProfile(name: 'Lookup', config: '{}'),
        );

        final fetched = await endpoints.adminProvisioningProfile.get(
          adminBuilder,
          stored.id!,
        );

        expect(fetched.name, 'Lookup');
      });

      test('when the profile does not exist then it is rejected.', () async {
        await createProfile();

        await expectLater(
          endpoints.adminProvisioningProfile.get(adminBuilder, 987654),
          throwsExceptionWith('Provisioning profile 987654 does not exist.'),
        );
      });
    });

    group('create', () {
      test('when a profile is created then it is owned by the signed in admin '
          'and stamped.', () async {
        await createProfile();

        final created = await endpoints.adminProvisioningProfile.create(
          adminBuilder,
          profile(id: 4242, createdById: null),
        );

        expect(created.id, isNot(4242));
        expect(
          created.createdById,
          UuidValue.fromString(adminUserId),
        );
        expect(created.createdAt, isNotNull);
        expect(created.updatedAt, isNotNull);
        expect(created.config, '{"a":1}');
      });

      test(
        'when the panel sends an author then the signed in admin wins.',
        () async {
          await createProfile();

          final created = await endpoints.adminProvisioningProfile.create(
            adminBuilder,
            profile(createdById: UuidValue.fromString(outsiderUserId)),
          );

          expect(created.createdById, UuidValue.fromString(adminUserId));
        },
      );
    });

    group('update', () {
      test('when a profile is edited then the form fields change and the '
          'author stays.', () async {
        await createProfile();

        final created = await endpoints.adminProvisioningProfile.create(
          adminBuilder,
          profile(),
        );

        final saved = await endpoints.adminProvisioningProfile.update(
          adminBuilder,
          created.copyWith(name: 'Renamed', config: '{"b":2}', isActive: false),
        );

        expect(saved.name, 'Renamed');
        expect(saved.config, '{"b":2}');
        expect(saved.isActive, isFalse);
        expect(saved.createdById, created.createdById);
        expect(saved.createdAt, created.createdAt);
      });

      test(
        'when the panel drops the author then the stored one is kept.',
        () async {
          await createProfile();

          final created = await endpoints.adminProvisioningProfile.create(
            adminBuilder,
            profile(),
          );

          final saved = await endpoints.adminProvisioningProfile.update(
            adminBuilder,
            created.copyWith(createdById: null),
          );

          expect(saved.createdById, UuidValue.fromString(adminUserId));
        },
      );

      test('when the profile does not exist then the update is '
          'rejected.', () async {
        await createProfile();

        await expectLater(
          endpoints.adminProvisioningProfile.update(
            adminBuilder,
            profile(id: 987654),
          ),
          throwsExceptionWith('Provisioning profile 987654 does not exist.'),
        );
      });
    });

    group('delete', () {
      test('when profiles are deleted then the rows go away.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final first = await ProvisioningProfile.db.insertRow(
          session,
          ProvisioningProfile(name: 'First', config: '{}'),
        );
        final second = await ProvisioningProfile.db.insertRow(
          session,
          ProvisioningProfile(name: 'Second', config: '{}'),
        );

        final deleted = await endpoints.adminProvisioningProfile.delete(
          adminBuilder,
          [first.id!, second.id!],
        );

        expect(deleted, 2);
        expect(
          await ProvisioningProfile.db.findById(session, first.id!),
          isNull,
        );
      });

      test('when no profile is given then nothing is deleted.', () async {
        await createProfile();

        expect(
          await endpoints.adminProvisioningProfile.delete(adminBuilder, []),
          0,
        );
      });
    });

    group('defaultConfig', () {
      test('when the panel asks for a starting document then it matches the '
          'Android provisioning contract.', () async {
        await createProfile();

        final raw = await endpoints.adminProvisioningProfile.defaultConfig(
          adminBuilder,
        );
        final config = jsonDecode(raw) as Map<String, dynamic>;

        // Deliberately literal: comparing against the service constants would
        // replicate a typo in the constant into the test. The component name is
        // the agent's `applicationId` plus the receiver in the manifest.
        expect(
          config.keys,
          unorderedEquals([
            'android.app.extra.PROVISIONING_DEVICE_ADMIN_COMPONENT_NAME',
            'android.app.extra.PROVISIONING_DEVICE_ADMIN_SIGNATURE_CHECKSUM',
            'android.app.extra.PROVISIONING_DEVICE_ADMIN_PACKAGE_DOWNLOAD_LOCATION',
            'android.app.extra.PROVISIONING_TIME_ZONE',
            'android.app.extra.PROVISIONING_LOCALE',
            'android.app.extra.PROVISIONING_ORGANIZATION_NAME',
            'android.app.extra.PROVISIONING_ADMIN_EXTRAS_BUNDLE',
          ]),
        );
        expect(
          config['android.app.extra.PROVISIONING_DEVICE_ADMIN_COMPONENT_NAME'],
          'com.wonkrumdm/com.wonkrumdm.core.receivers.MdmDeviceAdminReceiver',
        );
        expect(
          config['android.app.extra.PROVISIONING_TIME_ZONE'],
          'Europe/Istanbul',
        );
        expect(config['android.app.extra.PROVISIONING_LOCALE'], 'tr_TR');

        // The device agent stores each bundle key verbatim and reads it back by
        // the same name; renaming one silently leaves the device unconfigured.
        final bundle =
            config['android.app.extra.PROVISIONING_ADMIN_EXTRAS_BUNDLE']
                as Map<String, dynamic>;
        expect(
          bundle.keys,
          unorderedEquals([
            'server_url',
            'policy_id',
            'group_id',
            'device_code',
            'enrollment_key',
          ]),
        );
        expect(bundle['server_url'], AppConfig.url);
        expect(bundle['policy_id'], isNull);
        expect(bundle['group_id'], isNull);
        expect(bundle['device_code'], matches(RegExp(r'^[A-Z0-9]+$')));
        expect(
          bundle['enrollment_key'],
          await EnrollmentKeyService.current(sessionBuilder.build()),
        );
      });

      test('when the mobile agent source is present then it still reads the '
          'bundle keys the server writes.', () {
        final agent = Directory('../wonkru_mdm_mobil');
        if (!agent.existsSync()) {
          markTestSkipped('mobile agent source is not in this workspace');
          return;
        }

        final manifest = File(
          '${agent.path}/android/app/src/main/AndroidManifest.xml',
        ).readAsStringSync();
        expect(
          manifest,
          contains('com.wonkrumdm.core.receivers.MdmDeviceAdminReceiver'),
        );

        final storageKeys = File(
          '${agent.path}/lib/Core/Constants/Enums/storage_keys.dart',
        ).readAsStringSync();
        for (final key in ['server_url', 'device_code']) {
          expect(
            RegExp('^\\s+$key,', multiLine: true).hasMatch(storageKeys),
            isTrue,
            reason: 'agent does not read the `Sk.$key` key',
          );
        }
      });

      test('when the document is asked for twice then the device code '
          'differs.', () async {
        await createProfile();

        final first =
            jsonDecode(
                  await endpoints.adminProvisioningProfile.defaultConfig(
                    adminBuilder,
                  ),
                )
                as Map<String, dynamic>;
        final second =
            jsonDecode(
                  await endpoints.adminProvisioningProfile.defaultConfig(
                    adminBuilder,
                  ),
                )
                as Map<String, dynamic>;

        String codeOf(Map<String, dynamic> config) =>
            (config['android.app.extra.PROVISIONING_ADMIN_EXTRAS_BUNDLE']
                    as Map<String, dynamic>)['device_code']
                as String;

        expect(codeOf(first), isNot(codeOf(second)));
      });
    });
  });
}
