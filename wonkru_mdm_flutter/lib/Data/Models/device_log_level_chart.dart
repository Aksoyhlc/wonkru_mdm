import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

extension DeviceLogLevelChart on List<DeviceLogLevelSlice> {
  DashboardChart toChart() => DashboardChart(
    labels: [for (final slice in this) slice.label],
    values: [for (final slice in this) slice.count],
    colors: [for (final slice in this) slice.color],
  );
}
