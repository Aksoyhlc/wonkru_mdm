import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../Client/serverpod_client.dart';

class AuthRepository {
  const AuthRepository._();

  static bool get isSignedIn => serverpodClient.auth.isAuthenticated;

  static UuidValue? get currentAuthUserId =>
      serverpodClient.auth.authInfo?.authUserId;

  static Future<AdminSessionInfo> me() => serverpodClient.adminAuth.me();

  static Future<AdminSessionInfo> bootstrap({
    required String email,
    required String password,
  }) => serverpodClient.adminAuth.bootstrap(
    email: email,
    password: password,
  );

  static Future<AdminTotpSetup> startTotpSetup() =>
      serverpodClient.adminAuth.startTotpSetup();

  static Future<List<String>> confirmTotpSetup(String code) =>
      serverpodClient.adminAuth.confirmTotpSetup(code);

  static Future<bool> verifyTotp(String code) =>
      serverpodClient.adminAuth.verifyTotp(code);

  static Future<void> disableTotp(String code) =>
      serverpodClient.adminAuth.disableTotp(code);

  /// Routed through the server so successful and failed attempts are recorded
  /// in the audit trail.
  static Future<void> signIn(String email, String password) async {
    final result = await serverpodClient.adminAuth.login(email, password);
    await serverpodClient.auth.updateSignedInUser(result);
  }

  /// Checks the password through `emailIdp.login`; the `changePassword` and
  /// `changeEmail` endpoints only check ownership. The fresh login produces a
  /// new session id, which is still unverified when 2FA is enabled.
  static Future<void> verifyPassword(String email, String password) async {
    final result = await serverpodClient.emailIdp.login(
      email: email,
      password: password,
    );
    await serverpodClient.auth.updateSignedInUser(result);
  }

  static Future<void> changePassword(String email, String newPassword) =>
      serverpodClient.adminAuth.changePassword(email, newPassword);

  static Future<void> changeEmail(String currentEmail, String newEmail) =>
      serverpodClient.adminAuth.changeEmail(currentEmail, newEmail);

  static Future<void> signOut() async {
    await serverpodClient.auth.signOutDevice();
  }
}
