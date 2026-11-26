import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../Core/Constants/Enums/alert_enums.dart';
import '../../../../Core/L10n/L.dart';
import '../../../../Core/Theme/design.dart';
import '../../../../Logic/Controllers/device_logs_controller.dart';
import '../../../Widgets/Card/section_card.dart';
import '../../../Widgets/Card/stat_card.dart';
import '../../../Widgets/Chart/distribution_chart.dart';
import '../../../Widgets/Chart/trend_chart/trend_chart.dart';

class DeviceLogSummary extends StatelessWidget {
  const DeviceLogSummary({super.key, required this.controller});

  final DeviceLogsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final stats = controller.stats.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _stat(
                L.common.total,
                stats == null ? null : '${stats.totalLogs}',
                LucideIcons.scrollText,
                UiAlertTone.info,
                caption:
                    '${controller.period.value} ${_periodUnit(controller.period.value)}',
              ),
              _stat(
                L.common.error,
                stats == null ? null : '${stats.errorCount}',
                LucideIcons.triangleAlert,
                UiAlertTone.danger,
                caption: 'ERROR + FATAL',
              ),
              _stat(
                L.deviceLogs.errorRate,
                stats == null ? null : '${stats.errorRate.toStringAsFixed(1)}%',
                LucideIcons.percent,
                UiAlertTone.warning,
              ),
              _stat(
                L.deviceLogs.activeDevices,
                stats == null ? null : '${stats.activeDevices}',
                LucideIcons.smartphone,
                UiAlertTone.success,
              ),
            ],
          ),
          AppGap.v16,
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              SizedBox(
                width: 460,
                child: SectionCard(
                  title: L.deviceLogs.levelDistribution,
                  child: DistributionChart(chart: controller.levelChart),
                ),
              ),
              SizedBox(
                width: 460,
                child: SectionCard(
                  title: 'Trend',
                  child: TrendChart(chart: controller.trendChart),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _stat(
    String label,
    String? value,
    IconData icon,
    UiAlertTone tone, {
    String? caption,
  }) {
    return SizedBox(
      width: 220,
      child: StatCard(
        label: label,
        value: value ?? '—',
        icon: icon,
        tone: tone,
        caption: caption,
      ),
    );
  }

  static String _periodUnit(String period) =>
      period == '24' ? L.deviceLogs.unitHours : L.deviceLogs.unitDays;
}
