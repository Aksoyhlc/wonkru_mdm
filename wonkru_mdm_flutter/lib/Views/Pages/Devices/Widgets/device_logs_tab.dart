import 'package:flutter/material.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../../Core/Extensions/datetime.dart';
import '../../../../Core/L10n/L.dart';
import '../../../../Core/Theme/design.dart';
import '../../../../Logic/Controllers/device_detail_logs_controller.dart';
import '../../../../Logic/Controllers/device_logs_controller.dart';
import '../../../Widgets/Badge/status_badge.dart';
import '../../../Widgets/Table/app_data_table.dart';
import '../../../Widgets/Table/table_column.dart';
import '../../DeviceLogs/Widgets/device_log_detail_dialog.dart';

class DeviceLogsTab extends StatefulWidget {
  const DeviceLogsTab({super.key, required this.deviceId});

  final int deviceId;

  @override
  State<DeviceLogsTab> createState() => _DeviceLogsTabState();
}

class _DeviceLogsTabState extends State<DeviceLogsTab> {
  late final DeviceDetailLogsController _controller =
      DeviceDetailLogsController(widget.deviceId);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppDataTable<DeviceLogRow>(
      controller: _controller,
      columns: _columns(context),
      searchHint: L.devices.logsSearchHint,
      emptyTitle: L.devices.noLogsTitle,
      emptySubtitle: L.devices.noLogsSubtitle,
      onRowTap: (row) => DeviceLogDetailDialog.show(context, row),
    );
  }

  List<AppColumn<DeviceLogRow>> _columns(BuildContext context) {
    return [
      AppColumn<DeviceLogRow>(
        title: L.common.time,
        width: 160,
        cell: (row) => _text(
          context,
          row.log.loggedAt?.formatDateTime('dd.MM.yyyy HH:mm:ss') ?? '—',
        ),
      ),
      AppColumn<DeviceLogRow>(
        title: L.common.level,
        width: 110,
        sortKey: 'level',
        cell: (row) => _badge(row.log.level),
      ),
      AppColumn<DeviceLogRow>(
        title: L.common.tag,
        width: 150,
        cell: (row) => _text(context, row.log.tag ?? '—'),
      ),
      AppColumn<DeviceLogRow>(
        title: L.common.message,
        width: 480,
        cell: (row) => _text(context, row.log.message),
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

  Widget _badge(int level) {
    return Padding(
      padding: AppInsets.h10,
      child: Align(
        alignment: Alignment.centerLeft,
        child: StatusBadge(
          label: DeviceLogsController.levelLabel(level),
          tone: DeviceLogsController.levelTone(level),
        ),
      ),
    );
  }
}
