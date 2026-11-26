import 'package:flutter/material.dart';

import '../../../../Core/Theme/design.dart';

class CellText extends StatelessWidget {
  const CellText(
    this.value, {
    super.key,
    this.muted = false,
    this.mono = false,
    this.align = TextAlign.left,
    this.tooltip,
  });

  final String? value;

  final bool muted;

  final bool mono;

  final TextAlign align;

  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final text = (value == null || value!.trim().isEmpty) ? '—' : value!;
    final style = mono
        ? AppText.mono(muted ? colors.graphite : colors.carbon)
        : (muted
              ? AppText.cellSecondary(context)
              : AppText.cellPrimary(context));

    final label = Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: align,
      style: style,
    );

    if (tooltip == null) return label;
    return Tooltip(message: tooltip!, child: label);
  }
}
