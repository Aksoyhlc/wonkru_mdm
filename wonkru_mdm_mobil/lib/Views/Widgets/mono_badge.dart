import 'package:flutter/material.dart';

import 'package:wonkrumdm/Core/Theme/wonkru_colors.dart';
import 'package:wonkrumdm/Core/Theme/wonkru_text.dart';

class MonoBadge extends StatelessWidget {
  final String label;
  final IconData icon;

  const MonoBadge({super.key, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: WonkruColors.accent.withValues(alpha: 0.8)),
          const SizedBox(width: 8),
          Text(
            label,
            style: WonkruText.body(12, color: Colors.white54, weight: FontWeight.w500).copyWith(height: 1.2),
          ),
        ],
      );
}