import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../Core/Constants/Enums/alert_enums.dart';
import '../../../Core/Extensions/datetime.dart';
import '../../../Core/L10n/L.dart';
import '../../../Core/Theme/design.dart';
import '../../../Logic/Controllers/device_sync_detail_controller.dart';
import '../../Widgets/Badge/status_badge.dart';
import '../../Widgets/Button/app_icon_button.dart';
import '../../Widgets/Card/section_card.dart';
import '../../Widgets/EmptyState/error_panel.dart';
import '../../Widgets/Loading/app_loader.dart';
import '../../Widgets/Motion/pulse_dot.dart';
import '../../Widgets/Page/page_header.dart';
import 'Widgets/device_sync_apps_table.dart';
import 'Widgets/device_sync_json_card.dart';

class DeviceSyncDetailPage extends StatefulWidget {
  const DeviceSyncDetailPage({super.key, required this.syncId});

  final int syncId;

  @override
  State<DeviceSyncDetailPage> createState() => _DeviceSyncDetailPageState();
}

class _DeviceSyncDetailPageState extends State<DeviceSyncDetailPage> {
  late final DeviceSyncDetailController _controller =
      DeviceSyncDetailController(widget.syncId);

  @override
  void initState() {
    super.initState();
    unawaited(_controller.load());
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_controller.loading.value && _controller.detail.value == null) {
        return const Center(child: AppLoader(size: 26));
      }

      final detail = _controller.detail.value;
      if (detail == null) {
        return ErrorPanel(
          message: L.deviceSyncs.detailLoadFailed,
          onRetry: _controller.load,
        );
      }

      final row = detail.row;
      return Column(
        children: [
          PageHeader(
            title: row.deviceName?.isNotEmpty == true
                ? row.deviceName!
                : row.deviceCode,
            subtitle: _headerSubtitle(row),
            leading: AppIconButton.back(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: AppInsets.all20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionCard(
                    title: L.deviceSyncs.summary,
                    child: _summary(context, detail),
                  ),
                  AppGap.v16,
                  ..._jsonSections(context, row.deviceSync),
                  AppGap.v16,
                  SectionCard(
                    title: L.deviceSyncs.installedApps,
                    child: DeviceSyncAppsTable(syncId: widget.syncId),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  String _headerSubtitle(DeviceSyncRow row) {
    final collected = row.deviceSync.collectedAt.formatDateTime(
      'dd.MM.yyyy HH:mm',
    );
    return '${row.deviceCode} • $collected';
  }

  Widget _summary(BuildContext context, DeviceSyncDetail detail) {
    final row = detail.row;
    final state = detail.state;
    final version = row.policyVersion == null ? '' : ' v${row.policyVersion}';

    return Wrap(
      spacing: 24,
      runSpacing: 16,
      children: [
        _infoRow(context, L.common.device, row.deviceName ?? row.deviceCode),
        _infoRow(context, L.common.code, row.deviceCode),
        _infoRow(context, L.deviceSyncs.brand, row.brand ?? '—'),
        _infoRow(context, 'Android', row.androidVersion ?? '—'),
        _infoRow(
          context,
          L.deviceSyncs.collectedAt,
          row.deviceSync.collectedAt.formatDateTime(),
        ),
        _infoRow(
          context,
          L.common.policy,
          '${row.policyName ?? '—'}$version',
        ),
        _infoRow(context, L.common.application, '${row.appsCount}'),
        _infoRow(
          context,
          L.common.battery,
          state.batteryLevel == null ? '—' : '${state.batteryLevel}%',
        ),
        _infoRow(context, L.common.storage, _storage(state)),
        _infoRow(
          context,
          L.deviceSyncs.lastUpdate,
          state.updatedAt.formatDateTime(),
        ),
        _statusRow(context, state.isOnline),
      ],
    );
  }

  Widget _infoRow(BuildContext context, String label, String value) {
    return SizedBox(
      width: 240,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppText.caption(context, size: 11),
          ),
          AppGap.v2,
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppText.body(context),
          ),
        ],
      ),
    );
  }

  Widget _statusRow(BuildContext context, bool? isOnline) {
    return SizedBox(
      width: 240,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            L.common.status,
            style: AppText.caption(context, size: 11),
          ),
          AppGap.v4,
          if (isOnline == null)
            Text(
              '—',
              style: AppText.body(context),
            )
          else
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isOnline) ...[
                  PulseDot(color: context.appColors.success),
                  AppGap.h8,
                ],
                StatusBadge(
                  label: isOnline ? L.common.online : L.common.offline,
                  tone: isOnline ? UiAlertTone.success : UiAlertTone.danger,
                ),
              ],
            ),
        ],
      ),
    );
  }

  List<Widget> _jsonSections(BuildContext context, DeviceSync sync) {
    final sections = <({String title, String? value})>[
      (title: L.deviceSyncs.sectionDeviceInfo, value: sync.deviceInfo),
      (title: L.deviceSyncs.sectionMdmApp, value: sync.mdmAppInfo),
      (title: L.deviceSyncs.sectionApps, value: sync.appsInfo),
      (title: L.deviceSyncs.sectionAudio, value: sync.audioInfo),
      (title: L.deviceSyncs.sectionBattery, value: sync.batteryInfo),
      (
        title: L.deviceSyncs.sectionCertificates,
        value: sync.certificatesInfo,
      ),
      (title: L.deviceSyncs.sectionDisplay, value: sync.displayInfo),
      (title: L.deviceSyncs.sectionNetwork, value: sync.networkInfo),
      (
        title: L.deviceSyncs.sectionNotifications,
        value: sync.notificationInfo,
      ),
      (
        title: L.deviceSyncs.sectionRestrictions,
        value: sync.restrictionsInfo,
      ),
      (title: L.deviceSyncs.sectionSecurity, value: sync.securityInfo),
      (title: L.deviceSyncs.sectionStorage, value: sync.storageInfo),
      (title: L.deviceSyncs.sectionSystem, value: sync.systemInfo),
      (title: L.deviceSyncs.sectionOther, value: sync.otherInfo),
      (title: 'BS (bsInfo)', value: sync.bsInfo),
      (title: 'ST (stInfo)', value: sync.stInfo),
    ];

    final cards = <Widget>[
      for (final section in sections)
        if (section.value?.trim().isNotEmpty == true)
          DeviceSyncJsonCard(title: section.title, json: section.value!),
    ];

    return [
      for (var i = 0; i < cards.length; i++) ...[
        if (i > 0) AppGap.v12,
        cards[i],
      ],
    ];
  }

  static String _storage(DeviceStateCache state) {
    final pct = state.storageUsagePct;
    final used = _formatBytes(state.usedStorageBytes);
    final total = _formatBytes(state.totalStorageBytes);

    if (used == '—' && total == '—') {
      return pct == null ? '—' : '${pct.toStringAsFixed(0)}%';
    }

    final percent = pct == null ? '' : ' (${pct.toStringAsFixed(0)}%)';
    return '$used / $total$percent';
  }

  static String _formatBytes(int? bytes) {
    if (bytes == null) return '—';
    const units = ['B', 'KB', 'MB', 'GB', 'TB'];

    var value = bytes.toDouble();
    var unit = 0;
    while (value >= 1024 && unit < units.length - 1) {
      value /= 1024;
      unit++;
    }

    final digits = unit == 0 || value >= 100 ? 0 : 1;
    return '${value.toStringAsFixed(digits)} ${units[unit]}';
  }
}
