import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Core/L10n/L.dart';
import '../../../../Logic/Controllers/dashboard_controller.dart';
import '../../../Widgets/Card/section_card.dart';
import '../../../Widgets/Chart/trend_chart/trend_chart.dart';
import '../../../Widgets/Input/app_dropdown.dart';
import '../../../Widgets/Motion/app_skeleton.dart';
import '../../../Widgets/Motion/fade_switcher.dart';
import 'dashboard_format.dart';

class LogTrendCard extends StatelessWidget {
  const LogTrendCard({super.key, required this.controller});

  final DashboardController controller;

  static Map<String, String> get logPeriods => {
    '24': L.common.chartPeriodLast24h,
    '7': L.common.periodLast7Days,
    '30': L.common.periodLast30Days,
  };

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final logTrend = controller.logTrend.value;
      final hourly = controller.logPeriod.value == '24';

      return SectionCard(
        title: L.dashboard.logTrend,
        expand: true,
        trailing: SizedBox(
          width: 140,
          child: AppDropdown<String>(
            value: controller.logPeriod.value,
            dense: true,
            items: logPeriods,
            onChanged: (value) {
              if (value != null) controller.setLogPeriod(value);
            },
          ),
        ),
        child: FadeSwitcher(
          child: logTrend == null
              ? const AppSkeleton(
                  key: ValueKey('loading'),
                  height: double.infinity,
                )
              : TrendChart(
                  key: const ValueKey('content'),
                  chart: logTrend,
                  secondary: controller.logTrendErrors.toList(),
                  height: null,
                  primaryLabel: L.common.total,
                  secondaryLabel: L.common.error,
                  labelFormatter: hourly
                      ? DashboardFormat.hourLabel
                      : DashboardFormat.dayLabel,
                ),
        ),
      );
    });
  }
}
