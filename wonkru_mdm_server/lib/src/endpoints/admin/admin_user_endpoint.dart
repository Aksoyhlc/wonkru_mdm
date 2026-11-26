import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import '../../generated/protocol.dart';
import '../../util/page_params.dart';
import '../../service/admin_auth_service.dart';
import '../../service/admin_scope_service.dart';
import '../../service/admin_user_service.dart';
import 'admin_audit.dart';

/// A panel user spans an auth user, an auth profile, an email account and an
/// [AdminProfile]; writes go through the auth module so the four stay in step.
class AdminUserEndpoint extends Endpoint with AdminAudit {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {AdminScopeService.admin};

  static const maxPerPage = PageParams.maxPerPage;

  Future<AdminUserPage> list(Session session, AdminListRequest request) async {
    await AdminAuthService.requireAdmin(session);

    final params = PageParams.from(request.page, request.perPage);
    final search = request.search?.trim();

    final matchingIds = search == null || search.isEmpty
        ? null
        : await AdminUserService.idsMatchingSearch(session, search);

    if (matchingIds != null && matchingIds.isEmpty) {
      return AdminUserPage(
        items: const [],
        total: 0,
        page: params.page,
        perPage: params.perPage,
      );
    }

    final WhereExpressionBuilder<AuthUserTable>? where = matchingIds == null
        ? null
        : (t) => t.id.inSet(matchingIds.toSet());

    final total = await AuthUser.db.count(session, where: where);
    final users = await AuthUser.db.find(
      session,
      where: where,
      limit: params.perPage,
      offset: params.offset,
      orderByList: _orderBy(request),
    );

    final items = await AdminUserService.rowsForUsers(session, [
      for (final user in users) user.id!,
    ]);

    return AdminUserPage(
      items: items,
      total: total,
      page: params.page,
      perPage: params.perPage,
    );
  }

  Future<AdminUserRow> get(Session session, UuidValue authUserId) async {
    await AdminAuthService.requireAdmin(session);

    final row = await AdminUserService.rowForUser(session, authUserId);
    await audit(
      session,
      action: 'user.view',
      targetType: 'user',
      targetId: authUserId,
    );
    return row;
  }

  Future<AdminUserRow> create(
    Session session,
    AdminUserCreateRequest request,
  ) async {
    await AdminAuthService.requireAdmin(session);

    final email = _normalizedEmail(request.email);
    final password = request.password;
    if (password.isEmpty) {
      throw Exception('A password is required to create a user.');
    }

    final authUserId = await session.db.transaction((transaction) async {
      await _assertEmailFree(session, email, transaction: transaction);

      final authUser = await AuthServices.instance.authUsers.create(
        session,
        blocked: request.blocked,
        transaction: transaction,
      );
      final authUserId = authUser.id;

      await AuthServices.instance.emailIdp.admin.createEmailAuthentication(
        session,
        authUserId: authUserId,
        email: email,
        password: password,
        transaction: transaction,
      );

      await AuthServices.instance.userProfiles.createUserProfile(
        session,
        authUserId,
        UserProfileData(fullName: _emptyToNull(request.name), email: email),
        transaction: transaction,
      );

      await _saveAdminProfile(
        session,
        authUserId,
        status: request.status,
        transaction: transaction,
      );

      return authUserId;
    });

    await audit(
      session,
      action: 'user.create',
      targetType: 'user',
      targetId: authUserId,
      data: {
        'email': email,
        'name': _emptyToNull(request.name),
        'blocked': request.blocked,
      },
    );

    return AdminUserService.rowForUser(session, authUserId);
  }

  Future<AdminUserRow> update(
    Session session,
    AdminUserUpdateRequest request,
  ) async {
    await AdminAuthService.requireAdmin(session);

    final authUserId = request.authUserId;
    final email = _normalizedEmail(request.email);
    final password = request.password;
    final newPassword = password == null || password.isEmpty ? null : password;

    await session.db.transaction((transaction) async {
      final authUser = await AuthUser.db.findById(
        session,
        authUserId,
        transaction: transaction,
      );
      if (authUser == null) {
        throw Exception('User $authUserId does not exist.');
      }

      final account = await AdminUserService.emailAccountFor(
        session,
        authUserId,
        transaction: transaction,
      );

      if (account == null) {
        if (newPassword == null) {
          throw Exception('A password is required to give $email a login.');
        }

        await _assertEmailFree(session, email, transaction: transaction);
        await AuthServices.instance.emailIdp.admin.createEmailAuthentication(
          session,
          authUserId: authUserId,
          email: email,
          password: newPassword,
          transaction: transaction,
        );
      } else {
        if (account.email != email) {
          await _assertEmailFree(
            session,
            email,
            exceptAccountId: account.id,
            transaction: transaction,
          );

          account.email = email;
          await EmailAccount.db.updateRow(
            session,
            account,
            transaction: transaction,
          );
        }

        if (newPassword != null) {
          await AuthServices.instance.emailIdp.admin.setPassword(
            session,
            email: email,
            password: newPassword,
            transaction: transaction,
          );
        }
      }

      await _saveProfile(
        session,
        authUserId,
        name: _emptyToNull(request.name),
        email: email,
        transaction: transaction,
      );

      if (authUser.blocked != request.blocked) {
        await AuthServices.instance.authUsers.update(
          session,
          authUserId: authUserId,
          blocked: request.blocked,
          transaction: transaction,
        );
      }

      await _saveAdminProfile(
        session,
        authUserId,
        status: request.status,
        transaction: transaction,
      );
    });

    await audit(
      session,
      action: 'user.update',
      targetType: 'user',
      targetId: authUserId,
      data: {
        'email': email,
        'blocked': request.blocked,
        'passwordChanged': newPassword != null,
      },
    );

    return AdminUserService.rowForUser(session, authUserId);
  }

