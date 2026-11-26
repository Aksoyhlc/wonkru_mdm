import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../../Core/L10n/L.dart';
import '../../../../Logic/Controllers/admin_activity_controller.dart';
import '../../../Widgets/Table/filter_dropdown.dart';
import '../../../Widgets/Table/table_date_filter.dart';
import '../../../Widgets/Table/table_filter_bar.dart';

class AdminActivityFiltersBar extends StatelessWidget {
  const AdminActivityFiltersBar({super.key, required this.controller});

  final AdminActivityController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final filters = controller.filters;

      return TableFilterBar(
        activeCount: filters.length,
        onClear: controller.clearFilters,
        fields: [
          FilterDropdown(
            label: L.common.action,
            value: filters['action']?.toString() ?? FilterDropdown.all,
            items: {
              FilterDropdown.all: L.activity.allActions,
              for (final action in controller.actions) action: action,
            },
            onChanged: (value) => controller.setFilter(
              'action',
              value == FilterDropdown.all ? null : value,
            ),
          ),
          FilterDropdown(
            label: L.activity.filterActor,
            value: filters['actorUserId']?.toString() ?? FilterDropdown.all,
            items: {
              FilterDropdown.all: L.activity.allActors,
              for (final actor in controller.actors)
                actor.authUserId.toString(): AdminActivityController.actorLabel(
                  actor,
                ),
            },
            onChanged: (value) => controller.setFilter(
              'actorUserId',
              value == FilterDropdown.all ? null : UuidValue.fromString(value),
            ),
          ),
          TableDateFilter(
            name: 'activity_filter_from',
            label: L.activity.filterFrom,
            controller: controller,
            filterKey: 'from',
          ),
          TableDateFilter(
            name: 'activity_filter_to',
            label: L.activity.filterTo,
            controller: controller,
            filterKey: 'to',
            endOfDay: true,
          ),
        ],
      );
    });
  }
}
