import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../../Core/Constants/Enums/alert_enums.dart';
import '../../../../Core/Constants/Enums/button_enums.dart';
import '../../../../Core/Errors/server_error_message.dart';
import '../../../../Core/L10n/L.dart';
import '../../../../Core/Theme/design.dart';
import '../../../../Logic/Controllers/file_groups_controller.dart';
import '../../../Widgets/Alert/app_toast.dart';
import '../../../Widgets/Button/app_button.dart';
import '../../../Widgets/Button/app_icon_button.dart';
import '../../../Widgets/Card/section_card.dart';
import '../../../Widgets/Dialog/app_dialog_shell.dart';
import '../../../Widgets/Dialog/confirm_dialog.dart';
import '../../../Widgets/Input/custom_text_field.dart';
import '../../../Widgets/Input/text_controllers_owner.dart';
import '../../Files/Widgets/file_form_dialog.dart';

Future<void> showFileGroupMembersDialog(
  BuildContext context, {
  required FileGroup group,
  required FileGroupsController controller,
}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => AppDialogShell(
      title: L.files.membersTitle.trParams({'name': group.name}),
      maxWidth: 620,
      actions: [
        AppButton.cancel(dialogContext, label: L.common.close),
      ],
      child: FileGroupMembersSection(group: group, controller: controller),
    ),
  );
}

class FileGroupMembersSection extends StatefulWidget {
  const FileGroupMembersSection({
    super.key,
    required this.group,
    required this.controller,
  });

  final FileGroup group;
  final FileGroupsController controller;

  @override
  State<FileGroupMembersSection> createState() =>
      _FileGroupMembersSectionState();
}

