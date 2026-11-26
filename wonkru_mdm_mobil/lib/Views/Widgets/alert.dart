import 'package:flutter/material.dart';

import 'package:wonkrumdm/Core/Theme/wonkru_colors.dart';
import 'package:wonkrumdm/Core/Theme/wonkru_text.dart';

class Alert extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color color;
  final VoidCallback? onDismiss;

  const Alert({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    required this.color,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(16, 14, onDismiss != null ? 40 : 16, 14),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: color.withValues(alpha: 0.35)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 20, color: color),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: WonkruText.body(13, color: color, weight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        message,
                        style: WonkruText.body(12, color: Colors.white70).copyWith(height: 1.45),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 3,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
              ),
            ),
          ),
          if (onDismiss != null)
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: onDismiss,
                behavior: HitTestBehavior.opaque,
                child: Icon(Icons.close_rounded, size: 18, color: WonkruColors.grayLight),
              ),
            ),
        ],
      ),
    );
  }
}