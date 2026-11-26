import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Core/L10n/L.dart';
import '../../../../Logic/Controllers/applications_controller.dart';
import '../../../Widgets/Table/bulk_delete_button.dart';
import '../../../Widgets/Table/selection_actions.dart';

class ApplicationBulkActions extends StatelessWidget {
  const ApplicationBulkActions({super.key, required this.controller});

  final ApplicationsController controller;

  @override
  Widget build(BuildContext context) {
    return SelectionActions(
      selected: controller.selected,
      countLabel: (count) =>
          L.common.selectedCount.trParams({'count': '$count'}),
      actions: (count) => [
        BulkDeleteButton(
          label: L.common.delete,
          title: L.applications.bulkDeleteTitle,
          message: L.applications.bulkDeleteConfirm.trParams({
            'count': '$count',
          }),
          onDelete: () async {
            final deleted = await controller.deleteApplications(
              controller.selectedIds,
            );
            controller.clearSelection();
            return deleted;
          },
          successMessage: (deleted) =>
              L.applications.bulkDeleted.trParams({'count': '$deleted'}),
          failure: L.common.deleteFailed,
        ),
      ],
    );
  }
}
