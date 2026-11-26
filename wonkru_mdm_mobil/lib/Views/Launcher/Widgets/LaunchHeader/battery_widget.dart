import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wonkrumdm/Core/Theme/wonkru_theme.dart';
import 'package:wonkrumdm/Logic/Common/device_controller.dart';
import 'package:wonkrumdm/Logic/UI/launcher_controller.dart';
import 'package:wonkrumdm/Views/Launcher/Widgets/LaunchHeader/status_badge.dart';

class BatteryWidget extends StatelessWidget {
  final LauncherController lc;

  const BatteryWidget({super.key, required this.lc});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final level = lc.batteryLevel.value;
      final charging = lc.isCharging.value;
      final batteryConfig = DeviceController.to.config.value.batterySettings;
      final critical = batteryConfig?.criticalBatteryThreshold ?? 10;
      final low = batteryConfig?.lowBatteryThreshold ?? 20;

      var color = WonkruColors.accent;
      if (!charging) {
        if (level <= critical) {
          color = WonkruColors.red;
        } else if (level <= low) {
          color = WonkruColors.orange;
        }
      }

      final locale = Localizations.localeOf(context).toString();
      return StatusBadge(
        icon: _BatteryIcon(level: level, charging: charging, color: color),
        label: NumberFormat.percentPattern(locale).format(level / 100),
      );
    });
  }
}

class _BatteryIcon extends StatelessWidget {
  const _BatteryIcon({required this.level, required this.charging, required this.color});

  final int level;
  final bool charging;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: FittedBox(
        child: SizedBox(
          width: 24,
          height: 24,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(size: const Size(24, 16), painter: _BatteryPainter(level, color)),
              if (charging)
                Icon(Icons.bolt_rounded, size: 14, color: level >= 60 ? WonkruColors.bg : Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

class _BatteryPainter extends CustomPainter {
  const _BatteryPainter(this.level, this.color);

  final int level;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    canvas.drawRRect(
      RRect.fromLTRBR(1, 1.5, 21, 14.5, const Radius.circular(2.5)),
      paint
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    paint.style = PaintingStyle.fill;
    canvas.drawRRect(RRect.fromLTRBR(21, 5.5, 24, 10.5, const Radius.circular(1)), paint);
    if (level > 0) {
      canvas.drawRRect(
        RRect.fromLTRBR(
          3.5,
          4,
          3.5 + 15 * level.clamp(0, 100) / 100,
          12,
          const Radius.circular(0.7),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_BatteryPainter oldDelegate) =>
      level != oldDelegate.level || color != oldDelegate.color;
}
