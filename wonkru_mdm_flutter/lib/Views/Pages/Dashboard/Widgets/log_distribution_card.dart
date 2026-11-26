import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Core/L10n/L.dart';
import '../../../../Logic/Controllers/dashboard_controller.dart';
import '../../../Widgets/Card/section_card.dart';
import '../../../Widgets/Chart/distribution_chart.dart';
import '../../../Widgets/Motion/app_skeleton.dart';
import '../../../Widgets/Motion/fade_switcher.dart';
import 'dashboard_format.dart';
import 'header_summary.dart';
import 'log_trend_card.dart';

class LogDistributionCard extends StatelessWidget {
  const LogDistributionCard({super.key, required this.controller});

  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final logDistribution = controller.logDistribution.value;

      return SectionCard(
        title: L.dashboard.logLevelDistribution,
        expand: true,
        trailing: HeaderSummary(
          label: LogTrendCard.logPeriods[controller.logPeriod.value] ?? '',
          value: logDistribution == null
              ? '—'
              : DashboardFormat.number(
                  logDistribution.values.fold<int>(0, (sum, v) => sum + v),
                ),
        ),
        child: FadeSwitcher(
          child: logDistribution == null
              ? const AppSkeleton(
                  key: ValueKey('loading'),
                  height: double.infinity,
                )
              : SingleChildScrollView(
                  key: const ValueKey('content'),
                  child: DistributionChart(chart: logDistribution),
                ),
        ),
      );
    });
  }
}
