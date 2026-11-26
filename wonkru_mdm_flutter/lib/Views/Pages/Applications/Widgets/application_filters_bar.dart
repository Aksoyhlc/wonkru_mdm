import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Core/L10n/L.dart';
import '../../../../Logic/Controllers/applications_controller.dart';
import '../../../Widgets/Table/filter_dropdown.dart';
import '../../../Widgets/Table/table_filter_bar.dart';
import '../../../Widgets/Table/table_text_filter.dart';

class ApplicationFiltersBar extends StatelessWidget {
  const ApplicationFiltersBar({super.key, required this.controller});

  final ApplicationsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final filters = controller.filters;

      return TableFilterBar(
        activeCount: filters.length,
        onClear: controller.clearFilters,
        fields: [
          FilterDropdown(
            label: L.applications.source,
            value: filters['sourceType'] as String? ?? FilterDropdown.all,
            items: {
              FilterDropdown.all: L.applications.allSources,
              'apk': 'APK',
              'play_store': 'Play Store',
              'app_store': 'App Store',
              'other': L.applications.sourceOther,
            },
            onChanged: (value) => controller.setFilter('sourceType', value == FilterDropdown.all ? null : value),
          ),
          TableTextFilter(
            name: 'application_filter_category',
            label: L.applications.category,
            hint: L.applications.categoryHint,
            controller: controller,
            filterKey: 'category',
          ),
          FilterDropdown.ternary(
            label: L.applications.systemAppFilter,
            current: filters['isSystemApp'],
            onSelected: (value) => controller.setFilter('isSystemApp', value),
          ),
        ],
      );
    });
  }
}
