import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../Client/serverpod_client.dart';

class AdminActivityRepository {
  const AdminActivityRepository._();

  static Future<AdminActivityPage> list(AdminActivityListRequest request) =>
      serverpodClient.adminActivity.list(request);

  static Future<List<String>> actions() =>
      serverpodClient.adminActivity.actions();
}
