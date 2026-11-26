import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../Core/Constants/Enums/alert_enums.dart';
import '../../../Core/Constants/Enums/table_enums.dart';
import '../../../Core/L10n/L.dart';
import '../../../Logic/Controllers/users_controller.dart';
import '../../Widgets/Action/run_action.dart';
import '../../Widgets/Table/Cells/cell_action.dart';
import '../../Widgets/Table/Cells/cell_badge.dart';
import '../../Widgets/Table/Cells/cell_date.dart';
import '../../Widgets/Table/Cells/cell_primary.dart';
import '../../Widgets/Table/app_data_table.dart';
import '../../Widgets/Table/table_column.dart';
import 'Widgets/user_form_dialog.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late final UsersController _controller = Get.find<UsersController>();

  @override
  Widget build(BuildContext context) {
    return AppDataTable<AdminUserRow>(
      controller: _controller,
      columns: _columns(context),
      selectable: true,
      onSelectionChanged: _controller.selectUsers,
      searchHint: L.users.searchHint,
      emptyTitle: L.users.emptyTitle,
      emptySubtitle: L.users.emptySubtitle,
      createLabel: L.users.newUser,
      onCreate: () => _create(context),
      onBulkDelete: _controller.deleteSelected,
    );
  }

  List<AppColumn<AdminUserRow>> _columns(BuildContext context) {
    return [
      AppColumn<AdminUserRow>(
        title: L.users.columnUser,
        width: 280,
        freeze: AppColumnFreeze.start,
        hideable: false,
        cell: (user) => CellPrimary(
          title: user.name?.isNotEmpty == true ? user.name! : '—',
          subtitle: user.email,
        ),
      ),
      AppColumn<AdminUserRow>(
        title: L.users.blocked,
        width: 110,
        sortKey: 'blocked',
        cell: (user) => CellBadge(
          user.blocked ? L.common.yes : L.common.no,
          tone: user.blocked ? UiAlertTone.danger : UiAlertTone.info,
        ),
      ),
      AppColumn<AdminUserRow>(
        title: L.users.columnLastLogin,
        width: 170,
        cell: (user) => CellDate(user.lastLoginAt),
      ),
      AppColumn<AdminUserRow>(
        title: L.users.columnCreated,
        width: 150,
        sortKey: 'createdAt',
        cell: (user) => CellDate(user.createdAt),
      ),
      AppColumn.actions(
        (user) => [
          CellAction.edit(() => _edit(context, user)),
          CellAction.delete(() => _delete(context, user)),
        ],
      ),
    ];
  }

  Future<void> _create(BuildContext context) async {
    final data = await showUserFormDialog(context);
    if (data == null) return;

    await runAction(
      () => _controller.createUser(
        AdminUserCreateRequest(
          name: data.name,
          email: data.email,
          password: data.password ?? '',
          status: data.status,
          blocked: data.blocked,
        ),
      ),
      success: L.users.created,
      failure: L.common.saveFailed,
    );
  }

  Future<void> _edit(BuildContext context, AdminUserRow user) async {
    final data = await showUserFormDialog(context, user: user);
    if (data == null) return;

    await runAction(
      () => _controller.updateUser(
        AdminUserUpdateRequest(
          authUserId: user.authUserId,
          name: data.name,
          email: data.email,
          password: data.password,
          status: data.status,
          blocked: data.blocked,
        ),
      ),
      success: L.users.updated,
      failure: L.common.saveFailed,
    );
  }

  Future<void> _delete(BuildContext context, AdminUserRow user) async {
    final label = user.name?.isNotEmpty == true ? user.name! : user.email;

    await confirmAndRun(
      context,
      title: L.users.deleteTitle,
      message: L.common.deleteConfirm.trParams({'name': '$label'}),
      action: () => _controller.deleteUser(user.authUserId),
      success: L.users.deleted,
      failure: L.common.deleteFailed,
    );
  }
}
