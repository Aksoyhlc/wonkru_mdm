import 'package:get/get.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../Data/Models/list_query.dart';
import '../../Data/Models/list_query_request.dart';
import '../../Data/Models/paged_result.dart';
import '../../Data/Repositories/file_group_repository.dart';
import '../../Data/Repositories/file_repository.dart';
import 'Base/paged_table_controller.dart';

class FilesController extends PagedTableController<FileAsset> {
  FilesController() : super(pageSize: 25);

  final fileGroups = <FileGroupRow>[].obs;
  final optionsLoaded = false.obs;

  @override
  Future<PagedResult<FileAsset>> fetch(ListQuery query) async {
    final page = await FileRepository.list(buildRequest(query));

    return PagedResult(items: page.items, total: page.total);
  }

  static FileListRequest buildRequest(ListQuery query) {
    final extensions = _split(query.filters['extension'] as String?);
    final mimeTypes = _split(query.filters['mimeType'] as String?);
    final fileGroupId = query.filters['fileGroupId'] as int?;

    return FileListRequest(
      page: query.apiPage,
      perPage: query.pageSize,
      search: query.search,
      sortBy: query.sortBy,
      sortDesc: query.sortDesc,
      extensions: extensions,
      mimeTypes: mimeTypes,
      fileGroupIds: fileGroupId == null ? null : [fileGroupId],
    );
  }

  Future<void> ensureOptionsLoaded() async {
    if (optionsLoaded.value) return;
    try {
      fileGroups.assignAll(await FileGroupRepository.lookup());
      optionsLoaded.value = true;
      // Cells resolve names from these lists; refresh the grid.
      refreshCells();
    } catch (_) {}
  }

  Future<FileAsset> createFile(FileAsset file) => reloadAfter(() => FileRepository.create(file));

  Future<FileAsset> updateFile(FileAsset file) => reloadAfter(() => FileRepository.update(file));

  Future<void> deleteFile(int fileId) => reloadAfter(() => FileRepository.delete([fileId]));

  Future<int> deleteSelected() => applyToSelected(FileRepository.delete);

  Future<List<int>> groupIdsForFile(int fileId) => FileRepository.groupIds(fileId);

  Future<List<FileGroupMember>> groupMembersForFiles(List<int> fileIds) => FileRepository.groupMembersForFiles(fileIds);

  Future<String?> downloadUrl(int fileId) => FileRepository.downloadUrl(fileId);

  Future<int> assignGroupsToFile(int fileId, List<int> fileGroupIds) =>
      reloadAfter(() => FileRepository.assignGroups([fileId], fileGroupIds));

  static List<String>? _split(String? raw) {
    if (raw == null) return null;
    final parts = raw.split(',').map((part) => part.trim()).where((part) => part.isNotEmpty).toList();
    return parts.isEmpty ? null : parts;
  }
}
