import 'dart:typed_data';

import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../Client/serverpod_client.dart';

class DeviceRepository {
  const DeviceRepository._();

  static Future<DevicePage> list(DeviceListRequest request) =>
      serverpodClient.adminDevice.list(request);

  static Future<ByteData> export(DeviceListRequest request) =>
      serverpodClient.adminDevice.export(request);

  static Future<Device> get(int deviceId) =>
      serverpodClient.adminDevice.get(deviceId);

  /// [locale] is the panel's active language; report text is generated in it.
  static Future<ByteData> reportPdf(int deviceId, String? locale) =>
      serverpodClient.adminDevice.reportPdf(deviceId, locale);

  /// Derived from the device's last sync; null when it has never synced.
  static Future<DeviceStateCache?> stateCache(int deviceId) =>
      serverpodClient.adminDevice.stateCache(deviceId);

  static Future<List<int>> groupIds(int deviceId) =>
      serverpodClient.adminDevice.groupIds(deviceId);

  static Future<Device> update(AdminDeviceUpdateRequest request) =>
      serverpodClient.adminDevice.update(request);

  static Future<int> delete(List<int> deviceIds) =>
      serverpodClient.adminDevice.delete(deviceIds);

  static Future<int> assignPolicy(List<int> deviceIds, int policyId) =>
      serverpodClient.adminDevice.assignPolicy(deviceIds, policyId);

  static Future<int> assignGroups(List<int> deviceIds, List<int> groupIds) =>
      serverpodClient.adminDevice.assignGroups(deviceIds, groupIds);

  static Future<int> sendPolicyUpdate(List<int> deviceIds) =>
      serverpodClient.adminDevice.sendPolicyUpdate(deviceIds);

  /// Responses are tracked on the `device_commands` ack stream; poll
  /// [bulkStatus] with the returned `bulkId` for progress.
  static Future<DeviceCommandBulkStatus> sendCommand(
    List<int> deviceIds,
    String action,
    String? paramsJson,
  ) => serverpodClient.adminDevice.sendCommand(deviceIds, action, paramsJson);

  static Future<DeviceCommandBulkStatus> bulkStatus(String bulkId) =>
      serverpodClient.adminDevice.bulkStatus(bulkId);

  static Future<List<DeviceCommand>> bulkCommands(String bulkId) =>
      serverpodClient.adminDevice.bulkCommands(bulkId);

  static Future<Policy> duplicatePolicy(int deviceId) =>
      serverpodClient.adminDevice.duplicatePolicy(deviceId);

  static Future<DeviceCommandPage> commands(
    int deviceId,
    AdminListRequest request,
  ) => serverpodClient.adminDevice.commands(deviceId, request);

  static Future<List<DeviceApplication>> applications(int deviceId) =>
      serverpodClient.adminDevice.applications(deviceId);

  static Future<List<DeviceReport>> reports(int deviceId, {int limit = 100}) =>
      serverpodClient.adminDevice.reports(deviceId, limit: limit);
}
