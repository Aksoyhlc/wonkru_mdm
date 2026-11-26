import 'package:get/get.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../Data/Models/list_query.dart';
import '../../Data/Models/list_query_request.dart';
import '../../Data/Models/paged_result.dart';
import '../../Data/Repositories/admin_activity_repository.dart';
import '../../Data/Repositories/user_repository.dart';
import 'Base/paged_table_controller.dart';

class AdminActivityController extends PagedTableController<AdminActivity> {
  AdminActivityController() : super(pageSize: 25);

  final actions = <String>[].obs;

  final actors = <AdminUserRow>[].obs;

  bool _lookupsLoaded = false;

  @override
  Future<PagedResult<AdminActivity>> fetch(ListQuery query) async {
    final page = await AdminActivityRepository.list(buildRequest(query));

    return PagedResult(items: page.items, total: page.total);
  }

  static AdminActivityListRequest buildRequest(ListQuery query) {
    return AdminActivityListRequest(
      page: query.apiPage,
      perPage: query.pageSize,
      search: query.search,
      sortBy: query.sortBy,
      sortDesc: query.sortDesc,
      actorUserId: query.filters['actorUserId'] as UuidValue?,
      action: query.filters['action'] as String?,
      from: query.filters['from'] as DateTime?,
      to: query.filters['to'] as DateTime?,
    );
  }

  Future<void> ensureLookupsLoaded() async {
    if (_lookupsLoaded) return;
    try {
      final results = await Future.wait<Object>([
        AdminActivityRepository.actions(),
        UserRepository.lookup(),
      ]);

      actions.assignAll(results[0] as List<String>);
      actors.assignAll(results[1] as List<AdminUserRow>);
      _lookupsLoaded = true;
    } catch (_) {}
  }

  static String actorLabel(AdminUserRow user) {
    final name = user.name?.trim();
    if (name != null && name.isNotEmpty) return name;
    final email = user.email?.trim();
    if (email != null && email.isNotEmpty) return email;

    return user.authUserId.toString();
  }
}
