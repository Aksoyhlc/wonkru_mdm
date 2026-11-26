import 'package:flutter/material.dart';

import '../../../../Core/Constants/Enums/alert_enums.dart';
import '../../../../Core/Theme/design.dart';
import '../../Badge/status_badge.dart';
import '../../Motion/pulse_dot.dart';

class CellBadge extends StatelessWidget {
  const CellBadge(
    this.label, {
    super.key,
    this.tone = UiAlertTone.info,
    this.icon,
    this.pulse = false,
  });

  final String? label;
  final UiAlertTone tone;
  final IconData? icon;

  final bool pulse;

  @override
  Widget build(BuildContext context) {
    if (label == null || label!.trim().isEmpty) {
      return Text('—', style: AppText.cellSecondary(context));
    }
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (pulse) ...[
            PulseDot(color: context.appColors.success),
            AppGap.h8,
          ],
          Flexible(
            child: StatusBadge(label: label!, tone: tone, icon: icon),
          ),
        ],
      ),
    );
  }
}
