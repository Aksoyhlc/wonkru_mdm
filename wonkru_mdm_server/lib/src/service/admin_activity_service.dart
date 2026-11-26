import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../util/like_pattern.dart';
import 'admin_user_service.dart';
import 'client_ip_resolver.dart';

/// Writes and reads the panel audit trail.
///
/// Records live in `admin_activities`. The actor is snapshotted with the
/// name/email as of the action, so history stays readable after the account is
/// deleted or renamed.
///
/// [record] never breaks the main operation: it swallows and logs its own
/// errors, so a failed audit write does not take down the RPC.
class AdminActivityService {
  const AdminActivityService._();

  /// When [actorUserId] is omitted the session's authenticated user is used;
  /// callers without a session (e.g. failed logins) pass the identity and email
  /// explicitly.
  static Future<void> record(
    Session session, {
    required String action,
    String? targetType,
    Object? targetId,
    Map<String, Object?>? data,
    UuidValue? actorUserId,
    String? actorEmail,
    String? actorName,
    Transaction? transaction,
  }) async {
    try {
      final resolvedUserId = actorUserId ?? _sessionUserId(session);
      var email = _clean(actorEmail);
      var name = _clean(actorName);

      if (resolvedUserId != null && (email == null || name == null)) {
        final rows = await AdminUserService.rowsForUsers(
          session,
          [resolvedUserId],
          transaction: transaction,
        );
        if (rows.isNotEmpty) {
          email ??= _clean(rows.first.email);
          name ??= _clean(rows.first.name);
        }
      }

      await AdminActivity.db.insertRow(
        session,
        AdminActivity(
          actorUserId: resolvedUserId,
          actorEmail: email,
          actorName: name,
          action: action,
          targetType: _clean(targetType),
          targetId: _clean(targetId?.toString()),
          data: data == null || data.isEmpty ? null : jsonEncode(data),
          ipAddress: ClientIpResolver.resolve(session.request),
          createdAt: DateTime.now().toUtc(),
        ),
        transaction: transaction,
      );
    } catch (error, stackTrace) {
      session.log(
        'AdminActivity: record failed ($action)',
        level: LogLevel.warning,
        exception: error,
        stackTrace: stackTrace,
      );
    }
  }

  static Future<AdminActivityPage> list(
    Session session, {
    required int page,
    required int perPage,
    String? search,
    String? sortBy,
    bool sortDesc = false,
    UuidValue? actorUserId,
    String? action,
    DateTime? from,
    DateTime? to,
    Transaction? transaction,
  }) async {
    final where = buildWhere(
      search: search,
      actorUserId: actorUserId,
      action: action,
      from: from,
      to: to,
    );

    final total = await AdminActivity.db.count(
      session,
      where: where,
      transaction: transaction,
    );
    final items = await AdminActivity.db.find(
      session,
      where: where,
      limit: perPage,
      offset: (page - 1) * perPage,
      orderByList: orderBy(sortBy: sortBy, sortDesc: sortDesc),
      transaction: transaction,
    );

    return AdminActivityPage(
      items: items,
      total: total,
      page: page,
      perPage: perPage,
    );
  }

  static WhereExpressionBuilder<AdminActivityTable> buildWhere({
    String? search,
    UuidValue? actorUserId,
    String? action,
    DateTime? from,
    DateTime? to,
  }) {
    final term = _clean(search);
    final normalizedAction = _clean(action);

    return (t) {
      final expressions = <Expression>[];

      if (term != null) {
        final pattern = likeContains(term);
        expressions.add(
          t.actorEmail.ilike(pattern) |
              t.actorName.ilike(pattern) |
              t.targetId.ilike(pattern) |
              t.action.ilike(pattern),
        );
      }
      if (actorUserId != null) {
        expressions.add(t.actorUserId.equals(actorUserId));
      }
      if (normalizedAction != null) {
        expressions.add(t.action.equals(normalizedAction));
      }
      if (from != null) {
        expressions.add(t.createdAt >= from);
      }
      if (to != null) {
        expressions.add(t.createdAt <= to);
      }

      return expressions.isEmpty
          ? Constant.bool(true)
          : expressions.reduce((left, right) => left & right);
    };
  }

  static OrderByListBuilder<AdminActivityTable> orderBy({
    String? sortBy,
    bool sortDesc = false,
  }) {
    return (t) => switch (sortBy) {
      'action' => [sortDesc ? t.action.desc() : t.action.asc()],
      'createdAt' => [sortDesc ? t.createdAt.desc() : t.createdAt.asc()],
      _ => [t.createdAt.desc(), t.id.desc()],
    };
  }

  static Future<List<String>> distinctActions(Session session) async {
    final result = await session.db.unsafeQuery(
      'SELECT DISTINCT "action" AS value FROM "admin_activities" '
      'WHERE "action" IS NOT NULL ORDER BY "action"',
    );

    return [
      for (final row in result)
        if (row.first is String) row.first as String,
    ];
  }

  static UuidValue? _sessionUserId(Session session) {
    final identifier = session.authenticated?.userIdentifier;
    if (identifier == null) {
      return null;
    }

    try {
      return UuidValue.fromString(identifier);
    } on FormatException {
      return null;
    }
  }

  static String? _clean(String? value) {
    final trimmed = value?.trim();

    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}
