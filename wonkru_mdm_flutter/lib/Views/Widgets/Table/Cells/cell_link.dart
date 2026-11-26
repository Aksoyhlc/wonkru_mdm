import 'package:flutter/material.dart';

import '../../../../Core/Theme/design.dart';

class CellLink extends StatelessWidget {
  const CellLink(this.label, {super.key, this.onTap, this.tooltip});

  final String label;
  final VoidCallback? onTap;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    if (onTap == null) {
      return Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppText.cellPrimary(context),
      );
    }

    final text = Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppText.cellPrimary(context).copyWith(
        color: colors.loomBlue,
        decoration: TextDecoration.underline,
        decorationColor: colors.loomBlue,
      ),
    );

    final link = MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(onTap: onTap, child: text),
    );

    return tooltip == null ? link : Tooltip(message: tooltip!, child: link);
  }
}
