import 'dart:typed_data';

import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../Data/Models/list_query.dart';
import '../../Data/Models/list_query_request.dart';
import '../../Data/Models/paged_result.dart';
import '../../Data/Repositories/policy_repository.dart';
import 'Base/paged_table_controller.dart';

class PoliciesController extends PagedTableController<Policy> {
  PoliciesController() : super(pageSize: 20);

  @override
  Future<PagedResult<Policy>> fetch(ListQuery query) async {
    final page = await PolicyRepository.list(_request(query));

    return PagedResult(items: page.items, total: page.total);
  }

  PolicyListRequest _request(ListQuery query) => PolicyListRequest(
    page: query.apiPage,
    perPage: query.pageSize,
    search: query.search,
    sortBy: query.sortBy,
    sortDesc: query.sortDesc,
    isActive: query.filters['isActive'] as bool?,
    defaultPolicy: query.filters['defaultPolicy'] as bool?,
  );

  Future<ByteData> export() => PolicyRepository.export(_request(query));

  Future<void> deletePolicy(int policyId) => reloadAfter(() => PolicyRepository.delete(policyId));

  Future<int> deleteSelected() => deleteSelectedEach(PolicyRepository.delete);

  Future<Policy> duplicatePolicy(int policyId, String? newName) =>
      reloadAfter(() => PolicyRepository.duplicate(policyId, newName: newName));

  Future<void> setDefault(int policyId) => reloadAfter(() => PolicyRepository.setDefault(policyId));

  Future<String> previewPolicy(int policyId) => PolicyRepository.preview(policyId);

  Future<int> sendToDevices(int policyId) => PolicyRepository.sendToDevices(policyId);
}
