import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class DeviceGroupService {
  const DeviceGroupService._();

  static Future<void> syncDeviceGroups(
    Session session,
    int deviceId,
    Iterable<int> groupIds, {
    Transaction? transaction,
  }) async {
    final wanted = groupIds.toSet();

    final memberships = await DeviceDeviceGroup.db.find(
      session,
      where: (t) => t.deviceId.equals(deviceId),
      transaction: transaction,
    );

    for (final membership in memberships) {
      if (!wanted.contains(membership.deviceGroupId)) {
        await DeviceDeviceGroup.db.deleteRow(
          session,
          membership,
          transaction: transaction,
        );
      }
    }

    final current = {
      for (final membership in memberships) membership.deviceGroupId,
    };

    for (final groupId in wanted) {
      if (current.contains(groupId)) {
        continue;
      }

      final now = DateTime.now().toUtc();
      await DeviceDeviceGroup.db.insertRow(
        session,
        DeviceDeviceGroup(
          deviceId: deviceId,
          deviceGroupId: groupId,
          createdAt: now,
          updatedAt: now,
        ),
        transaction: transaction,
      );
    }
  }

  static Future<List<int>> groupIdsForDevice(
    Session session,
    int deviceId, {
    Transaction? transaction,
  }) async {
    final memberships = await DeviceDeviceGroup.db.find(
      session,
      where: (t) => t.deviceId.equals(deviceId),
      transaction: transaction,
    );

    return [for (final membership in memberships) membership.deviceGroupId];
  }

  static Future<Set<int>> deviceIdsInGroup(
    Session session,
    int deviceGroupId, {
    Transaction? transaction,
  }) async {
    final memberships = await DeviceDeviceGroup.db.find(
      session,
      where: (t) => t.deviceGroupId.equals(deviceGroupId),
      transaction: transaction,
    );

    return {for (final membership in memberships) membership.deviceId};
  }

  /// Backs the group column of the delivery list. Devices without a group are
  /// absent from the result.
  static Future<Map<int, List<String>>> groupNamesForDevices(
    Session session,
    Iterable<int> deviceIds, {
    Transaction? transaction,
  }) async {
    final ids = deviceIds.toSet();
    if (ids.isEmpty) {
      return const {};
    }

    final memberships = await DeviceDeviceGroup.db.find(
      session,
      where: (t) => t.deviceId.inSet(ids),
      transaction: transaction,
    );
    if (memberships.isEmpty) {
      return const {};
    }

    final groupIds = <int>{};
    for (final membership in memberships) {
      groupIds.add(membership.deviceGroupId);
    }

    final groups = await DeviceGroup.db.find(
      session,
      where: (t) => t.id.inSet(groupIds),
      transaction: transaction,
    );
    final names = {for (final group in groups) group.id!: group.name};

    final result = <int, List<String>>{};
    for (final membership in memberships) {
      final name = names[membership.deviceGroupId];
      if (name == null) {
        continue;
      }

      (result[membership.deviceId] ??= []).add(name);
    }

    return result;
  }

  /// Every requested id is present in the result, so a group without members
  /// reports zero.
  static Future<Map<int, int>> deviceCounts(
    Session session,
    Iterable<int> deviceGroupIds, {
    Transaction? transaction,
  }) async {
    final ids = deviceGroupIds.toSet();
    if (ids.isEmpty) {
      return const {};
    }

    final memberships = await DeviceDeviceGroup.db.find(
      session,
      where: (t) => t.deviceGroupId.inSet(ids),
      transaction: transaction,
    );

    final counts = {for (final id in ids) id: 0};
    for (final membership in memberships) {
      final groupId = membership.deviceGroupId;
      counts[groupId] = (counts[groupId] ?? 0) + 1;
    }

    return counts;
  }
}
