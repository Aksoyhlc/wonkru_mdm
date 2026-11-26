import 'package:flutter/material.dart';

import '../../../Core/Constants/app_breakpoints.dart';
import '../../../Core/Theme/design.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actions = const [],
    this.leading,
  });

  final String title;
  final String? subtitle;

  final List<Widget> actions;

  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s14,
        vertical: AppSpacing.s10,
      ),
      decoration: colors.hairlineBottom(fill: colors.workshop),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact =
              constraints.maxWidth < AppBreakpoints.narrow &&
              actions.isNotEmpty;

          final titleRow = Row(
            children: [
              if (leading != null) ...[leading!, AppGap.h12],
              Expanded(child: _title(context)),
              if (!compact && actions.isNotEmpty) ...[
                AppGap.h12,
                // Over-wide action groups scroll instead of overflowing.
                // `Flexible` is avoided: it stretched 1:1 with the title and
                // gave half the row to a short button group, leaving it
                // centered. A max-width box keeps the group at its natural
                // width, the title takes the rest, and buttons stay right.
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: constraints.maxWidth * 0.7,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: _spaced(),
                    ),
                  ),
                ),
              ],
            ],
          );

          if (!compact) return titleRow;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              titleRow,
              AppGap.v8,
              Wrap(
                spacing: AppSpacing.s8,
                runSpacing: AppSpacing.s8,
                children: actions,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _title(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppText.pageTitle(context),
      ),
      if (subtitle != null)
        Text(
          subtitle!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppText.cellSecondary(context),
        ),
    ],
  );

  List<Widget> _spaced() => [
    for (var i = 0; i < actions.length; i++) ...[
      if (i > 0) AppGap.h8,
      actions[i],
    ],
  ];
}
