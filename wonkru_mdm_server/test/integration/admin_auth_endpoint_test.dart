import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  // Auth services are configured here because the test server does not run
  // `server.dart`.
  setUpAll(() {
    AuthServices.set(
      tokenManagerBuilders: [
        ServerSideSessionsConfig(sessionKeyHashPepper: 'wonkru-test-pepper'),
      ],
      identityProviderBuilders: [
        const EmailIdpConfig(secretHashPepper: 'wonkru-test-secret-pepper'),
      ],
    );
  });

  withServerpod('Given AdminAuthEndpoint', (sessionBuilder, endpoints) {
    const adminUserId = '11111111-1111-4111-8111-111111111111';

    final adminBuilder = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        adminUserId,
        const <Scope>{},
      ),
    );

    group('me', () {
      test('when the session is not authenticated then panel access is '
          'denied but the bootstrap need is still reported.', () async {
        final info = await endpoints.adminAuth.me(sessionBuilder);

        expect(info.status, isNull);
        expect(info.adminProfileId, isNull);
        // With no admin present even an anonymous client must learn that setup
        // is needed, so the panel can show the first-setup form.
        expect(info.needsBootstrap, isTrue);
      });

      test('when the user has no admin profile and none exists then '
          'bootstrap is needed.', () async {
        final info = await endpoints.adminAuth.me(adminBuilder);

        expect(info.status, isNull);
        expect(info.adminProfileId, isNull);
        expect(info.needsBootstrap, isTrue);
      });

      test('when another admin profile exists then bootstrap is not '
          'needed.', () async {
        final now = DateTime.now().toUtc();
        await AdminProfile.db.insertRow(
          sessionBuilder.build(),
          AdminProfile(
            userId: UuidValue.fromString(
              '22222222-2222-4222-8222-222222222222',
            ),
            status: AdminAccountStatus.active,
            createdAt: now,
            updatedAt: now,
          ),
        );

        final info = await endpoints.adminAuth.me(adminBuilder);

        expect(info.status, isNull);
        expect(info.needsBootstrap, isFalse);
      });
    });

    group('me displayName', () {
      Future<void> createAdmin({
        String? fullName,
        String? userName,
        String? email,
      }) async {
        final session = sessionBuilder.build();
        final id = UuidValue.fromString(adminUserId);
        final now = DateTime.now().toUtc();
        await AuthUser.db.insertRow(
          session,
          AuthUser(id: id, scopeNames: const {}),
        );
        await UserProfile.db.insertRow(
          session,
          UserProfile(
            authUserId: id,
            fullName: fullName,
            userName: userName,
            email: email,
          ),
        );
        await AdminProfile.db.insertRow(
          session,
          AdminProfile(
            userId: id,
            status: AdminAccountStatus.active,
            createdAt: now,
            updatedAt: now,
          ),
        );
      }

      test(
        'when the auth profile has a full name then it is returned.',
        () async {
          await createAdmin(
            fullName: 'Ada Lovelace',
            userName: 'ada',
            email: 'ada@example.com',
          );

          final info = await endpoints.adminAuth.me(adminBuilder);

          expect(info.displayName, 'Ada Lovelace');
        },
      );

      test('when only a user name exists then it is returned.', () async {
        await createAdmin(userName: 'ada', email: 'ada@example.com');

        final info = await endpoints.adminAuth.me(adminBuilder);

        expect(info.displayName, 'ada');
      });

      test('when no name exists then the email is returned.', () async {
        await createAdmin(email: 'ada@example.com');

        final info = await endpoints.adminAuth.me(adminBuilder);

        expect(info.displayName, 'ada@example.com');
      });

      test('when no auth profile exists then the id is returned.', () async {
        final now = DateTime.now().toUtc();
        await AdminProfile.db.insertRow(
          sessionBuilder.build(),
          AdminProfile(
            userId: UuidValue.fromString(adminUserId),
            status: AdminAccountStatus.active,
            createdAt: now,
            updatedAt: now,
          ),
        );

        final info = await endpoints.adminAuth.me(adminBuilder);

        expect(info.displayName, adminUserId);
      });
    });

    group('bootstrap', () {
      test('when nothing exists then the first admin is created without a '
          'session.', () async {
        final info = await endpoints.adminAuth.bootstrap(
          sessionBuilder,
          email: 'first-admin@example.com',
          password: 'Str0ng-Test-Password-42!',
          name: 'Administrator',
        );

        expect(info.status, AdminAccountStatus.active);
        expect(info.adminProfileId, isNotNull);
        expect(info.displayName, 'Administrator');
        expect(info.needsBootstrap, isFalse);

        final session = sessionBuilder.build();
        expect(await AdminProfile.db.count(session), 1);
        final profile = await AdminProfile.db.findFirstRow(session);
        expect(profile?.status, AdminAccountStatus.active);
      });

      test(
        'when a profile already exists then bootstrap is rejected.',
        () async {
          await endpoints.adminAuth.bootstrap(
            sessionBuilder,
            email: 'first-admin@example.com',
            password: 'Str0ng-Test-Password-42!',
          );

          await expectLater(
            endpoints.adminAuth.bootstrap(
              sessionBuilder,
              email: 'second@example.com',
              password: 'Str0ng-Test-Password-42!',
            ),
            throwsA(isA<ServerpodInsufficientAccessException>()),
          );

          expect(await AdminProfile.db.count(sessionBuilder.build()), 1);
        },
      );
    });
  });
}
