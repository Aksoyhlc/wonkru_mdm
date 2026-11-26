import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../Data/Models/list_query.dart';
import '../../Data/Models/list_query_request.dart';
import '../../Data/Models/paged_result.dart';
import '../../Data/Repositories/device_repository.dart';
import 'Base/paged_table_controller.dart';

class DeviceDetailCommandsController
    extends PagedTableController<DeviceCommand> {
  DeviceDetailCommandsController(this.deviceId) : super(pageSize: 50);

  final int deviceId;

  @override
  Future<PagedResult<DeviceCommand>> fetch(ListQuery query) async {
    final page = await DeviceRepository.commands(
      deviceId,
      AdminListRequest(
        page: query.apiPage,
        perPage: query.pageSize,
        sortBy: query.sortBy,
        sortDesc: query.sortDesc,
      ),
    );

    return PagedResult(items: page.items, total: page.total);
  }
}
