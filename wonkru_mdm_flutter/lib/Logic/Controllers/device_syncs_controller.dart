import 'dart:typed_data';

import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../Data/Models/list_query.dart';
import '../../Data/Models/list_query_request.dart';
import '../../Data/Models/paged_result.dart';
import '../../Data/Repositories/device_sync_repository.dart';
import 'Base/paged_table_controller.dart';

class DeviceSyncsController extends PagedTableController<DeviceSyncRow> {
  DeviceSyncsController() : super(pageSize: 25);

  @override
  Future<PagedResult<DeviceSyncRow>> fetch(ListQuery query) async {
    final page = await DeviceSyncRepository.list(buildRequest(query));

    return PagedResult(items: page.items, total: page.total);
  }

  static AdminDeviceSyncListRequest buildRequest(ListQuery query) =>
      AdminDeviceSyncListRequest(
        page: query.apiPage,
        perPage: query.pageSize,
        search: query.search,
        sortBy: query.sortBy,
        sortDesc: query.sortDesc,
        deviceId: query.filters['deviceId'] as int?,
        from: query.filters['from'] as DateTime?,
        to: query.filters['to'] as DateTime?,
      );

  Future<ByteData> export() => DeviceSyncRepository.export(buildRequest(query));
}
