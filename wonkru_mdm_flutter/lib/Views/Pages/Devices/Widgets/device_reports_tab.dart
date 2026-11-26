import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../../Core/Constants/Enums/alert_enums.dart';
import '../../../../Core/L10n/L.dart';
import '../../../../Core/Theme/design.dart';
import '../../../../Data/Models/device_report_point.dart';
import '../../../../Logic/Controllers/device_detail_controller.dart';
import '../../../Widgets/Badge/status_badge.dart';
import '../../../Widgets/Card/section_card.dart';
import '../../../Widgets/Chart/trend_chart/trend_chart.dart';
import '../../../Widgets/EmptyState/empty_state.dart';
import '../../../Widgets/EmptyState/error_panel.dart';
import '../../../Widgets/Loading/app_loader.dart';

class DeviceReportsTab extends StatefulWidget {
  const DeviceReportsTab({super.key, required this.controller});

  final DeviceDetailController controller;

  @override
  State<DeviceReportsTab> createState() => _DeviceReportsTabState();
}

class _DeviceReportsTabState extends State<DeviceReportsTab> {
  DeviceDetailController get _controller => widget.controller;

  @override
  void initState() {
    super.initState();
    unawaited(_controller.ensureReportsLoaded());
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final loading = _controller.reportsLoading.value;
      final reports = _controller.reports;
      final error = _controller.reportsError.value;

      if (loading && reports.isEmpty) {
        return const Center(child: AppLoader());
      }
      if (error != null && reports.isEmpty) {
        return ErrorPanel(message: error, onRetry: _controller.loadReports);
      }
      if (reports.isEmpty) {
        return EmptyState(
          title: L.devices.noReports,
          subtitle: L.devices.noReportsSubtitle,
        );
      }

      final points = [
        for (final report in reports) DeviceReportPoint.fromReport(report),
      ];

      return ListView(
        padding: AppInsets.all20,
        children: [
          SectionCard(
            title: L.devices.batteryPercent,
            child: _chart(points, (point) => point.batteryLevel),
          ),
          AppGap.v16,
          SectionCard(
            title: L.devices.freeStoragePercent,
            child: _chart(points, (point) => point.freeStoragePercent),
          ),
          AppGap.v16,
          SectionCard(
            title: L.devices.lastReports,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.s16,
              AppSpacing.s8,
              AppSpacing.s16,
              AppSpacing.s16,
            ),
            child: _table(context, points),
          ),
        ],
      );
    });
  }

  Widget _chart(
    List<DeviceReportPoint> points,
    int? Function(DeviceReportPoint) selector,
  ) {
    final filled = [
      for (final point in points)
        if (selector(point) != null) point,
    ]..sort((a, b) => _compareMoments(a.moment, b.moment));

    if (filled.isEmpty) {
      return EmptyState(title: L.common.noData);
    }

    return TrendChart(
      chart: DashboardChart(
        labels: [for (final point in filled) _label(point.moment)],
        values: [for (final point in filled) selector(point)!],
      ),
    );
  }

  Widget _table(BuildContext context, List<DeviceReportPoint> points) {
    final colors = context.appColors;
    final headerStyle = AppText.columnHeader(context);
    final cellStyle = AppText.body(context).copyWith(fontSize: 12.5);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: AppInsets.v6,
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(L.common.time, style: headerStyle),
              ),
              Expanded(
                flex: 2,
                child: Text(L.common.battery, style: headerStyle),
              ),
              Expanded(
                flex: 2,
                child: Text(L.devices.freeStorage, style: headerStyle),
              ),
              Expanded(
                flex: 2,
                child: Text(L.common.status, style: headerStyle),
              ),
              Expanded(
                flex: 3,
                child: Text(L.common.type, style: headerStyle),
              ),
            ],
          ),
        ),
        Divider(height: 1, color: colors.border),
        for (final point in points.take(25))
          Padding(
            padding: AppInsets.v8,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(_label(point.moment), style: cellStyle),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    point.batteryLevel == null ? '—' : '${point.batteryLevel}%',
                    style: cellStyle,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    point.freeStoragePercent == null
                        ? '—'
                        : '${point.freeStoragePercent}%',
                    style: cellStyle,
                  ),
                ),
                Expanded(flex: 2, child: _onlineBadge(point.online)),
                Expanded(
                  flex: 3,
                  child: Text(point.type ?? '—', style: cellStyle),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _onlineBadge(bool? online) {
    if (online == null) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Text('—', style: TextStyle(color: context.appColors.graphite)),
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: StatusBadge(
        label: online ? L.common.online : L.common.offline,
        tone: online ? UiAlertTone.success : UiAlertTone.danger,
      ),
    );
  }

  static int _compareMoments(DateTime? a, DateTime? b) {
    if (a == null && b == null) return 0;
    if (a == null) return -1;
    if (b == null) return 1;
    return a.compareTo(b);
  }

  static String _label(DateTime? moment) {
    if (moment == null) return '—';

    String two(int value) => value.toString().padLeft(2, '0');

    return '${two(moment.day)}.${two(moment.month)} '
        '${two(moment.hour)}:${two(moment.minute)}';
  }
}
