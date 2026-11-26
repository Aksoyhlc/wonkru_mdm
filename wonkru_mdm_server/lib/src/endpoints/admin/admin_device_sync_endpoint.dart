import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../util/page_params.dart';
import '../../util/csv.dart';
import '../../service/admin_auth_service.dart';
import '../../service/admin_scope_service.dart';
import '../../service/device_state_cache_service.dart';
import '../../service/device_sync_service.dart';
import '../../util/like_pattern.dart';
import 'admin_audit.dart';

class AdminDeviceSyncEndpoint extends Endpoint with AdminAudit {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {AdminScopeService.admin};

  static const maxPerPage = PageParams.maxPerPage;

  static const applicationPageSizes = [10, 25, 50, 100];

  Future<DeviceSyncPage> list(
    Session session,
    AdminDeviceSyncListRequest request,
  ) async {
    await AdminAuthService.requireAdmin(session);

    final params = PageParams.from(request.page, request.perPage);
    final where = await DeviceSyncService.buildWhere(session, request);

    final total = await DeviceSync.db.count(session, where: where);
    final items = await DeviceSync.db.find(
      session,
      where: where,
      limit: params.perPage,
      offset: params.offset,
      orderByList: DeviceSyncService.orderBy(request),
    );

    return DeviceSyncPage(
      items: await DeviceSyncService.rows(session, items),
      total: total,
      page: params.page,
      perPage: params.perPage,
    );
  }

  /// Exports every matching row, not just the current page.
  Future<ByteData> export(
    Session session,
    AdminDeviceSyncListRequest request,
  ) async {
    await AdminAuthService.requireAdmin(session);

    final where = await DeviceSyncService.buildWhere(session, request);
    final syncs = await DeviceSync.db.find(
      session,
      where: where,
      limit: PageParams.maxExportRows,
      orderByList: DeviceSyncService.orderBy(request),
    );

    final csv = DeviceSyncService.toCsv(
      await DeviceSyncService.rows(session, syncs),
    );

    await audit(session, action: 'device_sync.export');

    return csvBytes(csv);
  }

  Future<DeviceSyncDetail> get(Session session, int id) async {
    await AdminAuthService.requireAdmin(session);

    final sync = await _require(session, id);
    final detail = DeviceSyncDetail(
      row: await DeviceSyncService.row(session, sync),
      state: DeviceStateCacheService.extract(sync),
    );

    await audit(
      session,
      action: 'device_sync.view',
      targetType: 'device_sync',
      targetId: id,
    );

    return detail;
  }

  Future<DeviceApplicationPage> applications(
    Session session,
    int syncId,
    AdminListRequest request,
  ) async {
    await AdminAuthService.requireAdmin(session);

    final sync = await _require(session, syncId);
    final params = PageParams.from(request.page, request.perPage);
    final search = request.search?.trim();

    Expression where(DeviceApplicationTable t) {
      var expression = t.deviceId.equals(sync.deviceId);

      if (search != null && search.isNotEmpty) {
        expression = expression & t.appName.ilike(likeContains(search));
      }

      return expression;
    }

    final total = await DeviceApplication.db.count(session, where: where);
    final items = await DeviceApplication.db.find(
      session,
      where: where,
      limit: params.perPage,
      offset: params.offset,
      orderByList: (t) => switch (request.sortBy) {
        'versionName' => [
          request.sortDesc ? t.versionName.desc() : t.versionName.asc(),
        ],
        'isSystemApp' => [
          request.sortDesc ? t.isSystemApp.desc() : t.isSystemApp.asc(),
        ],
        _ => [t.appName.asc(), t.id.asc()],
      },
    );

    return DeviceApplicationPage(
      items: items,
      total: total,
      page: params.page,
      perPage: params.perPage,
    );
  }

  static Future<DeviceSync> _require(Session session, int id) async {
    final sync = await DeviceSync.db.findById(session, id);
    if (sync == null) {
      throw Exception('Device sync $id does not exist.');
    }

    return sync;
  }
}
