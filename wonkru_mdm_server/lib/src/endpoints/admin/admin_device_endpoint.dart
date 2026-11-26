import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:wonkru_core_server/wonkru_core_server.dart' show DeviceAction, DeviceCommandStatus;

import '../../generated/future_calls.dart';
import '../../generated/protocol.dart';
import '../../service/admin_auth_service.dart';
import '../../service/admin_scope_service.dart';
import '../../service/device_command_service.dart';
import '../../service/device_connection_registry.dart';
import '../../service/device_group_service.dart';
import '../../service/device_list_filter.dart';
import '../../service/device_pdf_report_service.dart';
import '../../service/device_service.dart';
import '../../service/policy_clone_service.dart';
import '../../util/app_date_time.dart';
import '../../util/csv.dart';
import '../../util/page_params.dart';
import 'admin_audit.dart';

class AdminDeviceEndpoint extends Endpoint with AdminAudit {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {AdminScopeService.admin};

  static const maxPerPage = PageParams.maxPerPage;

  /// Minutes after which a device counts as offline.
  static const offlineTimeoutSettingKey = DeviceListFilter.offlineTimeoutSettingKey;

  static const exportHeaders = <String>[
    'code',
    'name',
    'manufacturer',
    'model',
    'brand',
    'android_version',
    'sdk_version',
    'battery_level',
    'is_rooted',
    'is_launcher_mode',
    'policy_id',
    'group_id',
    'last_seen_at',
    'collected_at',
  ];

  Future<DevicePage> list(Session session, DeviceListRequest request) async {
    await AdminAuthService.requireAdmin(session);

    final params = PageParams.from(request.page, request.perPage);
    final where = await DeviceListFilter.build(session, request);

    final total = await Device.db.count(session, where: where);
    final items = await Device.db.find(
      session,
      where: where,
      limit: params.perPage,
      offset: params.offset,
      orderByList: _orderBy(request),
    );

    return DevicePage(
      items: items,
      total: total,
      page: params.page,
      perPage: params.perPage,
    );
  }

  /// Exports every matching row, not just the current page.
  Future<ByteData> export(Session session, DeviceListRequest request) async {
    await AdminAuthService.requireAdmin(session);

    final where = await DeviceListFilter.build(session, request);
    final rows = await Device.db.find(
      session,
      where: where,
      limit: PageParams.maxExportRows,
      orderByList: _orderBy(request),
    );

    await audit(session, action: 'device.export');

    return csvBytes(_toCsv(rows));
  }

  Future<Device> get(Session session, int deviceId) async {
    await AdminAuthService.requireAdmin(session);

    final device = await _require(session, deviceId);

    await audit(
      session,
      action: 'device.view',
      targetType: 'device',
      targetId: deviceId,
    );

    return device;
  }

  /// [locale] is `tr` or `en`; an empty or unknown value falls back to Turkish.
  Future<ByteData> reportPdf(
    Session session,
    int deviceId,
    String? locale,
  ) async {
    await AdminAuthService.requireAdmin(session);

    final bytes = await DevicePdfReportService.build(
      session,
      deviceId,
      locale: locale,
    );

    await audit(
      session,
      action: 'device.report',
      targetType: 'device',
      targetId: deviceId,
    );

    return ByteData.sublistView(bytes);
  }

  /// Latest sync state, or null when the device has never synced.
  Future<DeviceStateCache?> stateCache(Session session, int deviceId) async {
    await AdminAuthService.requireAdmin(session);

    return DeviceStateCache.db.findFirstRow(
      session,
      where: (t) => t.deviceId.equals(deviceId),
    );
  }

  Future<List<int>> groupIds(Session session, int deviceId) async {
    await AdminAuthService.requireAdmin(session);
    return DeviceGroupService.groupIdsForDevice(session, deviceId);
  }

  Future<List<DeviceApplication>> applications(
    Session session,
    int deviceId,
  ) async {
    await AdminAuthService.requireAdmin(session);

    return DeviceApplication.db.find(
      session,
      where: (t) => t.deviceId.equals(deviceId),
      orderBy: (t) => t.appName,
    );
  }

  Future<List<DeviceReport>> reports(
    Session session,
    int deviceId, {
    int limit = 100,
  }) async {
    await AdminAuthService.requireAdmin(session);

    final safeLimit = PageParams.clampSize(limit);

    return DeviceReport.db.find(
      session,
      where: (t) => t.deviceId.equals(deviceId),
      orderByList: (t) => [t.createdAt.desc(), t.id.desc()],
      limit: safeLimit,
    );
  }

