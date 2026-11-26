import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../../Core/Constants/Enums/alert_enums.dart';
import '../../../../Core/Constants/Enums/table_enums.dart';
import '../../../../Core/L10n/L.dart';
import '../../../../Logic/Controllers/device_applications_controller.dart';
import '../../../Widgets/Action/run_action.dart';
import '../../../Widgets/Alert/app_toast.dart';
import '../../../Widgets/Dialog/confirm_dialog.dart';
import '../../../Widgets/Table/Cells/cell_action.dart';
import '../../../Widgets/Table/Cells/cell_actions.dart';
import '../../../Widgets/Table/Cells/cell_badge.dart';
import '../../../Widgets/Table/Cells/cell_primary.dart';
import '../../../Widgets/Table/Cells/cell_text.dart';
import '../../../Widgets/Table/app_data_table.dart';
import '../../../Widgets/Table/table_column.dart';
import 'device_applications_filters_bar.dart';

class DeviceApplicationsTab extends StatefulWidget {
  const DeviceApplicationsTab({super.key, required this.deviceId});

  final int deviceId;

  @override
  State<DeviceApplicationsTab> createState() => _DeviceApplicationsTabState();
}

class _DeviceApplicationsTabState extends State<DeviceApplicationsTab> {
  late final DeviceApplicationsController _controller =
      DeviceApplicationsController(widget.deviceId);

  @override
  Widget build(BuildContext context) {
    return AppDataTable<DeviceApplication>(
      controller: _controller,
      columns: _columns(),
      searchHint: L.devices.appsSearchHint,
      emptyTitle: L.devices.noInstalledApps,
      emptySubtitle: L.devices.appsNotReported,
      filterBar: DeviceApplicationsFiltersBar(controller: _controller),
    );
  }

  List<AppColumn<DeviceApplication>> _columns() => [
    AppColumn<DeviceApplication>(
      title: L.common.application,
      width: 260,
      expand: true,
      sortKey: 'appName',
      hideable: false,
      freeze: AppColumnFreeze.start,
      cell: (app) => CellPrimary(title: app.appName),
    ),
    AppColumn<DeviceApplication>(
      title: L.devices.package,
      width: 260,
      sortKey: 'packageName',
      cell: (app) => CellText(app.packageName, muted: true, mono: true),
    ),
    AppColumn<DeviceApplication>(
      title: L.common.version,
      width: 120,
      sortKey: 'versionName',
      cell: (app) => CellText(app.versionName),
    ),
    AppColumn<DeviceApplication>(
      title: L.devices.system,
      width: 120,
      sortKey: 'isSystemApp',
      cell: (app) => CellBadge(
        app.isSystemApp ? L.devices.system : L.devices.appUser,
        tone: app.isSystemApp ? UiAlertTone.info : UiAlertTone.success,
      ),
    ),
    AppColumn<DeviceApplication>(
      title: L.devices.uninstallBlocked,
      width: 150,
      sortKey: 'isUninstallBlocked',
      cell: (app) => CellBadge(
        app.isUninstallBlocked
            ? L.devices.uninstallBlocked
            : L.devices.uninstallAllowed,
        tone: app.isUninstallBlocked ? UiAlertTone.danger : UiAlertTone.success,
      ),
    ),
    AppColumn<DeviceApplication>(
      title: L.common.actions,
      width: 80,
      hideable: false,
      freeze: AppColumnFreeze.end,
      align: Alignment.center,
      cell: (app) => CellActions(
        actions: [
          CellAction(
            label: L.devices.launch,
            icon: LucideIcons.play,
            onTap: () => _send(app, action: 'launch_app'),
          ),
          CellAction(
            label: L.devices.openSettings,
            icon: LucideIcons.settings,
            onTap: () => _send(app, action: 'open_app_settings'),
          ),
          if (!app.isSystemApp)
            CellAction(
              label: L.common.remove,
              icon: LucideIcons.trash2,
              danger: true,
              onTap: () => _send(
                app,
                action: 'uninstall_app',
                confirmMessage: L.devices.uninstallConfirm.trParams({
                  'app': app.appName,
                }),
              ),
            ),
        ],
      ),
    ),
  ];

  Future<void> _send(
    DeviceApplication app, {
    required String action,
    String? confirmMessage,
  }) async {
    if (confirmMessage != null) {
      final confirmed = await confirmDialog(
        context: context,
        title: L.devices.uninstallTitle,
        message: confirmMessage,
      );
      if (confirmed != true) return;
    }

    await runAction(() async {
      final status = await _controller.sendPackageCommand(
        action,
        app.packageName,
      );
      AppToast.show(
        status.total > 0 ? L.devices.commandSent : L.devices.noUuidInfo,
        tone: status.total > 0 ? UiAlertTone.success : UiAlertTone.warning,
      );
    }, failure: L.devices.commandSendFailed);
  }
}
