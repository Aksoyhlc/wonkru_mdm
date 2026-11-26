import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../Core/Constants/Enums/alert_enums.dart';
import '../../../Core/Constants/Enums/button_enums.dart';
import '../../../Core/Constants/Enums/table_enums.dart';
import '../../../Core/Extensions/num.dart';
import '../../../Core/L10n/L.dart';
import '../../../Core/Router/app_routes.dart';
import '../../../Core/Theme/design.dart';
import '../../../Core/Time/app_time.dart';
import '../../../Logic/Controllers/devices_controller.dart';
import '../../Widgets/Action/run_action.dart';
import '../../Widgets/Button/app_button.dart';
import '../../Widgets/Button/app_icon_button.dart';
import '../../Widgets/Table/Cells/cell_action.dart';
import '../../Widgets/Table/Cells/cell_badge.dart';
import '../../Widgets/Table/Cells/cell_bool.dart';
import '../../Widgets/Table/Cells/cell_date.dart';
import '../../Widgets/Table/Cells/cell_meter.dart';
import '../../Widgets/Table/Cells/cell_primary.dart';
import '../../Widgets/Table/Cells/cell_text.dart';
import '../../Widgets/Table/app_data_table.dart';
import '../../Widgets/Table/export_button.dart';
import '../../Widgets/Table/table_column.dart';
import 'Widgets/device_bulk_actions.dart';
import 'Widgets/device_filters_bar.dart';
import 'Widgets/device_summary_cards.dart';
import 'device_command_dialog.dart';

class DevicesPage extends StatefulWidget {
  const DevicesPage({super.key});

  @override
  State<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  /// How often the table and the summary cards refresh themselves.
  static const _refreshInterval = Duration(seconds: 30);

