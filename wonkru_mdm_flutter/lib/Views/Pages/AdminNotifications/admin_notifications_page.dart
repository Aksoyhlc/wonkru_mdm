import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../Core/Constants/Enums/alert_enums.dart';
import '../../../Core/Constants/Enums/button_enums.dart';
import '../../../Core/Constants/Enums/table_enums.dart';
import '../../../Core/L10n/L.dart';
import '../../../Core/Logging/wlog.dart';
import '../../../Logic/Controllers/admin_notifications_controller.dart';
import '../../Widgets/Alert/app_toast.dart';
import '../../Widgets/Button/app_button.dart';
import '../../Widgets/Table/Cells/cell_action.dart';
import '../../Widgets/Table/Cells/cell_badge.dart';
import '../../Widgets/Table/Cells/cell_date.dart';
import '../../Widgets/Table/Cells/cell_primary.dart';
import '../../Widgets/Table/app_data_table.dart';
import '../../Widgets/Table/table_column.dart';

class AdminNotificationsPage extends StatefulWidget {
  const AdminNotificationsPage({super.key});

  @override
  State<AdminNotificationsPage> createState() => _AdminNotificationsPageState();
}

class _AdminNotificationsPageState extends State<AdminNotificationsPage> {
  late final AdminNotificationsController _controller = Get.find<AdminNotificationsController>();

  @override
  void initState() {
    super.initState();
    unawaited(_controller.refreshUnread());
  }

  @override
  Widget build(BuildContext context) {
    return AppDataTable<AdminNotification>(
      controller: _controller,
      columns: _columns(context),
      emptyTitle: L.notifications.adminEmptyTitle,
      emptySubtitle: L.notifications.adminEmptySubtitle,
      // No server-side title filter; search is hidden to avoid showing a
      // misleading search box.
      showSearch: false,
      actions: [_markAllButton()],
    );
  }

  Widget _markAllButton() {
    return Obx(
      () => AppButton(
        label: L.notifications.markAllRead,
        icon: LucideIcons.checkCheck,
        compact: true,
        variant: AppButtonVariant.secondary,
        onPressed: _controller.unreadCount.value == 0 ? null : () => unawaited(_markAllRead()),
      ),
    );
  }

  List<AppColumn<AdminNotification>> _columns(BuildContext context) {
    return [
      AppColumn<AdminNotification>(
        title: L.notifications.adminColumnAlert,
        width: 380,
        freeze: AppColumnFreeze.start,
        hideable: false,
        cell: (row) => CellPrimary(title: row.title, subtitle: row.message),
      ),
      AppColumn<AdminNotification>(
        title: L.common.type,
        width: 170,
        cell: (row) => CellBadge(
          AdminNotificationsController.typeLabel(row.type),
          tone: AdminNotificationsController.typeTone(row.type),
        ),
      ),
      AppColumn<AdminNotification>(
        title: L.common.status,
        width: 110,
        cell: (row) => AdminNotificationsController.isRead(row)
            ? CellBadge(L.notifications.read, tone: UiAlertTone.success)
            : CellBadge(L.notifications.newBadge, tone: UiAlertTone.info),
      ),
      AppColumn<AdminNotification>(
        title: L.notifications.adminColumnDate,
        width: 180,
        cell: (row) => CellDate(row.createdAt),
      ),
      AppColumn.actions(
        (row) => [
          if (!AdminNotificationsController.isRead(row))
            CellAction(
              label: L.notifications.markRead,
              icon: LucideIcons.checkCheck,
              onTap: () => unawaited(_markRead(row)),
            ),
        ],
      ),
    ];
  }

  Future<void> _markRead(AdminNotification row) async {
    final id = row.id;
    if (id == null) return;

    try {
      await _controller.markRead([id]);
      if (!mounted) return;
      AppToast.show(L.notifications.markedRead, tone: UiAlertTone.success);
    } catch (e) {
      WLog.e('AdminNotifications', 'mark read failed', error: e);
      if (!mounted) return;
      AppToast.show(L.notifications.markFailed, tone: UiAlertTone.danger);
    }
  }

  Future<void> _markAllRead() async {
    try {
      final count = await _controller.markAllRead();
      if (!mounted) return;
      AppToast.show(
        count == 0
            ? L.notifications.noUnreadAlerts
            : (count == 1 ? L.notifications.markedReadAlertsOne : L.notifications.markedReadAlertsMany).trParams({
                'count': '$count',
              }),
        tone: UiAlertTone.success,
      );
    } catch (e) {
      WLog.e('AdminNotifications', 'mark all read failed', error: e);
      if (!mounted) return;
      AppToast.show(L.notifications.markFailed, tone: UiAlertTone.danger);
    }
  }
}
