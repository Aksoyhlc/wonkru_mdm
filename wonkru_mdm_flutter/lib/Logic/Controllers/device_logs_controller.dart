import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../Core/Constants/Enums/alert_enums.dart';
import '../../Core/L10n/L.dart';
import '../../Data/Models/device_log_level_chart.dart';
import '../../Data/Models/device_log_trend_chart.dart';
import '../../Data/Models/list_query.dart';
import '../../Data/Models/list_query_request.dart';
import '../../Data/Models/paged_result.dart';
import '../../Data/Repositories/device_log_repository.dart';
import 'Base/paged_table_controller.dart';

class DeviceLogsController extends PagedTableController<DeviceLogRow> {
  DeviceLogsController() : super(pageSize: 25);

  /// Order matches the server's `LogLevel` enum (0..5).
  static const levelLabels = <String>[
    'VERBOSE',
    'DEBUG',
    'INFO',
    'WARNING',
    'ERROR',
    'FATAL',
  ];

  /// Levels treated as errors; must match the server's
  /// `DeviceLogService.errorLevels`.
  static const errorLevels = <int>[4, 5];

  final stats = Rxn<DeviceLogStats>();
  final levelDistribution = <DeviceLogLevelSlice>[].obs;
  final trend = Rxn<DeviceLogTrend>();

  /// Period feeding the charts: `24` hours, `7` or `30` days.
  final period = '24'.obs;

  final summaryLoading = false.obs;

  bool _summaryLoaded = false;

  /// Values accepted by the server: `today`, `yesterday`, `last_7_days`,
  /// `last_30_days`, `this_week` and `this_month`. Labels follow the active
  /// language, so this is a getter rather than `const`.
  static Map<String, String> get periodOptions => {
    'today': L.common.periodToday,
    'yesterday': L.common.periodYesterday,
    'last_7_days': L.common.periodLast7Days,
    'last_30_days': L.common.periodLast30Days,
    'this_week': L.common.periodThisWeek,
    'this_month': L.common.periodThisMonth,
  };

  /// Period feeding the charts: `24` hours, `7` or `30` days.
  static Map<String, String> get chartPeriodOptions => {
    '24': L.common.chartPeriodLast24h,
    '7': L.common.periodLast7Days,
    '30': L.common.periodLast30Days,
  };

  @override
  Future<PagedResult<DeviceLogRow>> fetch(ListQuery query) async {
    final page = await DeviceLogRepository.list(buildRequest(query));

    return PagedResult(items: page.items, total: page.total);
  }

  static AdminDeviceLogListRequest buildRequest(ListQuery query) {
    final level = query.filters['level'] as int?;
    final deviceId = query.filters['deviceId'] as int?;
    final tag = query.textFilter('tag');
    final sessionId = query.textFilter('sessionId');
    final period = query.textFilter('period');
    final hasStacktrace = query.filters['hasStacktrace'] as bool?;
    final loggedFrom = query.filters['loggedFrom'] as DateTime?;
    final loggedUntil = query.filters['loggedUntil'] as DateTime?;

    return AdminDeviceLogListRequest(
      page: query.apiPage,
      perPage: query.pageSize,
      search: query.search,
      sortBy: query.sortBy,
      sortDesc: query.sortDesc,
      levels: level == null ? null : [level],
      deviceId: deviceId,
      tag: tag,
      sessionId: sessionId,
      period: period,
      hasStacktrace: hasStacktrace,
      loggedFrom: loggedFrom,
      loggedUntil: loggedUntil,
    );
  }

  Future<void> ensureSummaryLoaded() async {
    if (_summaryLoaded) return;
    await loadSummary();
  }

  Future<void> loadSummary() async {
    summaryLoading.value = true;
    try {
      final results = await Future.wait<Object>([
        DeviceLogRepository.stats(),
        DeviceLogRepository.levelDistribution(period.value),
        DeviceLogRepository.trend(period.value),
      ]);

      stats.value = results[0] as DeviceLogStats;
      levelDistribution.assignAll(results[1] as List<DeviceLogLevelSlice>);
      trend.value = results[2] as DeviceLogTrend;
      _summaryLoaded = true;
    } catch (_) {
    } finally {
      summaryLoading.value = false;
    }
  }

  Future<void> setPeriod(String value) async {
    if (value == period.value) return;
    period.value = value;
    await loadSummary();
  }

  DashboardChart get levelChart => levelDistribution.toChart();

  DashboardChart get trendChart =>
      trend.value?.toChart() ??
      DashboardChart(labels: const [], values: const []);

  Future<int> deleteSelected() async {
    final count = await applyToSelected(DeviceLogRepository.delete);
    await loadSummary();
    return count;
  }

  Future<void> deleteRow(int logId) async {
    await reloadAfter(() => DeviceLogRepository.delete([logId]));
    await loadSummary();
  }

  Future<ByteData> export() => DeviceLogRepository.export(buildRequest(query));

  static String levelLabel(int level) =>
      level >= 0 && level < levelLabels.length ? levelLabels[level] : 'INFO';

  static UiAlertTone levelTone(int level) => switch (level) {
    3 => UiAlertTone.warning,
    4 || 5 => UiAlertTone.danger,
    _ => UiAlertTone.info,
  };

  static bool isError(int level) => errorLevels.contains(level);
}