  late final DevicesController _controller = Get.find<DevicesController>();

  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    unawaited(_controller.ensureOptionsLoaded());
    unawaited(_controller.loadOnlineMinutes());
    unawaited(_controller.refreshSummary());
    _refreshTimer = Timer.periodic(_refreshInterval, (_) => _refreshAll());
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _refreshAll() {
    if (!mounted) return;
    // Skip overlapping loads; the summary call already guards itself.
    if (!_controller.loading.value) unawaited(_controller.reload());
    unawaited(_controller.refreshSummary());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.s16,
            AppSpacing.s16,
            AppSpacing.s16,
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _summaryHeader(context),
              AppGap.v12,
              DeviceSummaryCards(controller: _controller),
            ],
          ),
        ),
        Expanded(
          child: Obx(() {
            // The status column depends on the online threshold; rebuilding
            // hands the table fresh columns once it arrives.
            _controller.onlineMinutes.value;
            return AppDataTable<Device>(
              controller: _controller,
              columns: _columns(context),
              rowId: (device) => device.id,
              searchHint: L.common.deviceSearchHint,
              emptyTitle: L.devices.emptyTitle,
              filterBar: DeviceFiltersBar(controller: _controller),
              onRowTap: (device) => context.go(AppRoutes.device(device.id!)),
              actions: [
                _DeviceCommandAction(controller: _controller),
                ExportButton(fileName: 'devices', onExport: _controller.export),
                DeviceBulkActions(controller: _controller),
              ],
            );
          }),
        ),
      ],
    );
  }

  Widget _summaryHeader(BuildContext context) {
    return Row(
      children: [
        const _LiveDot(),
        AppGap.h8,
        Text(
          L.devices.summaryAutoRefresh,
          style: AppText.caption(context, size: 12),
        ),
        AppGap.h8,
        Obx(() {
          final at = _controller.summaryUpdatedAt.value;
          if (at == null) return const SizedBox.shrink();
          return Text(
            '· ${L.devices.summaryUpdated}: '
            '${AppTime.instance.format(at, 'HH:mm:ss')}',
            style: AppText.caption(context, size: 12),
          );
        }),
        const Spacer(),
        Obx(() {
          if (_controller.summaryLoading.value &&
              _controller.summaryLoaded.value) {
            return const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            );
          }
          return AppIconButton(
            icon: LucideIcons.refreshCw,
            tooltip: L.common.refresh,
            onPressed: _refreshAll,
          );
        }),
      ],
    );
  }

  List<AppColumn<Device>> _columns(BuildContext context) {
    return [
      AppColumn<Device>(
        title: L.common.device,
        width: 220,
        sortKey: 'name',
        freeze: AppColumnFreeze.start,
        hideable: false,
        cell: (device) => CellPrimary(
          title: device.name?.isNotEmpty == true ? device.name! : device.code,
          subtitle: device.code,
        ),
      ),
      AppColumn<Device>(
        title: L.devices.columnManufacturerModel,
        width: 200,
        cell: (device) => CellPrimary(
          title: device.model ?? '—',
          subtitle: device.manufacturer,
        ),
      ),
      AppColumn<Device>(
        title: L.devices.serialNo,
        width: 150,
        cell: (device) => CellText(device.serialNo, mono: true),
      ),
      AppColumn<Device>(
        title: 'Android',
        width: 90,
        cell: (device) => CellText(device.androidVersion),
      ),
      AppColumn<Device>(
        title: L.common.battery,
        width: 110,
        cell: (device) => CellMeter(
          percent: device.batteryLevel?.toDouble(),
          tone: CellMeter.batteryTone(device.batteryLevel),
        ),
      ),
      AppColumn<Device>(
        title: L.common.storage,
        width: 140,
        cell: (device) => _storage(device),
      ),
      AppColumn<Device>(
        title: 'Root',
        width: 70,
        align: Alignment.center,
        cell: (device) => CellBool(
          device.isRooted,
          invert: true,
          trueLabel: L.devices.rooted,
          falseLabel: L.devices.clean,
        ),
      ),
      AppColumn<Device>(
        title: 'Launcher',
        width: 90,
        align: Alignment.center,
        cell: (device) => CellBool(
          device.isLauncherMode,
          trueLabel: L.devices.launcherOn,
          falseLabel: L.devices.launcherOff,
        ),
      ),
      AppColumn<Device>(
        title: L.common.policy,
        width: 170,
        cell: (device) => CellText(_controller.policyName(device.policyId)),
      ),
      AppColumn<Device>(
        title: L.devices.policyVersion,
        width: 140,
        cell: (device) => _policyVersion(device),
      ),
      AppColumn<Device>(
        title: L.devices.agentVersion,
        width: 120,
        visible: false,
        cell: (device) => CellText(device.agentVersionName),
      ),
      AppColumn<Device>(
        title: 'IP',
        width: 130,
        visible: false,
        cell: (device) => CellText(device.ipAddress, mono: true),
      ),
      AppColumn<Device>(
        title: L.common.status,
        width: 120,
        cell: (device) => _status(device),
      ),
      AppColumn<Device>(
        title: L.devices.lastSeen,
        width: 150,
        sortKey: 'lastSeenAt',
        cell: (device) => CellDate(device.lastSeenAt),
      ),
      AppColumn.actions((device) => _rowActions(context, device)),
    ];
  }

  List<CellAction> _rowActions(BuildContext context, Device device) {
    return [
      CellAction(
        label: L.common.detail,
        icon: LucideIcons.arrowRight,
        onTap: () => context.go(AppRoutes.device(device.id!)),
      ),
      CellAction(
        label: L.devices.sendCommand,
        icon: LucideIcons.command,
        onTap: () => showDeviceCommandDialog(
          context,
          deviceId: device.id,
          deviceLabel: device.name?.isNotEmpty == true
              ? device.name!
              : device.code,
        ),
      ),
      CellAction.delete(() => _delete(context, device)),
    ];
  }

  Future<void> _delete(BuildContext context, Device device) async {
    await confirmAndRun(
      context,
      message: L.devices.deleteConfirm,
      action: () {
        _controller.setSelection({device.id!});
        return _controller.deleteSelected();
      },
      success: L.devices.deleted,
      failure: L.devices.deleteFailed,
    );
  }

  Widget _storage(Device device) {
    final total = device.totalStorageBytes;
    final free = device.freeStorageBytes;
    if (total == null || total <= 0 || free == null) {
      return const CellText(null);
    }

    final used = ((total - free) / total * 100).clamp(0, 100).toDouble();
    return CellMeter(
      percent: used,
      label: L.devices.freeSpace.trParams({'free': free.readableBytes}),
      tone: CellMeter.usageTone(used),
      width: 116,
    );
  }

  Widget _policyVersion(Device device) {
    if (device.policyId == null) return const CellText(null);

    final version = device.policyVersion;
    final current = _controller.policyById(device.policyId)?.version;
    final stale = version != null && current != null && version != current;

    if (!stale) return CellText(version?.toString());

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CellText(version.toString()),
        AppGap.h6,
        CellBadge(L.devices.policyOutdated, tone: UiAlertTone.warning),
      ],
    );
  }

  Widget _status(Device device) {
    final lastSeen = device.lastSeenAt;
    final online =
        lastSeen != null &&
        DateTime.now().difference(lastSeen).inMinutes <=
            _controller.onlineMinutes.value;

    return CellBadge(
      online ? L.common.online : L.common.offline,
      tone: online ? UiAlertTone.success : UiAlertTone.danger,
      pulse: online,
    );
  }
}

class _LiveDot extends StatelessWidget {
  const _LiveDot();

  @override
  Widget build(BuildContext context) {
    return Container(
          width: AppSpacing.s8,
          height: AppSpacing.s8,
          decoration: BoxDecoration(
            color: context.appColors.success,
            shape: BoxShape.circle,
          ),
        )
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .fadeIn(duration: AppMotion.pulse, begin: 0.4);
  }
}

class _DeviceCommandAction extends StatelessWidget {
  const _DeviceCommandAction({required this.controller});

  final DevicesController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // GetX needs observables read inside the Obx builder; reading the
      // selection here and passing it into the closure avoids "improper use".
      final selected = controller.selected.toSet();

      return AppButton(
        label: L.devices.commandCenter,
        compact: true,
        variant: AppButtonVariant.secondary,
        icon: LucideIcons.command,
        onPressed: () =>
            showDeviceCommandDialog(context, initialDeviceIds: selected),
      );
    });
  }
}
