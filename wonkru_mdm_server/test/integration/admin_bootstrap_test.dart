import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';
import 'package:wonkru_mdm_server/src/service/admin_scope_service.dart';
import 'package:wonkru_mdm_server/src/service/rate_limiter.dart';

import 'test_tools/serverpod_test_tools.dart';

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

  withServerpod('Given AdminAuthEndpoint.bootstrap', (
    sessionBuilder,
    endpoints,
  ) {
    const email = 'first-admin@example.com';
    const password = 'Str0ng-Test-Password-42!';

    late InMemoryRateLimiter originalLimiter;

    setUp(() {
      // `authBootstrap` is limited per window; each test gets a fresh limiter
      // so tests added to the file do not share the quota and get 429s.
      originalLimiter = InMemoryRateLimiter.instance;
      InMemoryRateLimiter.instance = InMemoryRateLimiter();
    });

    tearDown(() {
      InMemoryRateLimiter.instance.stop();
      InMemoryRateLimiter.instance = originalLimiter;
    });

    test('the first admin is created from scratch with the right credentials.', () async {
      final info = await endpoints.adminAuth.bootstrap(
        sessionBuilder,
        email: email,
        password: password,
        name: 'Administrator',
      );

      expect(info.status, AdminAccountStatus.active);
      expect(info.adminProfileId, isNotNull);
      expect(info.displayName, 'Administrator');
      expect(info.needsBootstrap, isFalse);

      final session = sessionBuilder.build();
      expect(await AdminProfile.db.count(session), 1);
      final profile = (await AdminProfile.db.findFirstRow(session))!;
      expect(profile.status, AdminAccountStatus.active);

      final account = await AuthServices.instance.emailIdp.admin.findAccount(
        session,
        email: email,
      );
      expect(account, isNotNull);

      final user = (await AuthUser.db.findById(session, profile.userId))!;
      expect(user.scopeNames, contains(AdminScopeService.admin.name));
    });

    test('a second bootstrap is rejected while an admin exists.', () async {
      await endpoints.adminAuth.bootstrap(
        sessionBuilder,
        email: email,
        password: password,
      );

      await expectLater(
        endpoints.adminAuth.bootstrap(
          sessionBuilder,
          email: 'second@example.com',
          password: password,
        ),
        throwsA(isA<ServerpodInsufficientAccessException>()),
      );

      expect(await AdminProfile.db.count(sessionBuilder.build()), 1);
    });

    test('an empty password is rejected.', () async {
      await expectLater(
        endpoints.adminAuth.bootstrap(
          sessionBuilder,
          email: email,
          password: '',
        ),
        throwsA(anything),
      );

      expect(await AdminProfile.db.count(sessionBuilder.build()), 0);
    });
  });
}
