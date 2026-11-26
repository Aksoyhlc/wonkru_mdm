import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:test/test.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';

import 'support/admin_fixture.dart';
import 'test_tools/serverpod_test_tools.dart';

/// The real `emailIdp.login` opens its own transaction, and the rollback test
/// database does not allow concurrent transactions (see
/// `admin_credential_change_test.dart`), so rollback is disabled and the rows
/// created are deleted by hand in `tearDown`.
void main() {
  setUpAll(installTestAuthServices);

  withServerpod(
    'Given a panel login',
    rollbackDatabase: RollbackDatabase.disabled,
    (sessionBuilder, endpoints) {
      const password = 'Str0ng-Test-Password-42!';
      final createdUserIds = <UuidValue>{};
      final createdEmails = <String>{};

      Future<TestAdmin> makeAdmin(String prefix) async {
        final email =
            '$prefix-${DateTime.now().microsecondsSinceEpoch}@example.com';
        final admin = await createEmailAdmin(
          sessionBuilder.build(),
          sessionBuilder,
          email: email,
          password: password,
        );
        createdUserIds.add(admin.userId);
        createdEmails.add(email);
        return admin;
      }

      tearDown(() async {
        final session = sessionBuilder.build();
        if (createdUserIds.isEmpty && createdEmails.isEmpty) return;

        // Audit rows store successful logins by actor id, failures by email only.
        await AdminActivity.db.deleteWhere(
          session,
          where: (t) =>
              t.actorUserId.inSet(createdUserIds) |
              t.actorEmail.inSet(createdEmails),
        );
        await AdminProfile.db.deleteWhere(
          session,
          where: (t) => t.userId.inSet(createdUserIds),
        );
        // Deleting the auth user cascades to its email account and profile.
        await AuthUser.db.deleteWhere(
          session,
          where: (t) => t.id.inSet(createdUserIds),
        );

        createdUserIds.clear();
        createdEmails.clear();
      });

      test(
        'a successful login stamps lastLoginAt and records sign_in',
        () async {
          final admin = await makeAdmin('ok');

          expect(admin.profile.lastLoginAt, isNull);

          await endpoints.adminAuth.login(
            sessionBuilder,
            createdEmails.single,
            password,
          );

          final row = await endpoints.adminUser.get(
            admin.builder,
            admin.userId,
          );
          expect(row.lastLoginAt, isNotNull);

          final page = await endpoints.adminActivity.list(
            admin.builder,
            AdminActivityListRequest(action: 'auth.sign_in'),
          );
          expect(page.total, 1);
          expect(page.items.single.actorUserId, admin.userId);
        },
      );

      test(
        'a failed login leaves lastLoginAt null and records the failure',
        () async {
          final admin = await makeAdmin('bad');

          await expectLater(
            endpoints.adminAuth.login(
              sessionBuilder,
              createdEmails.single,
              'wrong-password',
            ),
            throwsA(anything),
          );

          final row = await endpoints.adminUser.get(
            admin.builder,
            admin.userId,
          );
          expect(row.lastLoginAt, isNull);

          final page = await endpoints.adminActivity.list(
            admin.builder,
            AdminActivityListRequest(action: 'auth.sign_in_failed'),
          );
          expect(page.total, greaterThanOrEqualTo(1));
        },
      );
    },
  );
}
