import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';
import 'package:wonkru_mdm_server/src/service/admin_recovery_service.dart';
import 'package:wonkru_mdm_server/src/service/admin_scope_service.dart';

import 'support/admin_fixture.dart';
import 'test_tools/serverpod_test_tools.dart';

/// `emailIdp.login` opens its own transaction, which the rollback test proxy
/// rejects; rollback is disabled and every test cleans up its own rows.
void main() {
  setUpAll(installTestAuthServices);

  withServerpod(
    'Given AdminRecoveryService',
    rollbackDatabase: RollbackDatabase.disabled,
    (sessionBuilder, endpoints) {
      const oldPassword = 'Old-Password-42!';
      const newPassword = 'New-Password-84!';

      final createdUserIds = <UuidValue>{};
      final createdEmails = <String>{};

      Future<TestAdmin> makeAdmin(String prefix) async {
        final email =
            '$prefix-${DateTime.now().microsecondsSinceEpoch}@example.com';
        final admin = await createEmailAdmin(
          sessionBuilder.build(),
          sessionBuilder,
          email: email,
          password: oldPassword,
        );
        createdUserIds.add(admin.userId);
        createdEmails.add(email);
        return admin;
      }

      Future<void> trackUser(UuidValue userId) async {
        createdUserIds.add(userId);
      }

      tearDown(() async {
        final session = sessionBuilder.build();
        if (createdUserIds.isEmpty) return;

        final targetIds = createdUserIds.map((id) => id.toString()).toSet();
        await AdminActivity.db.deleteWhere(
          session,
          where: (t) =>
              t.actorUserId.inSet(createdUserIds) |
              t.actorEmail.inSet(createdEmails) |
              (t.action.equals('auth.cli_password_reset') &
                  t.targetId.inSet(targetIds)),
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

      test('resets the password of an existing admin', () async {
        final admin = await makeAdmin('reset');
        final session = sessionBuilder.build();

        final result = await AdminRecoveryService.resetPassword(
          session,
          email: createdEmails.single,
          password: newPassword,
        );

        expect(result.userCreated, isFalse);
        expect(result.profileCreated, isFalse);
        expect(result.sessionsRevoked, isTrue);

        final success = await AuthServices.instance.emailIdp.login(
          session,
          email: createdEmails.single,
          password: newPassword,
        );
        expect(success.authUserId, admin.userId);

        await expectLater(
          AuthServices.instance.emailIdp.login(
            session,
            email: createdEmails.single,
            password: oldPassword,
          ),
          throwsA(anything),
        );
      });

      test('revokes active sessions by default', () async {
        final admin = await makeAdmin('revoke');
        final session = sessionBuilder.build();
        await AuthServices.instance.emailIdp.login(
          session,
          email: createdEmails.single,
          password: oldPassword,
        );

        expect(
          await AuthServices.instance.tokenManager.listTokens(
            session,
            authUserId: admin.userId,
          ),
          isNotEmpty,
        );

        await AdminRecoveryService.resetPassword(
          session,
          email: createdEmails.single,
          password: newPassword,
        );

        expect(
          await AuthServices.instance.tokenManager.listTokens(
            session,
            authUserId: admin.userId,
          ),
          isEmpty,
        );
      });

      test('keeps sessions when revokeSessions is false', () async {
        final admin = await makeAdmin('keep');
        final session = sessionBuilder.build();
        await AuthServices.instance.emailIdp.login(
          session,
          email: createdEmails.single,
          password: oldPassword,
        );

        await AdminRecoveryService.resetPassword(
          session,
          email: createdEmails.single,
          password: newPassword,
          revokeSessions: false,
        );

        expect(
          await AuthServices.instance.tokenManager.listTokens(
            session,
            authUserId: admin.userId,
          ),
          isNotEmpty,
        );
      });

      test('rejects an unknown email unless createUser is set', () async {
        final session = sessionBuilder.build();

        await expectLater(
          AdminRecoveryService.resetPassword(
            session,
            email: 'missing@example.com',
            password: newPassword,
          ),
          throwsA(isA<AdminRecoveryException>()),
        );
      });

      test('creates a working admin with createUser and grantAdmin', () async {
        const createdEmail = 'new-admin@example.com';
        final session = sessionBuilder.build();

        final result = await AdminRecoveryService.resetPassword(
          session,
          email: createdEmail,
          password: newPassword,
          createUser: true,
          grantAdmin: true,
          name: 'New Admin',
        );
        await trackUser(result.authUserId);

        expect(result.userCreated, isTrue);
        expect(result.profileCreated, isTrue);
        expect(result.authUserId, isNotNull);

        final success = await AuthServices.instance.emailIdp.login(
          session,
          email: createdEmail,
          password: newPassword,
        );
        final user = (await AuthUser.db.findById(session, success.authUserId))!;
        expect(user.scopeNames, contains(AdminScopeService.admin.name));

        final profile = await AdminProfile.db.findFirstRow(
          session,
          where: (t) => t.userId.equals(success.authUserId),
        );
        expect(profile?.status, AdminAccountStatus.active);
      });

      test('requires grantAdmin when the account has no profile', () async {
        const userOnlyEmail = 'user-only@example.com';
        final session = sessionBuilder.build();
        final authUser = await AuthServices.instance.authUsers.create(session);
        await trackUser(authUser.id);
        await AuthServices.instance.emailIdp.admin.createEmailAuthentication(
          session,
          authUserId: authUser.id,
          email: userOnlyEmail,
          password: oldPassword,
        );

        await expectLater(
          AdminRecoveryService.resetPassword(
            session,
            email: userOnlyEmail,
            password: newPassword,
          ),
          throwsA(isA<AdminRecoveryException>()),
        );

        // The failed attempt must not have changed the password first.
        await expectLater(
          AuthServices.instance.emailIdp.login(
            session,
            email: userOnlyEmail,
            password: newPassword,
          ),
          throwsA(anything),
        );
        await AuthServices.instance.emailIdp.login(
          session,
          email: userOnlyEmail,
          password: oldPassword,
        );

        final result = await AdminRecoveryService.resetPassword(
          session,
          email: userOnlyEmail,
          password: newPassword,
          grantAdmin: true,
        );
        expect(result.profileCreated, isTrue);
      });

      test('createUser alone creates a panel admin', () async {
        const createdEmail = 'created-alone@example.com';
        final session = sessionBuilder.build();

        final result = await AdminRecoveryService.resetPassword(
          session,
          email: createdEmail,
          password: newPassword,
          createUser: true,
        );
        await trackUser(result.authUserId);

        expect(result.userCreated, isTrue);
        expect(result.profileCreated, isTrue);

        final success = await AuthServices.instance.emailIdp.login(
          session,
          email: createdEmail,
          password: newPassword,
        );
        expect(success.scopeNames, contains(AdminScopeService.admin.name));
      });

      test('clearTotp wipes the stored secret', () async {
        final admin = await makeAdmin('totp');
        final session = sessionBuilder.build();
        admin.profile
          ..totpSecret = 'encrypted-secret'
          ..recoveryCodes = 'recovery-codes';
        await AdminProfile.db.updateRow(session, admin.profile);

        final result = await AdminRecoveryService.resetPassword(
          session,
          email: createdEmails.single,
          password: newPassword,
          clearTotp: true,
        );

        expect(result.totpCleared, isTrue);
        final updated = (await AdminProfile.db.findFirstRow(
          session,
          where: (t) => t.userId.equals(admin.userId),
        ))!;
        expect(updated.totpSecret, isNull);
        expect(updated.recoveryCodes, isNull);
      });

      test('writes an audit row for the reset', () async {
        final admin = await makeAdmin('audit');
        final session = sessionBuilder.build();

        await AdminRecoveryService.resetPassword(
          session,
          email: createdEmails.single,
          password: newPassword,
        );

        final activity = await AdminActivity.db.findFirstRow(
          session,
          where: (t) =>
              t.action.equals('auth.cli_password_reset') &
              t.targetId.equals(admin.userId.toString()),
        );
        expect(activity, isNotNull);
        expect(activity!.actorEmail, 'cli');
      });

      test('lists admins without secrets', () async {
        final admin = await makeAdmin('list');
        final session = sessionBuilder.build();

        final admins = await AdminRecoveryService.listAdmins(session);
        final entry = admins.where((a) => a.authUserId == admin.userId).single;

        expect(entry.email, createdEmails.single);
        expect(entry.status, AdminAccountStatus.active);
        expect(entry.hasPassword, isTrue);
        expect(entry.totpEnabled, isFalse);
      });
    },
  );
}
