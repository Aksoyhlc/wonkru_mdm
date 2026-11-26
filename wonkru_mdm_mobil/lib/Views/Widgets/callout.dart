import 'package:flutter/material.dart';

import 'package:wonkrumdm/Core/Theme/wonkru_colors.dart';
import 'package:wonkrumdm/Core/Theme/wonkru_text.dart';

class Callout extends StatelessWidget {
  final String label;
  final String text;

  const Callout({super.key, required this.label, required this.text});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 18, 18, 18),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1F2B),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF2E3444)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('◆  $label'.toUpperCase(), style: WonkruText.mono(9, color: WonkruColors.accent, spacing: 0.2)),
                const SizedBox(height: 10),
                Text(text, style: WonkruText.body(13, color: WonkruColors.creamDim).copyWith(height: 1.65)),
              ],
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 3,
              decoration: const BoxDecoration(
                color: WonkruColors.accent,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}