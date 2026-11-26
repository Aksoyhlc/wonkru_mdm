import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Core/L10n/L.dart';
import '../../../../Logic/Controllers/device_applications_controller.dart';
import '../../../Widgets/Table/filter_dropdown.dart';
import '../../../Widgets/Table/table_filter_bar.dart';

class DeviceApplicationsFiltersBar extends StatelessWidget {
  const DeviceApplicationsFiltersBar({super.key, required this.controller});

  final DeviceApplicationsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final filters = controller.filters;

      return TableFilterBar(
        activeCount: filters.length,
        onClear: controller.clearFilters,
        fields: [
          FilterDropdown.ternary(
            label: L.devices.appTypeFilter,
            current: filters['isSystemApp'],
            allLabel: L.common.all,
            trueLabel: L.devices.system,
            falseLabel: L.devices.appUser,
            onSelected: (value) => controller.setFilter('isSystemApp', value),
          ),
        ],
      );
    });
  }
}
