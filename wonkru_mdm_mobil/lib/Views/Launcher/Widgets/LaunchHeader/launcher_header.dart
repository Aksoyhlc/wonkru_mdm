import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wonkrumdm/Logic/UI/launcher_controller.dart';

import 'date_time_widget.dart';
import 'battery_widget.dart';
import 'ip_address_widget.dart';

class LauncherHeader extends StatelessWidget {
  const LauncherHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final lc = LauncherController.to;

    return Obx(() {
      final config = lc.headerWidgets;
      if (config == null || config.isEmpty) return const SizedBox.shrink();

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black.withOpacity(0.5), Colors.transparent],
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: config.left ? _buildWidget(DateTimeWidget(lc: lc), MainAxisAlignment.start) : const SizedBox.shrink(),
            ),
            Expanded(
              child: config.center ? _buildWidget(const IpAddressWidget(), MainAxisAlignment.center) : const SizedBox.shrink(),
            ),
            Expanded(
              child: config.right ? _buildWidget(BatteryWidget(lc: lc), MainAxisAlignment.end) : const SizedBox.shrink(),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildWidget(Widget child, MainAxisAlignment alignment) {
    return Row(mainAxisAlignment: alignment, children: [
      Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: child),
    ]);
  }
}