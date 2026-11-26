import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wonkrumdm/Data/Models/Features/header_widgets_config.dart';
import 'package:wonkrumdm/Logic/UI/launcher_controller.dart';
import 'package:wonkrumdm/Views/Launcher/Widgets/LaunchHeader/battery_widget.dart';
import 'package:wonkrumdm/Views/Launcher/Widgets/LaunchHeader/date_time_widget.dart';
import 'package:wonkrumdm/Views/Launcher/Widgets/LaunchHeader/ip_address_widget.dart';

class LauncherStatusBar extends StatelessWidget {
  const LauncherStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    final lc = LauncherController.to;
    return Obx(() {
      final config = lc.headerWidgets ?? HeaderWidgetsConfig();
      if (config.isEmpty) return const SizedBox.shrink();
      final showDeviceStatus = config.right || config.center;

      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 58,
              child: config.left ? DateTimeWidget(lc: lc) : const SizedBox.shrink(),
            ),
            if (config.left && showDeviceStatus)
              const VerticalDivider(width: 28, thickness: 1, color: Colors.white24),
            if (showDeviceStatus)
              Expanded(
                flex: 42,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (config.right) BatteryWidget(lc: lc),
                    if (config.center && config.right) const SizedBox(height: 6),
                    if (config.center) const IpAddressWidget(),
                  ],
                ),
              ),
          ],
        ),
      );
    });
  }
}
