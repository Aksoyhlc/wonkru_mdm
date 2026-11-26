import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../Client/serverpod_client.dart';
import '../Models/list_query.dart';

class DeviceGroupRepository {
  const DeviceGroupRepository._();

  static Future<DeviceGroupPage> list(AdminListRequest request) =>
      serverpodClient.adminDeviceGroup.list(request);

  static Future<DeviceGroup> get(int deviceGroupId) =>
      serverpodClient.adminDeviceGroup.get(deviceGroupId);

  static Future<DeviceGroup> create(DeviceGroup deviceGroup) =>
      serverpodClient.adminDeviceGroup.create(deviceGroup);

  static Future<DeviceGroup> update(DeviceGroup deviceGroup) =>
      serverpodClient.adminDeviceGroup.update(deviceGroup);

  static Future<int> delete(List<int> deviceGroupIds) =>
      serverpodClient.adminDeviceGroup.delete(deviceGroupIds);

  static Future<List<DeviceGroupRow>> lookup() async {
    final page = await serverpodClient.adminDeviceGroup.list(
      AdminListRequest(perPage: lookupPageSize),
    );
    return page.items;
  }
}
