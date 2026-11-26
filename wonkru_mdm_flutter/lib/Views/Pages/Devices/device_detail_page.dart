import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../Core/Constants/Enums/alert_enums.dart';
import '../../../Core/Constants/Enums/button_enums.dart';
import '../../../Core/L10n/L.dart';
import '../../../Core/Logging/wlog.dart';
import '../../../Core/Router/app_routes.dart';
import '../../../Core/Theme/design.dart';
import '../../../Logic/Controllers/device_detail_controller.dart';
import '../../../Logic/Controllers/devices_controller.dart';
import '../../Widgets/Alert/app_toast.dart';
import '../../Widgets/Button/app_button.dart';
import '../../Widgets/Button/app_icon_button.dart';
import '../../Widgets/Card/section_card.dart';
import '../../Widgets/Dialog/confirm_dialog.dart';
import '../../Widgets/EmptyState/error_panel.dart';
import '../../Widgets/Loading/app_loader.dart';
import '../../Widgets/Page/page_header.dart';
import '../../Widgets/Table/Cells/cell_action.dart';
import '../../Widgets/Table/Cells/cell_actions.dart';
import '../../Widgets/Table/Cells/cell_chips.dart';
import '../../Widgets/Tabs/page_tabs.dart';
import 'Widgets/device_agent_card.dart';
import 'Widgets/device_applications_tab.dart';
import 'Widgets/device_commands_tab.dart';
import 'Widgets/device_connection_card.dart';
import 'Widgets/device_edit_dialog.dart';
import 'Widgets/device_info_card.dart';
import 'Widgets/device_logs_tab.dart';
import 'Widgets/device_pdf_report_button.dart';
import 'Widgets/device_reports_tab.dart';
import 'Widgets/device_security_card.dart';
import 'Widgets/device_summary_strip.dart';
import 'Widgets/device_syncs_tab.dart';
import 'device_command_dialog.dart';

class DeviceDetailPage extends StatefulWidget {
  const DeviceDetailPage({super.key, required this.deviceId, this.initialTab});

  final int deviceId;

  final String? initialTab;

  @override
  State<DeviceDetailPage> createState() => _DeviceDetailPageState();
}

class _DeviceDetailPageState extends State<DeviceDetailPage> {
  late final DeviceDetailController _controller = DeviceDetailController(
    widget.deviceId,
  );

  static const _twoColumnWidth = 1000.0;

  late final DevicesController _devices = Get.find<DevicesController>();

  @override
  void initState() {
    super.initState();
    unawaited(_controller.load());
    unawaited(_devices.loadOnlineMinutes());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_controller.loading.value && _controller.device.value == null) {
        return const Center(child: AppLoader(size: 26));
      }
      final device = _controller.device.value;
      if (device == null) {
        return ErrorPanel(
          message: L.devices.loadFailedDetail,
          onRetry: _controller.load,
        );
      }

