import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';

import 'support/admin_fixture.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given admin activity audit trail', (
    sessionBuilder,
    endpoints,
  ) {
    late Session session;
    late TestAdmin ada;
    late TestAdmin bob;

    setUp(() async {
      session = sessionBuilder.build();
      ada = await createAdmin(session, sessionBuilder);
      bob = await createAdmin(session, sessionBuilder);
    });

    Future<AdminActivity> write(
      TestAdmin actor,
      String action, {
      DateTime? createdAt,
    }) => AdminActivity.db.insertRow(
      sessionBuilder.build(),
      AdminActivity(
        actorUserId: actor.userId,
        action: action,
        createdAt: createdAt ?? DateTime.now().toUtc(),
      ),
    );

    test('a real endpoint mutation is recorded end to end', () async {
      final group = await endpoints.adminDeviceGroup.create(
        ada.builder,
        DeviceGroup(name: 'Grup A'),
      );

      final page = await endpoints.adminActivity.list(
        ada.builder,
        AdminActivityListRequest(),
      );

      final entry = page.items.firstWhere(
        (row) => row.action == 'device_group.create',
      );
      expect(entry.targetType, 'device_group');
      expect(entry.targetId, group.id.toString());
      expect(entry.actorUserId, ada.userId);
    });

    test('a read (view) is recorded too', () async {
      final group = await endpoints.adminDeviceGroup.create(
        ada.builder,
        DeviceGroup(name: 'Grup B'),
      );

      await endpoints.adminDeviceGroup.get(ada.builder, group.id!);

      final page = await endpoints.adminActivity.list(
        ada.builder,
        AdminActivityListRequest(action: 'device_group.view'),
      );

      expect(page.total, 1);
      expect(page.items.single.targetId, group.id.toString());
      expect(page.items.single.actorUserId, ada.userId);
    });

    test('list returns newest first and totals the set', () async {
      final now = DateTime.now().toUtc();
      await write(
        ada,
        'device.update',
        createdAt: now.subtract(const Duration(hours: 2)),
      );
      await write(
        ada,
        'device.delete',
        createdAt: now.subtract(const Duration(hours: 1)),
      );
      await write(bob, 'policy.delete', createdAt: now);

      final page = await endpoints.adminActivity.list(
        ada.builder,
        AdminActivityListRequest(),
      );

      expect(page.total, 3);
      expect(page.items.map((row) => row.action), [
        'policy.delete',
        'device.delete',
        'device.update',
      ]);
    });

    test('action, actor and date filters narrow the list', () async {
      final now = DateTime.now().toUtc();
      await write(
        ada,
        'device.update',
        createdAt: now.subtract(const Duration(hours: 2)),
      );
      await write(
        ada,
        'device.delete',
        createdAt: now.subtract(const Duration(hours: 1)),
      );
      await write(bob, 'policy.delete', createdAt: now);

      final byAction = await endpoints.adminActivity.list(
        ada.builder,
        AdminActivityListRequest(action: 'device.delete'),
      );
      expect(byAction.total, 1);

      final byActor = await endpoints.adminActivity.list(
        ada.builder,
        AdminActivityListRequest(actorUserId: bob.userId),
      );
      expect(byActor.total, 1);
      expect(byActor.items.single.action, 'policy.delete');

      final byDate = await endpoints.adminActivity.list(
        ada.builder,
        AdminActivityListRequest(
          from: now.subtract(const Duration(minutes: 90)),
        ),
      );
      expect(byDate.total, 2);
    });

    test('search matches the action code', () async {
      await write(ada, 'device.update');
      await write(ada, 'policy.delete');

      final page = await endpoints.adminActivity.list(
        ada.builder,
        AdminActivityListRequest(search: 'device'),
      );

      expect(page.total, 1);
      expect(page.items.single.action, 'device.update');
    });

    test('actions returns the distinct codes, sorted', () async {
      await write(ada, 'device.delete');
      await write(ada, 'device.update');
      await write(ada, 'device.delete');

      final actions = await endpoints.adminActivity.actions(ada.builder);

      expect(actions, ['device.delete', 'device.update']);
    });

    test('list clamps a zero page to the first page', () async {
      await write(ada, 'device.update');

      final page = await endpoints.adminActivity.list(
        ada.builder,
        AdminActivityListRequest(page: 0, perPage: 25),
      );

      expect(page.page, 1);
      expect(page.items, hasLength(1));
    });

    test('anonymous and unscoped sessions are rejected', () async {
      final nonAdmin = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          '33333333-3333-4333-8333-333333333333',
          const {},
        ),
      );

      await expectLater(
        endpoints.adminActivity.list(
          sessionBuilder,
          AdminActivityListRequest(),
        ),
        throwsA(isA<ServerpodUnauthenticatedException>()),
      );
      await expectLater(
        endpoints.adminActivity.list(nonAdmin, AdminActivityListRequest()),
        throwsA(isA<ServerpodInsufficientAccessException>()),
      );
    });
  });
}
