import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wonkrumdm/Core/Theme/wonkru_theme.dart';
import 'package:wonkrumdm/Logic/UI/launcher_controller.dart';
import 'package:wonkrumdm/Views/Launcher/Widgets/LaunchHeader/status_badge.dart';

class DateTimeWidget extends StatelessWidget {
  final LauncherController lc;

  const DateTimeWidget({super.key, required this.lc});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final now = lc.currentTime.value;
      final timeStr =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
      final locale = Localizations.localeOf(context);
      final dateStr = locale.languageCode == 'tr'
          ? DateFormat('d MMMM y, EEEE', locale.toString()).format(now)
          : MaterialLocalizations.of(context).formatFullDate(now);
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              timeStr,
              style: WonkruText.body(
                28,
                color: Colors.white,
                weight: FontWeight.w600,
              ).copyWith(height: 1, fontFeatures: [const FontFeature.tabularFigures()]),
            ),
          ),
          const SizedBox(height: 4),
          StatusBadge(icon: const Icon(Icons.calendar_month_outlined, size: 15), label: dateStr),
        ],
      );
    });
  }
}
