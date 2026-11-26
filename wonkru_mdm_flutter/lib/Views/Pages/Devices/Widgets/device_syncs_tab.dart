import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../../Core/Constants/Enums/button_enums.dart';
import '../../../../Core/Extensions/datetime.dart';
import '../../../../Core/L10n/L.dart';
import '../../../../Core/Router/app_routes.dart';
import '../../../../Core/Theme/design.dart';
import '../../../../Logic/Controllers/device_detail_syncs_controller.dart';
import '../../../Widgets/Table/app_data_table.dart';
import '../../../Widgets/Table/export_button.dart';
import '../../../Widgets/Table/table_column.dart';

class DeviceSyncsTab extends StatefulWidget {
  const DeviceSyncsTab({super.key, required this.deviceId});

  final int deviceId;

  @override
  State<DeviceSyncsTab> createState() => _DeviceSyncsTabState();
}

class _DeviceSyncsTabState extends State<DeviceSyncsTab> {
  late final DeviceDetailSyncsController _controller =
      DeviceDetailSyncsController(widget.deviceId);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppDataTable<DeviceSyncRow>(
      controller: _controller,
      columns: _columns(context),
      searchHint: L.devices.syncSearchHint,
      emptyTitle: L.devices.noSyncsTitle,
      emptySubtitle: L.devices.noSyncsSubtitle,
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
        title: L.devices.collectedAt,
        width: 170,
        sortKey: 'collectedAt',
        cell: (row) => _text(
          context,
          row.deviceSync.collectedAt.formatDateTime('dd.MM.yyyy HH:mm'),
        ),
      ),
      AppColumn<DeviceSyncRow>(
        title: L.common.battery,
        width: 100,
        cell: (row) => _battery(context, row.batteryLevel),
      ),
      AppColumn<DeviceSyncRow>(
        title: L.common.application,
        width: 110,
        cell: (row) => _text(context, '${row.appsCount}'),
      ),
      AppColumn<DeviceSyncRow>(
        title: L.common.policy,
        width: 220,
        cell: (row) => _policy(context, row),
      ),
      AppColumn<DeviceSyncRow>(
        title: 'Android',
        width: 120,
        cell: (row) => _text(context, row.androidVersion ?? '—'),
      ),
    ];
  }

  Widget _text(BuildContext context, String value) {
    return Padding(
      padding: AppInsets.h10,
      child: Text(
        value,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppText.body(context),
      ),
    );
  }

  Widget _battery(BuildContext context, int? level) {
    final colors = context.appColors;
    final tone = level == null
        ? colors.graphite
        : level < 20
        ? colors.madder
        : colors.carbon;

    return Padding(
      padding: AppInsets.h10,
      child: Text(
        level == null ? '—' : '$level%',
        style: AppText.cellPrimary(
          context,
        ).copyWith(fontWeight: FontWeight.w600, color: tone),
      ),
    );
  }

  Widget _policy(BuildContext context, DeviceSyncRow row) {
    final version = row.policyVersion == null ? '' : ' v${row.policyVersion}';
    return _text(context, '${row.policyName ?? '—'}$version');
  }
}
