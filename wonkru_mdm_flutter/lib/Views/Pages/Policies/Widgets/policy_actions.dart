import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../../Core/Constants/Enums/alert_enums.dart';
import '../../../../Core/L10n/L.dart';
import '../../../../Core/Router/app_routes.dart';
import '../../../../Core/Theme/design.dart';
import '../../../../Logic/Controllers/policies_controller.dart';
import '../../../Widgets/Action/run_action.dart';
import '../../../Widgets/Alert/app_toast.dart';
import '../../../Widgets/Button/app_button.dart';
import '../../../Widgets/Dialog/app_dialog_shell.dart';
import '../../../Widgets/Table/Cells/cell_action.dart';
import 'policy_clone_dialog.dart';

class PolicyRowActions {
  const PolicyRowActions(this.controller);

  final PoliciesController controller;

  List<CellAction> of(BuildContext context, Policy policy) => [
    CellAction.edit(() => context.go(AppRoutes.policy(policy.id!))),
    CellAction(
      label: L.common.copy,
      icon: LucideIcons.copy,
      onTap: () => _duplicate(context, policy),
    ),
    CellAction(
      label: L.policies.preview,
      icon: LucideIcons.eye,
      onTap: () => _preview(context, policy),
    ),
    CellAction(
      label: L.policies.sendToDevices,
      icon: LucideIcons.send,
      onTap: () => _sendToDevices(context, policy),
    ),
    CellAction(
      label: L.policies.makeDefault,
      icon: LucideIcons.star,
      enabled: !policy.defaultPolicy,
      onTap: () => _setDefault(policy),
    ),
    CellAction.delete(() => _delete(context, policy)),
  ];

  Future<void> _duplicate(BuildContext context, Policy policy) async {
    final id = policy.id;
    if (id == null) return;

    final newName = await showPolicyCloneDialog(
      context,
      defaultName: policy.name,
    );
    if (newName == null) return;

    await runAction(() async {
      final copy = await controller.duplicatePolicy(id, newName);
      AppToast.show(
        L.policies.copiedToast.trParams({'name': copy.name}),
        tone: UiAlertTone.success,
      );
      if (!context.mounted || copy.id == null) return;
      context.go(AppRoutes.policy(copy.id!));
    }, failure: L.policies.copyFailed);
  }

  Future<void> _preview(BuildContext context, Policy policy) async {
    final id = policy.id;
    if (id == null) return;

    await runAction(() async {
      final json = await controller.previewPolicy(id);
      if (!context.mounted) return;
      await showDialog<void>(
        context: context,
        builder: (_) => _PreviewDialog(title: policy.name, json: json),
      );
    }, failure: L.policies.previewFailed);
  }

  Future<void> _sendToDevices(BuildContext context, Policy policy) async {
    final id = policy.id;
    if (id == null) return;

    await confirmAndRun(
      context,
      title: L.policies.sendToDevices,
      message: L.policies.sendConfirm.trParams({'name': policy.name}),
      action: () async {
        final count = await controller.sendToDevices(id);
        AppToast.show(
          L.policies.sendQueued.trParams({'count': '$count'}),
          tone: UiAlertTone.success,
        );
      },
      failure: L.policies.sendFailed,
    );
  }

  Future<void> _setDefault(Policy policy) async {
    final id = policy.id;
    if (id == null) return;
    if (policy.defaultPolicy) {
      AppToast.show(L.policies.alreadyDefault, tone: UiAlertTone.info);
      return;
    }

    await runAction(
      () => controller.setDefault(id),
      success: L.policies.defaultUpdated,
      failure: L.policies.setDefaultFailed,
    );
  }

  Future<void> _delete(BuildContext context, Policy policy) async {
    final id = policy.id;
    if (id == null) return;

    await confirmAndRun(
      context,
      title: L.policies.deleteTitle,
      message: L.common.deleteConfirm.trParams({'name': policy.name}),
      action: () => controller.deletePolicy(id),
      success: L.policies.deleted,
      failure: L.common.deleteFailed,
    );
  }
}

class _PreviewDialog extends StatelessWidget {
  const _PreviewDialog({required this.title, required this.json});

  final String title;
  final String json;

  @override
  Widget build(BuildContext context) {
    return AppDialogShell(
      title: L.policies.previewTitle.trParams({'title': title}),
      maxWidth: 720,
      actions: [
        AppButton.cancel(context, label: L.common.close),
      ],
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 460),
        child: SingleChildScrollView(
          child: SelectableText(
            json,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
              height: 1.4,
              color: context.appColors.carbon,
            ),
          ),
        ),
      ),
    );
  }
}
