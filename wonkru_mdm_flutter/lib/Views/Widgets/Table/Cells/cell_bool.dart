import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../Core/L10n/L.dart';
import '../../../../Core/Theme/design.dart';

/// When [invert] is true, "yes" is the negative state (e.g. rooted device).
class CellBool extends StatelessWidget {
  const CellBool(
    this.value, {
    super.key,
    this.invert = false,
    this.trueLabel,
    this.falseLabel,
  });

  final bool? value;
  final bool invert;
  final String? trueLabel;
  final String? falseLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    if (value == null) {
      return Icon(LucideIcons.minus, size: 15, color: colors.graphite);
    }

    final positive = invert ? !value! : value!;
    return Tooltip(
      message: value!
          ? (trueLabel ?? L.common.yes)
          : (falseLabel ?? L.common.no),
      child: Icon(
        value! ? LucideIcons.check : LucideIcons.x,
        size: 16,
        color: positive ? colors.success : colors.madder,
      ),
    );
  }
}
