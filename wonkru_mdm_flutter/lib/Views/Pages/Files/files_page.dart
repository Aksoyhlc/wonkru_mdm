import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../Core/Constants/Enums/table_enums.dart';
import '../../../Core/Extensions/num.dart';
import '../../../Core/L10n/L.dart';
import '../../../Core/Theme/design.dart';
import '../../../Logic/Controllers/files_controller.dart';
import '../../Widgets/Action/open_link.dart';
import '../../Widgets/Action/run_action.dart';
import '../../Widgets/Table/Cells/cell_action.dart';
import '../../Widgets/Table/Cells/cell_chips.dart';
import '../../Widgets/Table/Cells/cell_copy.dart';
import '../../Widgets/Table/Cells/cell_primary.dart';
import '../../Widgets/Table/Cells/cell_text.dart';
import '../../Widgets/Table/app_data_table.dart';
import '../../Widgets/Table/table_column.dart';
import 'Widgets/file_filters_bar.dart';
import 'Widgets/file_form_dialog.dart';
import 'Widgets/file_page_actions.dart';

class FilesPage extends StatefulWidget {
  const FilesPage({super.key});

  @override
  State<FilesPage> createState() => _FilesPageState();
}

class _FilesPageState extends State<FilesPage> {
  late final FilesController _controller = Get.find<FilesController>();

  final Map<int, List<int>> _groupIdsByFile = <int, List<int>>{};

  Worker? _groupsWorker;

  @override
  void initState() {
    super.initState();
    unawaited(_controller.ensureOptionsLoaded());
    _groupsWorker = ever<List<FileAsset>>(
      _controller.rows,
      (rows) => unawaited(_loadGroups(rows)),
    );
    if (_controller.rows.isNotEmpty) {
      unawaited(_loadGroups(_controller.rows));
    }
  }

  @override
  void dispose() {
    _groupsWorker?.dispose();
    super.dispose();
  }