  /// [AdminProfile] is removed first; the rest cascades with the auth user.
  Future<int> delete(Session session, List<UuidValue> authUserIds) async {
    final caller = await AdminAuthService.requireAdmin(session);

    if (authUserIds.isEmpty) {
      return 0;
    }
    if (authUserIds.contains(caller.userId)) {
      throw Exception('You cannot delete your own account.');
    }

    var deleted = 0;

    await session.db.transaction((transaction) async {
      for (final authUserId in authUserIds) {
        final authUser = await AuthUser.db.findById(
          session,
          authUserId,
          transaction: transaction,
        );
        if (authUser == null) {
          continue;
        }

        await AdminProfile.db.deleteWhere(
          session,
          where: (t) => t.userId.equals(authUserId),
          transaction: transaction,
        );
        // 2FA rows are not tied to the auth user, so they are cleaned up here.
        await AdminTotpSession.db.deleteWhere(
          session,
          where: (t) => t.userId.equals(authUserId),
          transaction: transaction,
        );
        await AuthServices.instance.authUsers.delete(
          session,
          authUserId: authUserId,
          transaction: transaction,
        );

        deleted++;
      }
    });

    await audit(
      session,
      action: 'user.delete',
      targetType: 'user',
      data: {
        'ids': [for (final id in authUserIds) id.toString()],
        'count': deleted,
      },
    );

    return deleted;
  }

  /// Name and email are not auth-user columns, so they use default ordering.
  static OrderByListBuilder<AuthUserTable> _orderBy(
    AdminListRequest request,
  ) {
    final descending = request.sortDesc;

    return (t) => switch (request.sortBy) {
      'blocked' => [descending ? t.blocked.desc() : t.blocked.asc()],
      'createdAt' => [descending ? t.createdAt.desc() : t.createdAt.asc()],
      _ => [t.createdAt.desc(), t.id.desc()],
    };
  }

  /// The auth core only exposes profile creation to admins, so edits write the row.
  static Future<void> _saveProfile(
    Session session,
    UuidValue authUserId, {
    required String? name,
    required String email,
    required Transaction transaction,
  }) async {
    final profile = await AdminUserService.profileFor(
      session,
      authUserId,
      transaction: transaction,
    );

    if (profile == null) {
      await AuthServices.instance.userProfiles.createUserProfile(
        session,
        authUserId,
        UserProfileData(fullName: name, email: email),
        transaction: transaction,
      );
      return;
    }

    profile
      ..fullName = name
      ..email = email;

    await UserProfile.db.updateRow(session, profile, transaction: transaction);
  }

  /// The admin scope follows the status: active carries [AdminScopeService.admin],
  /// disabled does not; it is minted on the next login.
  static Future<void> _saveAdminProfile(
    Session session,
    UuidValue authUserId, {
    required AdminAccountStatus status,
    required Transaction transaction,
  }) async {
    final profile = await AdminProfile.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(authUserId),
      transaction: transaction,
    );
    final now = DateTime.now().toUtc();

    if (profile == null) {
      await AdminProfile.db.insertRow(
        session,
        AdminProfile(
          userId: authUserId,
          status: status,
          createdAt: now,
          updatedAt: now,
        ),
        transaction: transaction,
      );
    } else {
      profile
        ..status = status
        ..updatedAt = now;

      await AdminProfile.db.updateRow(
        session,
        profile,
        transaction: transaction,
      );
    }

    await AdminScopeService.sync(
      session,
      authUserId,
      active: status == AdminAccountStatus.active,
      transaction: transaction,
    );
  }

  static Future<void> _assertEmailFree(
    Session session,
    String email, {
    UuidValue? exceptAccountId,
    required Transaction transaction,
  }) async {
    final taken = await EmailAccount.db.findFirstRow(
      session,
      where: (t) => t.email.equals(email),
      transaction: transaction,
    );

    if (taken != null && taken.id != exceptAccountId) {
      throw Exception('$email is already in use.');
    }
  }

  static String _normalizedEmail(String raw) {
    final email = raw.trim().toLowerCase();
    if (email.isEmpty) {
      throw Exception('An email is required.');
    }

    return email;
  }

  static String? _emptyToNull(String? value) {
    final trimmed = value?.trim();

    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}
