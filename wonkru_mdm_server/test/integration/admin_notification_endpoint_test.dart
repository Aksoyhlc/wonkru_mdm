import 'package:test/test.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';
import 'package:wonkru_mdm_server/src/service/admin_notification_service.dart';

import 'support/admin_fixture.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given AdminNotificationEndpoint', (sessionBuilder, endpoints) {
    late TestAdmin ada;
    late TestAdmin bob;

    setUp(() async {
      final session = sessionBuilder.build();
      ada = await createAdmin(session, sessionBuilder);
      bob = await createAdmin(session, sessionBuilder);
    });

    Future<AdminNotification> notify(
      TestAdmin admin,
      String title, {
      DateTime? createdAt,
    }) => AdminNotification.db.insertRow(
      sessionBuilder.build(),
      AdminNotification(
        userId: admin.userId,
        type: SystemAlertType.device_offline.name,
        title: title,
        message: 'Body',
        createdAt: createdAt ?? DateTime.now().toUtc(),
      ),
    );

    test('when an admin has notifications then unreadCount and list show '
        'only their own, newest first', () async {
      final now = DateTime.now().toUtc();
      await notify(
        ada,
        'Old',
        createdAt: now.subtract(const Duration(hours: 1)),
      );
      await notify(ada, 'New', createdAt: now);
      await notify(bob, 'For Bob');

      expect(await endpoints.adminNotification.unreadCount(ada.builder), 2);
      final page = await endpoints.adminNotification.list(
        ada.builder,
        AdminListRequest(),
      );
      expect(page.total, 2);
      expect(page.items.map((row) => row.title), ['New', 'Old']);
    });

    test(
      'when markRead is given another admin\'s id then it is left unread',
      () async {
        final own = await notify(ada, 'Ada');
        final foreign = await notify(bob, 'Bob');

        final marked = await endpoints.adminNotification.markRead(ada.builder, [
          own.id!,
          foreign.id!,
        ]);

        expect(marked, 1);
        expect(await endpoints.adminNotification.unreadCount(ada.builder), 0);
        expect(await endpoints.adminNotification.unreadCount(bob.builder), 1);
      },
    );

    test(
      'markAllRead clears only the caller\'s unread notifications',
      () async {
        await notify(ada, 'One');
        await notify(ada, 'Two');
        await notify(bob, 'Bob');

        expect(await endpoints.adminNotification.markAllRead(ada.builder), 2);
        expect(await endpoints.adminNotification.unreadCount(ada.builder), 0);
        expect(await endpoints.adminNotification.unreadCount(bob.builder), 1);
      },
    );

    test('list clamps a zero page to the first page', () async {
      await notify(ada, 'Single');

      final page = await AdminNotificationService.list(
        sessionBuilder.build(),
        page: 0,
        perPage: 25,
        userId: ada.userId,
      );

      expect(page.page, 1);
      expect(page.items, hasLength(1));
    });

    test('me reports the unread badge count and follows markRead', () async {
      final row = await notify(ada, 'Badge');

      expect(
        (await endpoints.adminAuth.me(ada.builder)).unreadNotificationCount,
        1,
      );

      await endpoints.adminNotification.markRead(ada.builder, [row.id!]);
      expect(
        (await endpoints.adminAuth.me(ada.builder)).unreadNotificationCount,
        0,
      );
    });
  });
}
