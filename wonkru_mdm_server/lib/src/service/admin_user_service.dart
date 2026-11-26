import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import '../generated/protocol.dart';
import '../util/like_pattern.dart';

class AdminUserService {
  const AdminUserService._();

  static Future<List<AdminUserRow>> rowsForUsers(
    Session session,
    List<UuidValue> authUserIds, {
    Transaction? transaction,
  }) async {
    if (authUserIds.isEmpty) {
      return const [];
    }

    final ids = authUserIds.toSet();

    final users = await AuthUser.db.find(
      session,
      where: (t) => t.id.inSet(ids),
      transaction: transaction,
    );
    final profiles = await UserProfile.db.find(
      session,
      where: (t) => t.authUserId.inSet(ids),
      transaction: transaction,
    );
    final accounts = await EmailAccount.db.find(
      session,
      where: (t) => t.authUserId.inSet(ids),
      orderBy: (t) => t.createdAt,
      transaction: transaction,
    );
    final adminProfiles = await AdminProfile.db.find(
      session,
      where: (t) => t.userId.inSet(ids),
      transaction: transaction,
    );

    final userById = <UuidValue, AuthUser>{
      for (final user in users) user.id!: user,
    };
    final profileById = <UuidValue, UserProfile>{
      for (final profile in profiles) profile.authUserId: profile,
    };
    final adminByUser = <UuidValue, AdminProfile>{
      for (final admin in adminProfiles) admin.userId: admin,
    };

    final accountByUser = <UuidValue, EmailAccount>{};
    for (final account in accounts) {
      accountByUser.putIfAbsent(account.authUserId, () => account);
    }

    final rows = <AdminUserRow>[];
    for (final authUserId in authUserIds) {
      final user = userById[authUserId];
      if (user == null) {
        continue;
      }

      final profile = profileById[authUserId];
      final account = accountByUser[authUserId];
      final email = account?.email ?? profile?.email;

      rows.add(
        AdminUserRow(
          authUserId: authUserId,
          name: profile?.fullName,
          email: email == null || email.isEmpty ? null : email,
          hasPassword: account?.hasPassword ?? false,
          blocked: user.blocked,
          status:
              adminByUser[authUserId]?.status ?? AdminAccountStatus.disabled,
          lastLoginAt: adminByUser[authUserId]?.lastLoginAt,
          createdAt: user.createdAt,
        ),
      );
    }

    return rows;
  }

  static Future<AdminUserRow> rowForUser(
    Session session,
    UuidValue authUserId, {
    Transaction? transaction,
  }) async {
    final rows = await rowsForUsers(
      session,
      [authUserId],
      transaction: transaction,
    );
    if (rows.isEmpty) {
      throw Exception('User $authUserId does not exist.');
    }

    return rows.single;
  }

  static Future<EmailAccount?> emailAccountFor(
    Session session,
    UuidValue authUserId, {
    Transaction? transaction,
  }) {
    return EmailAccount.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authUserId),
      orderBy: (t) => t.createdAt,
      transaction: transaction,
    );
  }

  static Future<UserProfile?> profileFor(
    Session session,
    UuidValue authUserId, {
    Transaction? transaction,
  }) {
    return UserProfile.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authUserId),
      transaction: transaction,
    );
  }

  static Future<List<UuidValue>> idsMatchingSearch(
    Session session,
    String search, {
    Transaction? transaction,
  }) async {
    final pattern = likeContains(search);

    final profiles = await UserProfile.db.find(
      session,
      where: (t) => t.fullName.ilike(pattern) | t.email.ilike(pattern),
      transaction: transaction,
    );
    final accounts = await EmailAccount.db.find(
      session,
      where: (t) => t.email.ilike(pattern),
      transaction: transaction,
    );

    return <UuidValue>{
      ...profiles.map((profile) => profile.authUserId),
      ...accounts.map((account) => account.authUserId),
    }.toList();
  }
}
