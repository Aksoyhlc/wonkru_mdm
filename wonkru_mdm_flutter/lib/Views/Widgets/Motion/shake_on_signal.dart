import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../Core/Theme/design.dart';

class ShakeOnSignal extends StatefulWidget {
  const ShakeOnSignal({
    super.key,
    required this.signal,
    required this.child,
    this.offset = AppMotion.distance,
    this.duration = AppMotion.shake,
  });
  final int signal;
  final Widget child;
  final double offset;
  final Duration duration;
  @override
  State<ShakeOnSignal> createState() => _ShakeOnSignalState();
}

class _ShakeOnSignalState extends State<ShakeOnSignal>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
    value: 1,
  );
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (AppMotion.reduced(context)) _controller.value = 1;
  }

  @override
  void didUpdateWidget(ShakeOnSignal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.signal > oldWidget.signal && !AppMotion.reduced(context)) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child
      .animate(controller: _controller, autoPlay: false)
      .shakeX(
        amount: widget.offset,
        duration: widget.duration,
        curve: AppMotion.enter,
      );
}
