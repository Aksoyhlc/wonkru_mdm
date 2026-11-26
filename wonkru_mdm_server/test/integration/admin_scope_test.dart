import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';
import 'package:wonkru_mdm_server/src/service/admin_scope_service.dart';

import 'test_tools/serverpod_test_tools.dart';

/// `adminAuth` is deliberately not scope-gated: login and the 2FA flow run
/// before a scope is written onto the token.
void main() {
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

  withServerpod('Given admin scope', (sessionBuilder, endpoints) {
    const adminUserId = '11111111-1111-4111-8111-111111111111';
    const scopeLessUserId = '22222222-2222-4222-8222-222222222222';
    const password = 'Str0ng-Test-Password-42!';

    final scopedAdminBuilder = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        adminUserId,
        {AdminScopeService.admin},
      ),
    );

    final scopeLessBuilder = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        scopeLessUserId,
        const <Scope>{},
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

    Future<Set<String>?> scopeNamesOf(UuidValue authUserId) async {
      final user = await AuthUser.db.findById(
        sessionBuilder.build(),
        authUserId,
      );
      return user?.scopeNames;
    }

    group('scope assignment', () {
      test('bootstrap writes scope to the first admin.', () async {
        final info = await endpoints.adminAuth.bootstrap(
          sessionBuilder,
          email: 'bootstrap@example.com',
          password: password,
        );

        final profile = (await AdminProfile.db.findById(
          sessionBuilder.build(),
          info.adminProfileId!,
        ))!;

        expect(
          await scopeNamesOf(profile.userId),
          contains(AdminScopeService.admin.name),
        );
      });

      test('sync grants and revokes scope by account status.', () async {
        final userId = UuidValue.fromString(
          '44444444-4444-4444-8444-444444444444',
        );
        final session = sessionBuilder.build();
        await AuthUser.db.insertRow(
          session,
          AuthUser(id: userId, scopeNames: const {}),
        );

        await AdminScopeService.sync(session, userId, active: true);
        expect(
          await scopeNamesOf(userId),
          contains(AdminScopeService.admin.name),
        );

        await AdminScopeService.sync(session, userId, active: false);
        expect(
          await scopeNamesOf(userId),
          isNot(contains(AdminScopeService.admin.name)),
        );
      });

      test('an active user gains scope on create.', () async {
        await createProfile(adminUserId);

        final row = await endpoints.adminUser.create(
          scopedAdminBuilder,
          AdminUserCreateRequest(
            name: 'Ada Lovelace',
            email: 'ada@example.com',
            password: password,
            status: AdminAccountStatus.active,
            blocked: false,
          ),
        );

        expect(
          await scopeNamesOf(row.authUserId),
          contains(AdminScopeService.admin.name),
        );
      });

      test('a disabled user does not gain scope on create.', () async {
        await createProfile(adminUserId);

        final row = await endpoints.adminUser.create(
          scopedAdminBuilder,
          AdminUserCreateRequest(
            name: 'Ada Lovelace',
            email: 'ada@example.com',
            password: password,
            status: AdminAccountStatus.disabled,
            blocked: false,
          ),
        );

        expect(
          await scopeNamesOf(row.authUserId),
          isNot(contains(AdminScopeService.admin.name)),
        );
      });

      test('update adds and removes scope when the status changes.', () async {
        await createProfile(adminUserId);

        final row = await endpoints.adminUser.create(
          scopedAdminBuilder,
          AdminUserCreateRequest(
            name: 'Ada Lovelace',
            email: 'ada@example.com',
            password: password,
            status: AdminAccountStatus.active,
            blocked: false,
          ),
        );
        expect(
          await scopeNamesOf(row.authUserId),
          contains(AdminScopeService.admin.name),
        );

        await endpoints.adminUser.update(
          scopedAdminBuilder,
          AdminUserUpdateRequest(
            authUserId: row.authUserId,
            name: 'Ada Lovelace',
            email: 'ada@example.com',
            status: AdminAccountStatus.disabled,
            blocked: false,
          ),
        );
        expect(
          await scopeNamesOf(row.authUserId),
          isNot(contains(AdminScopeService.admin.name)),
        );

        await endpoints.adminUser.update(
          scopedAdminBuilder,
          AdminUserUpdateRequest(
            authUserId: row.authUserId,
            name: 'Ada Lovelace',
            email: 'ada@example.com',
            status: AdminAccountStatus.active,
            blocked: false,
          ),
        );
        expect(
          await scopeNamesOf(row.authUserId),
          contains(AdminScopeService.admin.name),
        );
      });
    });

    group('scope enforcement', () {
      test(
        'a token with an active profile but no scope is rejected at an admin '
        'endpoint.',
        () async {
          await createProfile(scopeLessUserId);

          await expectLater(
            endpoints.adminDashboard.deviceStats(scopeLessBuilder),
            throwsA(isA<ServerpodInsufficientAccessException>()),
          );
        },
      );

      test('an active admin carrying scope passes the admin endpoint.', () async {
        await createProfile(adminUserId);

        final stats = await endpoints.adminDashboard.deviceStats(
          scopedAdminBuilder,
        );

        expect(stats.totalDevices, isNotNull);
      });

      test('the adminAuth entrypoint works without scope.', () async {
        await createProfile(scopeLessUserId);

        final info = await endpoints.adminAuth.me(scopeLessBuilder);

        expect(info.status, AdminAccountStatus.active);
        expect(info.totpEnabled, isFalse);
      });
    });

    group('endpoint registry', () {
      test('every panel endpoint except adminAuth requires admin scope.', () {
        final dispatch = sessionBuilder.build().server.endpoints;
        final panelConnectors = dispatch.connectors.values.where(
          (connector) =>
              connector.name.startsWith('admin') &&
              connector.name != 'adminAuth',
        );

        expect(panelConnectors, isNotEmpty);
        for (final connector in panelConnectors) {
          expect(
            connector.endpoint.requiredScopes,
            contains(AdminScopeService.admin),
            reason: '${connector.name} does not require admin scope.',
          );
        }
      });

      test('adminAuth does not require admin scope.', () {
        final dispatch = sessionBuilder.build().server.endpoints;
        final connector = dispatch.getConnectorByName('adminAuth');

        expect(connector, isNotNull);
        expect(connector!.endpoint.requiredScopes, isEmpty);
      });
    });

    group('session scope report', () {
      test(
        'me returns hasAdminScope=false for a token without scope.',
        () async {
          await createProfile(scopeLessUserId);

          final info = await endpoints.adminAuth.me(scopeLessBuilder);

          // The account looks active but the token gets 403 on panel endpoints;
          // the panel uses hasAdminScope to show an access-denied state instead
          // of looping refreshes.
          expect(info.status, AdminAccountStatus.active);
          expect(info.hasAdminScope, isFalse);
        },
      );

      test('me returns hasAdminScope=true for a token carrying scope.', () async {
        await createProfile(adminUserId);

        final info = await endpoints.adminAuth.me(scopedAdminBuilder);

        expect(info.status, AdminAccountStatus.active);
        expect(info.hasAdminScope, isTrue);
      });
    });

    group('startup scope repair', () {
      test('repair grants scope to an active profile that lacks it.', () async {
        final userId = UuidValue.fromString(scopeLessUserId);
        await AuthUser.db.insertRow(
          sessionBuilder.build(),
          AuthUser(id: userId, scopeNames: const {}),
        );
        await createProfile(scopeLessUserId);

        await AdminScopeService.syncAllProfiles(sessionBuilder.build());

        expect(
          await scopeNamesOf(userId),
          contains(AdminScopeService.admin.name),
        );
      });

      test('repair removes scope from a disabled profile that has it.', () async {
        final userId = UuidValue.fromString(scopeLessUserId);
        await AuthUser.db.insertRow(
          sessionBuilder.build(),
          AuthUser(
            id: userId,
            scopeNames: {AdminScopeService.admin.name!},
          ),
        );
        await createProfile(
          scopeLessUserId,
          status: AdminAccountStatus.disabled,
        );

        await AdminScopeService.syncAllProfiles(sessionBuilder.build());

        expect(
          await scopeNamesOf(userId),
          isNot(contains(AdminScopeService.admin.name)),
        );
      });
    });
  });
}
