import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../Core/Constants/Enums/alert_enums.dart';
import '../../../Core/Constants/Enums/table_enums.dart';
import '../../../Core/L10n/L.dart';
import '../../../Core/Router/app_routes.dart';
import '../../../Logic/Controllers/provisioning_profiles_controller.dart';
import '../../Widgets/Action/run_action.dart';
import '../../Widgets/Table/Cells/cell_action.dart';
import '../../Widgets/Table/Cells/cell_badge.dart';
import '../../Widgets/Table/Cells/cell_date.dart';
import '../../Widgets/Table/Cells/cell_primary.dart';
import '../../Widgets/Table/Cells/cell_text.dart';
import '../../Widgets/Table/app_data_table.dart';
import '../../Widgets/Table/table_column.dart';

class ProvisioningProfilesPage extends StatefulWidget {
  const ProvisioningProfilesPage({super.key});

  @override
  State<ProvisioningProfilesPage> createState() =>
      _ProvisioningProfilesPageState();
}

class _ProvisioningProfilesPageState extends State<ProvisioningProfilesPage> {
  late final ProvisioningProfilesController _controller =
      Get.find<ProvisioningProfilesController>();

  @override
  Widget build(BuildContext context) {
    return AppDataTable<ProvisioningProfile>(
      controller: _controller,
      columns: _columns(context),
      searchHint: L.common.searchName,
      emptyTitle: L.provisioning.emptyTitle,
      emptySubtitle: L.provisioning.emptySubtitle,
      createLabel: L.provisioning.newProfile,
      onCreate: () => _openEditor(context),
      onRowTap: (profile) => _editProfile(context, profile),
    );
  }

  List<AppColumn<ProvisioningProfile>> _columns(BuildContext context) {
    return [
      AppColumn<ProvisioningProfile>(
        title: L.common.name,
        width: 260,
        sortKey: 'name',
        freeze: AppColumnFreeze.start,
        hideable: false,
        cell: (profile) => CellPrimary(title: profile.name),
      ),
      AppColumn<ProvisioningProfile>(
        title: L.common.description,
        width: 320,
        expand: true,
        cell: (profile) => CellText(profile.description, muted: true),
      ),
      AppColumn<ProvisioningProfile>(
        title: L.common.status,
        width: 120,
        sortKey: 'isActive',
        cell: (profile) => CellBadge(
          profile.isActive ? L.common.active : L.common.inactive,
          tone: profile.isActive ? UiAlertTone.success : UiAlertTone.danger,
        ),
      ),
      AppColumn<ProvisioningProfile>(
        title: L.provisioning.updated,
        width: 150,
        sortKey: 'createdAt',
        cell: (profile) => CellDate(profile.updatedAt),
      ),
      AppColumn.actions(
        (profile) => [
          CellAction.edit(() => _editProfile(context, profile)),
          CellAction.delete(() => _delete(context, profile)),
        ],
      ),
    ];
  }

  Future<void> _editProfile(
    BuildContext context,
    ProvisioningProfile profile,
  ) async {
    final id = profile.id;
    if (id == null) return;

    await _openEditor(context, profileId: id);
  }

  Future<void> _openEditor(BuildContext context, {int? profileId}) async {
    await context.push(
      profileId == null
          ? AppRoutes.provisioningProfileNew
          : AppRoutes.provisioningProfile(profileId),
    );
    await _controller.reload();
  }

  Future<void> _delete(
    BuildContext context,
    ProvisioningProfile profile,
  ) async {
    final id = profile.id;
    if (id == null) return;

    await confirmAndRun(
      context,
      title: L.provisioning.deleteTitle,
      message: L.provisioning.deleteConfirm.trParams({'name': profile.name}),
      action: () => _controller.deleteProfile(id),
      success: L.provisioning.deleted,
      failure: L.common.deleteFailed,
    );
  }
}