  /// Refilled on every page change so the column refreshes after a group
  /// assignment; a single RPC for all rows avoids N+1 queries.
  Future<void> _loadGroups(List<FileAsset> rows) async {
    final ids = <int>[
      for (final row in rows)
        if (row.id != null) row.id!,
    ];

    if (ids.isEmpty) {
      if (_groupIdsByFile.isNotEmpty && mounted) {
        setState(_groupIdsByFile.clear);
      }
      return;
    }

    try {
      final members = await _controller.groupMembersForFiles(ids);
      if (!mounted) return;
      setState(() {
        _groupIdsByFile
          ..clear()
          ..addEntries(ids.map((id) => MapEntry(id, <int>[])));
        for (final member in members) {
          (_groupIdsByFile[member.fileId] ??= <int>[]).add(member.fileGroupId);
        }
      });
    } catch (_) {
      // A failed group load leaves the column empty; the list stays usable.
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppDataTable<FileAsset>(
      controller: _controller,
      columns: _columns(context),
      rowId: (file) => file.id,
      searchHint: L.common.searchName,
      emptyTitle: L.files.emptyTitle,
      emptySubtitle: L.files.emptySubtitle,
      createLabel: L.files.newFile,
      onCreate: () => _create(context),
      filterBar: FileFiltersBar(controller: _controller),
      onBulkDelete: _controller.deleteSelected,
    );
  }

  List<AppColumn<FileAsset>> _columns(BuildContext context) {
    return [
      AppColumn<FileAsset>(
        title: '',
        width: 56,
        align: Alignment.center,
        hideable: false,
        freeze: AppColumnFreeze.start,
        cell: (file) => _previewCell(context, file),
      ),
      AppColumn<FileAsset>(
        title: L.common.name,
        width: 260,
        sortKey: 'name',
        freeze: AppColumnFreeze.start,
        hideable: false,
        cell: (file) => CellPrimary(
          title: file.customName?.isNotEmpty == true
              ? file.customName!
              : file.name,
          subtitle: file.name,
        ),
      ),
      AppColumn<FileAsset>(
        title: L.files.extension,
        width: 90,
        sortKey: 'fileExtension',
        cell: (file) => CellText(file.fileExtension),
      ),
      AppColumn<FileAsset>(
        title: L.common.size,
        width: 100,
        sortKey: 'sizeBytes',
        cell: (file) => CellText(file.sizeBytes.readableBytes),
      ),
      AppColumn<FileAsset>(
        title: 'MIME',
        width: 190,
        cell: (file) => CellText(file.mimeType, muted: true),
      ),
      AppColumn<FileAsset>(
        title: 'URL',
        width: 220,
        cell: (file) => CellCopy(
          file.publicUrl,
          maxChars: 28,
          copiedMessage: L.files.urlCopied,
          onOpen: file.publicUrl == null || file.publicUrl!.isEmpty
              ? null
              : () => openLinkOrCopy(file.publicUrl!, L.common.linkCopied),
        ),
      ),
      AppColumn<FileAsset>(
        title: 'Hash',
        width: 180,
        visible: false,
        cell: (file) => CellCopy(
          file.fileHashSha256,
          maxChars: 16,
          copiedMessage: L.files.hashCopied,
        ),
      ),
      AppColumn<FileAsset>(
        title: L.common.groups,
        width: 200,
        cell: (file) => CellChips(_groupNames(file)),
      ),
      AppColumn<FileAsset>(
        title: L.files.source,
        width: 100,
        sortKey: 'disk',
        cell: (file) => CellText(_diskLabel(file.disk)),
      ),
      AppColumn.actions(
        (file) => [
          CellAction.edit(
            () => FilePageActions.edit(context, _controller, file),
          ),
          CellAction(
            label: L.files.assignGroups,
            icon: LucideIcons.folderTree,
            onTap: () =>
                FilePageActions.assignGroups(context, _controller, file),
          ),
          CellAction(
            label: L.common.download,
            icon: LucideIcons.download,
            onTap: () => FilePageActions.download(_controller, file),
          ),
          CellAction.delete(
            () => FilePageActions.delete(context, _controller, file),
          ),
        ],
      ),
    ];
  }

  Widget _previewCell(BuildContext context, FileAsset file) {
    final colors = context.appColors;
    final isImage = file.mimeType?.startsWith('image/') ?? false;
    final url = file.publicUrl;

    Widget fallback() => Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: colors.muted,
        borderRadius: BorderRadius.circular(AppRadius.r6),
      ),
      child: Icon(LucideIcons.file, size: 16, color: colors.graphite),
    );

    return isImage && url != null && url.isNotEmpty
        ? ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.r6),
            child: Image.network(
              url,
              width: 32,
              height: 32,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => fallback(),
            ),
          )
        : fallback();
  }

  List<String> _groupNames(FileAsset file) {
    final id = file.id;
    final groupIds = id == null ? null : _groupIdsByFile[id];
    if (groupIds == null || groupIds.isEmpty) return const [];

    return [
      for (final groupId in groupIds)
        for (final row in _controller.fileGroups)
          if (row.group.id == groupId) row.group.name,
    ];
  }

  Future<void> _create(BuildContext context) async {
    await _controller.ensureOptionsLoaded();
    if (!context.mounted) return;

    final result = await showFileFormDialog(
      context,
      groups: _controller.fileGroups,
    );
    if (result == null) return;

    await runAction(
      () async {
        final saved = await _controller.createFile(result.file);
        final id = saved.id;
        if (id != null && result.groupIds.isNotEmpty) {
          await _controller.assignGroupsToFile(id, result.groupIds);
        }
      },
      success: L.files.created,
      failure: L.common.saveFailed,
    );
  }

  static String _diskLabel(StorageDisk? disk) => switch (disk) {
    StorageDisk.public => 'Public',
    StorageDisk.private => 'Private',
    null => '—',
  };
}
