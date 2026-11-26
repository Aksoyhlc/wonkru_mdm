import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:wonkru_mdm_server/src/endpoints/admin/admin_device_group_endpoint.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';

import 'support/matchers.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given AdminDeviceGroupEndpoint', (
    sessionBuilder,
    endpoints,
  ) {
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

    Future<DeviceGroup> createGroup(Session session, String name) {
      return DeviceGroup.db.insertRow(session, DeviceGroup(name: name));
    }

    Future<Device> createDevice(
      Session session, {
      required String code,
      int? groupId,
    }) {
      return Device.db.insertRow(
        session,
        Device(code: code, uuid: 'uuid-$code', groupId: groupId),
      );
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
      test('when groups exist then the requested page is returned in '
          'order.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        for (var index = 1; index <= 5; index++) {
          await createGroup(session, 'Group $index');
        }

        final page = await endpoints.adminDeviceGroup.list(
          adminBuilder,
          AdminListRequest(page: 2, perPage: 2, sortBy: 'name'),
        );

        expect(page.total, 5);
        expect(page.page, 2);
        expect(page.perPage, 2);
        expect(page.items.map((row) => row.group.name), ['Group 3', 'Group 4']);
      });

      test('when a search is given then the name and the description each '
          'match on their own.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        await DeviceGroup.db.insertRow(
          session,
          DeviceGroup(name: 'Field fleet', description: 'Outdoor units'),
        );
        await createGroup(session, 'Office');

        for (final search in ['Outdoor', 'fleet']) {
          final page = await endpoints.adminDeviceGroup.list(
            adminBuilder,
            AdminListRequest(search: search),
          );
          expect(
            page.items.map((row) => row.group.name),
            ['Field fleet'],
            reason: search,
          );
        }
      });

      test(
        'when a group has members then the row carries their count.',
        () async {
          await createProfile();

          final session = sessionBuilder.build();
          final group = await createGroup(session, 'Populated');
          await createGroup(session, 'Empty');

          for (final code in ['ONE', 'TWO']) {
            final device = await createDevice(session, code: code);
            await joinGroup(session, device, group);
          }

          final page = await endpoints.adminDeviceGroup.list(
            adminBuilder,
            AdminListRequest(sortBy: 'name'),
          );

          expect(page.items.first.group.name, 'Empty');
          expect(page.items.first.deviceCount, 0);
          expect(page.items.last.group.name, 'Populated');
          expect(page.items.last.deviceCount, 2);
        },
      );

      test('when perPage is above the maximum then it is clamped.', () async {
        await createProfile();

        final page = await endpoints.adminDeviceGroup.list(
          adminBuilder,
          AdminListRequest(perPage: 100000),
        );

        expect(page.perPage, AdminDeviceGroupEndpoint.maxPerPage);
      });
    });

    group('get', () {
      test('when the group exists then it is returned.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final group = await createGroup(session, 'Lookup');

        final fetched = await endpoints.adminDeviceGroup.get(
          adminBuilder,
          group.id!,
        );

        expect(fetched.name, 'Lookup');
      });

      test('when the group does not exist then it is rejected.', () async {
        await createProfile();

        await expectLater(
          endpoints.adminDeviceGroup.get(adminBuilder, 987654),
          throwsExceptionWith('Device group 987654 does not exist.'),
        );
      });
    });

    group('create', () {
      test('when a group is created then it is stored without the id the '
          'panel sent.', () async {
        await createProfile();

        final created = await endpoints.adminDeviceGroup.create(
          adminBuilder,
          DeviceGroup(id: 4242, name: 'Fresh', description: 'New fleet'),
        );

        expect(created.id, isNot(4242));
        expect(created.name, 'Fresh');
        expect(created.description, 'New fleet');
      });
    });

    group('update', () {
      test('when a group is renamed then the change is stored.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final group = await createGroup(session, 'Before');

        final saved = await endpoints.adminDeviceGroup.update(
          adminBuilder,
          group.copyWith(name: 'After'),
        );

        expect(saved.name, 'After');
        expect(
          (await DeviceGroup.db.findById(session, group.id!))!.name,
          'After',
        );
      });

      test('when the group does not exist then the update is '
          'rejected.', () async {
        await createProfile();

        await expectLater(
          endpoints.adminDeviceGroup.update(
            adminBuilder,
            DeviceGroup(id: 987654, name: 'Ghost'),
          ),
          throwsExceptionWith('Device group 987654 does not exist.'),
        );
      });
    });

    group('delete', () {
      test('when a group is deleted then its memberships go away and its '
          'devices lose their primary group.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final group = await createGroup(session, 'Doomed');
        final device = await createDevice(
          session,
          code: 'MEMBER',
          groupId: group.id,
        );
        await joinGroup(session, device, group);

        final deleted = await endpoints.adminDeviceGroup.delete(adminBuilder, [
          group.id!,
        ]);

        expect(deleted, 1);
        expect(await DeviceGroup.db.findById(session, group.id!), isNull);
        expect(
          await DeviceDeviceGroup.db.find(
            session,
            where: (t) => t.deviceGroupId.equals(group.id!),
          ),
          isEmpty,
        );
        expect(
          (await Device.db.findById(session, device.id!))!.groupId,
          isNull,
        );
      });

      test('when no group is given then nothing is deleted.', () async {
        await createProfile();

        expect(await endpoints.adminDeviceGroup.delete(adminBuilder, []), 0);
      });
    });
  });
}
