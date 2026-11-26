import 'package:test/test.dart';
import 'package:wonkru_core_server/wonkru_core_server.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';

import 'test_tools/serverpod_test_tools.dart';
import 'support/device_enrollment.dart';

void main() {
  withServerpod('DeviceEndpoint token verification', (
    sessionBuilder,
    endpoints,
  ) {
    test('config rejects without a token', () async {
      await expectLater(
        endpoints.device.config(
          sessionBuilder,
          DeviceConfigRequest(deviceUuid: 'none', token: ''),
        ),
        throwsA(isA<DeviceUnauthenticatedException>()),
      );
    });

    test('sync rejects without a token', () async {
      await expectLater(
        endpoints.device.sync(
          sessionBuilder,
          DeviceSyncRequest(deviceUuid: 'none', token: '', payload: '{}'),
        ),
        throwsA(isA<DeviceUnauthenticatedException>()),
      );
    });

    test('sync rejects a token from another device', () async {
      final a = await endpoints.device.register(
        sessionBuilder,
        await enrolled(sessionBuilder, model: 'a'),
      );
      final b = await endpoints.device.register(
        sessionBuilder,
        await enrolled(sessionBuilder, model: 'b'),
      );
      await expectLater(
        endpoints.device.sync(
          sessionBuilder,
          DeviceSyncRequest(deviceUuid: a.uuid, token: b.token, payload: '{}'),
        ),
        throwsA(
          isA<DeviceIdentityMismatchException>()
              .having((e) => e.deviceUuid, 'deviceUuid', b.uuid)
              .having((e) => e.deviceCode, 'deviceCode', b.code),
        ),
      );
    });

    test('register returns a token and config works with it', () async {
      final registered = await endpoints.device.register(
        sessionBuilder,
        await enrolled(sessionBuilder, model: 'test'),
      );
      final config = await endpoints.device.config(
        sessionBuilder,
        DeviceConfigRequest(
          deviceUuid: registered.uuid,
          token: registered.token,
        ),
      );
      expect(config.deviceCode, registered.code);
    });

    test('config rejects a token from another device', () async {
      final a = await endpoints.device.register(
        sessionBuilder,
        await enrolled(sessionBuilder, model: 'a'),
      );
      final b = await endpoints.device.register(
        sessionBuilder,
        await enrolled(sessionBuilder, model: 'b'),
      );
      await expectLater(
        endpoints.device.config(
          sessionBuilder,
          DeviceConfigRequest(deviceUuid: a.uuid, token: b.token),
        ),
        throwsA(
          isA<DeviceIdentityMismatchException>().having(
            (e) => e.deviceUuid,
            'deviceUuid',
            b.uuid,
          ),
        ),
      );
    });

    test('a missing/wrong uuid with a valid token returns the identity and '
        'does not open a new device', () async {
      final registered = await endpoints.device.register(
        sessionBuilder,
        await enrolled(sessionBuilder, model: 'identity'),
      );
      final session = sessionBuilder.build();

      await expectLater(
        endpoints.device.config(
          sessionBuilder,
          DeviceConfigRequest(
            deviceUuid: 'locally-generated-random',
            token: registered.token,
          ),
        ),
        throwsA(
          isA<DeviceIdentityMismatchException>()
              .having((e) => e.deviceUuid, 'deviceUuid', registered.uuid)
              .having((e) => e.deviceCode, 'deviceCode', registered.code),
        ),
      );
      expect(
        await Device.db.count(
          session,
          where: (t) => t.uuid.equals('locally-generated-random'),
        ),
        0,
        reason: 'a mismatch must not open a new (ghost) device record',
      );
      expect(
        await Device.db.count(
          session,
          where: (t) => t.model.equals('identity'),
        ),
        1,
      );

      final config = await endpoints.device.config(
        sessionBuilder,
        DeviceConfigRequest(
          deviceUuid: registered.uuid,
          token: registered.token,
        ),
      );
      expect(config.deviceCode, registered.code);
    });
  });
}
