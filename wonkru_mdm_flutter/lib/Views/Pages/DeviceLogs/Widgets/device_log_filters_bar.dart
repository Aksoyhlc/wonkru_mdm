import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Core/L10n/L.dart';
import '../../../../Logic/Controllers/device_logs_controller.dart';
import '../../../Widgets/Input/device_picker_field.dart';
import '../../../Widgets/Table/filter_dropdown.dart';
import '../../../Widgets/Table/table_date_filter.dart';
import '../../../Widgets/Table/table_filter_bar.dart';
import '../../../Widgets/Table/table_text_filter.dart';

/// Unlike the other filters, the chart-range filter feeds only the summary and
/// charts, not the table.
class DeviceLogFiltersBar extends StatelessWidget {
  const DeviceLogFiltersBar({super.key, required this.controller});

  final DeviceLogsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final filters = controller.filters;

      return TableFilterBar(
        activeCount: filters.length,
        onClear: controller.clearFilters,
        fields: [
          FilterDropdown(
            label: L.common.level,
            value: filters['level']?.toString() ?? FilterDropdown.all,
            items: {
              FilterDropdown.all: L.deviceLogs.allLevels,
              for (
                var level = 0;
                level < DeviceLogsController.levelLabels.length;
                level++
              )
                '$level': DeviceLogsController.levelLabels[level],
            },
            onChanged: (value) => controller.setFilter(
              'level',
              value == FilterDropdown.all ? null : int.tryParse(value),
            ),
          ),
          TableTextFilter(
            name: 'device_log_filter_tag',
            label: L.common.tag,
            hint: L.deviceLogs.tagHint,
            controller: controller,
            filterKey: 'tag',
          ),
          DevicePickerField(
            name: 'device_log_filter_device',
            onChanged: (device) => controller.setFilter('deviceId', device?.id),
          ),
          TableTextFilter(
            name: 'device_log_filter_session',
            label: L.deviceLogs.sessionId,
            hint: L.deviceLogs.sessionHint,
            controller: controller,
            filterKey: 'sessionId',
          ),
          FilterDropdown(
            label: L.deviceLogs.period,
            value: filters['period']?.toString() ?? FilterDropdown.all,
            items: {
              FilterDropdown.all: L.common.all,
              ...DeviceLogsController.periodOptions,
            },
            onChanged: (value) => controller.setFilter(
              'period',
              value == FilterDropdown.all ? null : value,
            ),
          ),
          FilterDropdown.ternary(
            label: 'Stacktrace',
            current: filters['hasStacktrace'],
            onSelected: (value) => controller.setFilter('hasStacktrace', value),
          ),
          TableDateFilter(
            name: 'device_log_filter_from',
            label: L.common.start,
            controller: controller,
            filterKey: 'loggedFrom',
          ),
          TableDateFilter(
            name: 'device_log_filter_until',
            label: L.common.end,
            controller: controller,
            filterKey: 'loggedUntil',
            endOfDay: true,
          ),
          FilterDropdown(
            label: L.deviceLogs.chartRange,
            value: controller.period.value,
            items: DeviceLogsController.chartPeriodOptions,
            onChanged: controller.setPeriod,
          ),
        ],
      );
    });
  }
}
