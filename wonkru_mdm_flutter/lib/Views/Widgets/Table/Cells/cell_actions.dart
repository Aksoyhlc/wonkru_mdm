import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../Core/L10n/L.dart';
import '../../../../Core/Theme/design.dart';
import '../../Menu/app_menu.dart';
import 'cell_action.dart';

/// Row action menu, also used in page headers as the "more" menu.
class CellActions extends StatelessWidget {
  const CellActions({
    super.key,
    required this.actions,
    this.tooltip,
  });

  final List<CellAction> actions;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    if (actions.isEmpty) return const SizedBox.shrink();

    return AppMenu(
      items: actions,
      tooltip: tooltip ?? L.common.actions,
      child: Container(
        width: 28,
        height: 28,
        alignment: Alignment.center,
        decoration: colors.outlined(radius: AppRadius.r6),
        child: Icon(LucideIcons.ellipsis, size: 15, color: colors.graphite),
      ),
    );
  }
}
