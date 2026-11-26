import 'dart:typed_data';

import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../Data/Models/list_query.dart';
import '../../Data/Models/list_query_request.dart';
import '../../Data/Models/paged_result.dart';
import '../../Data/Repositories/application_repository.dart';
import 'Base/paged_table_controller.dart';

class ApplicationsController extends PagedTableController<Application> {
  ApplicationsController() : super(pageSize: 25);

  @override
  Future<PagedResult<Application>> fetch(ListQuery query) async {
    final page = await ApplicationRepository.list(_request(query));

    return PagedResult(items: page.items, total: page.total);
  }

  ApplicationListRequest _request(ListQuery query) {
    return ApplicationListRequest(
      page: query.apiPage,
      perPage: query.pageSize,
      search: query.search,
      sortBy: query.sortBy,
      sortDesc: query.sortDesc,
      sourceType: query.textFilter('sourceType'),
      category: query.textFilter('category'),
      isSystemApp: query.filters['isSystemApp'] as bool?,
    );
  }

  Future<ByteData> export() => ApplicationRepository.export(_request(query));

  Future<int> deleteApplications(List<int> applicationIds) =>
      reloadAfter(() => ApplicationRepository.deleteMany(applicationIds));

  Future<Application> createApplication(Application application) =>
      reloadAfter(() => ApplicationRepository.create(application));

  Future<Application> updateApplication(Application application) =>
      reloadAfter(() => ApplicationRepository.update(application));

  Future<ApplicationVersion> createVersion(ApplicationVersion version) => ApplicationRepository.createVersion(version);

  Future<void> deleteApplication(int applicationId) => reloadAfter(() => ApplicationRepository.delete(applicationId));

  Future<List<Application>> searchApplications(String? search) async {
    final page = await ApplicationRepository.list(
      ApplicationListRequest(perPage: lookupPageSize, search: search),
    );
    return page.items;
  }

  Future<Application> getApplication(int applicationId) => ApplicationRepository.get(applicationId);
}