      // Keyed by the tab query: navigating to the same device with `?tab=apps`
      // rebuilds the controller and opens that tab.
      return DefaultTabController(
        key: ValueKey(widget.initialTab),
        length: 6,
        initialIndex: widget.initialTab == AppRoutes.deviceAppsTab ? 1 : 0,
        child: Column(
          children: [
            PageHeader(
              title: device.name?.isNotEmpty == true
                  ? device.name!
                  : device.code,
              subtitle: device.code,
              leading: AppIconButton.back(context),
              actions: _actions(device),
            ),
            PageTabs(
              labels: [
                L.devices.tabInfo,
                L.devices.tabInstalledApps,
                L.devices.tabLogs,
                L.devices.tabReports,
                L.devices.tabSyncs,
                L.devices.tabCommands,
              ],
            ),
            Expanded(
              // Swipe is disabled: panning a wide table sideways was jumping
              // between tabs.
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _infoTab(context, device),
                  DeviceApplicationsTab(deviceId: widget.deviceId),
                  DeviceLogsTab(deviceId: widget.deviceId),
                  DeviceReportsTab(controller: _controller),
                  DeviceSyncsTab(deviceId: widget.deviceId),
                  DeviceCommandsTab(deviceId: widget.deviceId),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  List<Widget> _actions(Device device) {
    return [
      AppButton(
        label: L.devices.sendCommand,
        compact: true,
        icon: LucideIcons.command,
        onPressed: () => _sendCommand(device),
      ),
      AppButton(
        label: L.common.edit,
        compact: true,
        variant: AppButtonVariant.secondary,
        icon: LucideIcons.pencil,
        onPressed: () => _edit(device),
      ),
      DevicePdfReportButton(
        fileName: _pdfFileName(device),
        onExport: _controller.reportPdf,
      ),
      CellActions(
        tooltip: L.devices.otherActions,
        actions: [
          CellAction(
            label: L.common.actionUpdatePolicy,
            icon: LucideIcons.refreshCw,
            onTap: _sendPolicyUpdate,
          ),
          CellAction(
            label: L.devices.ownPolicy,
            icon: LucideIcons.copy,
            onTap: _duplicatePolicy,
          ),
          CellAction(
            label: L.common.delete,
            icon: LucideIcons.trash2,
            danger: true,
            onTap: _delete,
          ),
        ],
      ),
    ];
  }

  Widget _infoTab(BuildContext context, Device device) {
    final state = _controller.state.value;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.s16,
        children: [
          Obx(
            () => DeviceSummaryStrip(
              device: device,
              state: state,
              onlineMinutes: _devices.onlineMinutes.value,
            ),
          ),
          _columns(
            context,
            left: DeviceInfoCard(
              device: device,
              state: state,
              policyName: _controller.policyName(device.policyId),
            ),
            right: DeviceConnectionCard(device: device, state: state),
          ),
          _columns(
            context,
            left: DeviceAgentCard(device: device, state: state),
            right: DeviceSecurityCard(device: device, state: state),
          ),
          SectionCard(title: L.common.groups, child: _groups(context)),
        ],
      ),
    );
  }

  Widget _columns(
    BuildContext context, {
    required Widget left,
    required Widget right,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < _twoColumnWidth) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              left,
              AppGap.v16,
              right,
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.s16,
          children: [
            Expanded(child: left),
            Expanded(child: right),
          ],
        );
      },
    );
  }

  Widget _groups(BuildContext context) {
    return CellChips(
      _controller.groupNames(),
      maxVisible: 12,
      emptyText: L.devices.noGroups,
    );
  }

  String _pdfFileName(Device device) {
    final raw = device.code.isEmpty ? '${device.id}' : device.code;
    final safe = raw.replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '_');
    return 'device-report-$safe';
  }

  void _sendCommand(Device device) {
    final label = device.name?.isNotEmpty == true ? device.name! : device.code;
    showDeviceCommandDialog(
      context,
      deviceId: device.id,
      deviceLabel: label,
    );
  }

  Future<void> _edit(Device device) async {
    final request = await showDeviceEditDialog(
      context,
      device: device,
      policies: _controller.policies,
      groups: _controller.groups,
      groupIds: _controller.groupIds,
      users: _controller.users,
    );
    if (request == null) return;

    final ok = await _run(() => _controller.updateDevice(request));
    if (ok) AppToast.show(L.devices.updated, tone: UiAlertTone.success);
  }

  Future<void> _sendPolicyUpdate() async {
    final confirmed = await confirmDialog(
      context: context,
      title: L.common.actionUpdatePolicy,
      message: L.devices.policyUpdateConfirm,
    );
    if (confirmed != true) return;

    var queued = 0;
    final ok = await _run(() async {
      queued = await _controller.sendPolicyUpdate();
    });
    if (ok) {
      AppToast.show(
        queued > 0 ? L.devices.commandQueued : L.devices.noPolicy,
        tone: queued > 0 ? UiAlertTone.success : UiAlertTone.warning,
      );
    }
  }

  Future<void> _duplicatePolicy() async {
    final confirmed = await confirmDialog(
      context: context,
      title: L.devices.ownPolicy,
      message: L.devices.ownPolicyConfirm,
    );
    if (confirmed != true) return;

    Policy? created;
    final ok = await _run(() async {
      created = await _controller.duplicatePolicy();
    });
    if (ok && created != null) {
      AppToast.show(
        L.devices.policyCreated.trParams({'name': created!.name}),
        tone: UiAlertTone.success,
      );
    }
  }

  Future<void> _delete() async {
    final confirmed = await confirmDialog(
      context: context,
      title: L.devices.deleteTitle,
      message: L.devices.deleteConfirm,
    );
    if (confirmed != true) return;

    final ok = await _run(() => _controller.deleteDevice());
    if (ok && mounted) {
      AppToast.show(L.devices.deleted, tone: UiAlertTone.success);
      context.back();
    }
  }

  Future<bool> _run(Future<void> Function() action) async {
    try {
      await action();
      return true;
    } catch (e) {
      WLog.e('DeviceDetail', 'action failed', error: e);
      AppToast.show(L.devices.actionFailed, tone: UiAlertTone.danger);
      return false;
    }
  }
}
