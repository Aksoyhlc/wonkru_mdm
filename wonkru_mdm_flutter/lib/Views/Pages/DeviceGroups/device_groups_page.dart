import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../Core/Constants/Enums/table_enums.dart';
import '../../../Core/L10n/L.dart';
import '../../../Core/Router/app_routes.dart';
import '../../../Logic/Controllers/device_groups_controller.dart';
import '../../../Logic/Controllers/devices_controller.dart';
import '../../Widgets/Action/run_action.dart';
import '../../Widgets/Table/Cells/cell_action.dart';
import '../../Widgets/Table/Cells/cell_link.dart';
import '../../Widgets/Table/Cells/cell_primary.dart';
import '../../Widgets/Table/Cells/cell_text.dart';
import '../../Widgets/Table/app_data_table.dart';
import '../../Widgets/Table/table_column.dart';
import 'Widgets/device_group_form_dialog.dart';

class DeviceGroupsPage extends StatefulWidget {
  const DeviceGroupsPage({super.key});

  @override
  State<DeviceGroupsPage> createState() => _DeviceGroupsPageState();
}

class _DeviceGroupsPageState extends State<DeviceGroupsPage> {
  late final DeviceGroupsController _controller =
      Get.find<DeviceGroupsController>();

  @override
  Widget build(BuildContext context) {
    return AppDataTable<DeviceGroupRow>(
      controller: _controller,
      columns: _columns(context),
      rowId: (row) => row.group.id,
      searchHint: L.common.searchName,
      emptyTitle: L.deviceGroups.emptyTitle,
      emptySubtitle: L.deviceGroups.emptyBody,
      createLabel: L.deviceGroups.newGroup,
      onCreate: () => _create(context),
      onBulkDelete: _controller.deleteSelected,
    );
  }

  List<AppColumn<DeviceGroupRow>> _columns(BuildContext context) {
    return [
      AppColumn<DeviceGroupRow>(
        title: L.common.name,
        width: 240,
        sortKey: 'name',
        freeze: AppColumnFreeze.start,
        hideable: false,
        cell: (row) => CellPrimary(title: row.group.name),
      ),
      AppColumn<DeviceGroupRow>(
        title: L.common.description,
        width: 320,
        expand: true,
        cell: (row) => CellText(row.group.description, muted: true),
      ),
      AppColumn<DeviceGroupRow>(
        title: L.deviceGroups.deviceCount,
        width: 120,
        cell: (row) => CellLink(
          '${row.deviceCount}',
          tooltip: L.deviceGroups.listDevicesTooltip,
          onTap: row.group.id == null ? null : () => _drillDown(row.group.id!),
        ),
      ),
      AppColumn.actions(
        (row) => [
          CellAction.edit(() => _edit(context, row.group)),
          CellAction.delete(() => _delete(context, row.group)),
        ],
      ),
    ];
  }

  void _drillDown(int groupId) {
    context.go(AppRoutes.devices);
    Get.find<DevicesController>().setFilter('deviceGroupId', groupId);
  }

  Future<void> _create(BuildContext context) async {
    final result = await showDeviceGroupFormDialog(context);
    if (result == null) return;

    await runAction(
      () => _controller.createGroup(result),
      success: L.deviceGroups.created,
      failure: L.common.saveFailed,
    );
  }

  Future<void> _edit(BuildContext context, DeviceGroup group) async {
    final result = await showDeviceGroupFormDialog(context, group: group);
    if (result == null) return;

    await runAction(
      () => _controller.updateGroup(result),
      success: L.deviceGroups.updated,
      failure: L.common.saveFailed,
    );
  }

  Future<void> _delete(BuildContext context, DeviceGroup group) async {
    final id = group.id;
    if (id == null) return;

    await confirmAndRun(
      context,
      title: L.deviceGroups.deleteTitle,
      message: L.deviceGroups.deleteConfirm.trParams({'name': group.name}),
      action: () => _controller.deleteGroup(id),
      success: L.deviceGroups.deleted,
      failure: L.common.deleteFailed,
    );
  }
}
