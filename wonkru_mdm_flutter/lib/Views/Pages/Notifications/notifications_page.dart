import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../Core/Constants/Enums/table_enums.dart';
import '../../../Core/L10n/L.dart';
import '../../../Logic/Controllers/notifications_controller.dart';
import '../../Widgets/Action/run_action.dart';
import '../../Widgets/Button/app_button.dart';
import '../../Widgets/Table/Cells/cell_action.dart';
import '../../Widgets/Table/Cells/cell_badge.dart';
import '../../Widgets/Table/Cells/cell_date.dart';
import '../../Widgets/Table/Cells/cell_primary.dart';
import '../../Widgets/Table/Cells/cell_text.dart';
import '../../Widgets/Table/app_data_table.dart';
import '../../Widgets/Table/table_column.dart';
import 'Widgets/notification_create_dialog.dart';
import 'Widgets/notification_deliveries_dialog.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late final NotificationsController _controller =
      Get.find<NotificationsController>();

  @override
  Widget build(BuildContext context) {
    return AppDataTable<DeviceNotificationRow>(
      controller: _controller,
      columns: _columns(context),
      rowId: (row) => row.notification.id,
      searchHint: L.notifications.searchHint,
      emptyTitle: L.notifications.emptyTitle,
      emptySubtitle: L.notifications.emptySubtitle,
      onBulkDelete: _controller.deleteSelected,
      actions: [
        AppButton(
          label: L.notifications.newNotification,
          compact: true,
          icon: LucideIcons.plus,
          onPressed: () =>
              showNotificationCreateDialog(context, controller: _controller),
        ),
      ],
    );
  }

  List<AppColumn<DeviceNotificationRow>> _columns(BuildContext context) {
    return [
      AppColumn<DeviceNotificationRow>(
        title: L.common.title,
        width: 320,
        freeze: AppColumnFreeze.start,
        hideable: false,
        cell: (row) => CellPrimary(
          title: row.notification.title,
          subtitle: row.notification.message,
        ),
      ),
      AppColumn<DeviceNotificationRow>(
        title: L.common.type,
        width: 110,
        sortKey: 'type',
        cell: (row) => CellBadge(
          NotificationsController.typeLabel(row.notification.type.name),
        ),
      ),
      AppColumn<DeviceNotificationRow>(
        title: L.notifications.columnSent,
        width: 170,
        sortKey: 'sentAt',
        cell: (row) => CellDate(row.notification.sentAt),
      ),
      AppColumn<DeviceNotificationRow>(
        title: L.notifications.columnRecipient,
        width: 90,
        cell: (row) => CellText('${row.deviceCount}'),
      ),
      AppColumn.actions(
        (row) => [
          CellAction(
            label: L.notifications.deliveries,
            icon: LucideIcons.listChecks,
            onTap: () => _showDeliveries(context, row),
          ),
          CellAction.delete(() => _delete(context, row)),
        ],
      ),
    ];
  }

  void _showDeliveries(BuildContext context, DeviceNotificationRow row) {
    final id = row.notification.id;
    if (id == null) return;

    showNotificationDeliveriesDialog(
      context,
      notificationId: id,
      controller: _controller,
    );
  }

  Future<void> _delete(BuildContext context, DeviceNotificationRow row) async {
    final id = row.notification.id;
    if (id == null) return;

    await confirmAndRun(
      context,
      title: L.notifications.deleteTitle,
      message: L.notifications.deleteConfirm,
      action: () => _controller.deleteRow(id),
      success: L.notifications.deleted,
      failure: L.common.deleteFailed,
    );
  }
}
