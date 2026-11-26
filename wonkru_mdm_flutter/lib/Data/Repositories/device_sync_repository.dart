import 'dart:typed_data';

import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../Client/serverpod_client.dart';

class DeviceSyncRepository {
  const DeviceSyncRepository._();

  static Future<DeviceSyncPage> list(AdminDeviceSyncListRequest request) =>
      serverpodClient.adminDeviceSync.list(request);

  /// CSV of every row matching the filter, not just the current page.
  static Future<ByteData> export(AdminDeviceSyncListRequest request) =>
      serverpodClient.adminDeviceSync.export(request);

  static Future<DeviceSyncDetail> get(int syncId) =>
      serverpodClient.adminDeviceSync.get(syncId);

  static Future<DeviceApplicationPage> applications(
    int syncId,
    AdminListRequest request,
  ) => serverpodClient.adminDeviceSync.applications(syncId, request);
}
