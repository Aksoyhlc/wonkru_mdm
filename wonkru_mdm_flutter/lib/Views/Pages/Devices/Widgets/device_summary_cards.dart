import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../Core/Constants/Enums/alert_enums.dart';
import '../../../../Core/L10n/L.dart';
import '../../../../Core/Theme/design.dart';
import '../../../../Logic/Controllers/devices_controller.dart';
import '../../../Widgets/Card/stat_card.dart';
import '../../../Widgets/Motion/enter_animation.dart';

/// Fleet-wide device counters shown above the devices table.
///
/// The values come from the dashboard endpoints and are independent of the
/// table filters. Tapping a card applies the matching filter to the table.
class DeviceSummaryCards extends StatelessWidget {
  const DeviceSummaryCards({super.key, required this.controller});

  final DevicesController controller;

  static const double _minCardWidth = 210;
  static const double _gap = AppSpacing.s12;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final available = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : _minCardWidth * 4;
        final columns = ((available + _gap) / (_minCardWidth + _gap))
            .floor()
            .clamp(1, 7);
        final width = (available - _gap * (columns - 1)) / columns;

        final cards = _cards();
        return Wrap(
          spacing: _gap,
          runSpacing: _gap,
          children: [
            for (var i = 0; i < cards.length; i++)
              EnterAnimation(
                index: i,
                child: SizedBox(width: width, child: cards[i]),
              ),
          ],
        );
      },
    );
  }

  List<Widget> _cards() {
    return [
      _card(
        label: L.devices.summaryTotal,
        icon: LucideIcons.smartphone,
        tone: UiAlertTone.info,
        value: () => controller.deviceStats.value?.totalDevices,
        onTap: () => unawaited(controller.clearFilters()),
      ),
      _card(
        label: L.devices.summaryOnline,
        icon: LucideIcons.wifi,
        tone: UiAlertTone.success,
        value: () => controller.deviceStats.value?.onlineDevices,
        caption: () {
          final stats = controller.deviceStats.value;
          return stats == null
              ? null
              : L.devices.summaryOnlineCaption.trParams({
                  'minutes': '${stats.onlineMinutes}',
                });
        },
        onTap: () => unawaited(controller.setFilter('isOnline', true)),
      ),
      _card(
        label: L.devices.summaryOffline,
        icon: LucideIcons.wifiOff,
        tone: UiAlertTone.danger,
        value: () => controller.deviceStats.value?.offlineDevices,
        onTap: () => unawaited(controller.setFilter('isOnline', false)),
      ),
      _card(
        label: L.devices.summaryCriticalBattery,
        icon: LucideIcons.batteryLow,
        tone: UiAlertTone.warning,
        value: () => controller.alertStats.value?.criticalBatteryDevices,
        caption: () => L.devices.summaryBatteryCaption,
        onTap: () => unawaited(controller.setFilter('criticalBattery', true)),
      ),
      _card(
        label: L.devices.summaryCriticalStorage,
        icon: LucideIcons.hardDrive,
        tone: UiAlertTone.warning,
        value: () => controller.alertStats.value?.criticalStorageDevices,
        caption: () => L.devices.summaryStorageCaption,
        onTap: () => unawaited(controller.setFilter('criticalStorage', true)),
      ),
      _card(
        label: L.devices.summaryLauncher,
        icon: LucideIcons.layoutGrid,
        tone: UiAlertTone.info,
        value: () => controller.alertStats.value?.launcherModeDevices,
      ),
      _card(
        label: L.devices.summaryRooted,
        icon: LucideIcons.shieldAlert,
        tone: UiAlertTone.danger,
        value: () => controller.alertStats.value?.rootedDevices,
        onTap: () => unawaited(controller.setFilter('isRooted', true)),
      ),
    ];
  }

  Widget _card({
    required String label,
    required IconData icon,
    required UiAlertTone tone,
    required int? Function() value,
    String? Function()? caption,
    VoidCallback? onTap,
  }) {
    return Obx(() {
      final count = value();
      return StatCard(
        label: label,
        value: count?.toString() ?? '—',
        numericValue: count,
        icon: icon,
        tone: tone,
        // Always reserve the caption line so every card has the same height.
        caption: caption?.call() ?? '',
        onTap: onTap,
      );
    });
  }
}
