import 'package:flutter/material.dart';

import '../../../Core/Constants/Enums/alert_enums.dart';
import '../../../Core/Theme/design.dart';
import '../Badge/status_badge.dart';

class SectionFlags extends StatelessWidget {
  const SectionFlags(this.flags, {super.key});

  final List<String> flags;

  @override
  Widget build(BuildContext context) {
    if (flags.isEmpty) return Text('—', style: AppText.bodyMuted(context));

    return Wrap(
      spacing: AppSpacing.s6,
      runSpacing: AppSpacing.s4,
      children: [
        for (final flag in flags)
          StatusBadge(label: flag, tone: UiAlertTone.info),
      ],
    );
  }
}
