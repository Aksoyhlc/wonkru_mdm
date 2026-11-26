import 'dart:convert';

import 'package:serverpod/protocol.dart' show FutureCallEntry;
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:wonkru_mdm_server/src/endpoints/admin/admin_device_endpoint.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';
import 'package:wonkru_mdm_server/src/service/setting_service.dart';

import 'support/matchers.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given AdminDeviceEndpoint', (sessionBuilder, endpoints) {
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

    Future<Device> createDevice(
      Session session, {
      required String code,
      String? name,
      String? brand,
      String? manufacturer,
      String? model,
      String? androidVersion,
      int? sdkVersion,
      int? policyId,
      int? batteryLevel,
      int? totalStorageBytes,
      int? freeStorageBytes,
      bool isRooted = false,
      bool isLauncherMode = false,
      DateTime? lastSeenAt,
      DateTime? collectedAt,
    }) {
      return Device.db.insertRow(
        session,
        Device(
          code: code,
          uuid: 'uuid-$code',
          name: name,
          brand: brand,
          manufacturer: manufacturer,
          model: model,
          androidVersion: androidVersion,
          sdkVersion: sdkVersion,
          policyId: policyId,
          batteryLevel: batteryLevel,
          totalStorageBytes: totalStorageBytes,
          freeStorageBytes: freeStorageBytes,
          isRooted: isRooted,
          isLauncherMode: isLauncherMode,
          lastSeenAt: lastSeenAt,
          collectedAt: collectedAt,
        ),
      );
    }

    Future<DeviceGroup> createGroup(Session session, String name) {
      return DeviceGroup.db.insertRow(session, DeviceGroup(name: name));
    }

    Future<void> joinGroup(
      Session session,
      Device device,
      DeviceGroup group,
    ) {
      return DeviceDeviceGroup.db.insertRow(
        session,
        DeviceDeviceGroup(
          deviceId: device.id!,
          deviceGroupId: group.id!,
        ),
      );
    }

    group('list', () {
      test(
        'when devices exist then the requested page is returned in order.',
        () async {
          await createProfile(adminUserId);

          final session = sessionBuilder.build();
          for (var index = 1; index <= 5; index++) {
            await createDevice(
              session,
              code: 'DEV$index',
              name: 'Device $index',
            );
          }

          final page = await endpoints.adminDevice.list(
            adminBuilder,
            DeviceListRequest(page: 2, perPage: 2, sortBy: 'name'),
          );

          expect(page.total, 5);
          expect(page.page, 2);
          expect(page.perPage, 2);
          expect(page.items.map((device) => device.name), [
            'Device 3',
            'Device 4',
          ]);
        },
      );

      test('when a search is given then codes and uuids are matched '
          'too.', () async {
        await createProfile(adminUserId);

        final session = sessionBuilder.build();
        await createDevice(session, code: 'ALPHA1', name: 'Fleet');
        await createDevice(session, code: 'BETA22', name: 'Other');

        final byCode = await endpoints.adminDevice.list(
          adminBuilder,
          DeviceListRequest(search: 'alpha'),
        );
        expect(byCode.total, 1);
        expect(byCode.items.single.code, 'ALPHA1');

        final byUuid = await endpoints.adminDevice.list(
          adminBuilder,
          DeviceListRequest(search: 'uuid-beta22'),
        );
        expect(byUuid.total, 1);
        expect(byUuid.items.single.code, 'BETA22');
      });

      test('when a brand is given then only partial matches are '
          'returned.', () async {
        await createProfile(adminUserId);

        final session = sessionBuilder.build();
        await createDevice(session, code: 'SAM1', brand: 'Samsung');
        await createDevice(session, code: 'XIA1', brand: 'Xiaomi');

        final page = await endpoints.adminDevice.list(
          adminBuilder,
          DeviceListRequest(brand: 'sam'),
        );

        expect(page.total, 1);
        expect(page.items.single.code, 'SAM1');
      });

      test('when a policy is given then only its devices are '
          'returned.', () async {
        await createProfile(adminUserId);

        final session = sessionBuilder.build();
        final policy = await Policy.db.insertRow(session, Policy(name: 'P'));
        await createDevice(session, code: 'MANAGED', policyId: policy.id);
        await createDevice(session, code: 'LOOSE');

        final page = await endpoints.adminDevice.list(
          adminBuilder,
          DeviceListRequest(policyId: policy.id),
        );

        expect(page.total, 1);
        expect(page.items.single.code, 'MANAGED');
      });

      test('when a group is given then its members are matched through the '
          'pivot.', () async {
        await createProfile(adminUserId);

        final session = sessionBuilder.build();
        final group = await createGroup(session, 'Fleet');
        final member = await createDevice(session, code: 'MEMBER');
        await createDevice(session, code: 'OUTSIDER');
        await joinGroup(session, member, group);

        final page = await endpoints.adminDevice.list(
          adminBuilder,
          DeviceListRequest(deviceGroupId: group.id),
        );

        expect(page.total, 1);
        expect(page.items.single.code, 'MEMBER');
      });

      test('when isOnline is given then the offline timeout setting decides '
          'the split.', () async {
        await createProfile(adminUserId);

        final session = sessionBuilder.build();
        final now = DateTime.now().toUtc();
        await createDevice(
          session,
          code: 'FRESH',
          lastSeenAt: now.subtract(const Duration(minutes: 1)),
        );
        await createDevice(
          session,
          code: 'STALE',
          lastSeenAt: now.subtract(const Duration(minutes: 30)),
        );
        await createDevice(session, code: 'NEVER');

        final online = await endpoints.adminDevice.list(
          adminBuilder,
          DeviceListRequest(isOnline: true),
        );
        expect(online.items.map((device) => device.code), ['FRESH']);

        final offline = await endpoints.adminDevice.list(
          adminBuilder,
          DeviceListRequest(isOnline: false, sortBy: 'code'),
        );
        expect(offline.items.map((device) => device.code), ['NEVER', 'STALE']);

        await SettingService.save(
          session,
          AdminDeviceEndpoint.offlineTimeoutSettingKey,
          '60',
        );
        final relaxed = await endpoints.adminDevice.list(
          adminBuilder,
          DeviceListRequest(isOnline: true, sortBy: 'code'),
        );
        expect(relaxed.items.map((device) => device.code), ['FRESH', 'STALE']);
      });

      test('when isRooted is given then only rooted devices are '
          'returned.', () async {
        await createProfile(adminUserId);

        final session = sessionBuilder.build();
        await createDevice(session, code: 'ROOTED', isRooted: true);
        await createDevice(session, code: 'CLEAN');

        final page = await endpoints.adminDevice.list(
          adminBuilder,
          DeviceListRequest(isRooted: true),
        );

        expect(page.total, 1);
        expect(page.items.single.code, 'ROOTED');
      });

      test(
        'when a manufacturer is given then it is matched partially.',
        () async {
          await createProfile(adminUserId);

          final session = sessionBuilder.build();
          await createDevice(session, code: 'SAMSUNG', manufacturer: 'Samsung');
          await createDevice(session, code: 'XIAOMI', manufacturer: 'Xiaomi');

          final page = await endpoints.adminDevice.list(
            adminBuilder,
            DeviceListRequest(manufacturer: 'sams'),
          );

          expect(page.total, 1);
          expect(page.items.single.code, 'SAMSUNG');
        },
      );

      test('when an android version is given then it is matched '
          'partially.', () async {
        await createProfile(adminUserId);

        final session = sessionBuilder.build();
        await createDevice(session, code: 'PIE', androidVersion: '9');
        await createDevice(session, code: 'THIRTEEN', androidVersion: '13');

        final page = await endpoints.adminDevice.list(
          adminBuilder,
          DeviceListRequest(androidVersion: '13'),
        );

        expect(page.total, 1);
        expect(page.items.single.code, 'THIRTEEN');
      });

      test(
        'when criticalBattery is given then the ternary is honoured.',
        () async {
          await createProfile(adminUserId);

          final session = sessionBuilder.build();
          await createDevice(session, code: 'LOW', batteryLevel: 10);
          await createDevice(session, code: 'HIGH', batteryLevel: 80);
          await createDevice(session, code: 'NONE');

          final critical = await endpoints.adminDevice.list(
            adminBuilder,
            DeviceListRequest(criticalBattery: true),
          );
          expect(critical.items.map((device) => device.code), ['LOW']);

          final rest = await endpoints.adminDevice.list(
            adminBuilder,
            DeviceListRequest(criticalBattery: false, sortBy: 'code'),
          );
          expect(rest.items.map((device) => device.code), ['HIGH', 'NONE']);
        },
      );

      test('when criticalStorage is given then the ratio is '
          'honoured.', () async {
        await createProfile(adminUserId);

        final session = sessionBuilder.build();
        await createDevice(
          session,
          code: 'FULL',
          totalStorageBytes: 100,
          freeStorageBytes: 5,
        );
        await createDevice(
          session,
          code: 'ROOMY',
          totalStorageBytes: 100,
          freeStorageBytes: 50,
        );
        await createDevice(session, code: 'UNKNOWN');

        final critical = await endpoints.adminDevice.list(
          adminBuilder,
          DeviceListRequest(criticalStorage: true),
        );
        expect(critical.items.map((device) => device.code), ['FULL']);

        final rest = await endpoints.adminDevice.list(
          adminBuilder,
          DeviceListRequest(criticalStorage: false, sortBy: 'code'),
        );
        expect(rest.items.map((device) => device.code), ['ROOMY', 'UNKNOWN']);
      });

      test('when notSeen24h is given then the ternary is honoured.', () async {
        await createProfile(adminUserId);

        final session = sessionBuilder.build();
        final now = DateTime.now().toUtc();
        await createDevice(
          session,
          code: 'RECENT',
          lastSeenAt: now.subtract(const Duration(hours: 1)),
        );
        await createDevice(
          session,
          code: 'OLD',
          lastSeenAt: now.subtract(const Duration(hours: 48)),
        );
        await createDevice(session, code: 'NEVER');

        final stale = await endpoints.adminDevice.list(
          adminBuilder,
          DeviceListRequest(notSeen24h: true, sortBy: 'code'),
        );
        expect(stale.items.map((device) => device.code), ['NEVER', 'OLD']);

        final fresh = await endpoints.adminDevice.list(
          adminBuilder,
          DeviceListRequest(notSeen24h: false),
        );
        expect(fresh.items.map((device) => device.code), ['RECENT']);
      });

      test('when noPolicy is given then the ternary is honoured.', () async {
        await createProfile(adminUserId);

        final session = sessionBuilder.build();
        final policy = await Policy.db.insertRow(session, Policy(name: 'P'));
        await createDevice(session, code: 'MANAGED', policyId: policy.id);
        await createDevice(session, code: 'LOOSE');

        final loose = await endpoints.adminDevice.list(
          adminBuilder,
          DeviceListRequest(noPolicy: true),
        );
        expect(loose.items.map((device) => device.code), ['LOOSE']);

        final managed = await endpoints.adminDevice.list(
          adminBuilder,
          DeviceListRequest(noPolicy: false),
        );
        expect(managed.items.map((device) => device.code), ['MANAGED']);
      });

      test('when perPage is above the maximum then it is clamped.', () async {
        await createProfile(adminUserId);

        final page = await endpoints.adminDevice.list(
          adminBuilder,
          DeviceListRequest(perPage: 100000),
        );

        expect(page.perPage, AdminDeviceEndpoint.maxPerPage);
      });

      test('when the page is below one then the first page is '
          'returned.', () async {
        await createProfile(adminUserId);

        final page = await endpoints.adminDevice.list(
          adminBuilder,
          DeviceListRequest(page: -5),
        );

        expect(page.page, 1);
      });
    });

    group('export', () {
      test('when devices match then every row is rendered as CSV.', () async {
        await createProfile(adminUserId);

        final session = sessionBuilder.build();
        await createDevice(
          session,
          code: 'ALPHA',
          name: 'Alpha',
          manufacturer: 'Samsung',
          model: 'S21',
          brand: 'Samsung',
          androidVersion: '13',
          sdkVersion: 33,
          batteryLevel: 42,
          isRooted: true,
          isLauncherMode: true,
        );
        await createDevice(session, code: 'BETA', name: 'Beta');

        final data = await endpoints.adminDevice.export(
          adminBuilder,
          DeviceListRequest(search: 'alpha'),
        );
        final csv = utf8.decode(
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
        );
        final lines = csv.trim().split('\n');

        expect(
          lines.first,
          'code,name,manufacturer,model,brand,android_version,sdk_version,'
          'battery_level,is_rooted,is_launcher_mode,policy_id,group_id,'
          'last_seen_at,collected_at',
        );
        expect(lines, hasLength(2));
        expect(
          lines[1],
          startsWith('ALPHA,Alpha,Samsung,S21,Samsung,13,33,42,true,true,'),
        );
      });

      test('when the session is not authenticated then the export is '
          'rejected.', () async {
        await expectLater(
          endpoints.adminDevice.export(
            sessionBuilder,
            DeviceListRequest(),
          ),
          throwsA(isA<ServerpodUnauthenticatedException>()),
        );
      });
    });

    group('get', () {
      test('when the device exists then it is returned.', () async {
        await createProfile(adminUserId);

        final session = sessionBuilder.build();
        final device = await createDevice(session, code: 'LOOKUP');

        final fetched = await endpoints.adminDevice.get(
          adminBuilder,
          device.id!,
        );

        expect(fetched.code, 'LOOKUP');
      });

      test('when the device does not exist then it is rejected.', () async {
        await createProfile(adminUserId);

        await expectLater(
          endpoints.adminDevice.get(adminBuilder, 987654),
          throwsExceptionWith('Device 987654 does not exist.'),
        );
      });
    });

    group('stateCache', () {
      test('when the device has synced then the flattened state is '
          'returned.', () async {
        await createProfile(adminUserId);

        final session = sessionBuilder.build();
        final device = await createDevice(session, code: 'STATE');
        final sync = await DeviceSync.db.insertRow(
          session,
          DeviceSync(
            deviceId: device.id!,
            collectedAt: DateTime.utc(2026, 9, 20, 9, 16),
            createdAt: DateTime.utc(2026, 9, 20, 9, 16),
          ),
        );
        await DeviceStateCache.db.insertRow(
          session,
          DeviceStateCache(
            deviceId: device.id!,
            deviceSyncId: sync.id!,
            collectedAt: DateTime.utc(2026, 9, 20, 9, 16),
            updatedAt: DateTime.utc(2026, 9, 20, 9, 16),
            currentSsid: 'AndroidWifi',
            batteryLevel: 87,
            isRooted: false,
          ),
        );

        final state = await endpoints.adminDevice.stateCache(
          adminBuilder,
          device.id!,
        );

        expect(state, isNotNull);
        expect(state!.currentSsid, 'AndroidWifi');
        expect(state.batteryLevel, 87);
        expect(state.isRooted, isFalse);
      });

      test('when the device has never synced then null is returned.', () async {
        await createProfile(adminUserId);

        final session = sessionBuilder.build();
        final device = await createDevice(session, code: 'NOSTATE');

        final state = await endpoints.adminDevice.stateCache(
          adminBuilder,
          device.id!,
        );

        expect(state, isNull);
      });

      test('when the caller is not a panel admin then it is '
          'rejected.', () async {
        await createProfile(
          outsiderUserId,
          status: AdminAccountStatus.disabled,
        );

        final session = sessionBuilder.build();
        final device = await createDevice(session, code: 'DENIED');

        await expectLater(
          endpoints.adminDevice.stateCache(outsiderBuilder, device.id!),
          throwsA(isA<ServerpodInsufficientAccessException>()),
        );
      });
    });

    group('groupIds', () {
      test('when the device belongs to groups then their ids are '
          'returned.', () async {
        await createProfile(adminUserId);

        final session = sessionBuilder.build();
        final device = await createDevice(session, code: 'GROUPED');
        final first = await createGroup(session, 'First');
        final second = await createGroup(session, 'Second');
        await joinGroup(session, device, first);
        await joinGroup(session, device, second);

        final ids = await endpoints.adminDevice.groupIds(
          adminBuilder,
          device.id!,
        );

        expect(ids, unorderedEquals([first.id, second.id]));
      });
    });

    group('applications', () {
      test('when the session is not authenticated then the applications are '
          'rejected.', () async {
        await expectLater(
          endpoints.adminDevice.applications(sessionBuilder, 1),
          throwsA(isA<ServerpodUnauthenticatedException>()),
        );
      });

      test('when the device has apps then only its rows come back, ordered '
          'by name.', () async {
        await createProfile(adminUserId);

        final session = sessionBuilder.build();
        final device = await createDevice(session, code: 'HOST');
        final other = await createDevice(session, code: 'OTHER');

        await DeviceApplication.db.insertRow(
          session,
          DeviceApplication(
            deviceId: device.id!,
            packageName: 'com.zeta',
            appName: 'Zeta',
          ),
        );
        await DeviceApplication.db.insertRow(
          session,
          DeviceApplication(
            deviceId: device.id!,
            packageName: 'com.alpha',
            appName: 'Alpha',
            isSystemApp: true,
          ),
        );
        await DeviceApplication.db.insertRow(
          session,
          DeviceApplication(
            deviceId: other.id!,
            packageName: 'com.other',
            appName: 'Other',
          ),
        );

        final apps = await endpoints.adminDevice.applications(
          adminBuilder,
          device.id!,
        );

        expect(apps.map((app) => app.appName), ['Alpha', 'Zeta']);
        expect(apps.first.isSystemApp, isTrue);
        expect(apps.first.versionName, isNull);
      });

      test('when the device has no apps then the list is empty.', () async {
        await createProfile(adminUserId);

        final session = sessionBuilder.build();
        final device = await createDevice(session, code: 'EMPTY');

        expect(
          await endpoints.adminDevice.applications(adminBuilder, device.id!),
          isEmpty,
        );
      });

      test('when the user has no admin profile then the applications are '
          'rejected.', () async {
        await expectLater(
          endpoints.adminDevice.applications(outsiderBuilder, 1),
          throwsA(isA<ServerpodInsufficientAccessException>()),
        );
      });
    });

    group('reports', () {
      test('when the session is not authenticated then the reports are '
          'rejected.', () async {
        await expectLater(
          endpoints.adminDevice.reports(sessionBuilder, 1, limit: 10),
          throwsA(isA<ServerpodUnauthenticatedException>()),
        );
      });

      test('when reports exist then the newest ones come first.', () async {
        await createProfile(adminUserId);

        final session = sessionBuilder.build();
        final device = await createDevice(session, code: 'REPORTING');
        final other = await createDevice(session, code: 'OTHER');

        await DeviceReport.db.insertRow(
          session,
          DeviceReport(
            deviceId: device.id!,
            type: 'impossibleSpeed',
            payload: '{"speed":1}',
            createdAt: DateTime.utc(2026, 1, 1),
          ),
        );
        await DeviceReport.db.insertRow(
          session,
          DeviceReport(
            deviceId: device.id!,
            type: 'impossibleSpeed',
            payload: '{"speed":2}',
            createdAt: DateTime.utc(2026, 3, 1),
          ),
        );
        await DeviceReport.db.insertRow(
          session,
          DeviceReport(
            deviceId: other.id!,
            type: 'impossibleSpeed',
            payload: '{"speed":3}',
            createdAt: DateTime.utc(2026, 4, 1),
          ),
        );

        final reports = await endpoints.adminDevice.reports(
          adminBuilder,
          device.id!,
          limit: 10,
        );

        expect(reports.map((report) => report.payload), [
          '{"speed":2}',
          '{"speed":1}',
        ]);
      });

      test(
        'when a limit is given then only that many rows come back.',
        () async {
          await createProfile(adminUserId);

          final session = sessionBuilder.build();
          final device = await createDevice(session, code: 'LIMITED');
          for (var index = 1; index <= 3; index++) {
            await DeviceReport.db.insertRow(
              session,
              DeviceReport(
                deviceId: device.id!,
                type: 'impossibleSpeed',
                payload: '{"index":$index}',
                createdAt: DateTime.utc(2026, 1, index),
              ),
            );
          }

          final reports = await endpoints.adminDevice.reports(
            adminBuilder,
            device.id!,
            limit: 1,
          );

          expect(reports, hasLength(1));
          expect(reports.single.payload, '{"index":3}');
        },
      );
    });

    group('update', () {
      test('when a code is given then it is sanitized before it is '
          'stored.', () async {
        await createProfile(adminUserId);

        final session = sessionBuilder.build();
        final device = await createDevice(session, code: 'BEFORE');

        final saved = await endpoints.adminDevice.update(
          adminBuilder,
          AdminDeviceUpdateRequest(deviceId: device.id!, code: 'after-1!'),
        );

        expect(saved.code, 'AFTER-1');
      });

      test('when the code belongs to another device then the update is '
          'rejected.', () async {
        await createProfile(adminUserId);

        final session = sessionBuilder.build();
        await createDevice(session, code: 'TAKEN');
        final device = await createDevice(session, code: 'MINE');

        await expectLater(
          endpoints.adminDevice.update(
            adminBuilder,
            AdminDeviceUpdateRequest(deviceId: device.id!, code: 'taken'),
          ),
          throwsExceptionWith('Device code TAKEN is already taken.'),
        );
      });

      test('when the policy is cleared then the device falls back to the '
          'default policy.', () async {
        await createProfile(adminUserId);

        final session = sessionBuilder.build();
        final fallback = await Policy.db.insertRow(session, Policy(name: 'D'));
        await SettingService.save(
          session,
          SettingService.defaultPolicyKey,
          '${fallback.id}',
        );
        final device = await createDevice(session, code: 'ORPHAN');

        final saved = await endpoints.adminDevice.update(
          adminBuilder,
          AdminDeviceUpdateRequest(deviceId: device.id!),
        );

        expect(saved.policyId, fallback.id);
      });

      test(
        'when groups are given then the memberships are replaced.',
        () async {
          await createProfile(adminUserId);

          final session = sessionBuilder.build();
          final device = await createDevice(session, code: 'SWITCH');
          final oldGroup = await createGroup(session, 'Old');
          final newGroup = await createGroup(session, 'New');
          await joinGroup(session, device, oldGroup);

          await endpoints.adminDevice.update(
            adminBuilder,
            AdminDeviceUpdateRequest(
              deviceId: device.id!,
              deviceGroupIds: [newGroup.id!],
            ),
          );

          final memberships = await DeviceDeviceGroup.db.find(
            session,
            where: (t) => t.deviceId.equals(device.id!),
          );
          expect(memberships.map((row) => row.deviceGroupId), [newGroup.id]);
        },
      );

      test('when the device does not exist then the update is '
          'rejected.', () async {
        await createProfile(adminUserId);

        await expectLater(
          endpoints.adminDevice.update(
            adminBuilder,
            AdminDeviceUpdateRequest(deviceId: 987654, name: 'Ghost'),
          ),
          throwsExceptionWith('Device 987654 does not exist.'),
        );
      });
    });

    group('delete', () {
      test('when devices are deleted then the rows and their memberships go '
          'away.', () async {
        await createProfile(adminUserId);

        final session = sessionBuilder.build();
        final device = await createDevice(session, code: 'DOOMED');
        final group = await createGroup(session, 'Fleet');
        await joinGroup(session, device, group);

        final deleted = await endpoints.adminDevice.delete(adminBuilder, [
          device.id!,
        ]);

        expect(deleted, 1);
        expect(await Device.db.findById(session, device.id!), isNull);
        expect(
          await DeviceDeviceGroup.db.find(
            session,
            where: (t) => t.deviceId.equals(device.id!),
          ),
          isEmpty,
        );
      });

      test('when no device is given then nothing is deleted.', () async {
        await createProfile(adminUserId);

        expect(await endpoints.adminDevice.delete(adminBuilder, []), 0);
      });
    });

    group('assignPolicy', () {
      test(
        'when devices are assigned then they move onto the policy.',
        () async {
          await createProfile(adminUserId);

          final session = sessionBuilder.build();
          final policy = await Policy.db.insertRow(
            session,
            Policy(name: 'New'),
          );
          final first = await createDevice(session, code: 'ONE');
          final second = await createDevice(session, code: 'TWO');

          final updated = await endpoints.adminDevice.assignPolicy(
            adminBuilder,
            [first.id!, second.id!],
            policy.id!,
          );

          expect(updated, 2);
          expect(
            (await Device.db.findById(session, first.id!))!.policyId,
            policy.id,
          );
        },
      );

      test('when the policy does not exist then the assignment is '
          'rejected.', () async {
        await createProfile(adminUserId);

        final session = sessionBuilder.build();
        final device = await createDevice(session, code: 'ONE');

        await expectLater(
          endpoints.adminDevice.assignPolicy(
            adminBuilder,
            [device.id!],
            987654,
          ),
          throwsExceptionWith('Policy 987654 does not exist.'),
        );
      });
    });

    group('assignGroups', () {
      test(
        'when groups are assigned then the memberships are replaced.',
        () async {
          await createProfile(adminUserId);

          final session = sessionBuilder.build();
          final device = await createDevice(session, code: 'ONE');
          final previous = await createGroup(session, 'Old fleet');
          final group = await createGroup(session, 'Fleet');
          await endpoints.adminDevice.assignGroups(
            adminBuilder,
            [device.id!],
            [previous.id!],
          );

          final updated = await endpoints.adminDevice.assignGroups(
            adminBuilder,
            [device.id!],
            [group.id!],
          );

          expect(updated, 1);
          final memberships = await DeviceDeviceGroup.db.find(
            session,
            where: (t) => t.deviceId.equals(device.id!),
          );
          expect(memberships.map((row) => row.deviceGroupId), [group.id]);
        },
      );
    });

    group('sendPolicyUpdate', () {
      test('when the devices have policies then one call per policy is '
          'queued.', () async {
        await createProfile(adminUserId);

        final session = sessionBuilder.build();
        final shared = await Policy.db.insertRow(session, Policy(name: 'A'));
        final other = await Policy.db.insertRow(session, Policy(name: 'B'));
        final first = await createDevice(
          session,
          code: 'ONE',
          policyId: shared.id,
        );
        final second = await createDevice(
          session,
          code: 'TWO',
          policyId: shared.id,
        );
        final third = await createDevice(
          session,
          code: 'THREE',
          policyId: other.id,
        );
        final loose = await createDevice(session, code: 'LOOSE');

        final queued = await endpoints.adminDevice.sendPolicyUpdate(
          adminBuilder,
          [first.id!, second.id!, third.id!, loose.id!],
        );

        expect(queued, 3);

        final calls = await FutureCallEntry.db.find(session);
        final payloads = [
          for (final call in calls)
            if (call.serializedObject case final raw?)
              jsonDecode(raw) as Map<String, dynamic>,
        ].where((json) => json.containsKey('policyId')).toList();
        expect(payloads, hasLength(2));
        final byPolicy = {
          for (final json in payloads)
            json['policyId']: (json['deviceIds'] as List).toSet(),
        };
        expect(byPolicy, {
          shared.id: {first.id, second.id},
          other.id: {third.id},
        });
      });

      test('when no device has a policy then nothing is queued.', () async {
        await createProfile(adminUserId);

        final session = sessionBuilder.build();
        final device = await createDevice(session, code: 'LOOSE');

        expect(
          await endpoints.adminDevice.sendPolicyUpdate(adminBuilder, [
            device.id!,
          ]),
          0,
        );
      });
    });

    group('duplicatePolicy', () {
      test('when the device has a policy then it gets its own copy.', () async {
        await createProfile(adminUserId);

        final session = sessionBuilder.build();
        final source = await Policy.db.insertRow(
          session,
          Policy(name: 'Shared', version: 3),
        );
        final device = await createDevice(
          session,
          code: 'COPYME',
          policyId: source.id,
        );

        final copy = await endpoints.adminDevice.duplicatePolicy(
          adminBuilder,
          device.id!,
        );

        expect(copy.name, 'COPYME - Policy');
        expect(copy.id, isNot(source.id));
        expect(copy.defaultPolicy, isFalse);
        expect(copy.version, 1);
        expect(
          (await Device.db.findById(session, device.id!))!.policyId,
          copy.id,
        );
      });

      test(
        'when the device has no policy then the copy is rejected.',
        () async {
          await createProfile(adminUserId);

          final session = sessionBuilder.build();
          final device = await createDevice(session, code: 'LOOSE');

          await expectLater(
            endpoints.adminDevice.duplicatePolicy(adminBuilder, device.id!),
            throwsExceptionWith('has no policy to copy.'),
          );
        },
      );
    });
  });
}
