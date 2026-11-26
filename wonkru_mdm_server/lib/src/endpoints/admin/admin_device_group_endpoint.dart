import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../util/page_params.dart';
import '../../service/admin_auth_service.dart';
import '../../service/admin_scope_service.dart';
import '../../service/device_group_service.dart';
import '../../util/like_pattern.dart';
import 'admin_audit.dart';

/// Group membership lives in the `device_device_group` pivot (cascades on
/// delete); writes never bump a policy version.
class AdminDeviceGroupEndpoint extends Endpoint with AdminAudit {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {AdminScopeService.admin};

  static const maxPerPage = PageParams.maxPerPage;

  /// No device-count sort: it needs a join the query builder cannot express.
  Future<DeviceGroupPage> list(
    Session session,
    AdminListRequest request,
  ) async {
    await AdminAuthService.requireAdmin(session);

    final params = PageParams.from(request.page, request.perPage);
    final search = request.search?.trim();

    final WhereExpressionBuilder<DeviceGroupTable>? where =
        search == null || search.isEmpty
        ? null
        : (t) =>
              t.name.ilike(likeContains(search)) |
              t.description.ilike(likeContains(search));

    final total = await DeviceGroup.db.count(session, where: where);
    final items = await DeviceGroup.db.find(
      session,
      where: where,
      limit: params.perPage,
      offset: params.offset,
      orderByList: _orderBy(request),
    );

    final counts = await DeviceGroupService.deviceCounts(
      session,
      items.map((group) => group.id!),
    );

    return DeviceGroupPage(
      items: [
        for (final group in items)
          DeviceGroupRow(group: group, deviceCount: counts[group.id] ?? 0),
      ],
      total: total,
      page: params.page,
      perPage: params.perPage,
    );
  }

  Future<DeviceGroup> get(Session session, int id) async {
    await AdminAuthService.requireAdmin(session);

    final deviceGroup = await _require(session, id);

    await audit(
      session,
      action: 'device_group.view',
      targetType: 'device_group',
      targetId: id,
    );

    return deviceGroup;
  }

  Future<DeviceGroup> create(
    Session session,
    DeviceGroup deviceGroup,
  ) async {
    await AdminAuthService.requireAdmin(session);

    final now = DateTime.now().toUtc();
    deviceGroup
      ..id = null
      ..createdAt = now
      ..updatedAt = now;

    final created = await DeviceGroup.db.insertRow(session, deviceGroup);

    await audit(
      session,
      action: 'device_group.create',
      targetType: 'device_group',
      targetId: created.id,
    );

    return created;
  }

  Future<DeviceGroup> update(
    Session session,
    DeviceGroup deviceGroup,
  ) async {
    await AdminAuthService.requireAdmin(session);

    final groupId = deviceGroup.id;
    if (groupId == null) {
      throw Exception('A device group id is required to update a group.');
    }

    final stored = await DeviceGroup.db.findById(session, groupId);
    if (stored == null) {
      throw Exception('Device group $groupId does not exist.');
    }

    deviceGroup
      ..createdAt = stored.createdAt
      ..updatedAt = DateTime.now().toUtc();

    final updated = await DeviceGroup.db.updateRow(session, deviceGroup);

    await audit(
      session,
      action: 'device_group.update',
      targetType: 'device_group',
      targetId: groupId,
    );

    return updated;
  }

  /// Deleting a group clears `groupId` on devices via the `SetNull` relation.
  Future<int> delete(Session session, List<int> deviceGroupIds) async {
    await AdminAuthService.requireAdmin(session);

    if (deviceGroupIds.isEmpty) {
      return 0;
    }

    final deleted = await DeviceGroup.db.deleteWhere(
      session,
      where: (t) => t.id.inSet(deviceGroupIds.toSet()),
    );

    await audit(
      session,
      action: 'device_group.delete',
      targetType: 'device_group',
      data: {
        'ids': [
          for (final group in deleted)
            if (group.id != null) group.id!,
        ],
        'count': deleted.length,
      },
    );

    return deleted.length;
  }

  static OrderByListBuilder<DeviceGroupTable> _orderBy(
    AdminListRequest request,
  ) {
    final descending = request.sortDesc;

    return (t) => switch (request.sortBy) {
      'name' => [descending ? t.name.desc() : t.name.asc()],
      'createdAt' => [descending ? t.createdAt.desc() : t.createdAt.asc()],
      _ => [t.createdAt.desc(), t.id.desc()],
    };
  }

  static Future<DeviceGroup> _require(Session session, int id) async {
    final deviceGroup = await DeviceGroup.db.findById(session, id);
    if (deviceGroup == null) {
      throw Exception('Device group $id does not exist.');
    }

    return deviceGroup;
  }
}
