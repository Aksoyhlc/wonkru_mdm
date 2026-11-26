import 'package:flutter/material.dart';

import '../../../Core/Constants/Enums/dialog_enums.dart';
import '../../../Core/Constants/app_breakpoints.dart';
import '../../../Core/Theme/design.dart';
import '../Motion/enter_animation.dart';

/// Shared dialog shell: title (+ optional description), scrollable body and a
/// bottom-right action bar. The body scrolls inside the shell so the actions
/// stay visible on long forms. [maxWidth] overrides [size]. Set [scrollable]
/// only when the content does not manage its own scroller.
class AppDialogShell extends StatelessWidget {
  const AppDialogShell({
    super.key,
    required this.title,
    required this.child,
    this.description,
    this.actions = const [],
    this.size = AppDialogSize.md,
    this.maxWidth,
    this.scrollable = false,
  });

  final String title;

  final String? description;

  final Widget child;
  final List<Widget> actions;
  final AppDialogSize size;

  final double? maxWidth;

  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final viewport = MediaQuery.sizeOf(context);

    return Material(
      color: Colors.transparent,
      child: Center(
        child: EnterAnimation(
          duration: AppMotion.dialog,
          offset: 0,
          scale: AppMotion.dialogScale,
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: viewport.width < AppBreakpoints.narrow
                  ? AppSpacing.s12
                  : AppSpacing.s20,
              vertical: AppSpacing.s24,
            ),
            constraints: BoxConstraints(
              maxWidth: maxWidth ?? size.width,
              maxHeight: viewport.height * 0.86,
            ),
            decoration: BoxDecoration(
              color: colors.workshop,
              borderRadius: BorderRadius.circular(AppRadius.r10),
              border: Border.all(color: colors.border),
              boxShadow: [
                BoxShadow(
                  color: colors.carbon.withValues(alpha: 0.15),
                  offset: const Offset(0, 4),
                  blurRadius: 24,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.s20,
                    18,
                    AppSpacing.s20,
                    0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(title, style: AppText.sectionTitle(context)),
                      if (description != null) ...[
                        AppGap.v4,
                        Text(
                          description!,
                          style: AppText.bodyMuted(context),
                        ),
                      ],
                    ],
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.s20,
                      AppSpacing.s16,
                      AppSpacing.s20,
                      AppSpacing.s4,
                    ),
                    child: scrollable
                        ? SingleChildScrollView(child: child)
                        : child,
                  ),
                ),
                if (actions.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.s20,
                      AppSpacing.s12,
                      AppSpacing.s20,
                      18,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        for (var i = 0; i < actions.length; i++) ...[
                          if (i > 0) AppGap.h10,
                          actions[i],
                        ],
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
