import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../../../Core/L10n/L.dart';
import '../../../../../Core/Theme/design.dart';
import '../../../../../Logic/Controllers/policy_editor_controller.dart';
import '../../../../Widgets/Action/run_action.dart';
import '../../../../Widgets/Button/app_button.dart';
import '../../../../Widgets/Button/app_icon_button.dart';
import '../../../../Widgets/Card/section_card.dart';
import '../../../../Widgets/Dialog/confirm_dialog.dart';
import '../../../../Widgets/EmptyState/empty_hint.dart';
import '../../../../Widgets/Section/section_column.dart';
import '../../../../Widgets/Section/section_flags.dart';
import '../../../../Widgets/Section/section_table.dart';
import '../policy_pivot_picker.dart';
import 'Widgets/policy_application_dialog.dart';

class PolicyApplicationsSection extends StatelessWidget {
  const PolicyApplicationsSection({super.key, required this.controller});

  final PolicyEditorController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Obx must read an observable; toList() reads the RxList even when the
      // isNew branch short-circuits.
      final entries = controller.applications.toList();

      return SectionCard(
        title: L.policies.applications,
        trailing: controller.isNew
            ? null
            : AppButton(
                label: L.common.add,
                compact: true,
                icon: LucideIcons.plus,
                onPressed: () => _add(context),
              ),
        child: controller.isNew
            ? EmptyHint(L.policies.pivotSaveFirst)
            : entries.isEmpty
            ? EmptyHint(L.policies.noApplications)
            : _table(context, entries),
      );
    });
  }

  Widget _table(BuildContext context, List<PolicyApplication> entries) {
    return SectionTable<PolicyApplication>(
      minWidth: 720,
      rows: entries,
      columns: [
        SectionColumn(
          L.common.application,
          flex: 3,
          cell: (context, entry) => _applicationCell(context, entry),
        ),
        SectionColumn.text(
          L.policies.action,
          (entry) => _actionLabel(entry.action),
          flex: 2,
          ellipsis: false,
        ),
        SectionColumn.text(
          L.policies.order,
          (entry) => '${entry.sort}',
          ellipsis: false,
        ),
        SectionColumn(
          L.policies.flags,
          flex: 4,
          cell: (context, entry) => SectionFlags([
            if (entry.showLauncher) 'Launcher',
            if (entry.runOnBoot) L.policies.flagBoot,
            if (entry.uninstallBlock) L.policies.uninstallBlock,
            if (entry.startAfterInstall) L.policies.flagAfterInstall,
          ]),
        ),
      ],
      actionsWidth: 148,
      actions: (entry, index) => [
        AppIconButton(
          icon: LucideIcons.arrowUp,
          tooltip: L.policies.up,
          onPressed: index > 0 ? () => _move(context, entry.id!, -1) : null,
        ),
        AppIconButton(
          icon: LucideIcons.arrowDown,
          tooltip: L.policies.down,
          onPressed: index < entries.length - 1
              ? () => _move(context, entry.id!, 1)
              : null,
        ),
        AppIconButton(
          icon: LucideIcons.pencil,
          tooltip: L.common.edit,
          onPressed: () => _edit(context, entry),
        ),
        AppIconButton(
          icon: LucideIcons.trash2,
          tooltip: L.common.remove,
          onPressed: () => _remove(context, entry),
        ),
      ],
    );
  }

  Widget _applicationCell(BuildContext context, PolicyApplication entry) {
    final package = controller.applicationPackage(entry.applicationId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          controller.applicationLabel(entry.applicationId),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppText.body(context),
        ),
        if (package.isNotEmpty)
          Text(
            package,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.cellSecondary(context),
          ),
      ],
    );
  }

  String _actionLabel(PolicyApplicationAction action) {
    return switch (action) {
      PolicyApplicationAction.install => L.policies.actionInstall,
      PolicyApplicationAction.remove => L.common.remove,
      PolicyApplicationAction.configure => L.policies.actionConfigure,
    };
  }

  Future<void> _add(BuildContext context) async {
    final applicationId = await showPolicyPivotPicker(
      context: context,
      title: L.policies.selectApplication,
      showApplicationFilters: true,
      options: availablePivotOptions(
        [
          for (final application in controller.applicationOptions)
            PolicyPivotOption(
              id: application.id!,
              label: application.appName,
              subtitle: application.packageName,
              isSystemApp: application.isSystemApp,
              hasVersions:
                  (controller.applicationVersionCounts[application.id] ?? 0) >
                  0,
            ),
        ],
        {for (final entry in controller.applications) entry.applicationId},
      ),
    );
    if (applicationId == null || !context.mounted) return;

    final entry = await showDialog<PolicyApplication>(
      context: context,
      builder: (_) => PolicyApplicationDialog(
        controller: controller,
        policyId: controller.policyId!,
        applicationId: applicationId,
        applicationLabel: controller.applicationLabel(applicationId),
      ),
    );
    if (entry == null || !context.mounted) return;

    await runAction(
      () => controller.attachApplication(entry),
      success: L.policies.applicationAdded,
      context: context,
    );
  }

  Future<void> _edit(BuildContext context, PolicyApplication entry) async {
    final updated = await showDialog<PolicyApplication>(
      context: context,
      builder: (_) => PolicyApplicationDialog(
        controller: controller,
        policyId: controller.policyId!,
        applicationId: entry.applicationId,
        applicationLabel: controller.applicationLabel(entry.applicationId),
        entry: entry,
      ),
    );
    if (updated == null || !context.mounted) return;

    await runAction(
      () => controller.updateApplicationEntry(updated),
      success: L.policies.applicationUpdated,
      context: context,
    );
  }

  Future<void> _remove(BuildContext context, PolicyApplication entry) async {
    final confirmed = await confirmDialog(
      context: context,
      title: L.policies.removeApplicationTitle,
      message: L.policies.removeApplicationConfirm.trParams({
        'name': controller.applicationLabel(entry.applicationId),
      }),
    );
    if (confirmed != true || !context.mounted) return;

    await runAction(
      () => controller.detachApplicationEntry(entry.id!),
      success: L.policies.applicationRemoved,
      context: context,
    );
  }

  Future<void> _move(BuildContext context, int entryId, int delta) => runAction(
    () => controller.moveApplication(entryId, delta),
    context: context,
  );
}
