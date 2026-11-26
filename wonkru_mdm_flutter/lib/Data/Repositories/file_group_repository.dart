import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../Client/serverpod_client.dart';
import '../Models/list_query.dart';

class FileGroupRepository {
  const FileGroupRepository._();

  static Future<FileGroupPage> list(AdminListRequest request) =>
      serverpodClient.adminFileGroup.list(request);

  static Future<FileGroup> get(int fileGroupId) =>
      serverpodClient.adminFileGroup.get(fileGroupId);

  static Future<List<int>> fileIds(int fileGroupId) =>
      serverpodClient.adminFileGroup.fileIds(fileGroupId);

  static Future<FileGroup> create(FileGroup fileGroup) =>
      serverpodClient.adminFileGroup.create(fileGroup);

  static Future<FileGroup> update(FileGroup fileGroup) =>
      serverpodClient.adminFileGroup.update(fileGroup);

  static Future<int> delete(List<int> fileGroupIds) =>
      serverpodClient.adminFileGroup.delete(fileGroupIds);

  static Future<int> assignFiles(int fileGroupId, List<int> fileIds) =>
      serverpodClient.adminFileGroup.assignFiles(fileGroupId, fileIds);

  static Future<List<FileGroupRow>> lookup() async {
    final page = await serverpodClient.adminFileGroup.list(
      AdminListRequest(perPage: lookupPageSize),
    );
    return page.items;
  }
}
