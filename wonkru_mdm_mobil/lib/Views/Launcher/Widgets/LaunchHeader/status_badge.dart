import 'package:flutter/material.dart';
import 'package:wonkrumdm/Core/Theme/wonkru_theme.dart';

class StatusBadge extends StatelessWidget {
  final Widget icon;
  final String label;

  const StatusBadge({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      alignment: Alignment.centerLeft,
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconTheme.merge(
            data: const IconThemeData(size: 18, color: WonkruColors.accent),
            child: icon,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: WonkruText.body(
              12,
              color: Colors.white70,
              weight: FontWeight.w500,
            ).copyWith(height: 1.2),
          ),
        ],
      ),
    );
  }
}
