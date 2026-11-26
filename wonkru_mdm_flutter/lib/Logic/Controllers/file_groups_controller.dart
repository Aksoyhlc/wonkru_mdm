import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../Data/Models/list_query.dart';
import '../../Data/Models/list_query_request.dart';
import '../../Data/Models/paged_result.dart';
import '../../Data/Repositories/file_group_repository.dart';
import '../../Data/Repositories/file_repository.dart';
import 'Base/paged_table_controller.dart';

class FileGroupsController extends PagedTableController<FileGroupRow> {
  FileGroupsController() : super(pageSize: 25);

  @override
  Future<PagedResult<FileGroupRow>> fetch(ListQuery query) async {
    final page = await FileGroupRepository.list(
      query.toAdminListRequest(),
    );

    return PagedResult(items: page.items, total: page.total);
  }

  Future<FileGroup> createGroup(FileGroup fileGroup) =>
      reloadAfter(() => FileGroupRepository.create(fileGroup));

  Future<FileGroup> updateGroup(FileGroup fileGroup) =>
      reloadAfter(() => FileGroupRepository.update(fileGroup));

  Future<void> deleteGroup(int fileGroupId) =>
      reloadAfter(() => FileGroupRepository.delete([fileGroupId]));

  Future<int> deleteSelected() => applyToSelected(FileGroupRepository.delete);

  Future<List<int>> fileIds(int fileGroupId) =>
      FileGroupRepository.fileIds(fileGroupId);

  Future<int> assignFiles(int fileGroupId, List<int> fileIds) =>
      reloadAfter(() => FileGroupRepository.assignFiles(fileGroupId, fileIds));

  Future<FileAsset> createFile(FileAsset file) => FileRepository.create(file);

  Future<int> deleteFile(int fileId) => FileRepository.delete([fileId]);

  /// If [search] is given it is applied on the server.
  Future<List<FileAsset>> searchFiles(
    String? search, {
    int perPage = 50,
  }) async {
    final trimmed = search?.trim();
    final page = await FileRepository.list(
      FileListRequest(
        perPage: perPage,
        search: trimmed == null || trimmed.isEmpty ? null : trimmed,
        sortBy: 'name',
      ),
    );

    return page.items;
  }
}
