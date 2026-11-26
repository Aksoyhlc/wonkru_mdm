import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../Core/Constants/Enums/alert_enums.dart';
import '../../../Core/L10n/L.dart';
import '../../../Core/Router/app_routes.dart';
import '../../../Core/Theme/design.dart';
import '../../../Data/Repositories/settings_repository.dart';
import '../../../Logic/Controllers/dashboard_controller.dart';
import '../../../Logic/Controllers/devices_controller.dart';
import '../../Widgets/Action/open_link.dart';
import '../../Widgets/Button/app_button.dart';
import '../../Widgets/Card/metric_group_card.dart';
import '../../Widgets/Card/metric_tile.dart';
import '../../Widgets/EmptyState/error_panel.dart';
import '../../Widgets/Motion/app_skeleton.dart';
import '../../Widgets/Motion/enter_animation.dart';
import '../../Widgets/Motion/fade_switcher.dart';
import '../Devices/device_command_dialog.dart';
import 'Widgets/dashboard_format.dart';
import 'Widgets/distribution_card.dart';
import 'Widgets/log_distribution_card.dart';
import 'Widgets/log_trend_card.dart';
import 'Widgets/quick_links.dart';
import 'Widgets/sync_trend_card.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final DashboardController _controller;

  static const _pairBreakpoint = 1100.0;

  static const _chartCardHeight = 340.0;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<DashboardController>();
    unawaited(_controller.ensureLoaded());
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => FadeSwitcher(child: _body(context)));
  }

  Widget _body(BuildContext context) {
    if (_controller.loading.value && _controller.deviceStats.value == null) {
      return _skeleton();
    }
    if (_controller.error.value != null) {
      return ErrorPanel(
        key: const ValueKey('error'),
        message: _controller.error.value!,
        onRetry: _controller.load,
      );
    }

    return LayoutBuilder(
      key: const ValueKey('content'),
      builder: (context, constraints) {
        final wide =
            constraints.maxWidth - AppSpacing.pagePadding * 2 >=
            _pairBreakpoint;

        return Obx(
          () => SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.pagePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _toolbar(context),
                AppGap.v24,
                const QuickLinks(),
                AppGap.v16,
                _pair(
                  wide,
                  _deviceGroup(),
                  _riskGroup(),
                  leftFlex: 3,
                  rightFlex: 4,
                ),
                AppGap.v16,
                _pair(
                  wide,
                  EnterAnimation(
                    index: 11,
                    child: SyncTrendCard(controller: _controller),
                  ),
                  EnterAnimation(
                    index: 12,
                    child: DistributionCard(controller: _controller),
                  ),
                  height: _chartCardHeight,
                ),
                AppGap.v24,
                _logGroup(),
                AppGap.v16,
                _pair(
                  wide,
                  EnterAnimation(
                    index: 13,
                    child: LogTrendCard(controller: _controller),
                  ),
                  EnterAnimation(
                    index: 14,
                    child: LogDistributionCard(controller: _controller),
                  ),
                  height: _chartCardHeight,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _skeleton() => LayoutBuilder(
    key: const ValueKey('loading'),
    builder: (context, constraints) {
      final wide =
          constraints.maxWidth - AppSpacing.pagePadding * 2 >= _pairBreakpoint;
      const metricHeight = 210.0;
      return SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: AppSkeleton(width: 240, height: AppSpacing.s24),
            ),
            AppGap.v24,
            const AppSkeleton(height: AppSpacing.controlHeight),
            AppGap.v16,
            _pair(
              wide,
              const AppSkeleton(height: metricHeight),
              const AppSkeleton(height: metricHeight),
              leftFlex: 3,
              rightFlex: 4,
            ),
            AppGap.v16,
            _pair(
              wide,
              const AppSkeleton(height: _chartCardHeight),
              const AppSkeleton(height: _chartCardHeight),
              height: _chartCardHeight,
            ),
            AppGap.v24,
            const AppSkeleton(height: metricHeight),
            AppGap.v16,
            _pair(
              wide,
              const AppSkeleton(height: _chartCardHeight),
              const AppSkeleton(height: _chartCardHeight),
              height: _chartCardHeight,
            ),
          ],
        ),
      );
    },
  );

  Widget _toolbar(BuildContext context) {
    final loadedAt = _controller.lastLoadedAt.value;
    final subtitle = loadedAt == null
        ? L.dashboard.subtitle
        : L.dashboard.subtitleUpdated.trParams({
            'time': DateFormat('HH:mm').format(loadedAt),
          });

    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.s16,
      runSpacing: AppSpacing.s16,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              L.dashboard.overview,
              style: AppText.sectionTitle(context).copyWith(fontSize: 19),
            ),
            AppGap.v2,
            Text(subtitle, style: AppText.bodyMuted(context)),
          ],
        ),
        Wrap(
          spacing: AppSpacing.s8,
          runSpacing: AppSpacing.s8,
          children: [
            AppButton(
              label: L.common.refresh,
              icon: LucideIcons.refreshCw,
              primary: false,
              compact: true,
              loading: _controller.loading.value,
              onPressed: _controller.load,
            ),
            AppButton(
              label: L.settings.downloadMdmApk,
              icon: LucideIcons.download,
              primary: false,
              compact: true,
              onAsync: () => openDownload(
                SettingsRepository.mdmApkUrl,
                missingMessage: L.settings.mdmApkUnavailable,
                copiedMessage: L.common.linkCopied,
                failure: L.common.downloadFailed,
              ),
            ),
            AppButton(
              label: L.dashboard.commandCenter,
              icon: LucideIcons.command,
              compact: true,
              onPressed: () => showDeviceCommandDialog(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _pair(
    bool wide,
    Widget left,
    Widget right, {
    int leftFlex = 3,
    int rightFlex = 2,
    double? height,
  }) {
    Widget sized(Widget child) =>
        height == null ? child : SizedBox(height: height, child: child);

    if (!wide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          sized(left),
          AppGap.v16,
          sized(right),
        ],
      );
    }

    return sized(
      Row(
        crossAxisAlignment: height == null
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.stretch,
        children: [
          Expanded(flex: leftFlex, child: left),
          AppGap.h16,
          Expanded(flex: rightFlex, child: right),
        ],
      ),
    );
  }

  Widget _deviceGroup() {
    final devices = _controller.deviceStats.value;
    final total = devices?.totalDevices ?? 0;

    return MetricGroupCard(
      title: L.dashboard.deviceStatus,
      motionStartIndex: 0,
      minTileWidth: 150,
      children: [
        MetricTile(
          label: L.dashboard.totalDevices,
          value: DashboardFormat.count(devices?.totalDevices),
          numericValue: devices?.totalDevices,
          format: DashboardFormat.count,
          icon: LucideIcons.smartphone,
          caption: L.dashboard.registeredDevices,
          onTap: () => _drillDown(null, null),
        ),
        MetricTile(
          label: L.common.online,
          value: DashboardFormat.count(devices?.onlineDevices),
          numericValue: devices?.onlineDevices,
          format: DashboardFormat.count,
          icon: LucideIcons.wifi,
          tone: UiAlertTone.success,
          caption: devices == null
              ? null
              : L.dashboard.onlineCaption.trParams({
                  'minutes': '${devices.onlineMinutes}',
                  'share': DashboardFormat.share(devices.onlineDevices, total),
                }),
          ratio: DashboardFormat.ratio(devices?.onlineDevices, total),
          onTap: () => _drillDown('isOnline', true),
        ),
        MetricTile(
          label: L.common.offline,
          value: DashboardFormat.count(devices?.offlineDevices),
          numericValue: devices?.offlineDevices,
          format: DashboardFormat.count,
          icon: LucideIcons.wifiOff,
          tone: UiAlertTone.danger,
          caption: devices == null
              ? null
              : L.dashboard.shareDevices.trParams({
                  'share': DashboardFormat.share(devices.offlineDevices, total),
                }),
          ratio: DashboardFormat.ratio(devices?.offlineDevices, total),
          onTap: () => _drillDown('isOnline', false),
        ),
      ],
    );
  }

  Widget _riskGroup() {
    final alerts = _controller.alertStats.value;
    final total = _controller.deviceStats.value?.totalDevices ?? 0;

    MetricTile risk(
      String label,
      int? count,
      IconData icon,
      UiAlertTone tone, {
      VoidCallback? onTap,
    }) {
      final clear = count == 0;
      return MetricTile(
        label: label,
        value: DashboardFormat.count(count),
        numericValue: count,
        format: DashboardFormat.count,
        icon: icon,
        tone: clear ? UiAlertTone.success : tone,
        caption: count == null
            ? null
            : (clear
                  ? L.dashboard.noIssues
                  : L.dashboard.shareDevices.trParams({
                      'share': DashboardFormat.share(count, total),
                    })),
        ratio: DashboardFormat.ratio(count, total),
        onTap: onTap,
      );
    }

    return MetricGroupCard(
      title: L.dashboard.riskCompliance,
      motionStartIndex: 3,
      minTileWidth: 150,
      children: [
        risk(
          L.dashboard.criticalBattery,
          alerts?.criticalBatteryDevices,
          LucideIcons.batteryWarning,
          UiAlertTone.warning,
          onTap: () => _drillDown('criticalBattery', true),
        ),
        risk(
          L.dashboard.criticalStorage,
          alerts?.criticalStorageDevices,
          LucideIcons.hardDrive,
          UiAlertTone.warning,
          onTap: () => _drillDown('criticalStorage', true),
        ),
        risk(
          L.dashboard.rooted,
          alerts?.rootedDevices,
          LucideIcons.shieldAlert,
          UiAlertTone.danger,
          onTap: () => _drillDown('isRooted', true),
        ),
        MetricTile(
          label: L.dashboard.launcherMode,
          value: DashboardFormat.count(alerts?.launcherModeDevices),
          numericValue: alerts?.launcherModeDevices,
          format: DashboardFormat.count,
          icon: LucideIcons.layoutPanelTop,
          caption: alerts == null
              ? null
              : L.dashboard.shareDevices.trParams({
                  'share': DashboardFormat.share(
                    alerts.launcherModeDevices,
                    total,
                  ),
                }),
          ratio: DashboardFormat.ratio(alerts?.launcherModeDevices, total),
        ),
      ],
    );
  }

  Widget _logGroup() {
    final logs = _controller.logStats.value;
    final errorRate = logs?.errorRate ?? 0;
    final totalDevices = _controller.deviceStats.value?.totalDevices ?? 0;

    return MetricGroupCard(
      title: L.dashboard.logs24h,
      motionStartIndex: 7,
      children: [
        MetricTile(
          label: L.dashboard.totalLogs,
          value: DashboardFormat.count(logs?.totalLogs),
          numericValue: logs?.totalLogs,
          format: DashboardFormat.count,
          icon: LucideIcons.scrollText,
          caption: L.dashboard.allLevels,
        ),
        MetricTile(
          label: L.common.error,
          value: DashboardFormat.count(logs?.errorCount),
          numericValue: logs?.errorCount,
          format: DashboardFormat.count,
          icon: LucideIcons.triangleAlert,
          tone: (logs?.errorCount ?? 0) == 0
              ? UiAlertTone.success
              : UiAlertTone.danger,
          caption: 'ERROR + FATAL',
          ratio: DashboardFormat.ratio(logs?.errorCount, logs?.totalLogs ?? 0),
        ),
        MetricTile(
          label: L.dashboard.errorRate,
          value: logs == null ? '—' : '%${errorRate.toStringAsFixed(1)}',
          icon: LucideIcons.percent,
          tone: errorRate > 10
              ? UiAlertTone.danger
              : (errorRate > 0 ? UiAlertTone.warning : UiAlertTone.success),
          caption: errorRate > 10
              ? L.dashboard.errorRateHigh
              : L.dashboard.errorRateOk,
          ratio: logs == null ? null : (errorRate / 100).clamp(0.0, 1.0),
        ),
        MetricTile(
          label: L.dashboard.activeDevices,
          value: DashboardFormat.count(logs?.activeDevices),
          numericValue: logs?.activeDevices,
          format: DashboardFormat.count,
          icon: LucideIcons.smartphone,
          tone: UiAlertTone.success,
          caption: logs == null
              ? null
              : L.dashboard.logSenders.trParams({
                  'share': DashboardFormat.share(
                    logs.activeDevices,
                    totalDevices,
                  ),
                }),
          ratio: DashboardFormat.ratio(logs?.activeDevices, totalDevices),
        ),
      ],
    );
  }

  /// Search and existing filters are reset so the list matches the tapped
  /// card's count; a `null` key clears all filters.
  void _drillDown(String? filterKey, Object? filterValue) {
    final devices = Get.find<DevicesController>();
    devices.search.value = '';
    devices.filters.clear();
    if (filterKey == null) {
      unawaited(devices.reload());
    } else {
      unawaited(devices.setFilter(filterKey, filterValue));
    }
    context.go(AppRoutes.devices);
  }
}
