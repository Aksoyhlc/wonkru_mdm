import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import 'support/admin_fixture.dart';
import 'test_tools/serverpod_test_tools.dart';

/// `changePassword` / `changeEmail` only change the caller's own account.
/// Without the ownership check any admin could take over another admin's
/// account; this file tests exactly that door.
void main() {
  setUpAll(installTestAuthServices);

  withServerpod('Given admin credential changes', (sessionBuilder, endpoints) {
    late TestAdmin ada;
    late TestAdmin bob;

    setUp(() async {
      final session = sessionBuilder.build();
      ada = await createEmailAdmin(
        session,
        sessionBuilder,
        email: 'ada@example.com',
        password: 'ada-password-123',
      );
      bob = await createEmailAdmin(
        session,
        sessionBuilder,
        email: 'bob@example.com',
        password: 'bob-password-123',
      );
    });

    // `emailIdp.login` records a failed attempt outside the transaction and
    // does not work on the rolled-back test database, so the stored account is
    // read directly.
    Future<EmailAccount?> accountOf(String email) =>
        EmailAccount.db.findFirstRow(
          sessionBuilder.build(),
          where: (t) => t.email.equals(email),
        );

    Future<String> hashOf(String email) async =>
        (await accountOf(email))!.passwordHash;

    group('changePassword', () {
      test('changes the password of their own account', () async {
        final before = await hashOf('ada@example.com');

        await endpoints.adminAuth.changePassword(
          ada.builder,
          'ada@example.com',
          'ada-new-password',
        );

        expect(await hashOf('ada@example.com'), isNot(before));
      });

      test('cannot change another admin\'s password', () async {
        final before = await hashOf('bob@example.com');

        await expectLater(
          endpoints.adminAuth.changePassword(
            ada.builder,
            'bob@example.com',
            'taken-over',
          ),
          throwsA(isA<ServerpodInsufficientAccessException>()),
        );

        expect(await hashOf('bob@example.com'), before);
      });

      test('access is denied for a nonexistent account', () async {
        await expectLater(
          endpoints.adminAuth.changePassword(
            ada.builder,
            'missing@example.com',
            'x-password-123',
          ),
          throwsA(isA<ServerpodInsufficientAccessException>()),
        );
      });
    });

    group('changeEmail', () {
      Future<String?> profileEmail(TestAdmin admin) async =>
          (await UserProfile.db.findFirstRow(
            sessionBuilder.build(),
            where: (t) => t.authUserId.equals(admin.userId),
          ))?.email;

      test(
        'changes the email in the account and profile, normalizing it',
        () async {
          await endpoints.adminAuth.changeEmail(
            ada.builder,
            'ada@example.com',
            '  Ada.New@Example.COM ',
          );

          final moved = await accountOf('ada.new@example.com');
          expect(moved?.authUserId, ada.userId);
          expect(await accountOf('ada@example.com'), isNull);
          expect(await profileEmail(ada), 'ada.new@example.com');
        },
      );

      test('cannot change another admin\'s email', () async {
        await expectLater(
          endpoints.adminAuth.changeEmail(
            ada.builder,
            'bob@example.com',
            'attacker@example.com',
          ),
          throwsA(isA<ServerpodInsufficientAccessException>()),
        );

        expect((await accountOf('bob@example.com'))?.authUserId, bob.userId);
        expect(await accountOf('attacker@example.com'), isNull);
        expect(await profileEmail(bob), 'bob@example.com');
      });

      test(
        'cannot switch to an email used by another account; nothing changes',
        () async {
          await expectLater(
            endpoints.adminAuth.changeEmail(
              ada.builder,
              'ada@example.com',
              'BOB@example.com',
            ),
            throwsA(
              isA<Exception>().having(
                (e) => e.toString(),
                'message',
                contains('already in use'),
              ),
            ),
          );

          expect((await accountOf('ada@example.com'))?.authUserId, ada.userId);
          expect((await accountOf('bob@example.com'))?.authUserId, bob.userId);
          expect(await profileEmail(ada), 'ada@example.com');
        },
      );

      test(
        'can switch to their own current email (with a case difference)',
        () async {
          await endpoints.adminAuth.changeEmail(
            ada.builder,
            'ada@example.com',
            'ADA@example.com',
          );

          expect((await accountOf('ada@example.com'))?.authUserId, ada.userId);
        },
      );
    });
  });
}
