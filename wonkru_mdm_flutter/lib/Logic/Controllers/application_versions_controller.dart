import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../Data/Models/list_query.dart';
import '../../Data/Models/list_query_request.dart';
import '../../Data/Models/paged_result.dart';
import '../../Data/Repositories/application_repository.dart';
import 'Base/paged_table_controller.dart';

class ApplicationVersionsController
    extends PagedTableController<ApplicationVersion> {
  ApplicationVersionsController(this.applicationId) : super(pageSize: 25);

  final int applicationId;

  @override
  Future<PagedResult<ApplicationVersion>> fetch(ListQuery query) async {
    final page = await ApplicationRepository.listVersions(
      applicationId,
      query.toAdminListRequest(),
    );

    return PagedResult(items: page.items, total: page.total);
  }

  Future<ApplicationVersion> createVersion(
    ApplicationVersion version,
  ) => reloadAfter(() => ApplicationRepository.createVersion(version));

  Future<ApplicationVersion> updateVersion(
    ApplicationVersion version,
  ) => reloadAfter(() => ApplicationRepository.updateVersion(version));

  Future<void> deleteVersion(int versionId) =>
      reloadAfter(() => ApplicationRepository.deleteVersion(versionId));

  Future<int> deleteSelected() =>
      deleteSelectedEach(ApplicationRepository.deleteVersion);
}
