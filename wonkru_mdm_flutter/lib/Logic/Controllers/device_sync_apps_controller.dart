import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../Data/Models/list_query.dart';
import '../../Data/Models/list_query_request.dart';
import '../../Data/Models/paged_result.dart';
import '../../Data/Repositories/device_sync_repository.dart';
import 'Base/paged_table_controller.dart';

class DeviceSyncAppsController extends PagedTableController<DeviceApplication> {
  DeviceSyncAppsController(this.syncId) : super(pageSize: 100);

  final int syncId;

  @override
  Future<PagedResult<DeviceApplication>> fetch(ListQuery query) async {
    final page = await DeviceSyncRepository.applications(
      syncId,
      query.toAdminListRequest(),
    );

    return PagedResult(items: page.items, total: page.total);
  }
}
