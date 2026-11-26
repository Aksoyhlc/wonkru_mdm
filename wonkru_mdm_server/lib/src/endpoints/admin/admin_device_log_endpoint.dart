import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../util/page_params.dart';
import '../../util/csv.dart';
import '../../service/admin_auth_service.dart';
import '../../service/admin_scope_service.dart';
import '../../service/device_log_service.dart';
import 'admin_audit.dart';

class AdminDeviceLogEndpoint extends Endpoint with AdminAudit {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {AdminScopeService.admin};

  static const maxPerPage = PageParams.maxPerPage;

  Future<DeviceLogPage> list(
    Session session,
    AdminDeviceLogListRequest request,
  ) async {
    await AdminAuthService.requireAdmin(session);

    final params = PageParams.from(request.page, request.perPage);
    final where = await DeviceLogService.buildWhere(session, request);

    final total = await DeviceLog.db.count(session, where: where);
    final items = await DeviceLog.db.find(
      session,
      where: where,
      limit: params.perPage,
      offset: params.offset,
      orderByList: DeviceLogService.orderBy(request),
    );

    return DeviceLogPage(
      items: await _rows(session, items),
      total: total,
      page: params.page,
      perPage: params.perPage,
    );
  }

  Future<DeviceLogRow> get(Session session, int id) async {
    await AdminAuthService.requireAdmin(session);

    final log = await _require(session, id);
    final row = (await _rows(session, [log])).single;

    await audit(
      session,
      action: 'device_log.view',
      targetType: 'device_log',
      targetId: id,
    );

    return row;
  }

  Future<DeviceLog> create(Session session, DeviceLog log) async {
    await AdminAuthService.requireAdmin(session);

    if (log.message.isEmpty) {
      throw Exception('A message is required to create a log entry.');
    }

    final now = DateTime.now().toUtc();
    log
      ..id = null
      ..createdAt = now
      ..updatedAt = now;

    final created = await DeviceLog.db.insertRow(session, log);

    await audit(
      session,
      action: 'device_log.create',
      targetType: 'device_log',
      targetId: created.id,
    );

    return created;
  }

  Future<int> delete(Session session, List<int> logIds) async {
    await AdminAuthService.requireAdmin(session);

    if (logIds.isEmpty) {
      return 0;
    }

    final deleted = await DeviceLog.db.deleteWhere(
      session,
      where: (t) => t.id.inSet(logIds.toSet()),
    );

    await audit(
      session,
      action: 'device_log.delete',
      targetType: 'device_log',
      data: {'ids': logIds, 'count': deleted.length},
    );

    return deleted.length;
  }

  Future<DeviceLogStats> stats(Session session) async {
    await AdminAuthService.requireAdmin(session);

    return DeviceLogService.stats(session);
  }

  /// [period] is `24` hours, or `7` and `30` days.
  Future<List<DeviceLogLevelSlice>> levelDistribution(
    Session session,
    String period,
  ) async {
    await AdminAuthService.requireAdmin(session);

    return DeviceLogService.levelDistribution(session, period);
  }

  /// [period] is `24` hours, or `7` and `30` days.
  Future<DeviceLogTrend> trend(Session session, String period) async {
    await AdminAuthService.requireAdmin(session);

    return DeviceLogService.trend(session, period);
  }

  /// Exports every matching row, not just the current page.
  Future<ByteData> export(
    Session session,
    AdminDeviceLogListRequest request,
  ) async {
    await AdminAuthService.requireAdmin(session);

    final where = await DeviceLogService.buildWhere(session, request);
    final rows = await DeviceLog.db.find(
      session,
      where: where,
      limit: PageParams.maxExportRows,
      orderByList: DeviceLogService.orderBy(request),
    );

    final csv = DeviceLogService.toCsv(await _rows(session, rows));

    await audit(session, action: 'device_log.export');

    return csvBytes(csv);
  }

  static Future<List<DeviceLogRow>> _rows(
    Session session,
    List<DeviceLog> logs,
  ) async {
    final labels = await DeviceLogService.deviceLabels(
      session,
      {for (final log in logs) log.deviceId},
    );

    return [
      for (final log in logs)
        DeviceLogRow(log: log, deviceLabel: labels[log.deviceId]),
    ];
  }

  static Future<DeviceLog> _require(Session session, int id) async {
    final log = await DeviceLog.db.findById(session, id);
    if (log == null) {
      throw Exception('Device log $id does not exist.');
    }

    return log;
  }
}
