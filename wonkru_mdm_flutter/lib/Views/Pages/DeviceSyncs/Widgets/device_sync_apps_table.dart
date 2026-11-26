import 'package:flutter/material.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../../Core/Constants/Enums/alert_enums.dart';
import '../../../../Core/L10n/L.dart';
import '../../../../Core/Theme/design.dart';
import '../../../../Logic/Controllers/device_sync_apps_controller.dart';
import '../../../Widgets/Badge/status_badge.dart';
import '../../../Widgets/Table/app_data_table.dart';
import '../../../Widgets/Table/table_column.dart';

class DeviceSyncAppsTable extends StatefulWidget {
  const DeviceSyncAppsTable({super.key, required this.syncId});

  final int syncId;

  @override
  State<DeviceSyncAppsTable> createState() => _DeviceSyncAppsTableState();
}

class _DeviceSyncAppsTableState extends State<DeviceSyncAppsTable> {
  late final DeviceSyncAppsController _controller = DeviceSyncAppsController(
    widget.syncId,
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 460,
      child: AppDataTable<DeviceApplication>(
        controller: _controller,
        columns: _columns(context),
        searchHint: L.deviceSyncs.appSearchHint,
        emptyTitle: L.deviceSyncs.noAppsTitle,
        emptySubtitle: L.deviceSyncs.noAppsSubtitle,
      ),
    );
  }

  List<AppColumn<DeviceApplication>> _columns(BuildContext context) {
    return [
      AppColumn<DeviceApplication>(
        title: L.common.application,
        width: 280,
        cell: (app) => _nameCell(context, app),
      ),
      AppColumn<DeviceApplication>(
        title: L.common.version,
        width: 150,
        sortKey: 'versionName',
        cell: (app) => _text(context, app.versionName ?? '—'),
      ),
      AppColumn<DeviceApplication>(
        title: L.common.type,
        width: 110,
        sortKey: 'isSystemApp',
        cell: (app) => _badge(app),
      ),
    ];
  }

  Widget _nameCell(BuildContext context, DeviceApplication app) {
    return Padding(
      padding: AppInsets.h10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            app.appName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.cellPrimary(
              context,
            ).copyWith(fontWeight: FontWeight.w600),
          ),
          Text(
            app.packageName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.caption(context, size: 11),
          ),
        ],
      ),
    );
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

  Widget _badge(DeviceApplication app) {
    return Padding(
      padding: AppInsets.h10,
      child: Align(
        alignment: Alignment.centerLeft,
        child: app.isSystemApp
            ? StatusBadge(
                label: L.deviceSyncs.system,
                tone: UiAlertTone.warning,
              )
            : StatusBadge(label: L.deviceSyncs.appUser),
      ),
    );
  }
}
