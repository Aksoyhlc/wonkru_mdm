import 'package:flutter/material.dart';

import 'package:wonkrumdm/Core/Theme/wonkru_colors.dart';
import 'package:wonkrumdm/Core/Theme/wonkru_text.dart';

class FieldNote extends StatelessWidget {
  final String text;

  const FieldNote(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 2),
        child: Text(text, style: WonkruText.mono(10, color: WonkruColors.grayMid, spacing: 0.06)),
      );
}