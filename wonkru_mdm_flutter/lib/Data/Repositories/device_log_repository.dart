import 'dart:typed_data';

import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../Client/serverpod_client.dart';

class DeviceLogRepository {
  const DeviceLogRepository._();

  static Future<DeviceLogPage> list(AdminDeviceLogListRequest request) =>
      serverpodClient.adminDeviceLog.list(request);

  static Future<DeviceLogRow> get(int logId) =>
      serverpodClient.adminDeviceLog.get(logId);

  static Future<int> delete(List<int> logIds) =>
      serverpodClient.adminDeviceLog.delete(logIds);

  static Future<DeviceLogStats> stats() =>
      serverpodClient.adminDeviceLog.stats();

  static Future<List<DeviceLogLevelSlice>> levelDistribution(String period) =>
      serverpodClient.adminDeviceLog.levelDistribution(period);

  static Future<DeviceLogTrend> trend(String period) =>
      serverpodClient.adminDeviceLog.trend(period);

  /// CSV of every row matching the filter, not just the current page.
  static Future<ByteData> export(AdminDeviceLogListRequest request) =>
      serverpodClient.adminDeviceLog.export(request);
}
