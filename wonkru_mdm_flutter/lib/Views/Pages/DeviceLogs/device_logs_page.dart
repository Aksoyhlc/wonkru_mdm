import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../Core/Constants/Enums/table_enums.dart';
import '../../../Core/L10n/L.dart';
import '../../../Core/Theme/design.dart';
import '../../../Logic/Controllers/device_logs_controller.dart';
import '../../Widgets/Action/run_action.dart';
import '../../Widgets/Table/Cells/cell_action.dart';
import '../../Widgets/Table/Cells/cell_badge.dart';
import '../../Widgets/Table/Cells/cell_date.dart';
import '../../Widgets/Table/Cells/cell_text.dart';
import '../../Widgets/Table/app_data_table.dart';
import '../../Widgets/Table/bulk_delete_button.dart';
import '../../Widgets/Table/export_button.dart';
import '../../Widgets/Table/selection_actions.dart';
import '../../Widgets/Table/table_column.dart';
import 'Widgets/device_log_detail_dialog.dart';
import 'Widgets/device_log_filters_bar.dart';
import 'Widgets/device_log_summary.dart';

class DeviceLogsPage extends StatefulWidget {
  const DeviceLogsPage({super.key});

  @override
  State<DeviceLogsPage> createState() => _DeviceLogsPageState();
}

class _DeviceLogsPageState extends State<DeviceLogsPage> {
  late final DeviceLogsController _controller =
      Get.find<DeviceLogsController>();

  @override
  void initState() {
    super.initState();
    unawaited(_controller.ensureSummaryLoaded());
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: constraints.maxHeight * 0.42,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.s16,
                  AppSpacing.s16,
                  AppSpacing.s16,
                  AppSpacing.s8,
                ),
                child: DeviceLogSummary(controller: _controller),
              ),
            ),
            Expanded(
              child: AppDataTable<DeviceLogRow>(
                controller: _controller,
                columns: _columns(context),
                rowId: (row) => row.log.id,
                searchHint: L.deviceLogs.searchHint,
                emptyTitle: L.deviceLogs.emptyTitle,
                emptySubtitle: L.common.noMatchingRecords,
                filterBar: DeviceLogFiltersBar(controller: _controller),
                onRowTap: (row) => DeviceLogDetailDialog.show(context, row),
                actions: [
                  SelectionActions(
                    selected: _controller.selected,
                    countLabel: (count) => L.common.selectedCount.trParams({
                      'count': '$count',
                    }),
                    countStyle: AppText.bodyMuted(context),
                    actions: (count) => [
                      BulkDeleteButton(
                        label: L.common.delete,
                        title: L.deviceLogs.bulkDeleteTitle,
                        message: L.deviceLogs.bulkDeleteConfirm.trParams({
                          'count': '$count',
                        }),
                        onDelete: _controller.deleteSelected,
                        successMessage: (deleted) => L.deviceLogs.bulkDeleted
                            .trParams({'count': '$deleted'}),
                        failure: L.common.deleteFailed,
                      ),
                    ],
                  ),
                  ExportButton(
                    fileName: 'device-logs',
                    onExport: _controller.export,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  List<AppColumn<DeviceLogRow>> _columns(BuildContext context) {
    return [
      AppColumn<DeviceLogRow>(
        title: L.common.time,
        width: 160,
        freeze: AppColumnFreeze.start,
        hideable: false,
        cell: (row) => CellDate(row.log.loggedAt),
      ),
      AppColumn<DeviceLogRow>(
        title: L.common.level,
        width: 110,
        sortKey: 'level',
        cell: (row) => CellBadge(
          DeviceLogsController.levelLabel(row.log.level),
          tone: DeviceLogsController.levelTone(row.log.level),
        ),
      ),
      AppColumn<DeviceLogRow>(
        title: L.common.tag,
        width: 140,
        cell: (row) => CellText(row.log.tag),
      ),
      AppColumn<DeviceLogRow>(
        title: L.common.message,
        width: 360,
        expand: true,
        cell: (row) => CellText(row.log.message, tooltip: row.log.message),
      ),
      AppColumn<DeviceLogRow>(
        title: L.common.device,
        width: 200,
        cell: (row) => CellText(row.deviceLabel ?? '#${row.log.deviceId}'),
      ),
      AppColumn.actions(
        (row) => [
          CellAction(
            label: L.common.detail,
            icon: LucideIcons.eye,
            onTap: () => DeviceLogDetailDialog.show(context, row),
          ),
          CellAction.delete(() => _delete(context, row)),
        ],
      ),
    ];
  }

  Future<void> _delete(BuildContext context, DeviceLogRow row) async {
    final id = row.log.id;
    if (id == null) return;

    await confirmAndRun(
      context,
      title: L.deviceLogs.deleteTitle,
      message: L.deviceLogs.deleteConfirm,
      action: () => _controller.deleteRow(id),
      success: L.deviceLogs.deleted,
      failure: L.common.deleteFailed,
    );
  }
}
