import 'package:flutter/material.dart';

import 'package:wonkrumdm/Core/Theme/wonkru_colors.dart';
import 'package:wonkrumdm/Core/Theme/wonkru_text.dart';

class SectionLabel extends StatelessWidget {
  final String label;
  final double fontSize;

  const SectionLabel(this.label, {super.key, this.fontSize = 9});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 24, height: 1, color: WonkruColors.accent),
          const SizedBox(width: 10),
          Text(label.toUpperCase(), style: WonkruText.mono(fontSize, color: WonkruColors.accent, spacing: 0.22)),
        ],
      );
}