import 'package:flutter/material.dart';

import '../../../Core/Theme/design.dart';

class FadeSwitcher extends StatelessWidget {
  const FadeSwitcher({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final reduced = AppMotion.reduced(context);
    // The tree structure stays fixed across preference changes, preserving form
    // and grid state.
    return AnimatedSwitcher(
      duration: AppMotion.of(context, AppMotion.fast),
      switchInCurve: AppMotion.enter,
      switchOutCurve: AppMotion.exit,
      transitionBuilder: (child, animation) => AnimatedBuilder(
        animation: animation,
        child: child,
        builder: (context, child) {
          final leaving = animation.status == AnimationStatus.reverse;
          return IgnorePointer(
            ignoring: leaving,
            child: ExcludeFocus(
              excluding: leaving,
              child: ExcludeSemantics(
                excluding: leaving,
                child: Opacity(
                  opacity: reduced ? 1 : animation.value,
                  child: child,
                ),
              ),
            ),
          );
        },
      ),
      // Both forms keep their natural height; once the old one disappears
      // AuthCard's AnimatedSize eases down to the new height.
      layoutBuilder: (current, previous) => Stack(
        alignment: Alignment.topCenter,
        children: [if (!reduced) ...previous, ?current],
      ),
      child: child,
    );
  }
}
