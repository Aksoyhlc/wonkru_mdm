import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

extension DeviceLogTrendChart on DeviceLogTrend {
  DashboardChart toChart() => DashboardChart(labels: labels, values: totals);
}
