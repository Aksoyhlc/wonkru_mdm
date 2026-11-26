import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../util/page_params.dart';
import '../../service/admin_auth_service.dart';
import '../../service/admin_scope_service.dart';
import '../../service/device_notification_service.dart';
import '../../util/like_pattern.dart';
import 'admin_audit.dart';

/// Sent messages are immutable: no update, only list/create/view/delete.
class AdminDeviceNotificationEndpoint extends Endpoint with AdminAudit {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {AdminScopeService.admin};

  static const maxPerPage = PageParams.maxPerPage;

  Future<DeviceNotificationPage> list(
    Session session,
    AdminListRequest request,
  ) async {
    await AdminAuthService.requireAdmin(session);

    final params = PageParams.from(request.page, request.perPage);
    final search = request.search?.trim();

    final WhereExpressionBuilder<DeviceNotificationTable>? where =
        search == null || search.isEmpty
        ? null
        : (t) => t.title.ilike(likeContains(search));

    final total = await DeviceNotification.db.count(session, where: where);
    final items = await DeviceNotification.db.find(
      session,
      where: where,
      limit: params.perPage,
      offset: params.offset,
      orderByList: _orderBy(request),
    );

    final counts = await DeviceNotificationService.deviceCounts(
      session,
      items.map((notification) => notification.id!),
    );

    return DeviceNotificationPage(
      items: [
        for (final notification in items)
          DeviceNotificationRow(
            notification: notification,
            deviceCount: counts[notification.id] ?? 0,
          ),
      ],
      total: total,
      page: params.page,
      perPage: params.perPage,
    );
  }

  Future<DeviceNotification> get(Session session, int id) async {
    await AdminAuthService.requireAdmin(session);

    final notification = await DeviceNotification.db.findById(session, id);
    if (notification == null) {
      throw Exception('Notification $id does not exist.');
    }

    await audit(
      session,
      action: 'device_notification.view',
      targetType: 'device_notification',
      targetId: id,
    );

    return notification;
  }

  Future<List<DeviceNotificationDeliveryRow>> deliveries(
    Session session,
    int id,
  ) async {
    await AdminAuthService.requireAdmin(session);

    return DeviceNotificationService.deliveries(session, id);
  }

  Future<AdminDeviceNotificationCreateResponse> create(
    Session session,
    AdminDeviceNotificationCreateRequest request,
  ) async {
    await AdminAuthService.requireAdmin(session);

    final created = await DeviceNotificationService.create(session, request);

    await audit(
      session,
      action: 'device_notification.create',
      targetType: 'device_notification',
      targetId: created.notification.id,
      data: {
        'id': created.notification.id,
        'uuid': created.notification.uuid,
      },
    );

    return created;
  }

  Future<int> delete(Session session, List<int> notificationIds) async {
    await AdminAuthService.requireAdmin(session);

    if (notificationIds.isEmpty) {
      return 0;
    }

    final deleted = await DeviceNotification.db.deleteWhere(
      session,
      where: (t) => t.id.inSet(notificationIds.toSet()),
    );

    await audit(
      session,
      action: 'device_notification.delete',
      targetType: 'device_notification',
      data: {'ids': notificationIds, 'count': deleted.length},
    );

    return deleted.length;
  }

  static OrderByListBuilder<DeviceNotificationTable> _orderBy(
    AdminListRequest request,
  ) {
    final descending = request.sortDesc;

    return (t) => switch (request.sortBy) {
      'type' => [descending ? t.type.desc() : t.type.asc()],
      'sentAt' => [descending ? t.sentAt.desc() : t.sentAt.asc()],
      'createdAt' => [descending ? t.createdAt.desc() : t.createdAt.asc()],
      'updatedAt' => [descending ? t.updatedAt.desc() : t.updatedAt.asc()],
      _ => [t.createdAt.desc(), t.id.desc()],
    };
  }
}
