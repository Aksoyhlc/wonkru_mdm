import 'package:serverpod/serverpod.dart';
import '../../enums/rate_limit_scope.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import '../../generated/protocol.dart';
import '../../service/admin_auth_service.dart';
import '../../service/admin_notification_service.dart';
import '../../service/admin_scope_service.dart';
import '../../service/admin_two_factor_service.dart';
import '../../service/client_ip_resolver.dart';
import '../../service/rate_limiter.dart';
import 'admin_audit.dart';

/// The panel's entry point. The auth session comes from Serverpod; panel access
/// is decided through [AdminProfile].
class AdminAuthEndpoint extends Endpoint with AdminAudit {
  /// `status` is null when there is no session or no active profile.
  /// [needsBootstrap] is true only while no [AdminProfile] exists at all, so the
  /// panel offers first-admin setup once.
  Future<AdminSessionInfo> me(Session session) async {
    final authenticated = session.authenticated;
    if (authenticated == null) {
      final adminCount = await AdminProfile.db.count(session);
      return AdminSessionInfo(needsBootstrap: adminCount == 0);
    }

    final profile = await AdminAuthService.tryRequireAdmin(session);
    if (profile != null) {
      final totpEnabled = AdminTwoFactorService.isEnabled(profile);
      return AdminSessionInfo(
        status: profile.status,
        adminProfileId: profile.id,
        displayName: await _displayNameFor(session, profile.userId),
        needsBootstrap: false,
        // The scope on the token is checked: an active account with a scope-less
        // token still gets 403 on panel endpoints. Knowing this lets the panel
        // show an access denial instead of looping on refresh.
        hasAdminScope: authenticated.scopes.contains(AdminScopeService.admin),
        totpEnabled: totpEnabled,
        twoFactorRequired:
            totpEnabled && !await AdminTwoFactorService.isVerified(session),
        unreadNotificationCount: await AdminNotificationService.unreadCount(
          session,
          profile.userId,
        ),
      );
    }

    final adminCount = await AdminProfile.db.count(session);

    return AdminSessionInfo(
      needsBootstrap: adminCount == 0,
    );
  }

  /// Wraps the IDP login so every attempt (success or failure) is audited with
  /// the client IP; login is rate limited per client IP.
  Future<AuthSuccess> login(
    Session session,
    String email,
    String password,
  ) async {
    InMemoryRateLimiter.instance.enforce(
      RateLimitScope.authLogin,
      key: ClientIpResolver.ipKey(session),
    );

    final loggedEmail = email.trim().toLowerCase();

    try {
      final result = await AuthServices.instance.emailIdp.login(
        session,
        email: email,
        password: password,
      );

      await audit(
        session,
        action: 'auth.sign_in',
        actorUserId: result.authUserId,
        data: {'email': loggedEmail},
      );

      await _touchLastLogin(session, result.authUserId);

      return result;
    } catch (_) {
      await audit(
        session,
        action: 'auth.sign_in_failed',
        actorEmail: loggedEmail,
        data: {'email': loggedEmail},
      );
      rethrow;
    }
  }

