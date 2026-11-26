import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../Core/Constants/Enums/alert_enums.dart';
import '../../../Core/Constants/Enums/table_enums.dart';
import '../../../Core/L10n/L.dart';
import '../../../Core/Theme/design.dart';
import '../../../Logic/Controllers/file_groups_controller.dart';
import '../../Widgets/Action/run_action.dart';
import '../../Widgets/Table/Cells/cell_action.dart';
import '../../Widgets/Table/Cells/cell_badge.dart';
import '../../Widgets/Table/Cells/cell_primary.dart';
import '../../Widgets/Table/Cells/cell_text.dart';
import '../../Widgets/Table/app_data_table.dart';
import '../../Widgets/Table/table_column.dart';
import 'Widgets/file_group_form_dialog.dart';
import 'Widgets/file_group_members_section.dart';

class FileGroupsPage extends StatefulWidget {
  const FileGroupsPage({super.key});

  @override
  State<FileGroupsPage> createState() => _FileGroupsPageState();
}

class _FileGroupsPageState extends State<FileGroupsPage> {
  late final FileGroupsController _controller =
      Get.find<FileGroupsController>();

  @override
  Widget build(BuildContext context) {
    return AppDataTable<FileGroupRow>(
      controller: _controller,
      columns: _columns(context),
      rowId: (row) => row.group.id,
      searchHint: L.common.searchName,
      emptyTitle: L.files.groupsEmptyTitle,
      emptySubtitle: L.files.groupsEmptySubtitle,
      createLabel: L.files.newGroup,
      onCreate: () => _create(context),
      onBulkDelete: _controller.deleteSelected,
    );
  }

  List<AppColumn<FileGroupRow>> _columns(BuildContext context) {
    return [
      AppColumn<FileGroupRow>(
        title: L.common.name,
        width: 240,
        sortKey: 'name',
        freeze: AppColumnFreeze.start,
        hideable: false,
        cell: (row) => CellPrimary(
          title: row.group.name,
          leading: _colorDot(context, row.group.color),
        ),
      ),
      AppColumn<FileGroupRow>(
        title: L.common.description,
        width: 300,
        expand: true,
        cell: (row) => CellText(row.group.description, muted: true),
      ),
      AppColumn<FileGroupRow>(
        title: L.files.fileCount,
        width: 120,
        cell: (row) => CellText('${row.fileCount}'),
      ),
      AppColumn<FileGroupRow>(
        title: L.common.status,
        width: 110,
        cell: (row) => CellBadge(
          row.group.isActive ? L.common.active : L.common.inactive,
          tone: row.group.isActive ? UiAlertTone.success : UiAlertTone.danger,
        ),
      ),
      AppColumn.actions(
        (row) => [
          CellAction.edit(() => _edit(context, row.group)),
          CellAction(
            label: L.files.membersAction,
            icon: LucideIcons.files,
            onTap: () => showFileGroupMembersDialog(
              context,
              group: row.group,
              controller: _controller,
            ),
          ),
          CellAction.delete(() => _delete(context, row.group)),
        ],
      ),
    ];
  }

  Widget? _colorDot(BuildContext context, String? value) {
    final color = _parseColor(value);
    if (color == null) return null;

    return Container(
      width: 10,
      height: 10,
      decoration: context.appColors.outlined(fill: color, radius: AppRadius.r3),
    );
  }

  Future<void> _create(BuildContext context) async {
    final result = await showFileGroupFormDialog(context);
    if (result == null) return;

    await runAction(
      () => _controller.createGroup(result),
      success: L.files.groupCreated,
      failure: L.common.saveFailed,
    );
  }

  Future<void> _edit(BuildContext context, FileGroup group) async {
    final result = await showFileGroupFormDialog(context, group: group);
    if (result == null) return;

    await runAction(
      () => _controller.updateGroup(result),
      success: L.files.groupUpdated,
      failure: L.common.saveFailed,
    );
  }

  Future<void> _delete(BuildContext context, FileGroup group) async {
    final id = group.id;
    if (id == null) return;

    await confirmAndRun(
      context,
      title: L.files.groupDeleteTitle,
      message: L.files.groupDeleteConfirm.trParams({'name': group.name}),
      action: () => _controller.deleteGroup(id),
      success: L.files.groupDeleted,
      failure: L.common.deleteFailed,
    );
  }

  static Color? _parseColor(String? value) {
    if (value == null) return null;
    var hex = value.trim();
    if (hex.isEmpty) return null;
    if (hex.startsWith('#')) hex = hex.substring(1);
    if (hex.length == 3) {
      hex = '${hex[0]}${hex[0]}${hex[1]}${hex[1]}${hex[2]}${hex[2]}';
    }
    if (hex.length != 6) return null;
    final parsed = int.tryParse(hex, radix: 16);
    return parsed == null ? null : Color(0xFF000000 | parsed);
  }
}