class _FileGroupMembersSectionState extends State<FileGroupMembersSection>
    with TextControllersOwner<FileGroupMembersSection> {
  late final _search = textController();
  final _catalog = <int, String>{};
  final _selected = <int>{};

  List<int> _order = const [];
  Timer? _debounce;
  bool _loading = true;
  bool _saving = false;
  bool _creating = false;
  String? _error;

  int? get _groupId => widget.group.id;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    final groupId = _groupId;
    if (groupId == null) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final ids = await widget.controller.fileIds(groupId);
      final files = await widget.controller.searchFiles(null);
      if (!mounted) return;
      setState(() {
        _selected
          ..clear()
          ..addAll(ids);
        _absorb(files);
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = serverErrorMessage(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 300),
      () => unawaited(_runSearch(value)),
    );
  }

  Future<void> _runSearch(String value) async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final files = await widget.controller.searchFiles(value);
      if (!mounted) return;
      setState(() => _absorb(files));
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = serverErrorMessage(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _absorb(List<FileAsset> files) {
    for (final file in files) {
      final id = file.id;
      if (id == null) continue;
      _catalog[id] = _label(file);
    }

    final order = <int>{for (final file in files) ?file.id};
    order.addAll(_selected);
    _order = order.toList();
  }

  static String _label(FileAsset file) {
    final custom = file.customName?.trim();
    return custom == null || custom.isEmpty ? file.name : custom;
  }

  Future<void> _create() async {
    final groupId = _groupId;
    if (groupId == null) return;

    final result = await showFileFormDialog(context, showGroupPicker: false);
    if (result == null || !mounted) return;

    setState(() => _creating = true);
    try {
      final saved = await widget.controller.createFile(result.file);
      final id = saved.id;
      if (!mounted) return;
      if (id != null) {
        setState(() {
          _selected.add(id);
          _catalog[id] = _label(saved);
          _order = <int>[..._order, id];
        });
      }
      await _syncMembership();
      if (!mounted) return;
      AppToast.show(L.files.fileCreated, tone: UiAlertTone.success);
    } catch (e) {
      if (!mounted) return;
      AppToast.show(
        L.files.createFailed.trParams({'error': serverErrorMessage(e)}),
        tone: UiAlertTone.danger,
      );
    } finally {
      if (mounted) setState(() => _creating = false);
    }
  }

  Future<void> _detach(int id) async {
    if (!_selected.contains(id)) return;
    setState(() => _selected.remove(id));
    await _syncMembership();
    if (!mounted) return;
    AppToast.show(L.files.fileDetached, tone: UiAlertTone.info);
  }

  Future<void> _deleteFile(int id) async {
    final label = _catalog[id] ?? L.files.fileFallback.trParams({'id': '$id'});
    final confirmed = await confirmDialog(
      context: context,
      title: L.files.deleteTitle,
      message: L.files.deleteConfirm.trParams({'name': label}),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _saving = true);
    try {
      await widget.controller.deleteFile(id);
      if (!mounted) return;
      setState(() {
        _selected.remove(id);
        _catalog.remove(id);
        _order = _order.where((rowId) => rowId != id).toList();
      });
      await _syncMembership();
      if (!mounted) return;
      AppToast.show(L.files.deleted, tone: UiAlertTone.success);
    } catch (e) {
      if (!mounted) return;
      AppToast.show(
        L.common.deleteFailed.trParams({'error': serverErrorMessage(e)}),
        tone: UiAlertTone.danger,
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _save() async {
    await _syncMembership();
    if (!mounted) return;
    AppToast.show(L.files.membersUpdated, tone: UiAlertTone.success);
  }

  Future<bool> _syncMembership() async {
    final groupId = _groupId;
    if (groupId == null) return false;

    setState(() => _saving = true);
    try {
      await widget.controller.assignFiles(groupId, _selected.toList());
      return true;
    } catch (e) {
      if (mounted) {
        AppToast.show(
          L.common.saveFailed.trParams({'error': serverErrorMessage(e)}),
          tone: UiAlertTone.danger,
        );
      }
      return false;
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: L.files.membersSection,
      trailing: Text(
        L.common.selectedCount.trParams({'count': '${_selected.length}'}),
        style: AppText.columnHeader(context).copyWith(fontSize: 11.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 280,
                child: CustomTextField(
                  name: 'file_group_member_search',
                  controller: _search,
                  hint: L.files.fileSearchHint,
                  dense: true,
                  onChanged: _onSearchChanged,
                  showValidationError: false,
                ),
              ),
              AppButton(
                label: L.files.createFile,
                icon: LucideIcons.plus,
                compact: true,
                loading: _creating,
                onPressed: _loading || _creating ? null : _create,
              ),
              AppButton(
                label: L.common.refresh,
                compact: true,
                variant: AppButtonVariant.secondary,
                onPressed: _loading ? null : _load,
              ),
            ],
          ),
          AppGap.v8,
          Text(
            L.files.membersHelp,
            style: AppText.caption(context, size: 11),
          ),
          AppGap.v10,
          _body(context),
          AppGap.v12,
          Align(
            alignment: Alignment.centerRight,
            child: AppButton(
              label: L.common.save,
              loading: _saving,
              onPressed: _loading ? null : _save,
            ),
          ),
        ],
      ),
    );
  }

  Widget _body(BuildContext context) {
    if (_error != null) {
      return _message(
        context,
        L.files.membersLoadFailed.trParams({'error': '$_error'}),
      );
    }
    if (_loading && _order.isEmpty) {
      return Padding(
        padding: AppInsets.v16,
        child: Center(
          child: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: context.appColors.loomBlue,
            ),
          ),
        ),
      );
    }
    if (_order.isEmpty) {
      return _message(context, L.files.noMatchingFiles);
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 320),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final id in _order)
              _MemberRow(
                label:
                    _catalog[id] ??
                    L.files.fileFallback.trParams({'id': '$id'}),
                selected: _selected.contains(id),
                onChanged: (checked) => setState(
                  () => checked ? _selected.add(id) : _selected.remove(id),
                ),
                onDetach: _selected.contains(id) && !_saving
                    ? () => unawaited(_detach(id))
                    : null,
                onDelete: _saving ? null : () => unawaited(_deleteFile(id)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _message(BuildContext context, String message) {
    return Padding(
      padding: AppInsets.v12,
      child: Text(
        message,
        style: AppText.bodyMuted(context),
      ),
    );
  }
}

class _MemberRow extends StatelessWidget {
  const _MemberRow({
    required this.label,
    required this.selected,
    required this.onChanged,
    this.onDetach,
    this.onDelete,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool> onChanged;
  final VoidCallback? onDetach;
  final VoidCallback? onDelete;

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
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.body(context),
              ),
            ),
            if (onDetach != null)
              AppIconButton(
                icon: LucideIcons.x,
                tooltip: L.files.detach,
                onPressed: onDetach,
              ),
            if (onDelete != null) ...[
              AppGap.h4,
              AppIconButton(
                icon: LucideIcons.trash2,
                tooltip: L.files.deleteFile,
                onPressed: onDelete,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
