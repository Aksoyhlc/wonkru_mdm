import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../Core/Constants/Enums/alert_enums.dart';
import '../../../Core/Constants/Enums/table_enums.dart';
import '../../../Core/L10n/L.dart';
import '../../../Core/Router/app_routes.dart';
import '../../../Logic/Controllers/policies_controller.dart';
import '../../Widgets/Table/Cells/cell_badge.dart';
import '../../Widgets/Table/Cells/cell_copy.dart';
import '../../Widgets/Table/Cells/cell_date.dart';
import '../../Widgets/Table/Cells/cell_primary.dart';
import '../../Widgets/Table/Cells/cell_text.dart';
import '../../Widgets/Table/app_data_table.dart';
import '../../Widgets/Table/export_button.dart';
import '../../Widgets/Table/table_column.dart';
import 'Widgets/policy_actions.dart';
import 'Widgets/policy_filters_bar.dart';

class PoliciesPage extends StatefulWidget {
  const PoliciesPage({super.key});

  @override
  State<PoliciesPage> createState() => _PoliciesPageState();
}

class _PoliciesPageState extends State<PoliciesPage> {
  late final PoliciesController _controller = Get.find<PoliciesController>();

  @override
  Widget build(BuildContext context) {
    return AppDataTable<Policy>(
      controller: _controller,
      columns: _columns(context),
      rowId: (policy) => policy.id,
      searchHint: L.common.searchName,
      emptyTitle: L.policies.emptyTitle,
      emptySubtitle: L.policies.emptySubtitle,
      createLabel: L.policies.newPolicy,
      onCreate: _openEditor,
      filterBar: PolicyFiltersBar(controller: _controller),
      onRowTap: (policy) => context.go(AppRoutes.policy(policy.id!)),
      onBulkDelete: _controller.deleteSelected,
      actions: [
        ExportButton(fileName: 'policies', onExport: _controller.export),
      ],
    );
  }

  void _openEditor() => context.go(AppRoutes.policyNew);

  List<AppColumn<Policy>> _columns(BuildContext context) {
    return [
      AppColumn<Policy>(
        title: L.common.name,
        width: 240,
        sortKey: 'name',
        freeze: AppColumnFreeze.start,
        hideable: false,
        cell: (policy) => CellPrimary(title: policy.name),
      ),
      AppColumn<Policy>(
        title: L.policies.slug,
        width: 220,
        sortKey: 'slug',
        cell: (policy) => CellCopy(policy.slug),
      ),
      AppColumn<Policy>(
        title: L.common.version,
        width: 90,
        cell: (policy) => CellText('v${policy.version}'),
      ),
      AppColumn<Policy>(
        title: L.policies.isDefault,
        width: 120,
        cell: (policy) => CellBadge(
          policy.defaultPolicy ? L.policies.isDefault : null,
          tone: UiAlertTone.success,
          icon: LucideIcons.star,
        ),
      ),
      AppColumn<Policy>(
        title: L.common.active,
        width: 100,
        cell: (policy) => CellBadge(
          policy.isActive ? L.common.active : L.common.inactive,
          tone: policy.isActive ? UiAlertTone.success : UiAlertTone.danger,
        ),
      ),
      AppColumn<Policy>(
        title: L.policies.updatedAt,
        width: 150,
        cell: (policy) => CellDate(policy.updatedAt),
      ),
      AppColumn.actions(
        (policy) => PolicyRowActions(_controller).of(context, policy),
      ),
    ];
  }
}
