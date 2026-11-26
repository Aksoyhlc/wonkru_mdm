import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import 'package:wonkru_mdm_server/src/enums/rate_limit_scope.dart';
import 'package:test/test.dart';
import 'package:wonkru_core_server/wonkru_core_server.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';
import 'package:wonkru_mdm_server/src/service/device_auth_service.dart';
import 'package:wonkru_mdm_server/src/service/enrollment_key_service.dart';
import 'package:wonkru_mdm_server/src/service/provisioning_profile_service.dart';
import 'package:wonkru_mdm_server/src/service/rate_limiter.dart';
import 'package:wonkru_mdm_server/src/util/password_hasher.dart';

import 'test_tools/serverpod_test_tools.dart';
import 'support/device_enrollment.dart';

void main() {
  withServerpod('Given device security hardening', (sessionBuilder, endpoints) {
    const adminUserId = '11111111-1111-4111-8111-111111111111';

    final adminBuilder = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        adminUserId,
        {Scope('admin')},
      ),
    );

    Future<void> createAdmin() async {
      await AdminProfile.db.insertRow(
        sessionBuilder.build(),
        AdminProfile(
          userId: UuidValue.fromString(adminUserId),
          status: AdminAccountStatus.active,
        ),
      );
    }

    Future<DeviceRegisterResponse> register([String model = 'test']) async =>
        endpoints.device.register(
          sessionBuilder,
          await enrolled(sessionBuilder, model: model),
        );

    tearDown(() {
      InMemoryRateLimiter.instance.stop();
      InMemoryRateLimiter.instance = InMemoryRateLimiter();
      PasswordHasher.debugPepper = null;
    });

    group('enrollment key', () {
      test('register without a key is rejected with a typed error', () async {
        await expectLater(
          endpoints.device.register(
            sessionBuilder,
            DeviceRegisterRequest(model: 'keyless-register'),
          ),
          throwsA(isA<DeviceEnrollmentRejectedException>()),
        );
        expect(
          await Device.db.count(
            sessionBuilder.build(),
            where: (t) => t.model.equals('keyless-register'),
          ),
          0,
        );
      });

      test('register with a wrong key is rejected', () async {
        await EnrollmentKeyService.current(sessionBuilder.build());

        await expectLater(
          endpoints.device.register(
            sessionBuilder,
            DeviceRegisterRequest(model: 'x', enrollmentKey: 'wrong'),
          ),
          throwsA(isA<DeviceEnrollmentRejectedException>()),
        );
      });

      test('the generated key uses the WNKR-XXXX-XXXX-XXXX format', () async {
        final key = await EnrollmentKeyService.current(sessionBuilder.build());

        expect(key, matches(RegExp(r'^WNKR(-[0-9A-HJKMNP-TV-Z]{4}){3}$')));
        expect(
          await EnrollmentKeyService.current(sessionBuilder.build()),
          key,
          reason: 'the key is generated only once on first use',
        );
      });

      test(
        'register accepts the key without separators and in lowercase',
        () async {
          final key = await EnrollmentKeyService.current(
            sessionBuilder.build(),
          );
          final typed = key.replaceAll('-', '').toLowerCase();

          final response = await endpoints.device.register(
            sessionBuilder,
            DeviceRegisterRequest(model: 'typed-key', enrollmentKey: typed),
          );

          expect(response.token, isNotEmpty);
        },
      );

      test('rotation rejects the old key but keeps enrolled devices', () async {
        await createAdmin();
        final device = await register();
        final oldKey = await endpoints.adminSettings.getEnrollmentKey(
          adminBuilder,
        );

        final newKey = await endpoints.adminSettings.rotateEnrollmentKey(
          adminBuilder,
        );
        expect(newKey, isNot(oldKey));

        await expectLater(
          endpoints.device.register(
            sessionBuilder,
            DeviceRegisterRequest(model: 'x', enrollmentKey: oldKey),
          ),
          throwsA(isA<DeviceEnrollmentRejectedException>()),
        );
        final config = await endpoints.device.config(
          sessionBuilder,
          DeviceConfigRequest(deviceUuid: device.uuid, token: device.token),
        );
        expect(config.deviceCode, device.code);
        expect(
          (await register('after')).token,
          isNotEmpty,
          reason: 'registration works with the new key',
        );
      });

      test('constant time comparison matches only equal strings', () {
        expect(EnrollmentKeyService.constantTimeEquals('abc', 'abc'), isTrue);
        expect(EnrollmentKeyService.constantTimeEquals('abc', 'abd'), isFalse);
        expect(EnrollmentKeyService.constantTimeEquals('abc', 'abcd'), isFalse);
        expect(EnrollmentKeyService.constantTimeEquals('', 'a'), isFalse);
      });

      test('the default QR config carries the current key', () async {
        final session = sessionBuilder.build();
        final config =
            jsonDecode(await ProvisioningProfileService.defaultConfig(session))
                as Map<String, dynamic>;
        final extras =
            config[ProvisioningProfileService.extrasBundleKey]
                as Map<String, dynamic>;

        expect(
          extras['enrollment_key'],
          await EnrollmentKeyService.current(session),
        );
      });

      test('stored profiles drop the key and reads inject the current one', () {
        const stored =
            '{"${ProvisioningProfileService.extrasBundleKey}":'
            '{"device_code":"A","enrollment_key":"old"}}';

        final stripped = ProvisioningProfileService.withEnrollmentKey(
          stored,
          null,
        );
        final injected = ProvisioningProfileService.withEnrollmentKey(
          stripped,
          'new',
        );

        Map<String, dynamic> extras(String raw) =>
            (jsonDecode(raw) as Map<String, dynamic>)[ProvisioningProfileService
                    .extrasBundleKey]
                as Map<String, dynamic>;
        expect(extras(stripped).containsKey('enrollment_key'), isFalse);
        expect(extras(injected)['enrollment_key'], 'new');
        expect(extras(injected)['device_code'], 'A');
        expect(
          ProvisioningProfileService.withEnrollmentKey('{"a":1}', 'new'),
          '{"a":1}',
          reason: 'a document without an extras bundle is left untouched',
        );
      });

      test('profile reads carry the current key after rotation', () async {
        await createAdmin();
        final created = await endpoints.adminProvisioningProfile.create(
          adminBuilder,
          ProvisioningProfile(
            name: 'QR',
            config:
                '{"${ProvisioningProfileService.extrasBundleKey}":'
                '{"device_code":"A","enrollment_key":"old"}}',
          ),
        );
        final raw = await ProvisioningProfile.db.findById(
          sessionBuilder.build(),
          created.id!,
        );
        expect(raw!.config, isNot(contains('enrollment_key')));

        final rotated = await endpoints.adminSettings.rotateEnrollmentKey(
          adminBuilder,
        );
        final fetched = await endpoints.adminProvisioningProfile.get(
          adminBuilder,
          created.id!,
        );
        expect(fetched.config, contains(rotated));
      });
    });

    group('device token at rest', () {
      test('only the SHA-256 of the token is stored', () async {
        final registered = await register();

        final device = await Device.db.findFirstRow(
          sessionBuilder.build(),
          where: (t) => t.uuid.equals(registered.uuid),
        );
        expect(device!.authToken, isNot(registered.token));
        expect(device.authToken, DeviceAuthService.hashToken(registered.token));
      });

      test('the token never reaches the panel serialization', () async {
        final registered = await register();
        final device = await Device.db.findFirstRow(
          sessionBuilder.build(),
          where: (t) => t.uuid.equals(registered.uuid),
        );

        expect(device!.toJsonForProtocol().containsKey('authToken'), isFalse);
      });
    });

    group('field limits', () {
      test('oversized register fields are rejected', () async {
        final key = await EnrollmentKeyService.current(sessionBuilder.build());

        await expectLater(
          endpoints.device.register(
            sessionBuilder,
            DeviceRegisterRequest(model: 'm' * 256, enrollmentKey: key),
          ),
          throwsA(
            isA<DeviceRequestInvalidException>().having(
              (e) => e.field,
              'field',
              'model',
            ),
          ),
        );
        await expectLater(
          endpoints.device.register(
            sessionBuilder,
            DeviceRegisterRequest(enrollmentKey: 'k' * 257),
          ),
          throwsA(isA<DeviceRequestInvalidException>()),
        );
      });

      test(
        'sync skips oversized package names and truncates app names',
        () async {
          final registered = await register();

          await endpoints.device.sync(
            sessionBuilder,
            DeviceSyncRequest(
              deviceUuid: registered.uuid,
              token: registered.token,
              payload: jsonEncode({
                'apps': {
                  'userApps': [
                    {'packageName': 'p' * 300, 'appName': 'Bad'},
                    {'packageName': 'com.example.ok', 'appName': 'a' * 400},
                  ],
                },
              }),
            ),
          );

          final apps = await DeviceApplication.db.find(sessionBuilder.build());
          expect(apps.map((a) => a.packageName), ['com.example.ok']);
          expect(apps.single.appName.length, 255);
        },
      );

      test('oversized passwords are rejected before hashing', () async {
        final registered = await register();

        await expectLater(
          endpoints.device.passwordCheck(
            sessionBuilder,
            DevicePasswordCheckRequest(
              deviceUuid: registered.uuid,
              token: registered.token,
              password: 'x' * 257,
            ),
          ),
          throwsA(isA<DeviceRequestInvalidException>()),
        );
      });
    });

    group('sync secrets', () {
      test('credential keys are stripped from stored st/bs info', () async {
        final registered = await register();

        await endpoints.device.sync(
          sessionBuilder,
          DeviceSyncRequest(
            deviceUuid: registered.uuid,
            token: registered.token,
            payload: jsonEncode({
              'st': {
                'deviceToken': registered.token,
                'enrollmentKey': 'secret',
                'commandJournal': '[]',
                'lastSync': 1,
              },
              'bs': {'enrollment_key': 'secret', 'server_url': 'http://x'},
            }),
          ),
        );

        final sync = await DeviceSync.db.findFirstRow(sessionBuilder.build());
        final st = jsonDecode(sync!.stInfo!) as Map<String, dynamic>;
        final bs = jsonDecode(sync.bsInfo!) as Map<String, dynamic>;
        expect(st, {'lastSync': 1});
        expect(bs, {'server_url': 'http://x'});
      });
    });

    group('passwordCheck per policy', () {
      test('devices sharing a policy share one attempt budget', () async {
        PasswordHasher.debugPepper = 'test-pepper';
        InMemoryRateLimiter.instance = InMemoryRateLimiter(
          policies: {
            RateLimitScope.devicePasswordCheckPolicy: const RateLimitPolicy(
              maxRequests: 2,
              window: Duration(minutes: 5),
            ),
          },
        );

        final session = sessionBuilder.build();
        final policy = await Policy.db.insertRow(
          session,
          Policy(
            name: 'Locked',
            adminPassword: await PasswordHasher.hash('correct'),
          ),
        );
        final devices = [await register('a'), await register('b')];
        for (final registered in devices) {
          await Device.db.updateWhere(
            session,
            where: (t) => t.uuid.equals(registered.uuid),
            columnValues: (t) => [t.policyId(policy.id)],
          );
        }

        Future<bool> check(DeviceRegisterResponse device) =>
            endpoints.device.passwordCheck(
              sessionBuilder,
              DevicePasswordCheckRequest(
                deviceUuid: device.uuid,
                token: device.token,
                password: 'wrong',
              ),
            );

        expect(await check(devices[0]), isFalse);
        expect(await check(devices[1]), isFalse);
        await expectLater(
          check(devices[0]),
          throwsA(isA<RateLimitExceededException>()),
        );
      });
    });
  });
}
