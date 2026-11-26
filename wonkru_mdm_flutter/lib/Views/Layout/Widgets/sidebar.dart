import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../Core/Constants/app_sections.dart';
import '../../../Core/L10n/L.dart';
import '../../../Core/Router/app_routes.dart';
import '../../../Core/Theme/design.dart';
import '../../../Logic/Controllers/admin_notifications_controller.dart';
import '../../../Logic/Controllers/device_count_controller.dart';
import '../../Widgets/Brand/app_logo.dart';
import 'sidebar_item.dart';
import 'sidebar_section_label.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({
    super.key,
    required this.navigationShell,
    this.inDrawer = false,
  });

  final bool inDrawer;

  final StatefulNavigationShell navigationShell;

  static const double width = 240;

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  Timer? _unreadTimer;

  @override
  void initState() {
    super.initState();
    unawaited(Get.find<DeviceCountController>().ensureLoaded());
    unawaited(Get.find<AdminNotificationsController>().refreshUnread());
    // Alerts are produced in the background (future calls); refresh the badge
    // periodically while the panel is open.
    _unreadTimer = Timer.periodic(
      const Duration(seconds: 60),
      (_) => unawaited(
        Get.find<AdminNotificationsController>().refreshUnread(),
      ),
    );
  }

  @override
  void dispose() {
    _unreadTimer?.cancel();
    super.dispose();
  }

  void _select(StatefulNavigationShell shell, int index) {
    shell.goBranch(index, initialLocation: index == shell.currentIndex);
    if (widget.inDrawer) Scaffold.of(context).closeDrawer();
    // Keep the badge current across navigation.
    unawaited(Get.find<AdminNotificationsController>().refreshUnread());
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final shell = widget.navigationShell;
    final counts = Get.find<DeviceCountController>();
    return Container(
      width: Sidebar.width,
      decoration: BoxDecoration(
        color: colors.workshop,
        border: Border(right: BorderSide(color: colors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _Brand(),
          SidebarSectionLabel(label: L.common.menu),
          Expanded(
            child: Obx(() {
              // Counts are read inside Obx: reading them lazily inside
              // `itemBuilder` would not register the listener.
              final deviceCount = counts.totalDevices.value;
              final unread = Get.find<AdminNotificationsController>().unreadCount.value;
              final selectedIndex = shell.currentIndex;
              // The highlight and the rows live in the same scrollable content.
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.s8,
                  0,
                  AppSpacing.s8,
                  AppSpacing.s12,
                ),
                child: Stack(
                  children: [
                    if (selectedIndex < appSections.length)
                      AnimatedPositioned(
                        duration: AppMotion.of(context, AppMotion.base),
                        curve: AppMotion.enter,
                        top: selectedIndex * (SidebarItem.height + SidebarItem.gap),
                        left: 0,
                        right: 0,
                        height: SidebarItem.height,
                        child: IgnorePointer(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: colors.selected,
                              borderRadius: BorderRadius.circular(
                                AppRadius.r6,
                              ),
                            ),
                          ),
                        ),
                      ),
                    Column(
                      children: [
                        for (var index = 0; index < appSections.length; index++) ...[
                          if (index > 0) const SizedBox(height: SidebarItem.gap),
                          SidebarItem(
                            section: appSections[index],
                            selected: index == selectedIndex,
                            badge: switch (appSections[index].path) {
                              AppRoutes.devices => deviceCount,
                              AppRoutes.adminNotifications => unread == 0 ? null : unread,
                              _ => null,
                            },
                            onTap: () => _select(shell, index),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.s16,
        18,
        AppSpacing.s16,
        AppSpacing.s16,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: AppLogo(height: 68),
      ),
    );
  }
}