  /// An emptied policy falls back to the default policy.
  Future<Device> update(
    Session session,
    AdminDeviceUpdateRequest request,
  ) async {
    await AdminAuthService.requireAdmin(session);

    final saved = await session.db.transaction((transaction) async {
      final device = await Device.db.findById(
        session,
        request.deviceId,
        transaction: transaction,
      );
      if (device == null) {
        throw Exception('Device ${request.deviceId} does not exist.');
      }

      final code = request.code;
      if (code != null) {
        final sanitized = DeviceService.sanitizeCode(code);
        if (sanitized == null) {
          throw Exception('Device code "$code" is not usable.');
        }

        if (sanitized != device.code) {
          final taken = await Device.db.findFirstRow(
            session,
            where: (t) => t.code.equals(sanitized),
            transaction: transaction,
          );
          if (taken != null && taken.id != device.id) {
            throw Exception('Device code $sanitized is already taken.');
          }
        }

        device.code = sanitized;
      }

      device
        ..name = request.name
        ..policyId = request.policyId
        ..userId = request.userId
        ..mustUseApplications = request.mustUseApplications
        ..updatedAt = DateTime.now().toUtc();

      await DeviceService.applySavingDefaults(
        session,
        device,
        transaction: transaction,
      );

      // Only the columns the form owns: a concurrent sync/heartbeat must not be
      // reverted by a stale copy.
      final saved = await Device.db.updateRow(
        session,
        device,
        columns: (t) => [
          t.code,
          t.uuid,
          t.name,
          t.policyId,
          t.userId,
          t.mustUseApplications,
          t.createdAt,
          t.updatedAt,
        ],
        transaction: transaction,
      );

      final deviceGroupIds = request.deviceGroupIds;
      if (deviceGroupIds != null) {
        await DeviceGroupService.syncDeviceGroups(
          session,
          saved.id!,
          deviceGroupIds,
          transaction: transaction,
        );
      }

      return saved;
    });

    await audit(
      session,
      action: 'device.update',
      targetType: 'device',
      targetId: saved.id,
    );

    return saved;
  }

  Future<int> delete(Session session, List<int> deviceIds) async {
    await AdminAuthService.requireAdmin(session);

    if (deviceIds.isEmpty) {
      return 0;
    }

    final deleted = await Device.db.deleteWhere(
      session,
      where: (t) => t.id.inSet(deviceIds.toSet()),
    );

    // Close the deleted device's command stream, or it would keep receiving commands.
    final registry = DeviceConnectionRegistry.instance;
    for (final device in deleted) {
      final uuid = device.uuid;
      if (uuid != null && uuid.isNotEmpty) {
        registry.disconnect(uuid);
      }
    }

    await audit(
      session,
      action: 'device.delete',
      targetType: 'device',
      data: {
        'ids': [
          for (final device in deleted)
            if (device.id != null) device.id!,
        ],
        'count': deleted.length,
      },
    );

    return deleted.length;
  }

  /// Moves the selected devices onto [policyId]; pushing is up to [sendPolicyUpdate].
  Future<int> assignPolicy(
    Session session,
    List<int> deviceIds,
    int policyId,
  ) async {
    await AdminAuthService.requireAdmin(session);

    if (deviceIds.isEmpty) {
      return 0;
    }

    final count = await DeviceService.assignPolicy(
      session,
      deviceIds,
      policyId,
    );

    await audit(
      session,
      action: 'device.assign_policy',
      targetType: 'device',
      targetId: deviceIds.length == 1 ? deviceIds.first : null,
      data: {'ids': deviceIds, 'policy_id': policyId},
    );

    return count;
  }

  Future<int> assignGroups(
    Session session,
    List<int> deviceIds,
    List<int> groupIds,
  ) async {
    await AdminAuthService.requireAdmin(session);

    if (deviceIds.isEmpty) {
      return 0;
    }

    final count = await session.db.transaction((transaction) async {
      for (final deviceId in deviceIds) {
        await DeviceGroupService.syncDeviceGroups(
          session,
          deviceId,
          groupIds,
          transaction: transaction,
        );
      }

      return deviceIds.length;
    });

    await audit(
      session,
      action: 'device.assign_groups',
      targetType: 'device',
      targetId: deviceIds.length == 1 ? deviceIds.first : null,
      data: {'ids': deviceIds, 'group_ids': groupIds},
    );

    return count;
  }

