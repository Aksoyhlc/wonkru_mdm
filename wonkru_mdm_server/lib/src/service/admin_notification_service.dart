import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class AdminNotificationService {
  const AdminNotificationService._();

  static Future<int> unreadCount(
    Session session,
    UuidValue userId, {
    Transaction? transaction,
  }) {
    return AdminNotification.db.count(
      session,
      where: (t) => t.userId.equals(userId) & t.readAt.equals(null),
      transaction: transaction,
    );
  }

  static Future<AdminNotificationPage> list(
    Session session, {
    int page = 1,
    int perPage = 25,
    UuidValue? userId,
    Transaction? transaction,
  }) async {
    // Negative/zero page and perPage produce a negative offset; even if
    // endpoints clamp, the service must be safe on its own.
    final safePage = page < 1 ? 1 : page;
    final safePerPage = perPage < 1 ? 25 : perPage;

    final WhereExpressionBuilder<AdminNotificationTable>? where = userId == null
        ? null
        : (t) => t.userId.equals(userId);

    final total = await AdminNotification.db.count(
      session,
      where: where,
      transaction: transaction,
    );
    final items = await AdminNotification.db.find(
      session,
      where: where,
      limit: safePerPage,
      offset: (safePage - 1) * safePerPage,
      orderByList: (t) => [t.createdAt.desc(), t.id.desc()],
      transaction: transaction,
    );

    return AdminNotificationPage(
      items: items,
      total: total,
      page: safePage,
      perPage: safePerPage,
    );
  }

  /// Ownership is enforced: another admin's notification is not updated even if
  /// its id is passed.
  static Future<int> markRead(
    Session session,
    List<int> ids,
    UuidValue userId, {
    Transaction? transaction,
  }) async {
    if (ids.isEmpty) {
      return 0;
    }

    final now = DateTime.now().toUtc();

    final updated = await AdminNotification.db.updateWhere(
      session,
      where: (t) => t.id.inSet(ids.toSet()) & t.userId.equals(userId),
      columnValues: (t) => [t.readAt(now)],
      transaction: transaction,
    );

    return updated.length;
  }

  static Future<int> markAllRead(
    Session session,
    UuidValue userId, {
    Transaction? transaction,
  }) async {
    final now = DateTime.now().toUtc();

    final updated = await AdminNotification.db.updateWhere(
      session,
      where: (t) => t.userId.equals(userId) & t.readAt.equals(null),
      columnValues: (t) => [t.readAt(now)],
      transaction: transaction,
    );

    return updated.length;
  }
}
