import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../util/app_date_time.dart';
import '../util/json_utils.dart';
import '../util/like_pattern.dart';
import '../util/csv.dart';

class DeviceSyncService {
  const DeviceSyncService._();

  static const exportHeaders = <String>[
    'id',
    'device_code',
    'device_name',
    'collected_at',
    'battery_level',
    'android_version',
    'policy_name',
    'apps_count',
  ];

  static String toCsv(List<DeviceSyncRow> rows) => csvDocument(exportHeaders, [
    for (final row in rows)
      [
        '${row.deviceSync.id ?? ''}',
        row.deviceCode,
        row.deviceName ?? '',
        formatDateTime(row.deviceSync.collectedAt),
        row.batteryLevel?.toString() ?? '',
        row.androidVersion ?? '',
        row.policyName ?? '',
        '${row.appsCount}',
      ],
  ]);

  static int appsCount(DeviceSync sync) {
    final apps = decodeJsonMap(sync.appsInfo);
    final total = asInt(apps['totalInstalled']);

    return total ?? 0;
  }

  static String deviceCode(Device? device, int deviceId) {
    if (device == null || device.code.isEmpty) {
      return '#$deviceId';
    }

    return device.code;
  }

  static Future<List<DeviceSyncRow>> rows(
    Session session,
    List<DeviceSync> syncs, {
    Transaction? transaction,
  }) async {
    if (syncs.isEmpty) {
      return const [];
    }

    final syncDeviceIds = <int>{for (final sync in syncs) sync.deviceId};

    final devices = await Device.db.find(
      session,
      where: (t) => t.id.inSet(syncDeviceIds),
      transaction: transaction,
    );
    final devicesById = {
      for (final device in devices)
        if (device.id != null) device.id!: device,
    };

    final policyIds = {
      for (final device in devices)
        if (device.policyId != null) device.policyId!,
    };
    final policies = policyIds.isEmpty
        ? const <Policy>[]
        : await Policy.db.find(
            session,
            where: (t) => t.id.inSet(policyIds),
            transaction: transaction,
          );
    final policyNames = {
      for (final policy in policies)
        if (policy.id != null) policy.id!: policy.name,
    };

    return [
      for (final sync in syncs)
        _row(
          sync,
          devicesById[sync.deviceId],
          policyNames,
        ),
    ];
  }

  static Future<DeviceSyncRow> row(Session session, DeviceSync sync) async {
    return (await rows(session, [sync])).single;
  }

  /// `device.code` is the only searchable column, so search resolves matching
  /// devices first.
  static Future<WhereExpressionBuilder<DeviceSyncTable>> buildWhere(
    Session session,
    AdminDeviceSyncListRequest request,
  ) async {
    final search = request.search?.trim();

    Set<int> searchedDeviceIds = const {};
    if (search != null && search.isNotEmpty) {
      final devices = await Device.db.find(
        session,
        where: (t) => t.code.ilike(likeContains(search)),
      );
      searchedDeviceIds = {
        for (final device in devices)
          if (device.id != null) device.id!,
      };
    }

    return (t) {
      final expressions = <Expression>[];

      if (search != null && search.isNotEmpty) {
        expressions.add(
          searchedDeviceIds.isEmpty
              ? Constant.bool(false)
              : t.deviceId.inSet(searchedDeviceIds),
        );
      }
      if (request.deviceId != null) {
        expressions.add(t.deviceId.equals(request.deviceId));
      }
      if (request.from != null) {
        expressions.add(t.collectedAt >= request.from!);
      }
      if (request.to != null) {
        expressions.add(t.collectedAt <= request.to!);
      }

      return expressions.isEmpty
          ? Constant.bool(true)
          : expressions.reduce((left, right) => left & right);
    };
  }

  /// Sort keys, newest snapshot first by default.
  ///
  /// Device, policy and app-count sorting would need joins the ORM does not
  /// offer, so those columns are sorted per page instead.
  static OrderByListBuilder<DeviceSyncTable> orderBy(
    AdminDeviceSyncListRequest request,
  ) {
    final descending = request.sortDesc;

    return (t) => switch (request.sortBy) {
      'id' => [descending ? t.id.desc() : t.id.asc()],
      'syncType' => [descending ? t.syncType.desc() : t.syncType.asc()],
      'createdAt' => [descending ? t.createdAt.desc() : t.createdAt.asc()],
      'collectedAt' => [
        descending ? t.collectedAt.desc() : t.collectedAt.asc(),
      ],
      _ => [t.collectedAt.desc(), t.id.desc()],
    };
  }

  static DeviceSyncRow _row(
    DeviceSync sync,
    Device? device,
    Map<int, String> policyNames,
  ) {
    return DeviceSyncRow(
      deviceSync: sync,
      deviceCode: deviceCode(device, sync.deviceId),
      deviceName: device?.name,
      policyName: device?.policyId == null
          ? null
          : policyNames[device!.policyId],
      policyVersion: device?.policyVersion,
      brand: device?.brand,
      androidVersion: device?.androidVersion,
      batteryLevel: device?.batteryLevel,
      appsCount: appsCount(sync),
    );
  }
}
