import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import '../generated/protocol.dart';
import 'admin_activity_service.dart';
import 'admin_scope_service.dart';
import 'admin_two_factor_service.dart';
import 'admin_user_service.dart';

/// Thrown when the recovery request is valid enough to run but the account
/// state needs a different flag (for example `--create` or `--grant-admin`).
class AdminRecoveryException implements Exception {
  AdminRecoveryException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Result of [AdminRecoveryService.resetPassword], used by the CLI output.
class AdminRecoveryResult {
  const AdminRecoveryResult({
    required this.email,
    required this.authUserId,
    required this.adminProfileId,
    required this.userCreated,
    required this.profileCreated,
    required this.profileActivated,
    required this.totpCleared,
    required this.sessionsRevoked,
  });

  final String email;
  final UuidValue authUserId;
  final int adminProfileId;
  final bool userCreated;
  final bool profileCreated;
  final bool profileActivated;
  final bool totpCleared;
  final bool sessionsRevoked;
}

/// Read model for `admin list`.
class AdminSummary {
  const AdminSummary({
    required this.email,
    required this.authUserId,
    required this.status,
    required this.hasPassword,
    required this.blocked,
    required this.totpEnabled,
    required this.lastLoginAt,
  });

  final String? email;
  final UuidValue authUserId;
  final AdminAccountStatus status;
  final bool hasPassword;
  final bool blocked;
  final bool totpEnabled;
  final DateTime? lastLoginAt;
}

/// Password and account recovery from the server shell (no HTTP endpoint).
///
/// The CLI is the only caller. It runs a maintenance-mode pod and passes that
/// pod's [Session]; this service never checks an admin session because access
/// is already gated by shell access to the container.
class AdminRecoveryService {
  const AdminRecoveryService._();

  static const minimumPasswordLength = 8;

