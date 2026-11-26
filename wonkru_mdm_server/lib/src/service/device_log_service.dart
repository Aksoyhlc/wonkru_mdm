import 'package:serverpod/serverpod.dart' hide LogLevel;
import 'package:wonkru_core_server/wonkru_core_server.dart' show LogLevel;

import '../generated/protocol.dart';
import '../util/app_date_time.dart';
import '../util/device_label.dart';
import '../util/like_pattern.dart';
import '../util/csv.dart';

class DeviceLogService {
  const DeviceLogService._();

  static const statsWindowHours = 24;

  static const trendHours = 7;

  static const errorLevels = <int>[4, 5];

  static const levelLabels = <String>[
    'VERBOSE',
    'DEBUG',
    'INFO',
    'WARNING',
    'ERROR',
    'FATAL',
  ];

  static const levelColors = <String>[
    '#6b7280',
    '#3b82f6',
    '#0ea5e9',
    '#f59e0b',
    '#ef4444',
    '#dc2626',
  ];

  static const exportDateTimeFormat = 'd.m.Y H:i:s';

  static const exportHeaders = <String>[
    'device',
    'entry_uuid',
    'session_id',
    'logged_at',
    'level',
    'tag',
    'message',
    'stacktrace',
    'created_at',
  ];

  static String deviceLabel(Device device) => deviceDetailedLabel(device);

  static Future<Map<int, String>> deviceLabels(
    Session session,
    Set<int> deviceIds, {
    Transaction? transaction,
  }) async {
    if (deviceIds.isEmpty) {
      return const {};
    }

    final devices = await Device.db.find(
      session,
      where: (t) => t.id.inSet(deviceIds),
      transaction: transaction,
    );

    return {
      for (final device in devices)
        if (device.id != null) device.id!: deviceLabel(device),
    };
  }

  static Future<WhereExpressionBuilder<DeviceLogTable>> buildWhere(
    Session session,
    AdminDeviceLogListRequest request,
  ) async {
    final search = request.search?.trim();
    final sessionId = request.sessionId?.trim();
    final tag = request.tag?.trim();

    Set<int> searchedDeviceIds = const {};
    if (search != null && search.isNotEmpty) {
      final devices = await Device.db.find(
        session,
        where: (t) => t.name.ilike(likeContains(search)),
      );
      searchedDeviceIds = {
        for (final device in devices)
          if (device.id != null) device.id!,
      };
    }

    final window = _periodWindow(request.period, DateTime.now().toUtc());

    return (t) {
      final expressions = <Expression>[];

      if (search != null && search.isNotEmpty) {
        var text =
            t.tag.ilike(likeContains(search)) |
            t.message.ilike(likeContains(search)) |
            t.entryUuid.ilike(likeContains(search)) |
            t.sessionId.ilike(likeContains(search));

        if (searchedDeviceIds.isNotEmpty) {
          text = text | t.deviceId.inSet(searchedDeviceIds);
        }

        expressions.add(text);
      }
      if (request.levels != null && request.levels!.isNotEmpty) {
        expressions.add(t.level.inSet(request.levels!.toSet()));
      }
      if (request.deviceId != null) {
        expressions.add(t.deviceId.equals(request.deviceId));
      }
      if (request.loggedFrom != null) {
        expressions.add(t.loggedAt >= request.loggedFrom!);
      }
      if (request.loggedUntil != null) {
        expressions.add(t.loggedAt <= request.loggedUntil!);
      }
      if (sessionId != null && sessionId.isNotEmpty) {
        expressions.add(t.sessionId.equals(sessionId));
      }
      if (tag != null && tag.isNotEmpty) {
        expressions.add(t.tag.equals(tag));
      }
      if (request.hasStacktrace != null) {
        expressions.add(
          request.hasStacktrace!
              ? t.stacktrace.notEquals(null)
              : t.stacktrace.equals(null),
        );
      }
      if (window != null) {
        expressions
          ..add(t.loggedAt >= window.from)
          ..add(t.loggedAt < window.to);
      }

      return expressions.isEmpty
          ? Constant.bool(true)
          : expressions.reduce((left, right) => left & right);
    };
  }

  /// The device name is not sortable server-side (it would need a join the ORM
  /// does not offer); the panel sorts that column per page instead.
  static OrderByListBuilder<DeviceLogTable> orderBy(
    AdminDeviceLogListRequest request,
  ) {
    final descending = request.sortDesc;

    return (t) => switch (request.sortBy) {
      'level' => [descending ? t.level.desc() : t.level.asc()],
      'createdAt' => [descending ? t.createdAt.desc() : t.createdAt.asc()],
      _ => [t.loggedAt.desc(), t.id.desc()],
    };
  }