  Future<int> sendPolicyUpdate(
    Session session,
    List<int> deviceIds,
  ) async {
    await AdminAuthService.requireAdmin(session);

    if (deviceIds.isEmpty) {
      return 0;
    }

    final devices = await Device.db.find(
      session,
      where: (t) => t.id.inSet(deviceIds.toSet()),
    );

    final byPolicy = <int, List<int>>{};
    for (final device in devices) {
      final policyId = device.policyId;
      final deviceId = device.id;
      if (policyId == null || deviceId == null) {
        continue;
      }

      byPolicy.putIfAbsent(policyId, () => []).add(deviceId);
    }

    final futureCalls = session.serverpod.futureCalls;
    for (final entry in byPolicy.entries) {
      await futureCalls
          .callWithDelay(Duration.zero)
          .sendPolicy
          .send(
            SendPolicyCall(policyId: entry.key, deviceIds: entry.value),
          );
    }

    final count = byPolicy.values.fold<int>(
      0,
      (total, ids) => total + ids.length,
    );

    await audit(
      session,
      action: 'device.policy_push',
      targetType: 'device',
      targetId: deviceIds.length == 1 ? deviceIds.first : null,
      data: {'ids': deviceIds},
    );

    return count;
  }

  Future<DeviceCommandBulkStatus> sendCommand(
    Session session,
    List<int> deviceIds,
    String action,
    String? paramsJson,
  ) async {
    await AdminAuthService.requireAdmin(session);

    final prepared = DeviceCommandService.prepare(
      action,
      paramsJson,
      deviceCount: deviceIds.length,
    );
    final deviceAction = prepared.action;
    final params = prepared.params;

    final devices = await Device.db.find(
      session,
      where: (t) => t.id.inSet(deviceIds.toSet()),
    );

    final ids = [
      for (final device in devices)
        if (device.id != null) device.id!,
    ];

    // `policy_change` is written before the command is queued so the device sees
    // the new policy when it fetches its config.
    if (deviceAction == DeviceAction.policy_change) {
      final policyId = int.tryParse((params['policy_id'] ?? '').trim());
      if (policyId == null) {
        throw DeviceCommandValidationException(
          message: 'The "policy_id" parameter is required for "$action".',
        );
      }
      params['policy_id'] = '$policyId';
      await DeviceService.assignPolicy(session, ids, policyId);
    }

    final bulkId = const Uuid().v7();
    await DeviceCommandService.enqueue(
      session,
      ids,
      deviceAction,
      params,
      bulkId: bulkId,
    );
    await DeviceCommandService.flushAllFor(session, ids);

    await audit(
      session,
      action: 'device.command',
      targetType: 'device',
      targetId: ids.length == 1 ? ids.first : null,
      data: {'action': action, 'ids': ids, 'bulk_id': bulkId},
    );

    return _bulkStatus(session, bulkId);
  }

  /// A send is terminal once `pending + sent` reaches zero.
  Future<DeviceCommandBulkStatus> bulkStatus(
    Session session,
    String bulkId,
  ) async {
    await AdminAuthService.requireAdmin(session);
    return _bulkStatus(session, bulkId);
  }

  Future<List<DeviceCommand>> bulkCommands(
    Session session,
    String bulkId,
  ) async {
    await AdminAuthService.requireAdmin(session);
    return DeviceCommand.db.find(
      session,
      where: (t) => t.bulkId.equals(bulkId),
      orderBy: (t) => t.id,
      limit: maxBulkCommands,
    );
  }

  static const maxBulkCommands = 100;

  /// `total` counts the `bulkId` rows directly, so an unknown status is still counted.
  static Future<DeviceCommandBulkStatus> _bulkStatus(
    Session session,
    String bulkId,
  ) async {
    Expression where(DeviceCommandTable t) => t.bulkId.equals(bulkId);

    Future<int> countFor(DeviceCommandStatus status) => DeviceCommand.db.count(
      session,
      where: (t) => where(t) & t.status.equals(status),
    );

    final total = await DeviceCommand.db.count(session, where: where);
    final pending = await countFor(DeviceCommandService.statusPending);
    final sent = await countFor(DeviceCommandService.statusSent);
    final acked = await countFor(DeviceCommandService.statusAcked);
    final timeout = await countFor(DeviceCommandService.statusTimeout);
    final error = await countFor(DeviceCommandService.statusError);

    return DeviceCommandBulkStatus(
      bulkId: bulkId,
      total: total,
      pending: pending,
      sent: sent,
      acked: acked,
      timeout: timeout,
      error: error,
    );
  }

