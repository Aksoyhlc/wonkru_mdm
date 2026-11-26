import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../Client/serverpod_client.dart';
import '../Models/list_query.dart';

class FileRepository {
  const FileRepository._();

  static Future<FilePage> list(FileListRequest request) =>
      serverpodClient.adminFile.list(request);

  static Future<FileAsset> get(int fileId) =>
      serverpodClient.adminFile.get(fileId);

  static Future<List<int>> groupIds(int fileId) =>
      serverpodClient.adminFile.groupIds(fileId);

  /// Group memberships for the visible rows in a single call (avoids N+1).
  static Future<List<FileGroupMember>> groupMembersForFiles(
    List<int> fileIds,
  ) => serverpodClient.adminFile.groupMembersForFiles(fileIds);

  /// Permanent for public files, temporary for private ones.
  static Future<String?> downloadUrl(int fileId) =>
      serverpodClient.adminFile.downloadUrl(fileId);

  static Future<FileAsset> create(FileAsset file) =>
      serverpodClient.adminFile.create(file);

  static Future<FileAsset> update(FileAsset file) =>
      serverpodClient.adminFile.update(file);

  static Future<int> delete(List<int> fileIds) =>
      serverpodClient.adminFile.delete(fileIds);

  static Future<int> assignGroups(List<int> fileIds, List<int> fileGroupIds) =>
      serverpodClient.adminFile.assignGroups(fileIds, fileGroupIds);

  static Future<List<FileAsset>> lookup() async {
    final page = await serverpodClient.adminFile.list(
      FileListRequest(perPage: lookupPageSize),
    );
    return page.items;
  }
}
