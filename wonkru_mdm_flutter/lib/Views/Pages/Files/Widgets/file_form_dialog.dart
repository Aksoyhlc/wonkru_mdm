import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../../Core/Constants/Enums/alert_enums.dart';
import '../../../../Core/L10n/L.dart';
import '../../../../Core/Theme/design.dart';
import '../../../../Core/Utils/file_metadata.dart';
import '../../../Widgets/Alert/app_toast.dart';
import '../../../Widgets/Button/app_button.dart';
import '../../../Widgets/Dialog/app_dialog_shell.dart';
import '../../../Widgets/Input/app_dropdown.dart';
import '../../../Widgets/Input/app_file_upload/app_file_upload.dart';
import '../../../Widgets/Input/custom_text_field.dart';
import '../../../Widgets/Input/text_controllers_owner.dart';
import '../../../Widgets/Input/uploaded_file.dart';

typedef FileFormResult = ({FileAsset file, List<int> groupIds});

Future<FileFormResult?> showFileFormDialog(
  BuildContext context, {
  FileAsset? file,
  List<FileGroupRow> groups = const [],
  List<int> initialGroupIds = const [],
  bool showGroupPicker = true,
}) {
  return showDialog<FileFormResult>(
    context: context,
    builder: (_) => _FileFormDialog(
      file: file,
      groups: groups,
      initialGroupIds: initialGroupIds,
      showGroupPicker: showGroupPicker,
    ),
  );
}

class _FileFormDialog extends StatefulWidget {
  const _FileFormDialog({
    this.file,
    this.groups = const [],
    this.initialGroupIds = const [],
    this.showGroupPicker = true,
  });

  final FileAsset? file;
  final List<FileGroupRow> groups;
  final List<int> initialGroupIds;
  final bool showGroupPicker;

  @override
  State<_FileFormDialog> createState() => _FileFormDialogState();
}

class _FileFormDialogState extends State<_FileFormDialog>
    with TextControllersOwner<_FileFormDialog> {
  static final _disks = <String, String>{
    'private': L.files.diskPrivate,
    'public': L.files.diskPublic,
  };

  late final _name = textController(widget.file?.name ?? '');
  late final _customName = textController(widget.file?.customName ?? '');

  late String _disk = widget.file?.disk?.name ?? 'private';

  static StorageDisk _storageDisk(String value) =>
      StorageDisk.values.firstWhere(
        (disk) => disk.name == value,
        orElse: () => StorageDisk.private,
      );

  late final Set<int> _selectedGroupIds = widget.initialGroupIds.toSet();

  UploadedFile? _uploaded;

  bool get _isEditing => widget.file != null;

  Future<void> _onUploaded(UploadedFile file) async {
    setState(() {
      _uploaded = file;
      if (_name.text.trim().isEmpty) {
        _name.text = _baseName(file.fileName);
      }
      if (_customName.text.trim().isEmpty) {
        _customName.text = file.fileName;
      }
    });
  }

  static String _baseName(String fileName) {
    final dot = fileName.lastIndexOf('.');
    return dot > 0 ? fileName.substring(0, dot) : fileName;
  }

  String? _nullable(TextEditingController controller) {
    final value = controller.text.trim();
    return value.isEmpty ? null : value;
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    if (name.isEmpty) {
      AppToast.show(L.files.nameRequired, tone: UiAlertTone.warning);
      return;
    }

    if (_isEditing) {
      final source = widget.file!;
      Navigator.pop(
        context,
        (
          file: FileAsset(
            id: source.id,
            name: name,
            customName: _nullable(_customName),
            fileExtension: source.fileExtension,
            filePath: source.filePath,
            publicUrl: source.publicUrl,
            mimeType: source.mimeType,
            sizeBytes: source.sizeBytes,
            fileHashSha256: source.fileHashSha256,
            disk: _storageDisk(_disk),
            createdAt: source.createdAt,
            updatedAt: source.updatedAt,
          ),
          groupIds: _selectedGroupIds.toList(),
        ),
      );
      return;
    }

    final uploaded = _uploaded;
    if (uploaded == null) {
      AppToast.show(L.files.selectFileFirst, tone: UiAlertTone.warning);
      return;
    }

    final asset = FileAsset(
      name: name,
      customName: _nullable(_customName),
      fileExtension: fileExtensionOf(uploaded.fileName),
      filePath: uploaded.path,
      mimeType: uploaded.contentType ?? mimeTypeForFileName(uploaded.fileName),
      sizeBytes: uploaded.sizeBytes,
      disk: _storageDisk(uploaded.storageId),
    );

    if (mounted) {
      Navigator.pop(
        context,
        (file: asset, groupIds: _selectedGroupIds.toList()),
      );
    }
  }

  Widget _groupPicker() {
    if (widget.groups.isEmpty) {
      return Text(
        L.files.noGroups,
        style: AppText.caption(context, size: 12),
      );
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 160),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final row in widget.groups)
              _GroupOption(
                label: row.group.name,
                subtitle: L.files.groupFileCount.trParams({
                  'count': '${row.fileCount}',
                }),
                selected:
                    row.group.id != null &&
                    _selectedGroupIds.contains(row.group.id),
                onChanged: (checked) {
                  final id = row.group.id;
                  if (id == null) return;
                  setState(() {
                    checked
                        ? _selectedGroupIds.add(id)
                        : _selectedGroupIds.remove(id);
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppDialogShell(
      title: _isEditing ? L.files.editFile : L.files.newFile,
      maxWidth: 560,
      actions: [
        AppButton.cancel(context),
        AppButton(label: L.common.save, onPressed: _save),
      ],
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 460),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppDropdown<String>(
                label: L.files.disk,
                value: _disks.containsKey(_disk) ? _disk : 'private',
                items: _disks,
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _disk = value;
                    if (!_isEditing) _uploaded = null;
                  });
                },
              ),
              AppGap.v14,
              if (!_isEditing) ...[
                AppFileUpload(
                  key: ValueKey('file-upload-$_disk'),
                  purpose: 'file',
                  disk: _disk,
                  label: L.files.fileLabel,
                  helper: L.files.fileHelper,
                  onUploaded: _onUploaded,
                  onRemoved: () => setState(() => _uploaded = null),
                ),
                AppGap.v14,
              ],
              CustomTextField(
                name: 'file_name',
                controller: _name,
                label: L.files.systemName,
                hint: L.files.systemNameHint,
                autofocus: _isEditing,
                showValidationError: false,
              ),
              AppGap.v12,
              CustomTextField(
                name: 'file_custom_name',
                controller: _customName,
                label: L.files.displayName,
                hint: L.common.optional,
                showValidationError: false,
              ),
              if (widget.showGroupPicker) ...[
                AppGap.v14,
                Text(
                  L.files.groupsSection,
                  style: AppText.cellPrimary(
                    context,
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
                AppGap.v6,
                _groupPicker(),
              ],
              if (_isEditing) ...[
                AppGap.v6,
                Text(
                  L.files.metadataOnlyNote,
                  style: AppText.caption(context, size: 11),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _GroupOption extends StatelessWidget {
  const _GroupOption({
    required this.label,
    required this.subtitle,
    required this.selected,
    required this.onChanged,
  });

  final String label;
  final String subtitle;
  final bool selected;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!selected),
      child: Padding(
        padding: AppInsets.v2,
        child: Row(
          children: [
            Checkbox(
              value: selected,
              visualDensity: VisualDensity.compact,
              onChanged: (value) => onChanged(value ?? false),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: AppText.body(context),
                  ),
                  Text(
                    subtitle,
                    style: AppText.caption(context, size: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
