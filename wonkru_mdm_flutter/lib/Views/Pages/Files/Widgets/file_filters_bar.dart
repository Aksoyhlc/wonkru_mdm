import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Core/L10n/L.dart';
import '../../../../Logic/Controllers/files_controller.dart';
import '../../../Widgets/Table/filter_dropdown.dart';
import '../../../Widgets/Table/table_filter_bar.dart';
import '../../../Widgets/Table/table_text_filter.dart';

class FileFiltersBar extends StatelessWidget {
  const FileFiltersBar({super.key, required this.controller});

  final FilesController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final filters = controller.filters;

      return TableFilterBar(
        activeCount: filters.length,
        onClear: controller.clearFilters,
        fields: [
          TableTextFilter(
            name: 'file_filter_extension',
            label: L.files.extension,
            hint: 'png, jpg',
            controller: controller,
            filterKey: 'extension',
            keepEmpty: true,
          ),
          TableTextFilter(
            name: 'file_filter_mime',
            label: L.files.mimeType,
            hint: 'image/png',
            controller: controller,
            filterKey: 'mimeType',
            keepEmpty: true,
          ),
          FilterDropdown(
            label: L.files.fileGroup,
            value: filters['fileGroupId']?.toString() ?? FilterDropdown.all,
            items: {
              FilterDropdown.all: L.common.allGroups,
              for (final row in controller.fileGroups)
                '${row.group.id}': row.group.name,
            },
            onChanged: (value) => controller.setFilter(
              'fileGroupId',
              value == FilterDropdown.all ? null : int.tryParse(value),
            ),
          ),
        ],
      );
    });
  }
}
