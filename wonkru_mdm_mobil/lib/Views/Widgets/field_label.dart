import 'package:flutter/material.dart';

import 'package:wonkrumdm/Core/Theme/wonkru_text.dart';

class FieldLabel extends StatelessWidget {
  final String label;

  const FieldLabel(this.label, {super.key});

  @override
  Widget build(BuildContext context) => Text(
        label,
        style: WonkruText.body(12, color: Colors.white70, weight: FontWeight.w500).copyWith(height: 1.2),
      );
}