import 'package:flutter_test/flutter_test.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';
import 'package:wonkru_mdm_flutter/Core/Constants/Enums/auth_enums.dart';
import 'package:wonkru_mdm_flutter/Logic/Controllers/auth_controller.dart';

/// A scope-less active session must map to noAccess: returning ready causes a
/// `403 → init → ready → 403` refresh loop.
void main() {
  AdminSessionInfo sessionInfo({
    AdminAccountStatus? status,
    bool hasAdminScope = false,
    bool twoFactorRequired = false,
    bool needsBootstrap = false,
  }) => AdminSessionInfo(
    status: status,
    hasAdminScope: hasAdminScope,
    twoFactorRequired: twoFactorRequired,
    needsBootstrap: needsBootstrap,
  );

  test('returns noAccess when active without scope', () {
    expect(
      AuthController.statusFor(
        sessionInfo(status: AdminAccountStatus.active),
      ),
      AuthStatus.noAccess,
    );
  });

  test('returns ready when active with scope', () {
    expect(
      AuthController.statusFor(
        sessionInfo(status: AdminAccountStatus.active, hasAdminScope: true),
      ),
      AuthStatus.ready,
    );
  });

  test('returns noAccess for a disabled account even with scope', () {
    expect(
      AuthController.statusFor(
        sessionInfo(status: AdminAccountStatus.disabled, hasAdminScope: true),
      ),
      AuthStatus.noAccess,
    );
  });

  test('returns noAccess when there is no profile (status null)', () {
    expect(AuthController.statusFor(sessionInfo()), AuthStatus.noAccess);
  });

  test('returns awaitingTwoFactor for a session awaiting 2FA', () {
    expect(
      AuthController.statusFor(
        sessionInfo(
          status: AdminAccountStatus.active,
          hasAdminScope: true,
          twoFactorRequired: true,
        ),
      ),
      AuthStatus.awaitingTwoFactor,
    );
  });
}
