import 'dart:typed_data';

import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../Data/Models/list_query.dart';
import '../../Data/Models/list_query_request.dart';
import '../../Data/Models/paged_result.dart';
import '../../Data/Repositories/device_sync_repository.dart';
import 'Base/paged_table_controller.dart';

class DeviceDetailSyncsController extends PagedTableController<DeviceSyncRow> {
  DeviceDetailSyncsController(this.deviceId) : super(pageSize: 15);

  final int deviceId;

  @override
  Future<PagedResult<DeviceSyncRow>> fetch(ListQuery query) async {
    final page = await DeviceSyncRepository.list(_request(query));

    return PagedResult(items: page.items, total: page.total);
  }

  Future<ByteData> export() => DeviceSyncRepository.export(_request(query));

  AdminDeviceSyncListRequest _request(ListQuery query) => AdminDeviceSyncListRequest(
    page: query.apiPage,
    perPage: query.pageSize,
    search: query.search,
    sortBy: query.sortBy,
    sortDesc: query.sortDesc,
    deviceId: deviceId,
  );
}