  /// Resets the password for [email], optionally creating the auth user and
  /// admin profile when they are missing.
  ///
  /// [createUser] creates the auth user, email account, admin profile and scope
  /// when the address is unknown. [grantAdmin] adds or re-activates the panel
  /// profile of an existing auth user. Both are explicit so a typo cannot
  /// silently create or promote an account.
  static Future<AdminRecoveryResult> resetPassword(
    Session session, {
    required String email,
    required String password,
    bool createUser = false,
    bool grantAdmin = false,
    bool clearTotp = false,
    bool revokeSessions = true,
    String? name,
  }) async {
    final normalizedEmail = _normalizeEmail(email);
    if (password.length < minimumPasswordLength) {
      throw AdminRecoveryException(
        'Password must be at least $minimumPasswordLength characters.',
      );
    }

    final result = await session.db.transaction((transaction) async {
      final auth = AuthServices.instance;
      final existing = await auth.emailIdp.admin.findAccount(
        session,
        email: normalizedEmail,
        transaction: transaction,
      );

      final existingUserId = existing?.authUserId;
      if (existingUserId != null) {
        final user = await auth.authUsers.get(
          session,
          authUserId: existingUserId,
          transaction: transaction,
        );
        if (user.blocked) {
          throw AdminRecoveryException(
            'The account for $normalizedEmail is blocked. '
            'Unblock it in the panel before resetting its password.',
          );
        }
      }
      var profile = existingUserId == null
          ? null
          : await AdminProfile.db.findFirstRow(
              session,
              where: (t) => t.userId.equals(existingUserId),
              transaction: transaction,
              lockMode: LockMode.forUpdate,
            );

      // Validate the account/profile shape before touching the password, so a
      // missing flag cannot leave a half-completed recovery behind.
      if (existing == null) {
        if (!createUser) {
          throw AdminRecoveryException(
            'No account found for $normalizedEmail. '
            'Re-run with --create to create it.',
          );
        }
      } else if (profile == null) {
        if (!grantAdmin) {
          throw AdminRecoveryException(
            'The account exists but has no admin profile, so it cannot open the '
            'panel. Re-run with --grant-admin to create it.',
          );
        }
      } else if (profile.status != AdminAccountStatus.active && !grantAdmin) {
        throw AdminRecoveryException(
          'The admin profile is ${profile.status.name}. '
          'Re-run with --grant-admin to activate it.',
        );
      }

      late final UuidValue userId;
      final userCreated = existing == null;

      if (userCreated) {
        final authUser = await auth.authUsers.create(
          session,
          transaction: transaction,
        );
        final createdId = authUser.id;
        await auth.emailIdp.admin.createEmailAuthentication(
          session,
          authUserId: createdId,
          email: normalizedEmail,
          password: password,
          transaction: transaction,
        );
        await auth.userProfiles.createUserProfile(
          session,
          createdId,
          UserProfileData(
            fullName: _cleanName(name),
            email: normalizedEmail,
          ),
          transaction: transaction,
        );
        userId = createdId;
      } else {
        userId = existingUserId!;
        await auth.emailIdp.admin.setPassword(
          session,
          email: normalizedEmail,
          password: password,
          transaction: transaction,
        );
      }

      var profileCreated = false;
      var profileActivated = false;

      if (profile == null) {
        final now = DateTime.now().toUtc();
        profile = await AdminProfile.db.insertRow(
          session,
          AdminProfile(
            userId: userId,
            status: AdminAccountStatus.active,
            createdAt: now,
            updatedAt: now,
          ),
          transaction: transaction,
        );
        profileCreated = true;
      } else if (profile.status != AdminAccountStatus.active) {
        profile
          ..status = AdminAccountStatus.active
          ..updatedAt = DateTime.now().toUtc();
        await AdminProfile.db.updateRow(
          session,
          profile,
          columns: (t) => [t.status, t.updatedAt],
          transaction: transaction,
        );
        profileActivated = true;
      }

      // Keep the JWT scope in sync with the profile so the next sign-in carries
      // the `admin` scope; a scope-less token is rejected by panel endpoints.
      await AdminScopeService.grant(session, userId, transaction: transaction);

      final totpWasEnabled = AdminTwoFactorService.isEnabled(profile);
      if (clearTotp) {
        await AdminTwoFactorService.clearForRecovery(
          session,
          profile,
          transaction: transaction,
        );
      }

      if (revokeSessions) {
        await auth.tokenManager.revokeAllTokens(
          session,
          authUserId: userId,
          transaction: transaction,
        );
      }

      return AdminRecoveryResult(
        email: normalizedEmail,
        authUserId: userId,
        adminProfileId: profile.id!,
        userCreated: userCreated,
        profileCreated: profileCreated,
        profileActivated: profileActivated,
        totpCleared: clearTotp && totpWasEnabled,
        sessionsRevoked: revokeSessions,
      );
    });

    await AdminActivityService.record(
      session,
      action: 'auth.cli_password_reset',
      actorEmail: 'cli',
      actorName: 'Command line',
      targetType: 'admin',
      targetId: result.authUserId,
      data: {
        'email': normalizedEmail,
        'userCreated': result.userCreated,
        'profileCreated': result.profileCreated,
        'profileActivated': result.profileActivated,
        'totpCleared': result.totpCleared,
        'sessionsRevoked': result.sessionsRevoked,
      },
    );

    return result;
  }

  /// Lists panel admins for `admin list`. Never returns password hashes.
  static Future<List<AdminSummary>> listAdmins(Session session) async {
    final profiles = await AdminProfile.db.find(
      session,
      orderBy: (t) => t.id,
    );
    if (profiles.isEmpty) return const [];

    final rows = await AdminUserService.rowsForUsers(
      session,
      [for (final profile in profiles) profile.userId],
    );
    final byUserId = {
      for (final row in rows) row.authUserId: row,
    };

    final summaries = [
      for (final profile in profiles)
        if (byUserId[profile.userId] case final row?)
          AdminSummary(
            email: row.email,
            authUserId: row.authUserId,
            status: row.status,
            hasPassword: row.hasPassword,
            blocked: row.blocked,
            totpEnabled: (profile.totpSecret ?? '').isNotEmpty,
            lastLoginAt: row.lastLoginAt,
          ),
    ];

    summaries.sort((a, b) => (a.email ?? '').compareTo(b.email ?? ''));
    return summaries;
  }

  static String _normalizeEmail(String email) {
    final normalized = email.trim().toLowerCase();
    if (normalized.isEmpty || !normalized.contains('@')) {
      throw AdminRecoveryException('A valid email address is required.');
    }
    return normalized;
  }

  static String? _cleanName(String? name) {
    final cleaned = name?.trim();
    return cleaned == null || cleaned.isEmpty ? null : cleaned;
  }
}
