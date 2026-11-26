import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../Core/Constants/Enums/alert_enums.dart';
import '../../../Core/Constants/Enums/table_enums.dart';
import '../../../Core/Errors/server_error_message.dart';
import '../../../Core/L10n/L.dart';
import '../../../Core/Router/app_routes.dart';
import '../../../Logic/Controllers/applications_controller.dart';
import '../../Widgets/Action/run_action.dart';
import '../../Widgets/Alert/app_toast.dart';
import '../../Widgets/Dialog/confirm_dialog.dart';
import '../../Widgets/Table/Cells/cell_action.dart';
import '../../Widgets/Table/Cells/cell_badge.dart';
import '../../Widgets/Table/Cells/cell_primary.dart';
import '../../Widgets/Table/Cells/cell_text.dart';
import '../../Widgets/Table/app_data_table.dart';
import '../../Widgets/Table/export_button.dart';
import '../../Widgets/Table/table_column.dart';
import 'Widgets/application_bulk_actions.dart';
import 'Widgets/application_filters_bar.dart';
import 'Widgets/application_form_dialog.dart';
import 'Widgets/application_form_result.dart';

class ApplicationsPage extends StatefulWidget {
  const ApplicationsPage({super.key});

  @override
  State<ApplicationsPage> createState() => _ApplicationsPageState();
}

class _ApplicationsPageState extends State<ApplicationsPage> {
  late final ApplicationsController _controller =
      Get.find<ApplicationsController>();

  @override
  Widget build(BuildContext context) {
    return AppDataTable<Application>(
      controller: _controller,
      columns: _columns(context),
      searchHint: L.applications.searchHint,
      emptyTitle: L.applications.emptyTitle,
      emptySubtitle: L.applications.emptySubtitle,
      createLabel: L.applications.newApplication,
      onCreate: () => _openForm(context),
      filterBar: ApplicationFiltersBar(controller: _controller),
      rowId: (application) => application.id,
      actions: [
        ExportButton(fileName: 'applications', onExport: _controller.export),
        ApplicationBulkActions(controller: _controller),
      ],
    );
  }

  List<AppColumn<Application>> _columns(BuildContext context) {
    return [
      AppColumn<Application>(
        title: L.common.application,
        width: 280,
        sortKey: 'appName',
        freeze: AppColumnFreeze.start,
        hideable: false,
        cell: (application) => CellPrimary(
          title: application.appName,
          subtitle: application.packageName,
        ),
      ),
      AppColumn<Application>(
        title: L.applications.developer,
        width: 180,
        cell: (application) => CellText(application.developerName),
      ),
      AppColumn<Application>(
        title: L.applications.category,
        width: 150,
        cell: (application) => CellText(application.category),
      ),
      AppColumn<Application>(
        title: L.common.status,
        width: 120,
        cell: (application) => CellBadge(
          application.isSystemApp
              ? L.applications.systemApp
              : L.applications.userApp,
          tone: application.isSystemApp
              ? UiAlertTone.warning
              : UiAlertTone.info,
        ),
      ),
      AppColumn.actions(
        (application) => [
          CellAction.edit(() => _edit(context, application)),
          CellAction(
            label: L.applications.versionsApk,
            icon: LucideIcons.package,
            onTap: () => context.go(
              AppRoutes.applicationVersions(application.id!),
              extra: application,
            ),
          ),
          CellAction.delete(() => _delete(context, application)),
        ],
      ),
    ];
  }

  Future<void> _openForm(BuildContext context) async {
    final result = await showApplicationFormDialog(context);
    if (result == null) return;

    try {
      final created = await _controller.createApplication(result.application);
      final createdId = created.id;

      if (result.hasApk && createdId != null) {
        await _controller.createVersion(result.toVersion(createdId));
        AppToast.show(
          L.applications.createdWithApk,
          tone: UiAlertTone.success,
        );
        return;
      }

      AppToast.show(L.applications.created, tone: UiAlertTone.success);
      if (!context.mounted) return;
      context.go(
        '${AppRoutes.applicationVersions(createdId!)}?upload=1',
        extra: created,
      );
    } on ApplicationConflictException catch (e) {
      if (!context.mounted) return;
      await _handleConflict(context, result, e);
    } catch (e) {
      AppToast.show(
        L.common.saveFailed.trParams({'error': serverErrorMessage(e)}),
        tone: UiAlertTone.danger,
      );
    }
  }

  Future<void> _handleConflict(
    BuildContext context,
    ApplicationFormResult result,
    ApplicationConflictException conflict,
  ) async {
    if (!context.mounted) return;

    final existing = conflict.existingApplication;

    if (existing == null) {
      AppToast.show(
        L.applications.versionCodeExists.trParams({
          'code': '${result.versionCode}',
        }),
        tone: UiAlertTone.warning,
      );
      return;
    }

    if (!result.hasApk) {
      AppToast.show(
        L.applications.duplicatePackageExists.trParams({
          'package': existing.packageName,
          'name': existing.appName,
        }),
        tone: UiAlertTone.warning,
      );
      return;
    }

    final confirmed = await confirmDialog(
      context: context,
      title: L.applications.duplicatePackageTitle,
      message: L.applications.duplicatePackageConfirm.trParams({
        'package': existing.packageName,
        'name': existing.appName,
      }),
    );
    if (confirmed != true) return;

    final existingId = existing.id;
    if (existingId == null) {
      AppToast.show(conflict.message, tone: UiAlertTone.danger);
      return;
    }

    try {
      await _controller.createVersion(result.toVersion(existingId));
      AppToast.show(
        L.applications.duplicatePackageSaved.trParams({
          'name': existing.appName,
        }),
        tone: UiAlertTone.success,
      );
    } on ApplicationConflictException catch (e) {
      AppToast.show(
        e.existingApplication == null
            ? L.applications.versionCodeExists.trParams({
                'code': '${result.versionCode}',
              })
            : e.message,
        tone: UiAlertTone.danger,
      );
    } catch (e) {
      AppToast.show(
        L.common.saveFailed.trParams({'error': serverErrorMessage(e)}),
        tone: UiAlertTone.danger,
      );
    }
  }

  Future<void> _edit(BuildContext context, Application application) async {
    final result = await showApplicationFormDialog(
      context,
      application: application,
    );
    if (result == null) return;

    await runAction(
      () => _controller.updateApplication(result.application),
      success: L.applications.updated,
      failure: L.common.saveFailed,
    );
  }

  Future<void> _delete(BuildContext context, Application application) async {
    final id = application.id;
    if (id == null) return;

    await confirmAndRun(
      context,
      title: L.applications.deleteTitle,
      message: L.applications.deleteConfirm.trParams({
        'name': application.appName,
      }),
      action: () => _controller.deleteApplication(id),
      success: L.applications.deleted,
      failure: L.common.deleteFailed,
    );
  }
}
