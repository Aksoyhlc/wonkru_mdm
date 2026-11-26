import 'package:flutter/material.dart';

import '../../../Core/Theme/design.dart';

/// Fades the branch in without replacing its existing navigation stack.
class BranchFadeIn extends StatefulWidget {
  const BranchFadeIn({super.key, required this.index, required this.child});
  final int index;
  final Widget child;
  @override
  State<BranchFadeIn> createState() => _BranchFadeInState();
}

class _BranchFadeInState extends State<BranchFadeIn>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: AppMotion.fast,
    value: 1,
  );
  late final _opacity = CurvedAnimation(
    parent: _controller,
    curve: AppMotion.enter,
  );
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (AppMotion.reduced(context)) _controller.value = 1;
  }

  @override
  void didUpdateWidget(BranchFadeIn oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index && !AppMotion.reduced(context)) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _opacity.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      FadeTransition(opacity: _opacity, child: widget.child);
}
