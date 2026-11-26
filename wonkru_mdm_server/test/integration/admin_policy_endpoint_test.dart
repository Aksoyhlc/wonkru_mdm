import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:wonkru_core_server/wonkru_core_server.dart'
    show FileOperationType, PolicyApplicationAction;
import 'package:wonkru_mdm_server/src/endpoints/admin/admin_policy_endpoint.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';
import 'package:wonkru_mdm_server/src/service/setting_service.dart';
import 'package:wonkru_mdm_server/src/util/password_hasher.dart';

import 'support/matchers.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given AdminPolicyEndpoint', (sessionBuilder, endpoints) {
    const adminUserId = '11111111-1111-4111-8111-111111111111';
    const outsiderUserId = '22222222-2222-4222-8222-222222222222';

    final adminBuilder = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        adminUserId,
        {Scope('admin')},
      ),
    );

    final outsiderBuilder = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        outsiderUserId,
        {Scope('admin')},
      ),
    );

    // Password hashing requires a pepper; tests use a fixed one instead of
    // touching the environment variable.
    setUp(() {
      PasswordHasher.debugPepper = 'test-pepper';
    });

    tearDown(() {
      PasswordHasher.debugPepper = null;
    });

    Future<void> createProfile(
      String userId, {
      AdminAccountStatus status = AdminAccountStatus.active,
    }) async {
      final session = sessionBuilder.build();
      await AdminProfile.db.insertRow(
        session,
        AdminProfile(
          userId: UuidValue.fromString(userId),
          status: status,
        ),
      );
    }

    group('attachFile validation', () {
      test(
        'when destination path is relative then it is rejected.',
        () async {
          await createProfile(adminUserId);
          final session = sessionBuilder.build();
          final policy = await Policy.db.insertRow(
            session,
            Policy(name: 'Relative path policy'),
          );

          await expectLater(
            endpoints.adminPolicy.attachFile(
              adminBuilder,
              PolicyFile(
                policyId: policy.id!,
                usageType: FileOperationType.delete,
                destinationPath: 'bvc',
              ),
            ),
            throwsExceptionWith('absolute'),
          );
        },
      );
    });

    group('list', () {
      test(
        'when policies exist then the requested page is returned in order.',
        () async {
          await createProfile(adminUserId);

          final session = sessionBuilder.build();
          for (var index = 1; index <= 5; index++) {
            await Policy.db.insertRow(
              session,
              Policy(name: 'Policy $index', slug: 'policy-$index'),
            );
          }

          final page = await endpoints.adminPolicy.list(
            adminBuilder,
            PolicyListRequest(page: 2, perPage: 2, sortBy: 'name'),
          );

          expect(page.total, 5);
          expect(page.page, 2);
          expect(page.perPage, 2);
          expect(page.items.map((policy) => policy.name), [
            'Policy 3',
            'Policy 4',
          ]);
        },
      );

      test('when a search is given then only matching policies are '
          'returned.', () async {
        await createProfile(adminUserId);

        final session = sessionBuilder.build();
        await Policy.db.insertRow(session, Policy(name: 'Alpha fleet'));
        await Policy.db.insertRow(session, Policy(name: 'Beta fleet'));

        final page = await endpoints.adminPolicy.list(
          adminBuilder,
          PolicyListRequest(search: 'alpha'),
        );

        expect(page.total, 1);
        expect(page.items.single.name, 'Alpha fleet');
      });

      test('when perPage is above the maximum then it is clamped.', () async {
        await createProfile(adminUserId);

        final page = await endpoints.adminPolicy.list(
          adminBuilder,
          PolicyListRequest(perPage: 100000),
        );

        expect(page.perPage, AdminPolicyEndpoint.maxPerPage);
      });

      test('when the page is below one then the first page is '
          'returned.', () async {
        await createProfile(adminUserId);

        final page = await endpoints.adminPolicy.list(
          adminBuilder,
          PolicyListRequest(page: -5),
        );

        expect(page.page, 1);
      });

      test('when isActive is given then only matching policies are '
          'returned.', () async {
        await createProfile(adminUserId);

        final session = sessionBuilder.build();
        await Policy.db.insertRow(
          session,
          Policy(name: 'Active', isActive: true),
        );
        await Policy.db.insertRow(
          session,
          Policy(name: 'Inactive', isActive: false),
        );

        final page = await endpoints.adminPolicy.list(
          adminBuilder,
          PolicyListRequest(isActive: true),
        );

        expect(page.total, 1);
        expect(page.items.single.name, 'Active');
      });

      test('when defaultPolicy is given then only matching policies are '
          'returned.', () async {
        await createProfile(adminUserId);

        final session = sessionBuilder.build();
        await Policy.db.insertRow(
          session,
          Policy(name: 'Default', defaultPolicy: true),
        );
        await Policy.db.insertRow(session, Policy(name: 'Other'));

        final page = await endpoints.adminPolicy.list(
          adminBuilder,
          PolicyListRequest(defaultPolicy: false),
        );

        expect(page.total, 1);
        expect(page.items.single.name, 'Other');
      });
    });

    group('export', () {
      test('when policies match then every row is rendered as CSV.', () async {
        await createProfile(adminUserId);

        final session = sessionBuilder.build();
        final fleet = await Policy.db.insertRow(
          session,
          Policy(
            name: 'Fleet',
            slug: 'fleet',
            isActive: true,
            version: 3,
          ),
        );
        await Policy.db.insertRow(session, Policy(name: 'Other'));

        final data = await endpoints.adminPolicy.export(
          adminBuilder,
          PolicyListRequest(search: 'fleet'),
        );
        final csv = utf8.decode(
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
        );
        final lines = csv.trim().split('\n');

        expect(
          lines.first,
          'id,name,slug,is_active,default_policy,version,'
          'updated_at',
        );
        expect(lines, hasLength(2));
        expect(
          lines[1],
          startsWith('${fleet.id},Fleet,fleet,true,false,3,'),
        );
      });

      test('when the session is not authenticated then the export is '
          'rejected.', () async {
        await expectLater(
          endpoints.adminPolicy.export(sessionBuilder, PolicyListRequest()),
          throwsA(isA<ServerpodUnauthenticatedException>()),
        );
      });
    });

    group('sendToDevices', () {
      test('when devices use the policy then the count is returned.', () async {
        await createProfile(adminUserId);

        final session = sessionBuilder.build();
        final policy = await Policy.db.insertRow(
          session,
          Policy(name: 'Target'),
        );
        await Device.db.insertRow(
          session,
          Device(code: 'DEV-1', uuid: 'uuid-1', policyId: policy.id),
        );
        await Device.db.insertRow(
          session,
          Device(code: 'DEV-2', uuid: 'uuid-2', policyId: policy.id),
        );
        await Device.db.insertRow(
          session,
          Device(code: 'DEV-3', uuid: 'uuid-3'),
        );

        final count = await endpoints.adminPolicy.sendToDevices(
          adminBuilder,
          policy.id!,
        );

        expect(count, 2);
      });

      test(
        'when the policy does not exist then the send is rejected.',
        () async {
          await createProfile(adminUserId);

          await expectLater(
            endpoints.adminPolicy.sendToDevices(adminBuilder, 987654),
            throwsExceptionWith('Policy 987654 does not exist.'),
          );
        },
      );

      test('when the session is not authenticated then the send is '
          'rejected.', () async {
        await expectLater(
          endpoints.adminPolicy.sendToDevices(sessionBuilder, 1),
          throwsA(isA<ServerpodUnauthenticatedException>()),
        );
      });
    });

    group('create', () {
      test('when a policy is created then the version starts at one and the '
          'sync settings are normalized.', () async {
        await createProfile(adminUserId);

        final created = await endpoints.adminPolicy.create(
          adminBuilder,
          Policy(
            name: 'Fresh policy',
            syncSettings: '{"full_sync_cron":"0 3 * * *","unknown":1}',
          ),
        );

        expect(created.id, isNotNull);
        expect(created.version, 1);
        expect(
          created.syncSettings,
          '{"full_sync_cron":"0 3 * * *","max_interval_minutes":60}',
        );
      });

      test('when an admin password is sent then it is stored hashed and '
          'verifiable.', () async {
        await createProfile(adminUserId);

        final created = await endpoints.adminPolicy.create(
          adminBuilder,
          Policy(name: 'Locked', adminPassword: 'plain-secret'),
        );

        expect(created.adminPassword, isNotNull);
        expect(created.adminPassword, isNot('plain-secret'));
        expect(
          await PasswordHasher.verify(
            password: 'plain-secret',
            hash: created.adminPassword!,
          ),
          isTrue,
        );
      });

      test('when no admin password is sent then none is stored.', () async {
        await createProfile(adminUserId);

        final created = await endpoints.adminPolicy.create(
          adminBuilder,
          Policy(name: 'Open'),
        );

        expect(created.adminPassword, isNull);
      });
    });

    group('slug', () {
      test(
        'when no slug is given then one is generated from the name.',
        () async {
          await createProfile(adminUserId);

          final created = await endpoints.adminPolicy.create(
            adminBuilder,
            Policy(name: 'Company Policy'),
          );

          expect(created.slug, 'company-policy');
        },
      );

      test('when a slug is given then it is kept.', () async {
        await createProfile(adminUserId);

        final created = await endpoints.adminPolicy.create(
          adminBuilder,
          Policy(name: 'Custom', slug: 'my-slug'),
        );

        expect(created.slug, 'my-slug');
      });

      test('when two policies share a name then generated slugs '
          'differ.', () async {
        await createProfile(adminUserId);

        final first = await endpoints.adminPolicy.create(
          adminBuilder,
          Policy(name: 'Fleet'),
        );
        final second = await endpoints.adminPolicy.create(
          adminBuilder,
          Policy(name: 'Fleet'),
        );

        expect(first.slug, 'fleet');
        expect(second.slug, 'fleet-1');
      });

      test('when the slug is already used then create is rejected.', () async {
        await createProfile(adminUserId);
        final session = sessionBuilder.build();
        await Policy.db.insertRow(
          session,
          Policy(name: 'Taken', slug: 'taken'),
        );

        await expectLater(
          endpoints.adminPolicy.create(
            adminBuilder,
            Policy(name: 'Other', slug: 'taken'),
          ),
          throwsExceptionWith('Slug "taken" is already in use.'),
        );
      });

      test('when the list is searched then the slug matches too.', () async {
        await createProfile(adminUserId);
        final session = sessionBuilder.build();
        await Policy.db.insertRow(
          session,
          Policy(name: 'Alpha', slug: 'unique-slug'),
        );

        final page = await endpoints.adminPolicy.list(
          adminBuilder,
          PolicyListRequest(search: 'unique-slug'),
        );

        expect(page.total, 1);
        expect(page.items.single.slug, 'unique-slug');
      });

      test('when the update leaves the slug blank then the stored slug is '
          'kept.', () async {
        await createProfile(adminUserId);
        final session = sessionBuilder.build();
        final stored = await Policy.db.insertRow(
          session,
          Policy(name: 'Keep', slug: 'keep-me', version: 1),
        );

        final saved = await endpoints.adminPolicy.update(
          adminBuilder,
          stored.copyWith(slug: ''),
        );

        expect(saved.slug, 'keep-me');
      });
    });

    group('update', () {
      test('when only the version is sent then the stored version is '
          'kept.', () async {
        await createProfile(adminUserId);

        final session = sessionBuilder.build();
        final stored = await Policy.db.insertRow(
          session,
          Policy(name: 'Stable', version: 4),
        );

        final saved = await endpoints.adminPolicy.update(
          adminBuilder,
          stored.copyWith(version: 99),
        );

        expect(saved.version, 4);
      });

      test('when the content changes then the version is bumped.', () async {
        await createProfile(adminUserId);

        final session = sessionBuilder.build();
        final stored = await Policy.db.insertRow(
          session,
          Policy(name: 'Rename me', version: 4),
        );

        final saved = await endpoints.adminPolicy.update(
          adminBuilder,
          stored.copyWith(name: 'Renamed'),
        );

        expect(saved.version, 5);
      });

      test('when the stored hash is sent back then it is not hashed '
          'again.', () async {
        await createProfile(adminUserId);

        final session = sessionBuilder.build();
        final stored = await Policy.db.insertRow(
          session,
          Policy(
            name: 'Hashed',
            version: 1,
            adminPassword:
                r'$argon2id$v=19$m=65536,t=3,p=4$c2FsdHNhbHRzYWx0c2FsdA$Zm9vYmFyYmF6cXV1eA',
          ),
        );

        final saved = await endpoints.adminPolicy.update(
          adminBuilder,
          stored.copyWith(name: 'Renamed'),
        );

        expect(saved.adminPassword, stored.adminPassword);
        expect(saved.version, 2);
      });

      test('when the policy does not exist then the update is '
          'rejected.', () async {
        await createProfile(adminUserId);

        await expectLater(
          endpoints.adminPolicy.update(
            adminBuilder,
            Policy(id: 987654, name: 'Ghost', version: 1),
          ),
          throwsExceptionWith('Policy 987654 does not exist.'),
        );
      });
    });

    group('delete', () {
      test('when a policy is deleted then its entries are removed and its '
          'devices move to the default policy.', () async {
        await createProfile(adminUserId);

        final session = sessionBuilder.build();
        final fallback = await Policy.db.insertRow(
          session,
          Policy(name: 'Fallback'),
        );
        final doomed = await Policy.db.insertRow(
          session,
          Policy(name: 'Doomed'),
        );
        final application = await Application.db.insertRow(
          session,
          Application(packageName: 'com.example.app', appName: 'Example'),
        );

        await SettingService.save(
          session,
          SettingService.defaultPolicyKey,
          '${fallback.id}',
        );
        await PolicyApplication.db.insertRow(
          session,
          PolicyApplication(
            policyId: doomed.id!,
            applicationId: application.id!,
            action: PolicyApplicationAction.install,
          ),
        );
        final device = await Device.db.insertRow(
          session,
          Device(code: 'DEV-DELETE', uuid: 'uuid-delete', policyId: doomed.id),
        );

        await endpoints.adminPolicy.delete(adminBuilder, doomed.id!);

        expect(await Policy.db.findById(session, doomed.id!), isNull);
        expect(
          await PolicyApplication.db.find(
            session,
            where: (t) => t.policyId.equals(doomed.id!),
          ),
          isEmpty,
        );

        final reloaded = await Device.db.findById(session, device.id!);
        expect(reloaded!.policyId, fallback.id);
      });

      test('when the default policy itself is deleted then its devices lose '
          'their policy.', () async {
        await createProfile(adminUserId);

        final session = sessionBuilder.build();
        final doomed = await Policy.db.insertRow(
          session,
          Policy(name: 'Default', defaultPolicy: true),
        );

        await SettingService.save(
          session,
          SettingService.defaultPolicyKey,
          '${doomed.id}',
        );
        final device = await Device.db.insertRow(
          session,
          Device(code: 'DEV-ORPHAN', uuid: 'uuid-orphan', policyId: doomed.id),
        );

        await endpoints.adminPolicy.delete(adminBuilder, doomed.id!);

        final reloaded = await Device.db.findById(session, device.id!);
        expect(reloaded!.policyId, isNull);
      });
    });

    group('setDefault', () {
      test('when a policy is made default then the flag moves and the setting '
          'is persisted.', () async {
        await createProfile(adminUserId);

        final session = sessionBuilder.build();
        final first = await Policy.db.insertRow(
          session,
          Policy(name: 'First', defaultPolicy: true),
        );
        final second = await Policy.db.insertRow(
          session,
          Policy(name: 'Second'),
        );
        await SettingService.save(
          session,
          SettingService.defaultPolicyKey,
          '${first.id}',
        );

        await endpoints.adminPolicy.setDefault(adminBuilder, second.id!);

        expect(
          (await Policy.db.findById(session, first.id!))!.defaultPolicy,
          isFalse,
        );
        expect(
          (await Policy.db.findById(session, second.id!))!.defaultPolicy,
          isTrue,
        );
        expect(
          await SettingService.getInt(
            session,
            SettingService.defaultPolicyKey,
          ),
          second.id,
        );
      });

      test('when the user is not an admin then setting the default is '
          'rejected.', () async {
        final session = sessionBuilder.build();
        final policy = await Policy.db.insertRow(
          session,
          Policy(name: 'Target'),
        );

        await expectLater(
          endpoints.adminPolicy.setDefault(outsiderBuilder, policy.id!),
          throwsA(isA<ServerpodInsufficientAccessException>()),
        );
      });
    });

    group('application entries', () {
      test(
        'when an application is attached then the sort order is assigned and '
        'the policy version is bumped.',
        () async {
          await createProfile(adminUserId);

          final session = sessionBuilder.build();
          final policy = await Policy.db.insertRow(
            session,
            Policy(name: 'Target', version: 3),
          );
          final application = await Application.db.insertRow(
            session,
            Application(
              packageName: 'com.example.attached',
              appName: 'Attached',
            ),
          );

          final attached = await endpoints.adminPolicy.attachApplication(
            adminBuilder,
            PolicyApplication(
              policyId: policy.id!,
              applicationId: application.id!,
              action: PolicyApplicationAction.install,
            ),
          );

          expect(attached.sort, 1);

          final reloaded = await Policy.db.findById(session, policy.id!);
          expect(reloaded!.version, 4);
        },
      );

      test('when an application is detached then the policy version is '
          'bumped.', () async {
        await createProfile(adminUserId);

        final session = sessionBuilder.build();
        final policy = await Policy.db.insertRow(
          session,
          Policy(name: 'Target', version: 3),
        );
        final application = await Application.db.insertRow(
          session,
          Application(packageName: 'com.example.detached', appName: 'Detached'),
        );
        final entry = await PolicyApplication.db.insertRow(
          session,
          PolicyApplication(
            policyId: policy.id!,
            applicationId: application.id!,
            action: PolicyApplicationAction.install,
          ),
        );

        await endpoints.adminPolicy.detachApplication(adminBuilder, entry.id!);

        expect(
          await PolicyApplication.db.findById(session, entry.id!),
          isNull,
        );
        final reloaded = await Policy.db.findById(session, policy.id!);
        expect(reloaded!.version, 4);
      });

      test('when entries are reordered then the sort order follows the request '
          'and the version is bumped.', () async {
        await createProfile(adminUserId);

        final session = sessionBuilder.build();
        final policy = await Policy.db.insertRow(
          session,
          Policy(name: 'Ordered', version: 2),
        );
        final firstApplication = await Application.db.insertRow(
          session,
          Application(packageName: 'com.example.first', appName: 'First'),
        );
        final secondApplication = await Application.db.insertRow(
          session,
          Application(packageName: 'com.example.second', appName: 'Second'),
        );

        final first = await PolicyApplication.db.insertRow(
          session,
          PolicyApplication(
            policyId: policy.id!,
            applicationId: firstApplication.id!,
            action: PolicyApplicationAction.install,
            sort: 1,
          ),
        );
        final second = await PolicyApplication.db.insertRow(
          session,
          PolicyApplication(
            policyId: policy.id!,
            applicationId: secondApplication.id!,
            action: PolicyApplicationAction.remove,
            sort: 2,
          ),
        );

        await endpoints.adminPolicy.reorderApplications(
          adminBuilder,
          policy.id!,
          [
            second.id!,
            first.id!,
          ],
        );

        expect(
          (await PolicyApplication.db.findById(session, second.id!))!.sort,
          1,
        );
        expect(
          (await PolicyApplication.db.findById(session, first.id!))!.sort,
          2,
        );
        final reloaded = await Policy.db.findById(session, policy.id!);
        expect(reloaded!.version, 3);
      });
    });

    group('file entries', () {
      test(
        'when the same file is attached twice then the existing entry is '
        'refreshed instead of inserting a duplicate.',
        () async {
          await createProfile(adminUserId);

          final session = sessionBuilder.build();
          final policy = await Policy.db.insertRow(
            session,
            Policy(name: 'Files', version: 3),
          );
          final file = await FileAsset.db.insertRow(
            session,
            FileAsset(
              name: 'notes.txt',
              filePath: '/tmp/notes.txt',
              sizeBytes: 1,
            ),
          );

          final first = await endpoints.adminPolicy.attachFile(
            adminBuilder,
            PolicyFile(
              policyId: policy.id!,
              fileId: file.id!,
              usageType: FileOperationType.download,
            ),
          );

          final second = await endpoints.adminPolicy.attachFile(
            adminBuilder,
            PolicyFile(
              policyId: policy.id!,
              fileId: file.id!,
              usageType: FileOperationType.open,
              destinationPath: '/sdcard/notes.txt',
            ),
          );

          expect(second.id, first.id);
          expect(second.usageType, FileOperationType.open);
          expect(second.destinationPath, '/sdcard/notes.txt');
          expect(await PolicyFile.db.count(session), 1);
          expect((await Policy.db.findById(session, policy.id!))!.version, 5);
        },
      );
    });
  });
}
