import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../Core/Constants/Enums/alert_enums.dart';
import '../../../Core/Extensions/datetime.dart';
import '../../../Core/L10n/L.dart';
import '../../../Core/Router/app_routes.dart';
import '../../../Core/Theme/design.dart';
import '../../../Logic/Controllers/admin_notifications_controller.dart';
import '../../Widgets/Alert/app_toast.dart';
import '../../Widgets/Alert/ui_alert.dart';
import '../../Widgets/Button/app_button.dart';
import '../../Widgets/Loading/app_loader.dart';
import '../../Widgets/Table/Cells/cell_badge.dart';

/// Custom [MenuAnchor] content does not close itself; [onClose] must be called
/// explicitly.
class NotificationPopup extends StatelessWidget {
  const NotificationPopup({super.key, required this.onClose});

  final VoidCallback onClose;

  static const double width = 360;

  static const double maxBodyHeight = 340;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final controller = Get.find<AdminNotificationsController>();

    return Container(
      width: width,
      decoration: colors.outlined(fill: colors.workshop, radius: AppRadius.r10),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _header(context, controller),
          Divider(height: 1, color: colors.border),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: maxBodyHeight),
            child: _body(context, controller),
          ),
          Divider(height: 1, color: colors.border),
          _footer(context, controller),
        ],
      ),
    );
  }

  Widget _header(BuildContext context, AdminNotificationsController c) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
        vertical: AppSpacing.s10,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              L.common.notifications,
              style: AppText.sectionTitle(context),
            ),
          ),
          Obx(() {
            final unread = c.unreadCount.value;
            if (unread == 0) return const SizedBox.shrink();
            return CellBadge(
              L.common.unreadCount.trParams({'count': '$unread'}),
              tone: UiAlertTone.info,
            );
          }),
        ],
      ),
    );
  }

  Widget _body(BuildContext context, AdminNotificationsController c) {
    return Obx(() {
      if (c.recentLoading.value && c.recent.isEmpty) {
        return const Padding(
          padding: AppInsets.all24,
          child: Center(child: AppLoader(size: 22)),
        );
      }

      final error = c.recentError.value;
      if (error != null && c.recent.isEmpty) {
        return Padding(
          padding: AppInsets.all16,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              UiAlert(message: error, tone: UiAlertTone.danger),
              AppGap.v8,
              AppButton(
                label: L.common.retry,
                primary: false,
                compact: true,
                onPressed: () => c.loadRecent(),
              ),
            ],
          ),
        );
      }

      if (c.recent.isEmpty) {
        return Padding(
          padding: AppInsets.all24,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                LucideIcons.bellOff,
                size: 20,
                color: context.appColors.graphite,
              ),
              AppGap.v8,
              Text(
                L.common.noNewNotifications,
                style: AppText.bodyMuted(context),
              ),
            ],
          ),
        );
      }

      // `MenuAnchor` measures its child's intrinsic size, which a lazy
      // `ListView` cannot provide; `SingleChildScrollView` delegates intrinsics
      // to its child.
      return SingleChildScrollView(
        // Do not use the primary scroll controller: sharing the shell's
        // controller makes `Scrollbar` throw because it expects a single position.
        primary: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < c.recent.length; i++) ...[
              if (i > 0) Divider(height: 1, color: context.appColors.border),
              _row(context, c, c.recent[i]),
            ],
          ],
        ),
      );
    });
  }

  Widget _row(
    BuildContext context,
    AdminNotificationsController c,
    AdminNotification row,
  ) {
    final colors = context.appColors;
    final unread = !AdminNotificationsController.isRead(row);

    return InkWell(
      onTap: () => _open(context, c, row),
      child: Container(
        color: unread ? colors.surfaceSubtle : Colors.transparent,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s16,
          vertical: AppSpacing.s10,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Unread dot; its space is reserved when read so text does not shift.
            Padding(
              padding: const EdgeInsets.only(
                top: AppSpacing.s6,
                right: AppSpacing.s8,
              ),
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: unread ? colors.loomBlue : Colors.transparent,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: CellBadge(
                          AdminNotificationsController.typeLabel(row.type),
                          tone: AdminNotificationsController.typeTone(
                            row.type,
                          ),
                        ),
                      ),
                      AppGap.h8,
                      Text(
                        row.createdAt.relativeTr(),
                        style: AppText.caption(context),
                      ),
                    ],
                  ),
                  AppGap.v6,
                  Text(
                    row.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.cellPrimary(context).copyWith(
                      fontWeight: unread ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                  AppGap.v2,
                  Text(
                    row.message,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.cellSecondary(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _open(
    BuildContext context,
    AdminNotificationsController c,
    AdminNotification row,
  ) async {
    onClose();
    if (!AdminNotificationsController.isRead(row)) {
      try {
        await c.markRead([row.id!]);
      } catch (_) {
        AppToast.show(
          L.common.markReadFailed,
          tone: UiAlertTone.danger,
        );
      }
    }
    if (context.mounted) context.go(AppRoutes.adminNotifications);
  }

  /// Buttons stack full-width: a single row clipped the labels.
  Widget _footer(BuildContext context, AdminNotificationsController c) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s10,
        vertical: AppSpacing.s8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() {
            final hasUnread = c.unreadCount.value > 0;
            return AppButton(
              label: L.common.markAllRead,
              primary: false,
              compact: true,
              expand: true,
              onPressed: hasUnread ? () => _markAllRead(c) : null,
            );
          }),
          AppGap.v8,
          AppButton(
            label: L.common.viewAll,
            primary: false,
            compact: true,
            expand: true,
            trailingIcon: LucideIcons.arrowRight,
            onPressed: () {
              onClose();
              context.go(AppRoutes.adminNotifications);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _markAllRead(AdminNotificationsController c) async {
    try {
      final updated = await c.markAllRead();
      AppToast.show(
        updated == 0
            ? L.common.noUnreadNotifications
            : L.common.notificationsMarkedRead.trParams({
                'count': '$updated',
              }),
        tone: UiAlertTone.success,
      );
    } catch (_) {
      AppToast.show(
        L.common.markAllReadFailed,
        tone: UiAlertTone.danger,
      );
    }
  }
}
