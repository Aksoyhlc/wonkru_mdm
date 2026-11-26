import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Core/L10n/L.dart';
import '../../../../Logic/Controllers/dashboard_controller.dart';
import '../../../Widgets/Card/section_card.dart';
import '../../../Widgets/Chart/distribution_chart.dart';
import '../../../Widgets/Input/app_dropdown.dart';
import '../../../Widgets/Motion/app_skeleton.dart';
import '../../../Widgets/Motion/fade_switcher.dart';

class DistributionCard extends StatelessWidget {
  const DistributionCard({super.key, required this.controller});

  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final distribution = controller.distribution.value;

      return SectionCard(
        title: L.dashboard.deviceDistribution,
        expand: true,
        trailing: SizedBox(
          width: 140,
          child: AppDropdown<String>(
            value: controller.distributionFilter.value,
            dense: true,
            items: {
              'manufacturer': L.dashboard.filterManufacturer,
              'model': L.dashboard.filterModel,
              'android_version': L.dashboard.filterAndroidVersion,
            },
            onChanged: (value) {
              if (value != null) controller.setDistributionFilter(value);
            },
          ),
        ),
        child: FadeSwitcher(
          child: distribution == null
              ? const AppSkeleton(
                  key: ValueKey('loading'),
                  height: double.infinity,
                )
              : SingleChildScrollView(
                  key: const ValueKey('content'),
                  child: DistributionChart(chart: distribution),
                ),
        ),
      );
    });
  }
}
