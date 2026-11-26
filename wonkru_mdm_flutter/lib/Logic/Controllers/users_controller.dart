import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../Data/Models/list_query.dart';
import '../../Data/Models/list_query_request.dart';
import '../../Data/Models/paged_result.dart';
import '../../Data/Repositories/user_repository.dart';
import 'Base/paged_table_controller.dart';

class UsersController extends PagedTableController<AdminUserRow> {
  UsersController() : super(pageSize: 25);

  final _selectedUserIds = <UuidValue>{};

  @override
  Future<PagedResult<AdminUserRow>> fetch(ListQuery query) async {
    final page = await UserRepository.list(
      query.toAdminListRequest(),
    );

    return PagedResult(items: page.items, total: page.total);
  }

  Future<AdminUserRow> createUser(AdminUserCreateRequest request) => reloadAfter(() => UserRepository.create(request));

  Future<AdminUserRow> updateUser(AdminUserUpdateRequest request) => reloadAfter(() => UserRepository.update(request));

  Future<void> deleteUser(UuidValue authUserId) => reloadAfter(() => UserRepository.delete([authUserId]));

  /// Rows have no numeric id, so [selected] only carries the count; the users
  /// are kept by `authUserId`, which stays valid when the rows reload.
  void selectUsers(Set<AdminUserRow> users) {
    _selectedUserIds
      ..clear()
      ..addAll(users.map((user) => user.authUserId));
    setSelection({for (var i = 0; i < users.length; i++) i});
  }

  @override
  void clearSelection() {
    _selectedUserIds.clear();
    super.clearSelection();
  }

  Future<int> deleteSelected() => applyToSelected(
    (_) => UserRepository.delete(_selectedUserIds.toList()),
  );
}
