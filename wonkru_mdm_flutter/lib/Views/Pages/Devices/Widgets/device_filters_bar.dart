import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Core/L10n/L.dart';
import '../../../../Logic/Controllers/devices_controller.dart';
import '../../../Widgets/Table/filter_dropdown.dart';
import '../../../Widgets/Table/table_filter_bar.dart';
import '../../../Widgets/Table/table_text_filter.dart';

class DeviceFiltersBar extends StatelessWidget {
  const DeviceFiltersBar({super.key, required this.controller});

  final DevicesController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final filters = controller.filters;

      return TableFilterBar(
        activeCount: filters.length,
        onClear: controller.clearFilters,
        fields: [
          FilterDropdown(
            label: L.common.policy,
            value: filters['policyId']?.toString() ?? FilterDropdown.all,
            items: {
              FilterDropdown.all: L.devices.allPolicies,
              for (final policy in controller.policies)
                '${policy.id}': policy.name,
            },
            onChanged: (value) => controller.setFilter(
              'policyId',
              value == FilterDropdown.all ? null : int.tryParse(value),
            ),
          ),
          FilterDropdown(
            label: L.common.group,
            value: filters['deviceGroupId']?.toString() ?? FilterDropdown.all,
            items: {
              FilterDropdown.all: L.common.allGroups,
              for (final row in controller.groups)
                '${row.group.id}': row.group.name,
            },
            onChanged: (value) => controller.setFilter(
              'deviceGroupId',
              value == FilterDropdown.all ? null : int.tryParse(value),
            ),
          ),
          FilterDropdown.ternary(
            label: L.common.status,
            current: filters['isOnline'],
            allLabel: L.devices.allStatuses,
            trueLabel: L.common.online,
            falseLabel: L.common.offline,
            onSelected: (value) => controller.setFilter('isOnline', value),
          ),
          FilterDropdown.ternary(
            label: 'Root',
            current: filters['isRooted'],
            allLabel: L.devices.rootAll,
            trueLabel: L.devices.rooted,
            falseLabel: L.devices.notRoot,
            onSelected: (value) => controller.setFilter('isRooted', value),
          ),
          TableTextFilter(
            name: 'device_filter_manufacturer',
            label: L.devices.manufacturer,
            hint: L.devices.manufacturerHint,
            controller: controller,
            filterKey: 'manufacturer',
          ),
          TableTextFilter(
            name: 'device_filter_android_version',
            label: L.devices.androidVersion,
            hint: L.devices.androidVersionHint,
            controller: controller,
            filterKey: 'androidVersion',
          ),
          FilterDropdown.ternary(
            label: L.devices.criticalBattery,
            current: filters['criticalBattery'],
            onSelected: (value) =>
                controller.setFilter('criticalBattery', value),
          ),
          FilterDropdown.ternary(
            label: L.devices.criticalStorage,
            current: filters['criticalStorage'],
            onSelected: (value) =>
                controller.setFilter('criticalStorage', value),
          ),
          FilterDropdown.ternary(
            label: L.devices.notSeen24h,
            current: filters['notSeen24h'],
            onSelected: (value) => controller.setFilter('notSeen24h', value),
          ),
          FilterDropdown.ternary(
            label: L.devices.policyless,
            current: filters['noPolicy'],
            onSelected: (value) => controller.setFilter('noPolicy', value),
          ),
        ],
      );
    });
  }
}
