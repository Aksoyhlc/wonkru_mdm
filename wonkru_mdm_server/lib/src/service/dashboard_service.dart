import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'setting_service.dart';

class DashboardService {
  const DashboardService._();

  static const criticalBatteryLevel = 20;

  static const criticalStoragePercentage = 10;

  static const distributionFilters = [
    'manufacturer',
    'model',
    'android_version',
  ];

  static const distributionLimit = 10;

  static const distributionPalette = [
    '#3b82f6',
    '#ef4444',
    '#22c55e',
    '#f59e0b',
    '#8b5cf6',
    '#ec4899',
    '#06b6d4',
    '#84cc16',
    '#f97316',
    '#6366f1',
  ];

  static const syncTrendDays = 30;

  static Future<DashboardDeviceStats> deviceStats(
    Session session, {
    Transaction? transaction,
  }) async {
    final onlineMinutes =
        await SettingService.getInt(
          session,
          'offline_timeout',
          fallback: 5,
          transaction: transaction,
        ) ??
        5;
    final onlineThreshold = DateTime.now().toUtc().subtract(
      Duration(minutes: onlineMinutes),
    );

    final totalDevices = await Device.db.count(
      session,
      transaction: transaction,
    );
    final onlineDevices = await Device.db.count(
      session,
      where: (t) => t.lastSeenAt >= onlineThreshold,
      transaction: transaction,
    );

    return DashboardDeviceStats(
      totalDevices: totalDevices,
      onlineDevices: onlineDevices,
      offlineDevices: totalDevices - onlineDevices,
      onlineMinutes: onlineMinutes,
    );
  }

  static Future<DashboardAlertStats> alertStats(
    Session session, {
    Transaction? transaction,
  }) async {
    final criticalBattery = await Device.db.count(
      session,
      where: (t) => t.batteryLevel < criticalBatteryLevel,
      transaction: transaction,
    );

    // The ORM cannot compare a computed ratio, so the candidates are read back
    // and counted here.
    final storageDevices = await Device.db.find(
      session,
      where: (t) => t.totalStorageBytes > 0,
      transaction: transaction,
    );
    final criticalStorage = storageDevices.where((device) {
      final free = device.freeStorageBytes;
      final total = device.totalStorageBytes;

      return free != null &&
          total != null &&
          free * 100.0 / total < criticalStoragePercentage;
    }).length;

    final launcherMode = await Device.db.count(
      session,
      where: (t) => t.isLauncherMode.equals(true),
      transaction: transaction,
    );
    final rooted = await Device.db.count(
      session,
      where: (t) => t.isRooted.equals(true),
      transaction: transaction,
    );

    return DashboardAlertStats(
      criticalBatteryDevices: criticalBattery,
      criticalStorageDevices: criticalStorage,
      launcherModeDevices: launcherMode,
      rootedDevices: rooted,
    );
  }

  // Ties are broken by label so the chart is stable between reads.
  static Future<DashboardChart> deviceDistribution(
    Session session,
    String filter, {
    Transaction? transaction,
  }) async {
    final column = distributionFilters.contains(filter)
        ? filter
        : distributionFilters.first;

    final devices = await Device.db.find(session, transaction: transaction);

    final counts = <String, int>{};
    for (final device in devices) {
      final value = switch (column) {
        'model' => device.model,
        'android_version' => device.androidVersion,
        _ => device.manufacturer,
      };

      if (value == null || value.isEmpty) {
        continue;
      }
      counts[value] = (counts[value] ?? 0) + 1;
    }

    final sorted = counts.entries.toList()
      ..sort((left, right) {
        final byCount = right.value.compareTo(left.value);

        return byCount != 0 ? byCount : left.key.compareTo(right.key);
      });
    final top = sorted.take(distributionLimit).toList();

    return DashboardChart(
      labels: [for (final entry in top) entry.key],
      values: [for (final entry in top) entry.value],
      colors: distributionPalette.take(top.length).toList(),
    );
  }

  static Future<DashboardChart> syncTrend(
    Session session, {
    Transaction? transaction,
  }) async {
    final now = DateTime.now().toUtc();
    final today = DateTime.utc(now.year, now.month, now.day);

    final labels = <String>[];
    final values = <int>[];

    for (var index = syncTrendDays; index >= 0; index--) {
      final start = today.subtract(Duration(days: index));
      final end = start.add(const Duration(days: 1));

      labels.add(_dayLabel(start));
      values.add(
        await DeviceSync.db.count(
          session,
          where: (t) => (t.createdAt >= start) & (t.createdAt < end),
          transaction: transaction,
        ),
      );
    }

    return DashboardChart(labels: labels, values: values);
  }

  static String _dayLabel(DateTime day) {
    final dayOfMonth = day.day.toString().padLeft(2, '0');
    final month = day.month.toString().padLeft(2, '0');

    return '$dayOfMonth $month';
  }
}
