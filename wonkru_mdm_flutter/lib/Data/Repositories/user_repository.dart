import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../Client/serverpod_client.dart';
import '../Models/list_query.dart';

class UserRepository {
  const UserRepository._();

  static Future<AdminUserPage> list(AdminListRequest request) =>
      serverpodClient.adminUser.list(request);

  static Future<AdminUserRow> get(UuidValue authUserId) =>
      serverpodClient.adminUser.get(authUserId);

  static Future<AdminUserRow> create(AdminUserCreateRequest request) =>
      serverpodClient.adminUser.create(request);

  static Future<AdminUserRow> update(AdminUserUpdateRequest request) =>
      serverpodClient.adminUser.update(request);

  static Future<int> delete(List<UuidValue> authUserIds) =>
      serverpodClient.adminUser.delete(authUserIds);

  static Future<List<AdminUserRow>> lookup() async {
    final page = await serverpodClient.adminUser.list(
      AdminListRequest(perPage: lookupPageSize),
    );
    return page.items;
  }
}
