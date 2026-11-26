import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../../Core/Constants/Enums/alert_enums.dart';
import '../../../../Core/L10n/L.dart';
import '../../../../Logic/Controllers/files_controller.dart';
import '../../../Widgets/Action/open_link.dart';
import '../../../Widgets/Action/run_action.dart';
import '../../../Widgets/Alert/app_toast.dart';
import '../../../Widgets/Dialog/assign_groups_dialog.dart';
import 'file_form_dialog.dart';

class FilePageActions {
  const FilePageActions._();

  static Future<void> edit(
    BuildContext context,
    FilesController controller,
    FileAsset file,
  ) async {
    final id = file.id;
    if (id == null) return;

    await controller.ensureOptionsLoaded();
    if (!context.mounted) return;

    List<int> initial = const [];
    try {
      initial = await controller.groupIdsForFile(id);
    } catch (_) {
      // A failed group load opens the form with no groups selected.
    }
    if (!context.mounted) return;

    final result = await showFileFormDialog(
      context,
      file: file,
      groups: controller.fileGroups,
      initialGroupIds: initial,
    );
    if (result == null) return;

    await runAction(
      () async {
        await controller.updateFile(result.file);
        await controller.assignGroupsToFile(id, result.groupIds);
      },
      success: L.files.updated,
      failure: L.common.saveFailed,
    );
  }

  static Future<void> assignGroups(
    BuildContext context,
    FilesController controller,
    FileAsset file,
  ) async {
    final id = file.id;
    if (id == null) return;

    await runAction(() async {
      final initial = await controller.groupIdsForFile(id);
      if (!context.mounted) return;

      final selection = await showAssignGroupsDialog<FileGroupRow>(
        context,
        title: L.files.assignGroups,
        applyLabel: L.common.apply,
        emptyText: L.files.noGroups,
        groups: controller.fileGroups,
        idOf: (row) => row.group.id,
        nameOf: (row) => row.group.name,
        subtitleOf: (row) =>
            L.files.groupFileCount.trParams({'count': '${row.fileCount}'}),
        initial: initial,
      );
      if (selection == null) return;

      await controller.assignGroupsToFile(id, selection);
      // Inside the action: a cancelled dialog must not report success.
      AppToast.show(L.files.groupsUpdated, tone: UiAlertTone.success);
    }, failure: L.files.assignFailed);
  }

  static Future<void> download(
    FilesController controller,
    FileAsset file,
  ) async {
    final id = file.id;
    if (id == null) return;

    await openDownload(
      () => controller.downloadUrl(id),
      missingMessage: L.files.downloadLinkMissing,
      copiedMessage: L.common.linkCopied,
      failure: L.common.downloadFailed,
    );
  }

  static Future<void> delete(
    BuildContext context,
    FilesController controller,
    FileAsset file,
  ) async {
    final id = file.id;
    if (id == null) return;

    final displayName = file.customName?.isNotEmpty == true
        ? file.customName!
        : file.name;

    await confirmAndRun(
      context,
      title: L.files.deleteTitle,
      message: L.files.deleteConfirm.trParams({'name': displayName}),
      action: () => controller.deleteFile(id),
      success: L.files.deleted,
      failure: L.common.deleteFailed,
    );
  }
}
