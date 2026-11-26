import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'admin_two_factor_service.dart';

/// Guards the admin endpoints.
///
/// The panel signs in through `serverpod_auth`, which fills
/// [Session.authenticated]. The account status (`status`) lives on
/// [AdminProfile]; only [AdminAccountStatus.active] accounts may reach the
/// panel.
///
/// When the account has two-factor authentication enabled, [requireAdmin] also
/// demands that the *current session* has passed 2FA. The verified state is
/// kept per session in [AdminTotpSession] (keyed by the auth session id), so a
/// code entered on one device does not unlock another.
class AdminAuthService {
  const AdminAuthService._();

  /// Returns the admin profile behind the current session.
  ///
  /// Throws [NotAuthorizedException] with [AuthenticationFailureReason.unauthenticated]
  /// when the session carries no authentication at all, and with
  /// [AuthenticationFailureReason.insufficientAccess] when the user has no
  /// profile, is not allowed to reach the panel, or has 2FA enabled but has
  /// not satisfied it in this session.
  ///
  /// [enforceTwoFactor] is `false` only for the 2FA endpoints themselves
  /// (`verifyTotp`/`disableTotp`), which have to run before the session is
  /// verified; those endpoints still prove possession through the submitted
  /// code.
  static Future<AdminProfile> requireAdmin(
    Session session, {
    bool enforceTwoFactor = true,
  }) async {
    final authenticated = session.authenticated;
    if (authenticated == null) {
      throw NotAuthorizedException(
        reason: AuthenticationFailureReason.unauthenticated,
      );
    }

    final UuidValue userId;
    try {
      userId = UuidValue.fromString(authenticated.userIdentifier);
    } on FormatException {
      throw NotAuthorizedException(
        reason: AuthenticationFailureReason.insufficientAccess,
      );
    }

    final profile = await AdminProfile.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId),
    );

    if (profile == null || profile.status != AdminAccountStatus.active) {
      throw NotAuthorizedException(
        reason: AuthenticationFailureReason.insufficientAccess,
      );
    }

    if (enforceTwoFactor &&
        AdminTwoFactorService.isEnabled(profile) &&
        !await AdminTwoFactorService.isVerified(session)) {
      throw NotAuthorizedException(
        reason: AuthenticationFailureReason.insufficientAccess,
      );
    }

    return profile;
  }

  /// Returns the admin profile behind the current session, or `null`.
  ///
  /// Unlike [requireAdmin] this never throws and never enforces 2FA: a session
  /// without authentication, an identifier that is not a UUID, a missing
  /// profile and a profile that is not [AdminAccountStatus.active] all just
  /// yield `null`. The 2FA-aware caller (`me`) needs the profile even before
  /// 2FA is satisfied.
  static Future<AdminProfile?> tryRequireAdmin(Session session) async {
    final authenticated = session.authenticated;
    if (authenticated == null) return null;

    final UuidValue userId;
    try {
      userId = UuidValue.fromString(authenticated.userIdentifier);
    } on FormatException {
      return null;
    }

    final profile = await AdminProfile.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId),
    );

    return (profile == null || profile.status != AdminAccountStatus.active)
        ? null
        : profile;
  }
}
