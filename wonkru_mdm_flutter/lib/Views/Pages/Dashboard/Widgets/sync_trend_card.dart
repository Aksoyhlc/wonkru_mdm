import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Core/L10n/L.dart';
import '../../../../Logic/Controllers/dashboard_controller.dart';
import '../../../Widgets/Card/section_card.dart';
import '../../../Widgets/Chart/trend_chart/trend_chart.dart';
import '../../../Widgets/Motion/app_skeleton.dart';
import '../../../Widgets/Motion/fade_switcher.dart';
import 'dashboard_format.dart';
import 'header_summary.dart';

class SyncTrendCard extends StatelessWidget {
  const SyncTrendCard({super.key, required this.controller});

  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final trend = controller.trend.value;
      final total = trend?.values.fold<int>(0, (sum, value) => sum + value);

      return SectionCard(
        title: L.dashboard.syncTrend30d,
        expand: true,
        trailing: HeaderSummary(
          label: L.common.total,
          value: total == null ? '—' : DashboardFormat.number(total),
        ),
        child: FadeSwitcher(
          child: trend == null
              ? const AppSkeleton(
                  key: ValueKey('loading'),
                  height: double.infinity,
                )
              : TrendChart(
                  key: const ValueKey('content'),
                  chart: trend,
                  height: null,
                  primaryLabel: L.dashboard.sync,
                  labelFormatter: DashboardFormat.dayLabel,
                ),
        ),
      );
    });
  }
}