  /// Best effort: a failure here must not undo the completed login.
  static Future<void> _touchLastLogin(Session session, UuidValue userId) async {
    try {
      await AdminProfile.db.updateWhere(
        session,
        where: (t) => t.userId.equals(userId),
        columnValues: (t) => [t.lastLoginAt(DateTime.now().toUtc())],
      );
    } catch (error, stackTrace) {
      session.log(
        'AdminAuth: lastLoginAt update failed',
        level: LogLevel.warning,
        exception: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Callable only while no [AdminProfile] exists, so first setup needs no
  /// sign-up flow; the user, email account, profile and admin scope are created
  /// in one transaction. Rate limited per client IP.
  Future<AdminSessionInfo> bootstrap(
    Session session, {
    required String email,
    required String password,
    String? name,
  }) async {
    InMemoryRateLimiter.instance.enforce(
      RateLimitScope.authBootstrap,
      key: ClientIpResolver.ipKey(session),
    );

    final normalizedEmail = _normalizedEmail(email);
    if (password.isEmpty) {
      throw Exception('A password is required for the first admin.');
    }

    final now = DateTime.now().toUtc();
    final fullName = name?.trim();

    final AdminProfile profile;
    try {
      profile = await session.db.transaction((transaction) async {
        // Serialize first-admin requests across processes sharing this database.
        await session.db.unsafeQuery(
          'SELECT 1 FROM pg_advisory_xact_lock(57219532)',
          transaction: transaction,
        );
        final existing = await AdminProfile.db.count(
          session,
          transaction: transaction,
        );
        if (existing > 0) {
          throw NotAuthorizedException(
            reason: AuthenticationFailureReason.insufficientAccess,
          );
        }

        final authUser = await AuthServices.instance.authUsers.create(
          session,
          transaction: transaction,
        );
        final userId = authUser.id;

        await AuthServices.instance.emailIdp.admin.createEmailAuthentication(
          session,
          authUserId: userId,
          email: normalizedEmail,
          password: password,
          transaction: transaction,
        );
        await AuthServices.instance.userProfiles.createUserProfile(
          session,
          userId,
          UserProfileData(
            fullName: fullName == null || fullName.isEmpty ? null : fullName,
            email: normalizedEmail,
          ),
          transaction: transaction,
        );

        final profile = await AdminProfile.db.insertRow(
          session,
          AdminProfile(
            userId: userId,
            status: AdminAccountStatus.active,
            createdAt: now,
            updatedAt: now,
          ),
          transaction: transaction,
        );

        await AdminScopeService.grant(
          session,
          userId,
          transaction: transaction,
        );

        return profile;
      });
    } on NotAuthorizedException {
      rethrow;
    } catch (_) {
      // Any DB error (incl. a TOCTOU race) becomes the panel's access denial.
      throw NotAuthorizedException(
        reason: AuthenticationFailureReason.insufficientAccess,
      );
    }

    await audit(
      session,
      action: 'auth.bootstrap',
      actorUserId: profile.userId,
      data: {'email': normalizedEmail, 'profileId': profile.id},
    );

    return AdminSessionInfo(
      status: AdminAccountStatus.active,
      adminProfileId: profile.id,
      displayName: await _displayNameFor(session, profile.userId),
      needsBootstrap: false,
      unreadNotificationCount: await AdminNotificationService.unreadCount(
        session,
        profile.userId,
      ),
    );
  }

  /// The secret is stored encrypted; the account is inactive until
  /// [confirmTotpSetup] produces the recovery codes.
  Future<AdminTotpSetup> startTotpSetup(Session session) async {
    final profile = await AdminAuthService.requireAdmin(session);
    final email = await _emailFor(session, profile.userId);
    return AdminTwoFactorService.startSetup(
      session,
      profile,
      accountLabel: email,
    );
  }

  /// The recovery codes are shown in plaintext only in this response.
  Future<List<String>> confirmTotpSetup(Session session, String code) async {
    final profile = await AdminAuthService.requireAdmin(session);
    final codes = await AdminTwoFactorService.confirmSetup(
      session,
      profile,
      code,
    );
    await audit(session, action: 'auth.totp_enable');
    return codes;
  }

  /// Skips 2FA enforcement (the panel is unreachable until 2FA is verified);
  /// repeated failures lock the account and throw `AdminTotpException`.
  Future<bool> verifyTotp(Session session, String code) async {
    final profile = await AdminAuthService.requireAdmin(
      session,
      enforceTwoFactor: false,
    );
    final result = await AdminTwoFactorService.verify(session, profile, code);
    if (result == null) {
      await audit(
        session,
        action: 'auth.totp_verify_failed',
        data: {'reason': 'locked'},
      );
      throw AdminTotpException(
        message: 'Too many failed attempts. Please try again later.',
      );
    }
    if (!result) {
      await audit(
        session,
        action: 'auth.totp_verify_failed',
      );
    }
    return result;
  }

  Future<void> disableTotp(Session session, String code) async {
    final profile = await AdminAuthService.requireAdmin(
      session,
      enforceTwoFactor: false,
    );
    await AdminTwoFactorService.disable(session, profile, code);
    await audit(session, action: 'auth.totp_disable');
  }

  /// Only the account's own auth user may change the password; the current one
  /// is verified client-side via `emailIdp.login`. With 2FA on, an unverified
  /// session cannot change it and take over the account.
  Future<void> changePassword(
    Session session,
    String email,
    String newPassword,
  ) async {
    final profile = await AdminAuthService.requireAdmin(session);
    final userId = profile.userId.toString();
    final account = await AuthServices.instance.emailIdp.admin.findAccount(
      session,
      email: email,
    );

    if (account == null || account.authUserId.toString() != userId) {
      throw NotAuthorizedException(
        reason: AuthenticationFailureReason.insufficientAccess,
      );
    }

    await AuthServices.instance.emailIdp.admin.setPassword(
      session,
      email: account.email,
      password: newPassword,
    );

    await audit(
      session,
      action: 'auth.password_change',
    );
  }

  /// Ownership is checked against the account's auth user; a new address in use
  /// is rejected. With 2FA on the second step is mandatory (see [changePassword]).
  Future<void> changeEmail(
    Session session,
    String currentEmail,
    String newEmail,
  ) async {
    final profile = await AdminAuthService.requireAdmin(session);
    final userId = profile.userId.toString();
    final normalized = _normalizedEmail(newEmail);

    await session.db.transaction((transaction) async {
      final account = await AuthServices.instance.emailIdp.admin.findAccount(
        session,
        email: currentEmail,
        transaction: transaction,
      );

      if (account == null || account.authUserId.toString() != userId) {
        throw NotAuthorizedException(
          reason: AuthenticationFailureReason.insufficientAccess,
        );
      }

      final taken = await EmailAccount.db.findFirstRow(
        session,
        where: (t) => t.email.equals(normalized),
        transaction: transaction,
      );
      if (taken != null && taken.id != account.id) {
        throw Exception('$normalized is already in use.');
      }

      account.email = normalized;
      await EmailAccount.db.updateRow(
        session,
        account,
        transaction: transaction,
      );

      final profile = await UserProfile.db.findFirstRow(
        session,
        where: (t) => t.authUserId.equals(account.authUserId),
        transaction: transaction,
      );
      if (profile != null) {
        profile.email = normalized;
        await UserProfile.db.updateRow(
          session,
          profile,
          transaction: transaction,
        );
      }
    });

    await audit(
      session,
      action: 'auth.email_change',
      data: {'from': currentEmail, 'to': normalized},
    );
  }

  static Future<String?> _emailFor(Session session, UuidValue userId) async {
    final account = await EmailAccount.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(userId),
    );
    return account?.email;
  }

  static Future<String> _displayNameFor(
    Session session,
    UuidValue userId,
  ) async {
    final profile = await UserProfile.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(userId),
    );

    for (final candidate in [
      profile?.fullName,
      profile?.userName,
      profile?.email,
    ]) {
      final trimmed = candidate?.trim();
      if (trimmed != null && trimmed.isNotEmpty) {
        return trimmed;
      }
    }

    return await _emailFor(session, userId) ?? userId.toString();
  }

  static String _normalizedEmail(String raw) {
    final email = raw.trim().toLowerCase();
    if (email.isEmpty) {
      throw Exception('An email address is required.');
    }

    return email;
  }
}
