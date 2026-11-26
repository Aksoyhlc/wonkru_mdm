import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../../Core/Constants/Enums/button_enums.dart';
import '../../../../Core/L10n/L.dart';
import '../../../../Logic/Controllers/devices_controller.dart';
import '../../../Widgets/Action/run_action.dart';
import '../../../Widgets/Button/app_button.dart';
import '../../../Widgets/Dialog/assign_groups_dialog.dart';
import '../../../Widgets/Table/selection_actions.dart';
import 'assign_policy_dialog.dart';

class DeviceBulkActions extends StatelessWidget {
  const DeviceBulkActions({super.key, required this.controller});

  final DevicesController controller;

  @override
  Widget build(BuildContext context) {
    return SelectionActions(
      selected: controller.selected,
      countLabel: (count) =>
          L.common.selectedCount.trParams({'count': '$count'}),
      actions: (_) => [
        AppButton(
          label: L.devices.assignPolicy,
          compact: true,
          variant: AppButtonVariant.secondary,
          onPressed: () => _assignPolicy(context),
        ),
        AppButton(
          label: L.devices.assignGroups,
          compact: true,
          variant: AppButtonVariant.secondary,
          onPressed: () => _assignGroups(context),
        ),
        AppButton(
          label: L.common.actionUpdatePolicy,
          compact: true,
          variant: AppButtonVariant.secondary,
          onPressed: () => _sendPolicyUpdate(context),
        ),
        AppButton(
          label: L.common.delete,
          compact: true,
          variant: AppButtonVariant.danger,
          onPressed: () => _delete(context),
        ),
      ],
    );
  }

  Future<void> _assignPolicy(BuildContext context) async {
    final policyId = await showAssignPolicyDialog(context, controller.policies);
    if (policyId == null) return;

    await runAction(
      () => controller.assignPolicyToSelected(policyId),
      success: L.devices.policiesUpdated,
    );
  }

  Future<void> _assignGroups(BuildContext context) async {
    final groupIds = await showAssignGroupsDialog<DeviceGroupRow>(
      context,
      title: L.devices.assignGroups,
      applyLabel: L.common.apply,
      emptyText: L.devices.noGroupsDefined,
      groups: controller.groups,
      idOf: (row) => row.group.id,
      nameOf: (row) => row.group.name,
      subtitleOf: (row) =>
          L.devices.deviceCount.trParams({'count': '${row.deviceCount}'}),
    );
    if (groupIds == null) return;

    await runAction(
      () => controller.assignGroupsToSelected(groupIds),
      success: L.devices.groupsUpdated,
    );
  }

  Future<void> _sendPolicyUpdate(BuildContext context) => confirmAndRun(
    context,
    title: L.common.actionUpdatePolicy,
    message: L.devices.policyUpdateConfirmBulk.trParams({
      'count': '${controller.selected.length}',
    }),
    action: controller.sendPolicyUpdateToSelected,
    success: L.devices.commandQueued,
  );

  Future<void> _delete(BuildContext context) => confirmAndRun(
    context,
    title: L.devices.bulkDeleteTitle,
    message: L.devices.bulkDeleteConfirm.trParams({
      'count': '${controller.selected.length}',
    }),
    action: controller.deleteSelected,
    success: L.devices.bulkDeleted,
  );
}
