import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../Data/Models/list_query.dart';
import '../../Data/Models/list_query_request.dart';
import '../../Data/Models/paged_result.dart';
import '../../Data/Repositories/device_log_repository.dart';
import 'Base/paged_table_controller.dart';

class DeviceDetailLogsController extends PagedTableController<DeviceLogRow> {
  DeviceDetailLogsController(this.deviceId) : super(pageSize: 15);

  final int deviceId;

  @override
  Future<PagedResult<DeviceLogRow>> fetch(ListQuery query) async {
    final page = await DeviceLogRepository.list(
      AdminDeviceLogListRequest(
        page: query.apiPage,
        perPage: query.pageSize,
        search: query.search,
        sortBy: query.sortBy,
        sortDesc: query.sortDesc,
        deviceId: deviceId,
      ),
    );

    return PagedResult(items: page.items, total: page.total);
  }
}
