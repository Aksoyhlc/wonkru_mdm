import 'package:test/test.dart';
import 'package:wonkru_core_server/wonkru_core_server.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';
import 'package:wonkru_mdm_server/src/service/device_auth_service.dart';
import 'package:wonkru_mdm_server/src/service/device_service.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given DeviceAuthService.requireDevice', (
    sessionBuilder,
    endpoints,
  ) {
    Future<void> enrollDevice() async {
      final session = sessionBuilder.build();
      await Device.db.insertRow(
        session,
        Device(
          code: 'AUTH-1',
          uuid: 'uuid-auth-1',
          authToken: DeviceAuthService.hashToken('token-auth-1'),
        ),
      );
    }

    test('when the token matches then the device is returned.', () async {
      await enrollDevice();

      final device = await DeviceAuthService.requireDevice(
        sessionBuilder.build(),
        'token-auth-1',
      );

      expect(device.uuid, 'uuid-auth-1');
    });

    test('when the stored value itself is sent then it throws.', () async {
      // The DB stores only the hash; a leaked hash is not a usable credential.
      await enrollDevice();

      await expectLater(
        DeviceAuthService.requireDevice(
          sessionBuilder.build(),
          DeviceAuthService.hashToken('token-auth-1'),
        ),
        throwsA(isA<DeviceUnauthenticatedException>()),
      );
    });

    test('the hash is lowercase hex SHA-256 and never looks like a token.', () {
      final hash = DeviceAuthService.hashToken('token-auth-1');

      expect(DeviceAuthService.hashPattern.hasMatch(hash), isTrue);
      // Real tokens are 43-char base64url; the migration SQL has to tell the
      // two formats apart.
      expect(
        DeviceAuthService.hashPattern.hasMatch(
          DeviceService.randomAuthToken(),
        ),
        isFalse,
      );
    });

    test('when the token is missing then it throws.', () async {
      await expectLater(
        DeviceAuthService.requireDevice(sessionBuilder.build(), null),
        throwsA(isA<DeviceUnauthenticatedException>()),
      );
    });

    test('when the token is empty then it throws.', () async {
      await expectLater(
        DeviceAuthService.requireDevice(sessionBuilder.build(), '  '),
        throwsA(isA<DeviceUnauthenticatedException>()),
      );
    });

    test('when the token is unknown then it throws.', () async {
      await enrollDevice();

      await expectLater(
        DeviceAuthService.requireDevice(sessionBuilder.build(), 'nope'),
        throwsA(isA<DeviceUnauthenticatedException>()),
      );
    });
  });
}