  Future<DeviceCommandPage> commands(
    Session session,
    int deviceId,
    AdminListRequest request,
  ) async {
    await AdminAuthService.requireAdmin(session);

    final params = PageParams.from(request.page, request.perPage);

    Expression where(DeviceCommandTable t) => t.deviceId.equals(deviceId);

    final total = await DeviceCommand.db.count(session, where: where);
    final items = await DeviceCommand.db.find(
      session,
      where: where,
      limit: params.perPage,
      offset: params.offset,
      orderByList: _commandOrderBy,
    );

    return DeviceCommandPage(
      items: items,
      total: total,
      page: params.page,
      perPage: params.perPage,
    );
  }

  Future<DeviceCommandPage> recentCommands(
    Session session,
    AdminListRequest request,
  ) async {
    await AdminAuthService.requireAdmin(session);

    final params = PageParams.from(request.page, request.perPage);

    final total = await DeviceCommand.db.count(session);
    final items = await DeviceCommand.db.find(
      session,
      limit: params.perPage,
      offset: params.offset,
      orderByList: _commandOrderBy,
    );

    return DeviceCommandPage(
      items: items,
      total: total,
      page: params.page,
      perPage: params.perPage,
    );
  }

  static OrderByListBuilder<DeviceCommandTable> get _commandOrderBy =>
      (t) => [t.createdAt.desc(), t.id.desc()];

  Future<Policy> duplicatePolicy(Session session, int deviceId) async {
    await AdminAuthService.requireAdmin(session);

    final copy = await session.db.transaction((transaction) async {
      final device = await Device.db.findById(
        session,
        deviceId,
        transaction: transaction,
      );
      if (device == null) {
        throw Exception('Device $deviceId does not exist.');
      }

      final sourcePolicyId = device.policyId;
      if (sourcePolicyId == null) {
        throw Exception('Device $deviceId has no policy to copy.');
      }

      final source = await Policy.db.findById(
        session,
        sourcePolicyId,
        transaction: transaction,
      );
      if (source == null) {
        throw Exception('Policy $sourcePolicyId does not exist.');
      }

      final copy = await PolicyCloneService.duplicate(
        session,
        source,
        newName: PolicyCloneService.devicePolicyName(device),
        transaction: transaction,
      );

      device
        ..policyId = copy.id
        ..updatedAt = DateTime.now().toUtc();
      await Device.db.updateRow(
        session,
        device,
        columns: (t) => [t.policyId, t.updatedAt],
        transaction: transaction,
      );

      return copy;
    });

    await audit(
      session,
      action: 'policy.duplicate',
      targetType: 'policy',
      targetId: copy.id,
      data: {'device_id': deviceId},
    );

    return copy;
  }

  static OrderByListBuilder<DeviceTable> _orderBy(DeviceListRequest request) {
    final descending = request.sortDesc;

    return (t) => switch (request.sortBy) {
      'name' => [descending ? t.name.desc() : t.name.asc()],
      'code' => [descending ? t.code.desc() : t.code.asc()],
      'lastSeenAt' => [descending ? t.lastSeenAt.desc() : t.lastSeenAt.asc()],
      'createdAt' => [descending ? t.createdAt.desc() : t.createdAt.asc()],
      _ => [t.collectedAt.desc(), t.id.desc()],
    };
  }

  static Future<Device> _require(Session session, int id) async {
    final device = await Device.db.findById(session, id);
    if (device == null) {
      throw Exception('Device $id does not exist.');
    }

    return device;
  }

  static String _toCsv(List<Device> devices) => csvDocument(exportHeaders, [
    for (final device in devices)
      [
        device.code,
        device.name ?? '',
        device.manufacturer ?? '',
        device.model ?? '',
        device.brand ?? '',
        device.androidVersion ?? '',
        device.sdkVersion?.toString() ?? '',
        device.batteryLevel?.toString() ?? '',
        device.isRooted.toString(),
        device.isLauncherMode.toString(),
        device.policyId?.toString() ?? '',
        device.groupId?.toString() ?? '',
        formatDateTime(device.lastSeenAt),
        formatDateTime(device.collectedAt),
      ],
  ]);
}
