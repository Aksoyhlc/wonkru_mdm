import 'package:flutter_test/flutter_test.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';
import 'package:wonkru_mdm_flutter/Logic/Controllers/profile_controller.dart';

AdminSessionInfo _info({required bool twoFactorRequired}) => AdminSessionInfo(
  status: AdminAccountStatus.active,
  needsBootstrap: false,
  twoFactorRequired: twoFactorRequired,
  unreadNotificationCount: 0,
);

void main() {
  group('ProfileController.ensureTwoFactorVerified', () {
    test('when 2FA is not required, no code is requested and no verification runs', () async {
      var requested = 0;
      var verified = 0;

      await ProfileController.ensureTwoFactorVerified(
        info: _info(twoFactorRequired: false),
        requestCode: () async {
          requested++;
          return '123456';
        },
        verify: (code) async {
          verified++;
          return true;
        },
      );

      expect(requested, 0);
      expect(verified, 0);
    });

    test('when 2FA is required, a code is requested and verified after trimming', () async {
      String? verifiedCode;

      await ProfileController.ensureTwoFactorVerified(
        info: _info(twoFactorRequired: true),
        requestCode: () async => '  123456  ',
        verify: (code) async {
          verifiedCode = code;
          return true;
        },
      );

      expect(verifiedCode, '123456');
    });

    test('if the user cancels, a clear error is thrown', () async {
      var verified = 0;

      await expectLater(
        ProfileController.ensureTwoFactorVerified(
          info: _info(twoFactorRequired: true),
          requestCode: () async => null,
          verify: (code) async {
            verified++;
            return true;
          },
        ),
        throwsA(isA<AdminTotpException>()),
      );

      expect(verified, 0);
    });

    test('verification is not called after an empty code', () async {
      var verified = 0;

      await expectLater(
        ProfileController.ensureTwoFactorVerified(
          info: _info(twoFactorRequired: true),
          requestCode: () async => '   ',
          verify: (code) async {
            verified++;
            return true;
          },
        ),
        throwsA(isA<AdminTotpException>()),
      );

      expect(verified, 0);
    });

    test('a wrong code turns into a clear error', () async {
      await expectLater(
        ProfileController.ensureTwoFactorVerified(
          info: _info(twoFactorRequired: true),
          requestCode: () async => '000000',
          verify: (code) async => false,
        ),
        throwsA(isA<AdminTotpException>()),
      );
    });
  });
}
