import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../Core/Constants/Enums/alert_enums.dart';
import '../../../Core/Constants/Enums/button_enums.dart';
import '../../../Core/Constants/Enums/table_enums.dart';
import '../../../Core/L10n/L.dart';
import '../../../Core/Router/app_routes.dart';
import '../../../Logic/Controllers/device_syncs_controller.dart';
import '../../Widgets/Input/device_picker_field.dart';
import '../../Widgets/Table/Cells/cell_badge.dart';
import '../../Widgets/Table/Cells/cell_date.dart';
import '../../Widgets/Table/Cells/cell_meter.dart';
import '../../Widgets/Table/Cells/cell_primary.dart';
import '../../Widgets/Table/Cells/cell_text.dart';
import '../../Widgets/Table/app_data_table.dart';
import '../../Widgets/Table/export_button.dart';
import '../../Widgets/Table/table_column.dart';
import '../../Widgets/Table/table_date_filter.dart';
import '../../Widgets/Table/table_filter_bar.dart';

class DeviceSyncsPage extends StatefulWidget {
  const DeviceSyncsPage({super.key});

  @override
  State<DeviceSyncsPage> createState() => _DeviceSyncsPageState();
}

class _DeviceSyncsPageState extends State<DeviceSyncsPage> {
  late final DeviceSyncsController _controller =
      Get.find<DeviceSyncsController>();

  @override
  Widget build(BuildContext context) {
    return AppDataTable<DeviceSyncRow>(
      controller: _controller,
      columns: _columns(context),
      searchHint: L.deviceSyncs.searchHint,
      emptyTitle: L.deviceSyncs.emptyTitle,
      emptySubtitle: L.common.noMatchingRecords,
      filterBar: _DeviceSyncFiltersBar(controller: _controller),
      onRowTap: (row) => context.go(AppRoutes.deviceSync(row.deviceSync.id!)),
      actions: [
        ExportButton(
          fileName: 'device-syncs',
          onExport: _controller.export,
          variant: AppButtonVariant.primary,
        ),
      ],
    );
  }

  List<AppColumn<DeviceSyncRow>> _columns(BuildContext context) {
    return [
      AppColumn<DeviceSyncRow>(
        title: L.common.device,
        width: 220,
        freeze: AppColumnFreeze.start,
        hideable: false,
        cell: (row) => CellPrimary(
          title: row.deviceName?.isNotEmpty == true
              ? row.deviceName!
              : row.deviceCode,
          subtitle: row.deviceCode,
        ),
      ),
      AppColumn<DeviceSyncRow>(
        title: L.common.type,
        width: 110,
        sortKey: 'syncType',
        cell: (row) => CellBadge(
          row.deviceSync.syncType,
          tone: row.deviceSync.syncType == 'full'
              ? UiAlertTone.success
              : UiAlertTone.info,
        ),
      ),
      AppColumn<DeviceSyncRow>(
        title: L.deviceSyncs.collectedAt,
        width: 150,
        sortKey: 'collectedAt',
        cell: (row) => CellDate(row.deviceSync.collectedAt),
      ),
      AppColumn<DeviceSyncRow>(
        title: L.deviceSyncs.createdAt,
        width: 150,
        sortKey: 'createdAt',
        visible: false,
        cell: (row) => CellDate(row.deviceSync.createdAt),
      ),
      AppColumn<DeviceSyncRow>(
        title: L.common.battery,
        width: 110,
        cell: (row) => CellMeter(
          percent: row.batteryLevel?.toDouble(),
          tone: CellMeter.batteryTone(row.batteryLevel),
        ),
      ),
      AppColumn<DeviceSyncRow>(
        title: L.common.application,
        width: 100,
        cell: (row) => CellText('${row.appsCount}'),
      ),
      AppColumn<DeviceSyncRow>(
        title: L.common.policy,
        width: 180,
        cell: (row) => CellPrimary(
          title: row.policyName ?? '—',
          subtitle: row.policyVersion == null ? null : 'v${row.policyVersion}',
        ),
      ),
      AppColumn<DeviceSyncRow>(
        title: 'Android',
        width: 100,
        cell: (row) => CellText(row.androidVersion),
      ),
    ];
  }
}

class _DeviceSyncFiltersBar extends StatelessWidget {
  const _DeviceSyncFiltersBar({required this.controller});

  final DeviceSyncsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final filters = controller.filters;

      return TableFilterBar(
        activeCount: filters.length,
        onClear: controller.clearFilters,
        fields: [
          DevicePickerField(
            name: 'device_sync_filter_device',
            onChanged: (device) => controller.setFilter('deviceId', device?.id),
          ),
          TableDateFilter(
            name: 'device_sync_filter_from',
            label: L.common.start,
            controller: controller,
            filterKey: 'from',
          ),
          TableDateFilter(
            name: 'device_sync_filter_until',
            label: L.common.end,
            controller: controller,
            filterKey: 'to',
            endOfDay: true,
          ),
        ],
      );
    });
  }
}
