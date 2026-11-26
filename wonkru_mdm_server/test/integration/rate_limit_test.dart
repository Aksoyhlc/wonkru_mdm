import 'dart:io';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:wonkru_mdm_server/src/enums/rate_limit_scope.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';
import 'package:wonkru_core_server/wonkru_core_server.dart' hide LogLevel;
import 'package:wonkru_mdm_server/src/generated/protocol.dart';
import 'package:wonkru_mdm_server/src/service/rate_limiter.dart';
import 'package:wonkru_mdm_server/src/web/routes/local_ca_route.dart';

import 'test_tools/serverpod_test_tools.dart';
import 'support/device_enrollment.dart';

void main() {
  withServerpod('Rate limit', (sessionBuilder, endpoints) {
    late InMemoryRateLimiter original;

    setUpAll(() {
      // The test server does not run `server.dart`, so the auth services are
      // set up here; this writes a scope for the bootstrap auth user.
      AuthServices.set(
        tokenManagerBuilders: [
          ServerSideSessionsConfig(sessionKeyHashPepper: 'wonkru-test-pepper'),
        ],
        identityProviderBuilders: [
          const EmailIdpConfig(secretHashPepper: 'wonkru-test-secret-pepper'),
        ],
      );
    });

    setUp(() {
      original = InMemoryRateLimiter.instance;
      InMemoryRateLimiter.instance = InMemoryRateLimiter();
    });

    tearDown(() {
      InMemoryRateLimiter.instance.stop();
      InMemoryRateLimiter.instance = original;
    });

    void tighten(Map<RateLimitScope, RateLimitPolicy> policies) {
      InMemoryRateLimiter.instance.stop();
      InMemoryRateLimiter.instance = InMemoryRateLimiter(policies: policies);
    }

    test(
      'register is limited per client IP and throws a typed exception.',
      () async {
        tighten({
          RateLimitScope.deviceRegister: const RateLimitPolicy(
            maxRequests: 2,
            window: Duration(minutes: 5),
          ),
        });

        await endpoints.device.register(
          sessionBuilder,
          await enrolled(sessionBuilder, model: 'a'),
        );
        await endpoints.device.register(
          sessionBuilder,
          await enrolled(sessionBuilder, model: 'b'),
        );

        await expectLater(
          endpoints.device.register(
            sessionBuilder,
            await enrolled(sessionBuilder, model: 'c'),
          ),
          throwsA(
            isA<RateLimitExceededException>().having(
              (e) => e.retryAfterSeconds,
              'retryAfterSeconds',
              greaterThanOrEqualTo(1),
            ),
          ),
        );
      },
    );

    test(
      'report is limited by the device uuid key; other devices are unaffected.',
      () async {
        tighten({
          RateLimitScope.deviceReport: const RateLimitPolicy(
            maxRequests: 2,
            window: Duration(minutes: 5),
          ),
        });

        final a = await endpoints.device.register(
          sessionBuilder,
          await enrolled(sessionBuilder, model: 'a'),
        );
        final b = await endpoints.device.register(
          sessionBuilder,
          await enrolled(sessionBuilder, model: 'b'),
        );

        Future<bool> report(DeviceRegisterResponse device) =>
            endpoints.device.report(
              sessionBuilder,
              DeviceReportRequest(
                deviceUuid: device.uuid,
                token: device.token,
                type: 'audit',
                payload: '{}',
              ),
            );

        expect(await report(a), isTrue);
        expect(await report(a), isTrue);

        await expectLater(
          report(a),
          throwsA(isA<RateLimitExceededException>()),
        );

        expect(await report(b), isTrue);
      },
    );

    test('passwordCheck is limited per device.', () async {
      tighten({
        RateLimitScope.devicePasswordCheck: const RateLimitPolicy(
          maxRequests: 2,
          window: Duration(minutes: 5),
        ),
      });

      final device = await endpoints.device.register(
        sessionBuilder,
        await enrolled(sessionBuilder, model: 'a'),
      );

      Future<bool> check() => endpoints.device.passwordCheck(
        sessionBuilder,
        DevicePasswordCheckRequest(
          deviceUuid: device.uuid,
          token: device.token,
          password: 'wrong',
        ),
      );

      // No policy is assigned, so the endpoint returns false, but the request
      // is still counted.
      expect(await check(), isFalse);
      expect(await check(), isFalse);

      await expectLater(check(), throwsA(isA<RateLimitExceededException>()));
    });

    test('bootstrap is limited per client IP.', () async {
      tighten({
        RateLimitScope.authBootstrap: const RateLimitPolicy(
          maxRequests: 1,
          window: Duration(minutes: 5),
        ),
      });
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
        throwsA(isA<RateLimitExceededException>()),
      );
    });

    test('the web route returns 429 and Retry-After on rate limit.', () async {
      tighten({
        RateLimitScope.webLocalCa: const RateLimitPolicy(
          maxRequests: 1,
          window: Duration(minutes: 5),
        ),
      });

      final dir = await Directory.systemTemp.createTemp('rate-limit-ca');
      addTearDown(() => dir.delete(recursive: true));
      final file = File('${dir.path}/local-ca.crt');
      await file.writeAsBytes(
        Uint8List.fromList(List<int>.generate(16, (i) => i)),
      );

      final session = sessionBuilder.build();
      addTearDown(session.close);
      final route = LocalCaRoute(caPath: file.path);

      Request buildRequest() => RequestInternal.create(
        Method.get,
        Uri.parse('http://localhost:8082/downloads/local-ca'),
        Object(),
      );

      final first = await route.handleCall(session, buildRequest());
      expect(first.statusCode, 200);

      final second = await route.handleCall(session, buildRequest());
      expect(second.statusCode, 429);
      expect(second.headers['retry-after'], isNotNull);
    });
  });
}
