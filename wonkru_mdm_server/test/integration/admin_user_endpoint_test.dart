import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';

import 'support/matchers.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  /// The auth module keeps its managers in a global, which `server.dart` fills in
  /// when the server boots. The test server never runs that method, so the tests
  /// register the same services with test-only secrets.
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

  withServerpod('Given AdminUserEndpoint', (sessionBuilder, endpoints) {
    const adminUserId = '11111111-1111-4111-8111-111111111111';
    const password = 'Str0ng-Test-Password-42!';

    final adminBuilder = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        adminUserId,
        {Scope('admin')},
      ),
    );

    Future<void> createProfile(
      String userId, {
      AdminAccountStatus status = AdminAccountStatus.active,
    }) {
      return AdminProfile.db.insertRow(
        sessionBuilder.build(),
        AdminProfile(
          userId: UuidValue.fromString(userId),
          status: status,
        ),
      );
    }

    Future<AdminUserRow> createUser({
      String? name = 'Ada Lovelace',
      String email = 'ada@example.com',
      AdminAccountStatus status = AdminAccountStatus.active,
      bool blocked = false,
    }) {
      return endpoints.adminUser.create(
        adminBuilder,
        AdminUserCreateRequest(
          name: name,
          email: email,
          password: password,
          status: status,
          blocked: blocked,
        ),
      );
    }

    group('create', () {
      test(
        'when a user is created then the four auth tables are filled.',
        () async {
          await createProfile(adminUserId);

          final row = await createUser(status: AdminAccountStatus.active);

          expect(row.name, 'Ada Lovelace');
          expect(row.email, 'ada@example.com');
          expect(row.hasPassword, isTrue);
          expect(row.blocked, isFalse);
          expect(row.status, AdminAccountStatus.active);
          expect(row.createdAt, isNotNull);

          final session = sessionBuilder.build();
          expect(await AuthUser.db.count(session), 1);

          final profile = await UserProfile.db.findFirstRow(session);
          expect(profile?.fullName, 'Ada Lovelace');
          expect(profile?.email, 'ada@example.com');

          final account = await EmailAccount.db.findFirstRow(session);
          expect(account?.email, 'ada@example.com');
          expect(account?.hasPassword, isTrue);
          expect(account?.authUserId, row.authUserId);

          final adminProfile = await AdminProfile.db.findFirstRow(
            session,
            where: (t) => t.userId.equals(row.authUserId),
          );
          expect(adminProfile?.status, AdminAccountStatus.active);
          expect(adminProfile?.createdAt, isNotNull);
        },
      );

      test('when the panel sends a mixed case email then it is stored in lower '
          'case.', () async {
        await createProfile(adminUserId);

        final row = await createUser(email: '  Ada@Example.COM ');

        expect(row.email, 'ada@example.com');
      });

      test('when the email is taken then the user is not created.', () async {
        await createProfile(adminUserId);
        await createUser();

        await expectLater(
          createUser(name: 'Someone Else', email: 'ada@example.com'),
          throwsExceptionWith('ada@example.com is already in use.'),
        );

        expect(await AuthUser.db.count(sessionBuilder.build()), 1);
      });

      test('when no password is given then the user is rejected.', () async {
        await createProfile(adminUserId);

        await expectLater(
          endpoints.adminUser.create(
            adminBuilder,
            AdminUserCreateRequest(
              name: 'No Password',
              email: 'nopassword@example.com',
              password: '',
              status: AdminAccountStatus.active,
              blocked: false,
            ),
          ),
          throwsExceptionWith('A password is required to create a user.'),
        );
      });
    });

    group('list', () {
      test('when users exist then the requested page is returned in '
          'order.', () async {
        await createProfile(adminUserId);
        for (var index = 1; index <= 3; index++) {
          await createUser(
            name: 'User $index',
            email: 'user$index@example.com',
          );
        }

        final page = await endpoints.adminUser.list(
          adminBuilder,
          AdminListRequest(page: 2, perPage: 2),
        );

        expect(page.total, 3);
        expect(page.page, 2);
        expect(page.perPage, 2);
        expect(page.items.single.name, 'User 1');
      });

      test('when a search matches a name then only that user is '
          'returned.', () async {
        await createProfile(adminUserId);
        await createUser(name: 'Grace Hopper', email: 'grace@example.com');
        await createUser(name: 'Alan Turing', email: 'alan@example.com');

        final page = await endpoints.adminUser.list(
          adminBuilder,
          AdminListRequest(search: 'Hopper'),
        );

        expect(page.total, 1);
        expect(page.items.single.name, 'Grace Hopper');
      });

      test('when a search matches an email then only that user is '
          'returned.', () async {
        await createProfile(adminUserId);
        await createUser(name: 'Grace Hopper', email: 'grace@example.com');
        await createUser(name: 'Alan Turing', email: 'alan@example.com');

        final page = await endpoints.adminUser.list(
          adminBuilder,
          AdminListRequest(search: 'alan@'),
        );

        expect(page.total, 1);
        expect(page.items.single.name, 'Alan Turing');
      });

      test('when nothing matches then no user is returned.', () async {
        await createProfile(adminUserId);

        final page = await endpoints.adminUser.list(
          adminBuilder,
          AdminListRequest(search: 'nobody'),
        );

        expect(page.total, 0);
        expect(page.items, isEmpty);
      });
    });

    group('get', () {
      test('when the user exists then it is returned.', () async {
        await createProfile(adminUserId);
        final created = await createUser();

        final fetched = await endpoints.adminUser.get(
          adminBuilder,
          created.authUserId,
        );

        expect(fetched.email, 'ada@example.com');
      });

      test('when the user does not exist then it is rejected.', () async {
        await createProfile(adminUserId);

        await expectLater(
          endpoints.adminUser.get(
            adminBuilder,
            UuidValue.fromString('99999999-9999-4999-8999-999999999999'),
          ),
          throwsExceptionWith(
            'User 99999999-9999-4999-8999-999999999999 does not exist.',
          ),
        );
      });
    });

    group('update', () {
      test('when a user is edited then every table follows.', () async {
        await createProfile(adminUserId);
        final created = await createUser();

        final saved = await endpoints.adminUser.update(
          adminBuilder,
          AdminUserUpdateRequest(
            authUserId: created.authUserId,
            name: 'Ada Byron',
            email: 'byron@example.com',
            status: AdminAccountStatus.disabled,
            blocked: true,
          ),
        );

        expect(saved.name, 'Ada Byron');
        expect(saved.email, 'byron@example.com');
        expect(saved.status, AdminAccountStatus.disabled);
        expect(saved.blocked, isTrue);

        final session = sessionBuilder.build();
        final profile = await UserProfile.db.findFirstRow(session);
        expect(profile?.fullName, 'Ada Byron');
        expect(profile?.email, 'byron@example.com');
        expect(
          (await EmailAccount.db.findFirstRow(session))?.email,
          'byron@example.com',
        );

        final authUser = await AuthUser.db.findById(
          session,
          created.authUserId,
        );
        expect(authUser?.blocked, isTrue);
      });

      test('when the email does not change then the account keeps its '
          'password.', () async {
        await createProfile(adminUserId);
        final created = await createUser();

        final before = await EmailAccount.db.findFirstRow(
          sessionBuilder.build(),
        );

        await endpoints.adminUser.update(
          adminBuilder,
          AdminUserUpdateRequest(
            authUserId: created.authUserId,
            name: 'Ada Lovelace',
            email: 'ada@example.com',
            status: AdminAccountStatus.active,
            blocked: false,
          ),
        );

        final after = await EmailAccount.db.findFirstRow(
          sessionBuilder.build(),
        );
        expect(after?.id, before?.id);
        expect(after?.passwordHash, before?.passwordHash);
      });

      test('when a password is given then the stored hash changes.', () async {
        await createProfile(adminUserId);
        final created = await createUser();

        final before = await EmailAccount.db.findFirstRow(
          sessionBuilder.build(),
        );

        await endpoints.adminUser.update(
          adminBuilder,
          AdminUserUpdateRequest(
            authUserId: created.authUserId,
            name: 'Ada Lovelace',
            email: 'ada@example.com',
            password: 'An0ther-Test-Password-84!',
            status: AdminAccountStatus.active,
            blocked: false,
          ),
        );

        final after = await EmailAccount.db.findFirstRow(
          sessionBuilder.build(),
        );
        expect(after?.passwordHash, isNot(before?.passwordHash));
      });

      test(
        'when the user does not exist then the update is rejected.',
        () async {
          await createProfile(adminUserId);

          await expectLater(
            endpoints.adminUser.update(
              adminBuilder,
              AdminUserUpdateRequest(
                authUserId: UuidValue.fromString(
                  '99999999-9999-4999-8999-999999999999',
                ),
                name: 'Nobody',
                email: 'nobody@example.com',
                status: AdminAccountStatus.active,
                blocked: false,
              ),
            ),
            throwsExceptionWith(
              'User 99999999-9999-4999-8999-999999999999 does not exist.',
            ),
          );
        },
      );
    });

    group('delete', () {
      test('when a user is deleted then the auth rows and the admin profile '
          'go away.', () async {
        await createProfile(adminUserId);
        final created = await createUser();

        final deleted = await endpoints.adminUser.delete(adminBuilder, [
          created.authUserId,
        ]);

        expect(deleted, 1);

        final session = sessionBuilder.build();
        expect(await AuthUser.db.count(session), 0);
        expect(await UserProfile.db.count(session), 0);
        expect(await EmailAccount.db.count(session), 0);
        expect(
          await AdminProfile.db.findFirstRow(
            session,
            where: (t) => t.userId.equals(created.authUserId),
          ),
          isNull,
        );
      });

      test(
        'when the batch includes the caller then nothing is deleted.',
        () async {
          // All-or-nothing: a partial delete would leave the panel orphaned.
          await createProfile(adminUserId);
          final created = await createUser();

          await expectLater(
            endpoints.adminUser.delete(adminBuilder, [
              created.authUserId,
              UuidValue.fromString(adminUserId),
            ]),
            throwsExceptionWith('own account'),
          );

          final session = sessionBuilder.build();
          expect(
            await AuthUser.db.findById(session, created.authUserId),
            isNotNull,
          );
          expect(
            await AdminProfile.db.count(
              session,
              where: (t) => t.userId.equals(UuidValue.fromString(adminUserId)),
            ),
            1,
          );
        },
      );

      test('when a user with 2FA sessions is deleted then those verification '
          'rows go too.', () async {
        await createProfile(adminUserId);
        final created = await createUser();
        final now = DateTime.now().toUtc();
        await AdminTotpSession.db.insertRow(
          sessionBuilder.build(),
          AdminTotpSession(
            userId: created.authUserId,
            sessionId: 'silinecek-oturum',
            verifiedUntil: now.add(const Duration(hours: 1)),
            createdAt: now,
          ),
        );

        await endpoints.adminUser.delete(adminBuilder, [created.authUserId]);

        expect(
          await AdminTotpSession.db.count(
            sessionBuilder.build(),
            where: (t) => t.userId.equals(created.authUserId),
          ),
          0,
        );
      });

      test('when no user is given then nothing is deleted.', () async {
        await createProfile(adminUserId);

        expect(await endpoints.adminUser.delete(adminBuilder, []), 0);
      });

      test('when the user does not exist then nothing is deleted.', () async {
        await createProfile(adminUserId);

        expect(
          await endpoints.adminUser.delete(adminBuilder, [
            UuidValue.fromString('99999999-9999-4999-8999-999999999999'),
          ]),
          0,
        );
      });
    });
  });
}
