import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Core/L10n/L.dart';
import '../../../../Logic/Controllers/policies_controller.dart';
import '../../../Widgets/Table/filter_dropdown.dart';
import '../../../Widgets/Table/table_filter_bar.dart';

class PolicyFiltersBar extends StatelessWidget {
  const PolicyFiltersBar({super.key, required this.controller});

  final PoliciesController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final filters = controller.filters;

      return TableFilterBar(
        activeCount: filters.length,
        onClear: controller.clearFilters,
        fields: [
          FilterDropdown.ternary(
            label: L.common.status,
            current: filters['isActive'],
            trueLabel: L.common.active,
            falseLabel: L.common.inactive,
            onSelected: (value) => controller.setFilter('isActive', value),
          ),
          FilterDropdown.ternary(
            label: L.policies.isDefault,
            current: filters['defaultPolicy'],
            trueLabel: L.policies.isDefault,
            falseLabel: L.policies.notDefault,
            onSelected: (value) => controller.setFilter('defaultPolicy', value),
          ),
        ],
      );
    });
  }
}
