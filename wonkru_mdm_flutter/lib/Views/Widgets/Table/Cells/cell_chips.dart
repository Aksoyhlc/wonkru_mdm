import 'package:flutter/material.dart';

import '../../../../Core/Constants/Enums/alert_enums.dart';
import '../../../../Core/Theme/design.dart';
import '../../Badge/status_badge.dart';

class CellChips extends StatelessWidget {
  const CellChips(
    this.labels, {
    super.key,
    this.tone = UiAlertTone.info,
    this.maxVisible = 2,
    this.emptyText = '—',
  });

  final List<String> labels;
  final UiAlertTone tone;
  final int maxVisible;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    if (labels.isEmpty) {
      return Text(emptyText, style: AppText.cellSecondary(context));
    }

    final visible = labels.take(maxVisible).toList();
    final hidden = labels.skip(maxVisible).toList();

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final label in visible) StatusBadge(label: label, tone: tone),
        if (hidden.isNotEmpty)
          Tooltip(
            message: hidden.join(', '),
            child: StatusBadge(label: '+${hidden.length}', tone: tone),
          ),
      ],
    );
  }
}
