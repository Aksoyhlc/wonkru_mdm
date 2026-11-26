import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../../../Core/Constants/Enums/alert_enums.dart';
import '../../../../../Core/Constants/Enums/button_enums.dart';
import '../../../../../Core/L10n/L.dart';
import '../../../../../Core/Theme/design.dart';
import '../../../../../Core/Utils/file_metadata.dart';
import '../../../../../Logic/Controllers/policy_editor_controller.dart';
import '../../../../Widgets/Action/open_link.dart';
import '../../../../Widgets/Action/run_action.dart';
import '../../../../Widgets/Alert/app_toast.dart';
import '../../../../Widgets/Button/app_button.dart';
import '../../../../Widgets/Button/app_icon_button.dart';
import '../../../../Widgets/Card/section_card.dart';
import '../../../../Widgets/Dialog/confirm_dialog.dart';
import '../../../../Widgets/EmptyState/empty_hint.dart';
import '../../../../Widgets/Section/section_column.dart';
import '../../../../Widgets/Section/section_flags.dart';
import '../../../../Widgets/Section/section_table.dart';
import '../policy_pivot_picker.dart';
import 'Widgets/add_path_dialog.dart';
import 'Widgets/policy_file_dialog.dart';
import 'Widgets/policy_file_upload_dialog.dart';
import 'Widgets/upload_result.dart';
import 'policy_file_operations.dart';

class PolicyFilesSection extends StatelessWidget {
  const PolicyFilesSection({super.key, required this.controller});

  final PolicyEditorController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Obx only rebuilds on observables read during build: reading the RxList
      // here is what keeps this widget subscribed, even when isNew short-circuits.
      final entries = controller.files.toList();

