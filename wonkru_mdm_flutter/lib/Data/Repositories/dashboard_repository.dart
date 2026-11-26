import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../Client/serverpod_client.dart';

class DashboardRepository {
  const DashboardRepository._();

  static Future<DashboardDeviceStats> deviceStats() =>
      serverpodClient.adminDashboard.deviceStats();

  static Future<DashboardAlertStats> alertStats() =>
      serverpodClient.adminDashboard.alertStats();

  static Future<DashboardChart> deviceDistribution(String filter) =>
      serverpodClient.adminDashboard.deviceDistribution(filter);

  static Future<DashboardChart> syncTrend() =>
      serverpodClient.adminDashboard.syncTrend();
}
