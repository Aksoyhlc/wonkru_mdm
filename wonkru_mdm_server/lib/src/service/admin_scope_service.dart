import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';

import '../generated/protocol.dart';

/// Manages the Serverpod auth scope carried by panel admins.
///
/// Panel endpoints require [admin] via `requiredScopes`; the framework checks
/// the token's scopes *before* running the method, adding another layer in front
/// of `AdminAuthService.requireAdmin` (profile status + 2FA).
///
/// Scopes are embedded in the JWT, so a scope written through
/// [AuthServices.instance] only enters the token on the next sign-in. Changing a
/// scope therefore does not drop current sessions; the admin must sign in again.
class AdminScopeService {
  const AdminScopeService._();

  /// Serverpod's built-in `Scope.admin` is `serverpod.admin`, so this
  /// application-specific name is used.
  static const Scope admin = Scope('admin');

  static Future<void> grant(
    Session session,
    UuidValue authUserId, {
    Transaction? transaction,
  }) async {
    final user = await AuthServices.instance.authUsers.get(
      session,
      authUserId: authUserId,
      transaction: transaction,
    );
    if (user.scopes.contains(admin)) return;

    await AuthServices.instance.authUsers.update(
      session,
      authUserId: authUserId,
      scopes: {...user.scopes, admin},
      transaction: transaction,
    );
  }

  static Future<void> revoke(
    Session session,
    UuidValue authUserId, {
    Transaction? transaction,
  }) async {
    final user = await AuthServices.instance.authUsers.get(
      session,
      authUserId: authUserId,
      transaction: transaction,
    );
    if (!user.scopes.contains(admin)) return;

    await AuthServices.instance.authUsers.update(
      session,
      authUserId: authUserId,
      scopes: user.scopes.where((scope) => scope != admin).toSet(),
      transaction: transaction,
    );
  }

  /// Single place that creates/updates admin profiles, so "profile active" and
  /// "scope granted" cannot drift apart.
  static Future<void> sync(
    Session session,
    UuidValue authUserId, {
    required bool active,
    Transaction? transaction,
  }) {
    return active
        ? grant(session, authUserId, transaction: transaction)
        : revoke(session, authUserId, transaction: transaction);
  }

  /// Scopes were only granted after G12, so accounts created earlier carry none
  /// and get 403 on panel endpoints. This repair runs once at startup and is
  /// idempotent; it makes existing admins get the `admin` scope on their next
  /// sign-in (scopes are embedded in the JWT at sign-in time; current sessions
  /// must sign in again).
  static Future<void> syncAllProfiles(Session session) async {
    final profiles = await AdminProfile.db.find(session);
    for (final profile in profiles) {
      await sync(
        session,
        profile.userId,
        active: profile.status == AdminAccountStatus.active,
      );
    }
  }
}