      return SectionCard(
        title: L.policies.files,
        child: controller.isNew
            ? EmptyHint(L.policies.pivotSaveFirst)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (
                    var index = 0;
                    index < policyFileOperations.length;
                    index++
                  ) ...[
                    if (index > 0) AppGap.v20,
                    _operationSection(
                      context,
                      policyFileOperations[index],
                      entries,
                    ),
                  ],
                ],
              ),
      );
    });
  }

  Widget _operationSection(
    BuildContext context,
    FileOperationType operation,
    List<PolicyFile> entries,
  ) {
    final colors = context.appColors;
    final rows = filesForOperation(entries, operation);
    final label = (policyOperationLabels[operation] ?? operation.name).tr;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppSpacing.s8,
          runSpacing: AppSpacing.s8,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: AppSpacing.s6,
              children: [
                Icon(
                  policyOperationIcons[operation] ?? LucideIcons.file,
                  size: 15,
                  color: colors.graphite,
                ),
                Text(
                  label,
                  style: AppText.cellPrimary(
                    context,
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  '(${rows.length})',
                  style: AppText.caption(context, size: 12),
                ),
              ],
            ),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                if (operation == FileOperationType.delete)
                  AppButton(
                    label: L.policies.addPath,
                    compact: true,
                    icon: LucideIcons.plus,
                    onPressed: () => _addByPath(context),
                  )
                else ...[
                  AppButton(
                    label: L.common.chooseFile,
                    compact: true,
                    icon: LucideIcons.folderOpen,
                    variant: AppButtonVariant.secondary,
                    onPressed: () => _add(context, operation),
                  ),
                  AppButton(
                    label: L.policies.uploadFile,
                    compact: true,
                    icon: LucideIcons.upload,
                    onPressed: () => _upload(context, operation),
                  ),
                ],
              ],
            ),
          ],
        ),
        AppGap.v8,
        if (rows.isEmpty)
          EmptyHint(L.policies.noFilesForOperation)
        else
          _table(context, operation, rows),
      ],
    );
  }

  Widget _table(
    BuildContext context,
    FileOperationType operation,
    List<PolicyFile> rows,
  ) {
    return SectionTable<PolicyFile>(
      minWidth: 640,
      rows: rows,
      columns: [
        SectionColumn.text(
          L.policies.file,
          (entry) =>
              entry.fileId == null ? '—' : controller.fileLabel(entry.fileId!),
          flex: 4,
        ),
        SectionColumn.text(
          operation == FileOperationType.delete
              ? L.policies.deletePath
              : L.policies.destinationPath,
          (entry) => entry.destinationPath ?? '—',
          flex: 3,
        ),
        SectionColumn(
          L.policies.flags,
          flex: 4,
          cell: (context, entry) => SectionFlags([
            if (entry.replaceIfExists) L.policies.flagReplaceIfExists,
            if (entry.openAfterDownload) L.policies.flagOpenAfterDownload,
          ]),
        ),
      ],
      actionsWidth: 128,
      actions: (entry, _) => [
        if (entry.fileId != null)
          AppIconButton(
            icon: LucideIcons.download,
            tooltip: L.common.download,
            onPressed: () => _download(context, entry),
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

  Future<void> _add(BuildContext context, FileOperationType operation) async {
    final attached = <int>{
      for (final entry in filesForOperation(
        controller.files.toList(),
        operation,
      ))
        if (entry.fileId != null) entry.fileId!,
    };
    final fileId = await showPolicyPivotPicker(
      context: context,
      title: L.policies.pickFileForOperation.trParams({
        'operation': (policyOperationLabels[operation] ?? operation.name).tr,
      }),
      options: availablePivotOptions(
        [
          for (final file in controller.fileOptions)
            PolicyPivotOption(
              id: file.id!,
              label: file.customName ?? file.name,
              subtitle: file.mimeType,
            ),
        ],
        attached,
      ),
    );
    if (fileId == null || !context.mounted) return;

    final entry = await showDialog<PolicyFile>(
      context: context,
      builder: (_) => PolicyFileDialog(
        policyId: controller.policyId!,
        fileId: fileId,
        fileLabel: controller.fileLabel(fileId),
        initialUsageType: operation,
      ),
    );
    if (entry == null || !context.mounted) return;

    await runAction(
      () => controller.attachFile(entry),
      success: L.policies.fileAdded,
      context: context,
    );
  }

  Future<void> _addByPath(BuildContext context) async {
    final path = await showDialog<String>(
      context: context,
      builder: (_) => const AddPathDialog(),
    );
    if (path == null || !context.mounted) return;

    final destination = path.trim();
    if (destination.isEmpty) return;

    await runAction(
      () => controller.attachFile(
        PolicyFile(
          policyId: controller.policyId!,
          usageType: FileOperationType.delete,
          destinationPath: destination,
          replaceIfExists: false,
          openAfterDownload: false,
        ),
      ),
      success: L.policies.fileAdded,
      context: context,
    );
  }

  Future<void> _upload(
    BuildContext context,
    FileOperationType operation,
  ) async {
    final result = await showDialog<UploadResult>(
      context: context,
      builder: (_) => PolicyFileUploadDialog(operation: operation),
    );
    if (result == null || !context.mounted) return;

    await runAction(
      () async {
        final uploaded = result.uploaded;
        final asset = await controller.createFileAsset(
          FileAsset(
            name: _baseName(uploaded.fileName),
            customName: uploaded.fileName,
            fileExtension: fileExtensionOf(uploaded.fileName),
            filePath: uploaded.path,
            mimeType:
                uploaded.contentType ?? mimeTypeForFileName(uploaded.fileName),
            sizeBytes: uploaded.sizeBytes,
            disk: StorageDisk.fromJson(uploaded.storageId),
          ),
        );

        await controller.attachFile(
          PolicyFile(
            policyId: controller.policyId!,
            fileId: asset.id!,
            usageType: operation,
            destinationPath: result.destinationPath,
            replaceIfExists: operation != FileOperationType.delete,
            openAfterDownload: operation == FileOperationType.open,
          ),
        );
      },
      success: L.policies.fileUploaded,
      context: context,
    );
  }

  Future<void> _edit(BuildContext context, PolicyFile entry) async {
    final updated = await showDialog<PolicyFile>(
      context: context,
      builder: (_) => PolicyFileDialog(
        policyId: controller.policyId!,
        fileId: entry.fileId,
        fileLabel: entry.fileId == null
            ? null
            : controller.fileLabel(entry.fileId!),
        entry: entry,
      ),
    );
    if (updated == null || !context.mounted) return;

    await runAction(
      () => controller.updateFileEntry(updated),
      success: L.policies.fileUpdated,
      context: context,
    );
  }

  Future<void> _remove(BuildContext context, PolicyFile entry) async {
    final confirmed = await confirmDialog(
      context: context,
      title: L.policies.removeFileTitle,
      message: L.policies.removeFileConfirm.trParams({
        'name': entry.fileId == null
            ? (entry.destinationPath ?? '—')
            : controller.fileLabel(entry.fileId!),
      }),
    );
    if (confirmed != true || !context.mounted) return;

    await runAction(
      () => controller.detachFileEntry(entry.id!),
      success: L.policies.fileRemoved,
      context: context,
    );
  }

  Future<void> _download(BuildContext context, PolicyFile entry) async {
    final fileId = entry.fileId;
    if (fileId == null) {
      AppToast.show(L.policies.fileNoDownloadUrl, tone: UiAlertTone.warning);
      return;
    }

    final url = controller.filePublicUrl(fileId);
    if (url == null || url.isEmpty) {
      AppToast.show(
        L.policies.fileNoDownloadUrl,
        tone: UiAlertTone.warning,
      );
      return;
    }

    await openLinkOrCopy(url, L.policies.linkCopied);
  }
}

String _baseName(String fileName) {
  final dot = fileName.lastIndexOf('.');
  return dot > 0 ? fileName.substring(0, dot) : fileName;
}
