import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../../Core/Constants/Enums/button_enums.dart';
import '../../../../Core/L10n/L.dart';
import '../../../../Core/Theme/design.dart';
import '../../../../Logic/Controllers/policy_editor_controller.dart';
import '../../../Widgets/Action/run_action.dart';
import '../../../Widgets/Button/app_button.dart';
import '../../../Widgets/Button/app_icon_button.dart';
import '../../../Widgets/Card/section_card.dart';
import '../../../Widgets/Dialog/app_dialog_shell.dart';
import '../../../Widgets/Dialog/confirm_dialog.dart';
import '../../../Widgets/EmptyState/empty_hint.dart';
import '../../../Widgets/Input/app_dropdown.dart';
import '../../../Widgets/Section/section_column.dart';
import '../../../Widgets/Section/section_table.dart';
import '../../Certificates/Widgets/certificate_form_dialog/certificate_form_dialog.dart';
import 'policy_pivot_picker.dart';

class PolicyCertificatesSection extends StatelessWidget {
  const PolicyCertificatesSection({super.key, required this.controller});

  final PolicyEditorController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Obx only rebuilds on observables read during build: reading the RxList
      // here is what keeps this widget subscribed, even when isNew short-circuits.
      final entries = controller.certificates.toList();

      return SectionCard(
        title: L.policies.certificates,
        trailing: controller.isNew
            ? null
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppButton(
                    label: L.policies.newCertificate,
                    compact: true,
                    icon: LucideIcons.shieldPlus,
                    variant: AppButtonVariant.secondary,
                    onPressed: () => _create(context),
                  ),
                  AppGap.h6,
                  AppButton(
                    label: L.common.add,
                    compact: true,
                    icon: LucideIcons.plus,
                    onPressed: () => _add(context),
                  ),
                ],
              ),
        child: controller.isNew
            ? EmptyHint(L.policies.pivotSaveFirst)
            : entries.isEmpty
            ? EmptyHint(L.policies.noCertificates)
            : _table(context, entries),
      );
    });
  }

  Widget _table(BuildContext context, List<PolicyCertificate> entries) {
    return SectionTable<PolicyCertificate>(
      minWidth: 620,
      rows: entries,
      columns: [
        SectionColumn.text(
          L.policies.certificate,
          (entry) => controller.certificateLabel(entry.certificateId),
          flex: 5,
        ),
        SectionColumn.text(
          L.policies.action,
          (entry) => _actionLabel(entry.action),
          flex: 3,
          ellipsis: false,
        ),
      ],
      actionsWidth: 44,
      actions: (entry, _) => [
        AppIconButton(
          icon: LucideIcons.trash2,
          tooltip: L.common.remove,
          onPressed: () => _remove(context, entry),
        ),
      ],
    );
  }

  String _actionLabel(CertificateAction? action) {
    return switch (action) {
      CertificateAction.install => L.policies.actionInstall,
      CertificateAction.uninstall => L.common.remove,
      null => '—',
    };
  }

  Future<void> _add(BuildContext context) async {
    final certificateId = await showPolicyPivotPicker(
      context: context,
      title: L.policies.selectCertificate,
      options: availablePivotOptions(
        [
          for (final certificate in controller.certificateOptions)
            PolicyPivotOption(
              id: certificate.id!,
              label: certificate.name,
              subtitle: certificate.certificateType.name,
            ),
        ],
        {for (final entry in controller.certificates) entry.certificateId},
      ),
    );
    if (certificateId == null || !context.mounted) return;

    final entry = await showDialog<PolicyCertificate>(
      context: context,
      builder: (_) => _PolicyCertificateDialog(
        policyId: controller.policyId!,
        certificateId: certificateId,
        certificateLabel: controller.certificateLabel(certificateId),
      ),
    );
    if (entry == null || !context.mounted) return;

    await runAction(
      () => controller.attachCertificate(entry),
      success: L.policies.certificateAdded,
      context: context,
    );
  }

  Future<void> _create(BuildContext context) async {
    final certificate = await showCertificateFormDialog(context);
    if (certificate == null || !context.mounted) return;

    await runAction(
      () async {
        final created = await controller.createCertificate(certificate);
        await controller.attachCertificate(
          PolicyCertificate(
            policyId: controller.policyId!,
            certificateId: created.id!,
            action: CertificateAction.install,
          ),
        );
      },
      success: L.policies.certificateCreatedAttached,
      context: context,
    );
  }

  Future<void> _remove(
    BuildContext context,
    PolicyCertificate entry,
  ) async {
    final confirmed = await confirmDialog(
      context: context,
      title: L.policies.removeCertificateTitle,
      message: L.policies.removeCertificateConfirm.trParams({
        'name': controller.certificateLabel(entry.certificateId),
      }),
    );
    if (confirmed != true || !context.mounted) return;

    await runAction(
      () => controller.detachCertificateEntry(entry.id!),
      success: L.policies.certificateRemoved,
      context: context,
    );
  }
}

class _PolicyCertificateDialog extends StatefulWidget {
  const _PolicyCertificateDialog({
    required this.policyId,
    required this.certificateId,
    required this.certificateLabel,
  });

  final int policyId;
  final int certificateId;
  final String certificateLabel;

  @override
  State<_PolicyCertificateDialog> createState() =>
      _PolicyCertificateDialogState();
}

class _PolicyCertificateDialogState extends State<_PolicyCertificateDialog> {
  static const _actions = <CertificateAction?, String>{
    null: 'common.none',
    CertificateAction.install: 'policies.action_install',
    CertificateAction.uninstall: 'common.remove',
  };

  CertificateAction? _action;

  void _submit() {
    Navigator.pop(
      context,
      PolicyCertificate(
        policyId: widget.policyId,
        certificateId: widget.certificateId,
        action: _action,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppDialogShell(
      title: L.policies.addCertificate,
      maxWidth: 520,
      actions: [
        AppButton.cancel(context),
        AppButton(label: L.common.add, onPressed: _submit),
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.certificateLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.sectionTitle(context).copyWith(fontSize: 14),
          ),
          AppGap.v12,
          AppDropdown<CertificateAction?>(
            label: L.policies.action,
            value: _action,
            items: _actions.map(
              (key, value) => MapEntry(key, value.tr),
            ),
            onChanged: (value) => setState(() => _action = value),
          ),
        ],
      ),
    );
  }
}
