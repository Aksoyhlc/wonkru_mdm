import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../Core/L10n/L.dart';
import '../../../Core/Theme/design.dart';
import '../../../Logic/Controllers/admin_notifications_controller.dart';
import '../../Widgets/Button/app_icon_button.dart';
import 'notification_popup.dart';

class NotificationBell extends StatefulWidget {
  const NotificationBell({super.key});

  @override
  State<NotificationBell> createState() => _NotificationBellState();
}

class _NotificationBellState extends State<NotificationBell> {
  final _menu = MenuController();

  /// The bell is 32px wide; the popup's right edge aligns with it.
  static const _anchorWidth = 32.0;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminNotificationsController>();

    return MenuAnchor(
      controller: _menu,
      alignmentOffset: const Offset(
        -(NotificationPopup.width - _anchorWidth),
        8,
      ),
      style: MenuStyle(
        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
        backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
        surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
        elevation: const WidgetStatePropertyAll(0),
        minimumSize: const WidgetStatePropertyAll(Size.zero),
        maximumSize: const WidgetStatePropertyAll(Size.infinite),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.r10),
          ),
        ),
      ),
      menuChildren: [NotificationPopup(onClose: _menu.close)],
      builder: (context, menuController, child) => Obx(() {
        final unread = controller.unreadCount.value;
        return _BellButton(
          unread: controller.unreadLoaded.value ? unread : null,
          onPressed: () {
            // The badge is secondary; open the popup even if the refresh fails.
            controller.refreshUnread();
            controller.loadRecent();
            menuController.open();
          },
        );
      }),
    );
  }
}

class _BellButton extends StatefulWidget {
  const _BellButton({required this.unread, required this.onPressed});

  final int? unread;
  final VoidCallback onPressed;

  @override
  State<_BellButton> createState() => _BellButtonState();
}

class _BellButtonState extends State<_BellButton>
    with SingleTickerProviderStateMixin {
  static const _maxShown = 9;
  late final _controller = AnimationController(
    vsync: this,
    duration: AppMotion.bell,
    value: 1,
  );
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (AppMotion.reduced(context)) _controller.value = 1;
  }

  @override
  void didUpdateWidget(_BellButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.unread != null &&
        widget.unread != null &&
        widget.unread! > oldWidget.unread! &&
        !AppMotion.reduced(context)) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final unread = widget.unread ?? 0;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        AppIconButton(
          icon: LucideIcons.bell,
          iconBuilder: (icon) => icon
              .animate(controller: _controller, autoPlay: false)
              .shake(
                rotation: AppMotion.bellRotation,
                duration: AppMotion.bell,
                curve: AppMotion.enter,
              ),
          tooltip: unread == 0
              ? L.common.notifications
              : L.common.unreadNotifications.trParams({'count': '$unread'}),
          onPressed: widget.onPressed,
        ),
        if (unread > 0)
          Positioned(
            top: -4,
            right: -4,
            child: AnimatedBuilder(
              animation: _controller,
              child: _UnreadBadge(
                count: unread > _maxShown ? '$_maxShown+' : '$unread',
              ),
              builder: (context, child) {
                final t = _controller.value;
                final progress = t < 0.5
                    ? AppMotion.enter.transform(t * 2)
                    : 1 - AppMotion.exit.transform((t - 0.5) * 2);
                return Transform.scale(
                  scale: 1 + (AppMotion.badgeScale - 1) * progress,
                  child: child,
                );
              },
            ),
          ),
      ],
    );
  }
}

class _UnreadBadge extends StatelessWidget {
  const _UnreadBadge({required this.count});

  final String count;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      constraints: const BoxConstraints(minWidth: 16),
      height: 16,
      padding: AppInsets.h4,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.madder,
        borderRadius: BorderRadius.circular(AppRadius.r8),
        border: Border.all(color: colors.workshop, width: 1.5),
      ),
      child: Text(
        count,
        style: AppText.badge(context, colors.workshop).copyWith(fontSize: 10),
      ),
    );
  }
}
