import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../Core/Constants/Enums/table_enums.dart';
import '../../../Core/L10n/L.dart';
import '../../../Logic/Controllers/admin_activity_controller.dart';
import '../../Widgets/Table/Cells/cell_action.dart';
import '../../Widgets/Table/Cells/cell_date.dart';
import '../../Widgets/Table/Cells/cell_primary.dart';
import '../../Widgets/Table/Cells/cell_text.dart';
import '../../Widgets/Table/app_data_table.dart';
import '../../Widgets/Table/table_column.dart';
import 'Widgets/admin_activity_detail_dialog.dart';
import 'Widgets/admin_activity_filters_bar.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  late final AdminActivityController _controller = Get.find<AdminActivityController>();

  @override
  void initState() {
    super.initState();
    unawaited(_controller.ensureLookupsLoaded());
  }

  @override
  Widget build(BuildContext context) {
    return AppDataTable<AdminActivity>(
      controller: _controller,
      columns: _columns(context),
      searchHint: L.activity.searchHint,
      emptyTitle: L.common.notFound,
      emptySubtitle: L.activity.emptyBody,
      filterBar: AdminActivityFiltersBar(controller: _controller),
      onRowTap: (row) => AdminActivityDetailDialog.show(context, row),
    );
  }

  List<AppColumn<AdminActivity>> _columns(BuildContext context) {
    return [
      AppColumn<AdminActivity>(
        title: L.common.time,
        width: 170,
        freeze: AppColumnFreeze.start,
        hideable: false,
        sortKey: 'createdAt',
        cell: (row) => CellDate(row.createdAt),
      ),
      AppColumn<AdminActivity>(
        title: L.activity.columnActor,
        width: 240,
        cell: (row) => CellPrimary(title: _actorTitle(row), subtitle: row.actorEmail),
      ),
      AppColumn<AdminActivity>(
        title: L.common.action,
        width: 240,
        sortKey: 'action',
        cell: (row) => CellText(row.action),
      ),
      AppColumn<AdminActivity>(title: L.activity.columnTarget, width: 200, cell: (row) => CellText(_target(row))),
      AppColumn<AdminActivity>(title: L.activity.columnIp, width: 150, cell: (row) => CellText(row.ipAddress)),
      AppColumn.actions(
        (row) => [
          CellAction(
            label: L.activity.detailTitle,
            icon: LucideIcons.eye,
            onTap: () => AdminActivityDetailDialog.show(context, row),
          ),
        ],
      ),
    ];
  }

  String _actorTitle(AdminActivity row) {
    final name = row.actorName?.trim();
    if (name != null && name.isNotEmpty) return name;
    final email = row.actorEmail?.trim();
    if (email != null && email.isNotEmpty) return email;

    return L.activity.system;
  }

  String? _target(AdminActivity row) {
    final type = row.targetType?.trim();
    if (type == null || type.isEmpty) return null;
    final id = row.targetId?.trim();

    return id == null || id.isEmpty ? type : '$type #$id';
  }
}