  static Future<DeviceLogStats> stats(Session session) async {
    final now = DateTime.now().toUtc();
    final since = now.subtract(const Duration(hours: statsWindowHours));

    Future<int> count(DateTime from, DateTime to, {bool errorsOnly = false}) {
      return DeviceLog.db.count(
        session,
        where: (t) {
          Expression where = (t.loggedAt >= from) & (t.loggedAt < to);

          if (errorsOnly) {
            where = where & t.level.inSet(errorLevels.toSet());
          }

          return where;
        },
      );
    }

    final totalLogs = await count(since, now);
    final errorCount = await count(since, now, errorsOnly: true);

    final recent = await DeviceLog.db.find(
      session,
      where: (t) => t.loggedAt >= since,
    );
    final activeDevices = {for (final log in recent) log.deviceId}.length;

    final hourlyTrend = <int>[];
    for (var index = trendHours - 1; index >= 0; index--) {
      hourlyTrend.add(
        await count(
          now.subtract(Duration(hours: index + 1)),
          now.subtract(Duration(hours: index)),
        ),
      );
    }

    final errorRate = totalLogs == 0
        ? 0.0
        : (errorCount / totalLogs * 100 * 10).round() / 10;

    return DeviceLogStats(
      totalLogs: totalLogs,
      errorCount: errorCount,
      errorRate: errorRate,
      activeDevices: activeDevices,
      hourlyTrend: hourlyTrend,
    );
  }

  /// [period] is the chart filter: `24` hours, or `7` and `30` days.
  static Future<List<DeviceLogLevelSlice>> levelDistribution(
    Session session,
    String period,
  ) async {
    final now = DateTime.now().toUtc();
    final since = period == '24'
        ? now.subtract(const Duration(hours: 24))
        : now.subtract(Duration(days: int.tryParse(period) ?? 7));

    final slices = <DeviceLogLevelSlice>[];

    for (final level in LogLevel.values) {
      final count = await DeviceLog.db.count(
        session,
        where: (t) => (t.loggedAt >= since) & t.level.equals(level.index),
      );

      slices.add(
        DeviceLogLevelSlice(
          label: levelLabels[level.index],
          level: level.index,
          count: count,
          color: levelColors[level.index],
        ),
      );
    }

    return slices;
  }

  /// [period] is the chart filter: `24` hours, or `7` and `30` days.
  static Future<DeviceLogTrend> trend(Session session, String period) async {
    final now = DateTime.now().toUtc();
    final hourly = period == '24';
    final buckets = hourly ? 24 : (int.tryParse(period) ?? 7);

    final labels = <String>[];
    final totals = <int>[];
    final errors = <int>[];

    for (var index = buckets - 1; index >= 0; index--) {
      final start = hourly
          ? now.subtract(Duration(hours: index + 1))
          : now.subtract(Duration(days: index + 1));
      final end = hourly
          ? now.subtract(Duration(hours: index))
          : now.subtract(Duration(days: index));

      labels.add(_bucketLabel(start, hourly: hourly));
      totals.add(
        await DeviceLog.db.count(
          session,
          where: (t) => (t.loggedAt >= start) & (t.loggedAt < end),
        ),
      );
      errors.add(
        await DeviceLog.db.count(
          session,
          where: (t) =>
              (t.loggedAt >= start) &
              (t.loggedAt < end) &
              t.level.inSet(errorLevels.toSet()),
        ),
      );
    }

    return DeviceLogTrend(labels: labels, totals: totals, errors: errors);
  }

  static String toCsv(List<DeviceLogRow> rows) => csvDocument(exportHeaders, [
    for (final row in rows)
      [
        row.deviceLabel ?? '',
        row.log.entryUuid ?? '',
        row.log.sessionId ?? '',
        formatDateTime(row.log.loggedAt),
        _levelName(row.log.level),
        row.log.tag ?? '',
        row.log.message,
        row.log.stacktrace ?? '',
        formatDateTime(row.log.createdAt),
      ],
  ]);

  static ({DateTime from, DateTime to})? _periodWindow(
    String? period,
    DateTime now,
  ) {
    final today = DateTime.utc(now.year, now.month, now.day);

    return switch (period?.trim()) {
      'today' => (from: today, to: today.add(const Duration(days: 1))),
      'yesterday' => (
        from: today.subtract(const Duration(days: 1)),
        to: today,
      ),
      'last_7_days' => (from: now.subtract(const Duration(days: 7)), to: now),
      'last_30_days' => (from: now.subtract(const Duration(days: 30)), to: now),
      'this_week' => (
        from: today.subtract(Duration(days: now.weekday - 1)),
        to: today
            .subtract(Duration(days: now.weekday - 1))
            .add(
              const Duration(days: 7),
            ),
      ),
      'this_month' => (
        from: DateTime.utc(now.year, now.month),
        to: DateTime.utc(now.year, now.month + 1),
      ),
      _ => null,
    };
  }

  static String _bucketLabel(DateTime moment, {required bool hourly}) {
    final day = moment.day.toString().padLeft(2, '0');
    final month = moment.month.toString().padLeft(2, '0');

    if (!hourly) {
      return '$day $month';
    }

    final hour = moment.hour.toString().padLeft(2, '0');
    final minute = moment.minute.toString().padLeft(2, '0');

    return '$day.$month $hour:$minute';
  }

  /// An out-of-range level (corrupt row) falls back to `INFO`.
  static String _levelName(int level) {
    if (level < 0 || level >= LogLevel.values.length) {
      return LogLevel.info.name.toUpperCase();
    }
    return LogLevel.values[level].name.toUpperCase();
  }
}
