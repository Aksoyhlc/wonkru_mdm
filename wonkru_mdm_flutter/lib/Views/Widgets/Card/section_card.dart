import 'package:flutter/material.dart';

import '../../../Core/Constants/app_breakpoints.dart';
import '../../../Core/Theme/design.dart';

/// The panel's single card shell: optional title row plus content. Use it for
/// page panels and form field groups alike. Without [title] it renders as a
/// plain framed container.
class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    this.title,
    required this.child,
    this.trailing,
    this.padding = const EdgeInsets.all(AppSpacing.cardPadding),
    this.expand = false,
  });

  final String? title;
  final Widget child;

  final Widget? trailing;

  final EdgeInsetsGeometry padding;

  /// Stretches [child] to the remaining height; only valid when the card's
  /// height is bounded from outside (inside an Expanded/SizedBox).
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final body = Padding(padding: padding, child: child);

    return Container(
      decoration: colors.outlined(fill: colors.workshop),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
        children: [
          if (title != null)
            Container(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.cardPadding,
                9,
                AppSpacing.s8,
                9,
              ),
              decoration: colors.hairlineBottom(fill: colors.surfaceSubtle),
              child: _header(context),
            ),
          if (expand) Expanded(child: body) else body,
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    final titleText = Text(title!, style: AppText.cardTitle(context));
    final actions = trailing;
    if (actions == null) return titleText;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < AppBreakpoints.narrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              titleText,
              AppGap.v8,
              Align(alignment: Alignment.centerLeft, child: actions),
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: titleText),
            actions,
          ],
        );
      },
    );
  }
}
