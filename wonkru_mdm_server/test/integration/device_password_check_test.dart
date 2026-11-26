import 'package:test/test.dart';
import 'package:wonkru_core_server/wonkru_core_server.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';
import 'package:wonkru_mdm_server/src/util/password_hasher.dart';

import 'test_tools/serverpod_test_tools.dart';
import 'support/device_enrollment.dart';

void main() {
  withServerpod('Given DeviceEndpoint.passwordCheck', (
    sessionBuilder,
    endpoints,
  ) {
    setUp(() {
      PasswordHasher.debugPepper = 'test-pepper';
    });

    tearDown(() {
      PasswordHasher.debugPepper = null;
    });

    Future<DeviceRegisterResponse> registerDevice() async =>
        endpoints.device.register(
          sessionBuilder,
          await enrolled(sessionBuilder, model: 'test'),
        );

    Future<void> assignPolicy(
      DeviceRegisterResponse registered,
      String? adminPassword,
    ) async {
      final session = sessionBuilder.build();
      final policy = await Policy.db.insertRow(
        session,
        Policy(name: 'Locked', adminPassword: adminPassword),
      );
      final device = await Device.db.findFirstRow(
        session,
        where: (t) => t.uuid.equals(registered.uuid),
      );
      device!
        ..policyId = policy.id
        ..policyVersion = policy.version;
      await Device.db.updateRow(session, device);
    }

    Future<bool> check(DeviceRegisterResponse registered, String password) =>
        endpoints.device.passwordCheck(
          sessionBuilder,
          DevicePasswordCheckRequest(
            deviceUuid: registered.uuid,
            token: registered.token,
            password: password,
          ),
        );

    test('correct password returns true, wrong password returns false', () async {
      final registered = await registerDevice();
      final hash = await PasswordHasher.hash('secret-password');
      await assignPolicy(registered, hash);

      expect(await check(registered, 'secret-password'), isTrue);
      expect(await check(registered, 'wrong-password'), isFalse);
    });

    test(
      'returns false when pepper is missing even if verification throws',
      () async {
      final registered = await registerDevice();
      final hash = await PasswordHasher.hash('secret-password');
      await assignPolicy(registered, hash);

      // `verify` throws `StateError` without a pepper; the endpoint must catch
      // it and return `false` to the device instead of an error.
      PasswordHasher.debugPepper = '';

      expect(await check(registered, 'secret-password'), isFalse);
    });
  });
}
