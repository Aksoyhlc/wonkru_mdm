import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../Data/Models/list_query.dart';
import '../../Data/Models/list_query_request.dart';
import '../../Data/Models/paged_result.dart';
import '../../Data/Repositories/device_group_repository.dart';
import 'Base/paged_table_controller.dart';

class DeviceGroupsController extends PagedTableController<DeviceGroupRow> {
  DeviceGroupsController() : super(pageSize: 25);

  @override
  Future<PagedResult<DeviceGroupRow>> fetch(ListQuery query) async {
    final page = await DeviceGroupRepository.list(
      query.toAdminListRequest(),
    );

    return PagedResult(items: page.items, total: page.total);
  }

  Future<DeviceGroup> createGroup(DeviceGroup deviceGroup) =>
      reloadAfter(() => DeviceGroupRepository.create(deviceGroup));

  Future<DeviceGroup> updateGroup(DeviceGroup deviceGroup) =>
      reloadAfter(() => DeviceGroupRepository.update(deviceGroup));

  Future<void> deleteGroup(int deviceGroupId) =>
      reloadAfter(() => DeviceGroupRepository.delete([deviceGroupId]));

  Future<int> deleteSelected() => applyToSelected(DeviceGroupRepository.delete);
}
