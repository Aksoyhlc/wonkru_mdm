import 'package:get/get.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../Core/L10n/L.dart';
import '../../Data/Models/device_log_level_chart.dart';
import '../../Data/Models/device_log_trend_chart.dart';
import '../../Data/Repositories/dashboard_repository.dart';
import '../../Data/Repositories/device_log_repository.dart';

class DashboardController extends GetxController {
  final loading = true.obs;
  final error = RxnString();

  final deviceStats = Rxn<DashboardDeviceStats>();
  final alertStats = Rxn<DashboardAlertStats>();
  final distribution = Rxn<DashboardChart>();
  final trend = Rxn<DashboardChart>();

  final logStats = Rxn<DeviceLogStats>();
  final logDistribution = Rxn<DashboardChart>();
  final logTrend = Rxn<DashboardChart>();

  /// ERROR + FATAL counts for the same buckets as [logTrend].
  final logTrendErrors = RxList<int>();

  final lastLoadedAt = Rxn<DateTime>();

  final distributionFilter = 'manufacturer'.obs;

  /// Period feeding the log charts: `24` hours, `7` or `30` days.
  final logPeriod = '24'.obs;

  bool _loaded = false;

  Future<void> ensureLoaded() async {
    if (_loaded) return;
    await load();
  }

  Future<void> load() async {
    loading.value = true;
    error.value = null;
    try {
      final results = await Future.wait<Object>([
        DashboardRepository.deviceStats(),
        DashboardRepository.alertStats(),
        DashboardRepository.deviceDistribution(distributionFilter.value),
        DashboardRepository.syncTrend(),
        DeviceLogRepository.stats(),
        DeviceLogRepository.levelDistribution(logPeriod.value),
        DeviceLogRepository.trend(logPeriod.value),
      ]);

      deviceStats.value = results[0] as DashboardDeviceStats;
      alertStats.value = results[1] as DashboardAlertStats;
      distribution.value = results[2] as DashboardChart;
      trend.value = results[3] as DashboardChart;
      logStats.value = results[4] as DeviceLogStats;
      logDistribution.value = (results[5] as List<DeviceLogLevelSlice>)
          .toChart();
      final logTrendResult = results[6] as DeviceLogTrend;
      logTrend.value = logTrendResult.toChart();
      logTrendErrors.assignAll(logTrendResult.errors);
      lastLoadedAt.value = DateTime.now();
      _loaded = true;
    } catch (e) {
      error.value = L.common.dashboardLoadFailed;
    } finally {
      loading.value = false;
    }
  }

  Future<void> setDistributionFilter(String filter) async {
    if (filter == distributionFilter.value) return;
    distributionFilter.value = filter;
    try {
      distribution.value = await DashboardRepository.deviceDistribution(filter);
    } catch (_) {}
  }

  Future<void> setLogPeriod(String value) async {
    if (value == logPeriod.value) return;
    logPeriod.value = value;
    try {
      final results = await Future.wait<Object>([
        DeviceLogRepository.levelDistribution(value),
        DeviceLogRepository.trend(value),
      ]);

      logDistribution.value = (results[0] as List<DeviceLogLevelSlice>)
          .toChart();
      final logTrendResult = results[1] as DeviceLogTrend;
      logTrend.value = logTrendResult.toChart();
      logTrendErrors.assignAll(logTrendResult.errors);
    } catch (_) {}
  }
}
