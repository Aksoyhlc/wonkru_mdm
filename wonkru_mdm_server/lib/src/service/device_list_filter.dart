import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../util/like_pattern.dart';
import 'dashboard_service.dart';
import 'device_group_service.dart';
import 'setting_service.dart';

/// Builds the `where` clause for the device list and its CSV export.
///
/// The ternary filters accept `true`, `false` or `null` (all), where `false`
/// inverts the condition. Filters the ORM cannot express — group membership and
/// the free-storage ratio — resolve their device ids first.
class DeviceListFilter {
  const DeviceListFilter._();

  /// Minutes after which a device counts as offline.
  static const offlineTimeoutSettingKey = 'offline_timeout';

  static const defaultOfflineTimeoutMinutes = 5;

  static Future<Expression Function(DeviceTable)> build(
    Session session,
    DeviceListRequest request,
  ) async {
    final search = request.search?.trim();
    final brand = request.brand?.trim();
    final manufacturer = request.manufacturer?.trim();
    final androidVersion = request.androidVersion?.trim();

    // The group filter matches through the pivot, so the members have to be
    // resolved before the query is built.
    final groupDeviceIds = request.deviceGroupId == null
        ? null
        : await DeviceGroupService.deviceIdsInGroup(
            session,
            request.deviceGroupId!,
          );

    final offlineCutoff = request.isOnline == null
        ? null
        : DateTime.now().toUtc().subtract(
            Duration(
              minutes:
                  await SettingService.getInt(
                    session,
                    offlineTimeoutSettingKey,
                    fallback: defaultOfflineTimeoutMinutes,
                  ) ??
                  defaultOfflineTimeoutMinutes,
            ),
          );

    final criticalStorageIds = request.criticalStorage == null
        ? null
        : await _criticalStorageIds(session);

    final notSeenCutoff = DateTime.now().toUtc().subtract(
      const Duration(hours: 24),
    );

    Expression where(DeviceTable t) {
      final expressions = <Expression>[];

      if (search != null && search.isNotEmpty) {
        expressions.add(
          t.name.ilike(likeContains(search)) |
              t.code.ilike(likeContains(search)) |
              t.uuid.ilike(likeContains(search)),
        );
      }
      if (brand != null && brand.isNotEmpty) {
        expressions.add(t.brand.ilike(likeContains(brand)));
      }
      if (manufacturer != null && manufacturer.isNotEmpty) {
        expressions.add(t.manufacturer.ilike(likeContains(manufacturer)));
      }
      if (androidVersion != null && androidVersion.isNotEmpty) {
        expressions.add(t.androidVersion.ilike(likeContains(androidVersion)));
      }
      if (request.policyId != null) {
        expressions.add(t.policyId.equals(request.policyId));
      }
      if (groupDeviceIds != null) {
        expressions.add(t.id.inSet(groupDeviceIds));
      }
      if (request.isRooted != null) {
        expressions.add(t.isRooted.equals(request.isRooted));
      }
      if (request.isLauncherMode != null) {
        expressions.add(t.isLauncherMode.equals(request.isLauncherMode));
      }
      if (offlineCutoff != null) {
        expressions.add(
          request.isOnline!
              ? t.lastSeenAt >= offlineCutoff
              : (t.lastSeenAt < offlineCutoff) | t.lastSeenAt.equals(null),
        );
      }
      if (request.criticalBattery != null) {
        expressions.add(
          request.criticalBattery!
              ? t.batteryLevel < DashboardService.criticalBatteryLevel
              : (t.batteryLevel >= DashboardService.criticalBatteryLevel) |
                    t.batteryLevel.equals(null),
        );
      }
      if (criticalStorageIds != null) {
        expressions.add(
          request.criticalStorage!
              ? t.id.inSet(criticalStorageIds)
              : t.id.notInSet(criticalStorageIds),
        );
      }
      if (request.notSeen24h != null) {
        expressions.add(
          request.notSeen24h!
              ? (t.lastSeenAt < notSeenCutoff) | t.lastSeenAt.equals(null)
              : t.lastSeenAt >= notSeenCutoff,
        );
      }
      if (request.noPolicy != null) {
        expressions.add(
          request.noPolicy!
              ? t.policyId.equals(null)
              : t.policyId.notEquals(null),
        );
      }

      return expressions.isEmpty
          ? Constant.bool(true)
          : expressions.reduce((left, right) => left & right);
    }

    return where;
  }

  /// Ids of the devices whose free storage ratio is critical.
  ///
  /// The ORM cannot compare the ratio in SQL, so candidates are read back and
  /// filtered here.
  static Future<Set<int>> _criticalStorageIds(Session session) async {
    final candidates = await Device.db.find(
      session,
      where: (t) => t.totalStorageBytes > 0,
    );

    return {
      for (final device in candidates)
        if (device.id != null &&
            device.freeStorageBytes != null &&
            device.totalStorageBytes != null &&
            device.freeStorageBytes! * 100.0 / device.totalStorageBytes! <
                DashboardService.criticalStoragePercentage)
          device.id!,
    };
  }
}
