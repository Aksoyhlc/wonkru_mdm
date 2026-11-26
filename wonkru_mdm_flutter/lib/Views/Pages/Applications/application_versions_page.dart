import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../Core/Constants/Enums/alert_enums.dart';
import '../../../Core/Constants/Enums/table_enums.dart';
import '../../../Core/Extensions/num.dart';
import '../../../Core/L10n/L.dart';
import '../../../Logic/Controllers/application_versions_controller.dart';
import '../../Widgets/Action/run_action.dart';
import '../../Widgets/Button/app_button.dart';
import '../../Widgets/Button/app_icon_button.dart';
import '../../Widgets/Page/page_header.dart';
import '../../Widgets/Table/Cells/cell_action.dart';
import '../../Widgets/Table/Cells/cell_badge.dart';
import '../../Widgets/Table/Cells/cell_primary.dart';
import '../../Widgets/Table/Cells/cell_text.dart';
import '../../Widgets/Table/app_data_table.dart';
import '../../Widgets/Table/table_column.dart';
import 'Widgets/apk_upload_dialog.dart';
import 'Widgets/version_form_dialog.dart';

class ApplicationVersionsPage extends StatefulWidget {
  const ApplicationVersionsPage({
    super.key,
    required this.application,
    this.openUploadOnStart = false,
  });

  final Application application;

  final bool openUploadOnStart;

  @override
  State<ApplicationVersionsPage> createState() =>
      _ApplicationVersionsPageState();
}

class _ApplicationVersionsPageState extends State<ApplicationVersionsPage> {
  late final ApplicationVersionsController _controller =
      ApplicationVersionsController(widget.application.id ?? 0);

  @override
  void initState() {
    super.initState();
    if (widget.openUploadOnStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _openUpload(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PageHeader(
          title: L.applications.versionsTitle.trParams({
            'name': widget.application.appName,
          }),
          subtitle: widget.application.packageName,
          leading: AppIconButton.back(context),
          actions: [
            AppButton(
              label: L.applications.uploadApk,
              compact: true,
              icon: LucideIcons.upload,
              onPressed: () => _openUpload(context),
            ),
          ],
        ),
        Expanded(
          child: AppDataTable<ApplicationVersion>(
            controller: _controller,
            columns: _columns(context),
            rowId: (version) => version.id,
            searchHint: L.applications.versionSearchHint,
            emptyTitle: L.applications.versionsEmptyTitle,
            emptySubtitle: L.applications.versionsEmptySubtitle,
            emptyActionLabel: L.applications.uploadApk,
            onEmptyAction: () => _openUpload(context),
            onBulkDelete: _controller.deleteSelected,
          ),
        ),
      ],
    );
  }

  List<AppColumn<ApplicationVersion>> _columns(BuildContext context) {
    return [
      AppColumn<ApplicationVersion>(
        title: L.common.version,
        width: 200,
        sortKey: 'versionName',
        freeze: AppColumnFreeze.start,
        hideable: false,
        cell: (version) => CellPrimary(
          title: version.versionName,
          subtitle: L.applications.versionCodeCell.trParams({
            'code': '${version.versionCode}',
          }),
        ),
      ),
      AppColumn<ApplicationVersion>(
        title: L.applications.isDefault,
        width: 120,
        cell: (version) => CellBadge(
          version.isDefault ? L.applications.isDefault : null,
          tone: UiAlertTone.success,
          icon: LucideIcons.star,
        ),
      ),
      AppColumn<ApplicationVersion>(
        title: L.common.status,
        width: 100,
        cell: (version) => CellBadge(
          version.isActive ? L.common.active : L.common.inactive,
          tone: version.isActive ? UiAlertTone.success : UiAlertTone.danger,
        ),
      ),
      AppColumn<ApplicationVersion>(
        title: L.common.size,
        width: 110,
        cell: (version) => CellText(version.fileSizeBytes?.readableBytes),
      ),
      AppColumn<ApplicationVersion>(
        title: L.applications.minTargetSdk,
        width: 150,
        cell: (version) => CellText(
          '${version.minSdkVersion ?? '—'} / ${version.targetSdkVersion ?? '—'}',
        ),
      ),
      AppColumn.actions(
        (version) => [
          CellAction.edit(() => _edit(context, version)),
          CellAction.delete(() => _delete(context, version)),
        ],
      ),
    ];
  }

  Future<void> _openUpload(BuildContext context) async {
    await showApkUploadDialog(
      context,
      application: widget.application,
      controller: _controller,
    );
  }

  Future<void> _edit(BuildContext context, ApplicationVersion version) async {
    final result = await showVersionFormDialog(context, version: version);
    if (result == null) return;

    await runAction(
      () => _controller.updateVersion(result),
      success: L.applications.versionUpdated,
      failure: L.common.saveFailed,
    );
  }

  Future<void> _delete(BuildContext context, ApplicationVersion version) async {
    final id = version.id;
    if (id == null) return;

    await confirmAndRun(
      context,
      title: L.applications.versionDeleteTitle,
      message: L.applications.versionDeleteConfirm.trParams({
        'name': version.versionName,
      }),
      action: () => _controller.deleteVersion(id),
      success: L.applications.versionDeleted,
      failure: L.common.deleteFailed,
    );
  }
}
