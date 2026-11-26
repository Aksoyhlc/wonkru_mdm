import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../Core/Theme/design.dart';

class EnterAnimation extends StatefulWidget {
  const EnterAnimation({
    super.key,
    required this.child,
    this.index = 0,
    this.offset = AppMotion.distance,
    this.duration = AppMotion.slow,
    this.scale = 1,
  });
  final Widget child;
  final int index;
  final double offset;
  final Duration duration;
  final double scale;

  /// Keeps an inner counter/chart from consuming its animation before the card
  /// appears. Read only on first build; a completed entrance is not re-delayed.
  static Duration remainingDelayOf(BuildContext context) =>
      context
          .findAncestorStateOfType<_EnterAnimationState>()
          ?._remainingDelay ??
      Duration.zero;

  @override
  State<EnterAnimation> createState() => _EnterAnimationState();
}

class _EnterAnimationState extends State<EnterAnimation>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: widget.duration + AppMotion.stagger * widget.index,
  );
  bool _started = false;
  Duration get _remainingDelay {
    final delay = AppMotion.stagger * widget.index;
    final elapsed = _controller.duration! * _controller.value;
    return elapsed >= delay ? Duration.zero : delay - elapsed;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (AppMotion.reduced(context)) {
      _started = true;
      _controller.value = 1;
    } else if (!_started) {
      _started = true;
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final delay = AppMotion.of(context, AppMotion.stagger * widget.index);
    return Animate(
      controller: _controller,
      autoPlay: false,
      effects: [
        FadeEffect(
          begin: 0,
          end: 1,
          delay: delay,
          duration: widget.duration,
          curve: AppMotion.enter,
        ),
        MoveEffect(
          begin: Offset(0, widget.offset),
          end: Offset.zero,
          delay: delay,
          duration: widget.duration,
          curve: AppMotion.enter,
        ),
        if (widget.scale != 1)
          ScaleEffect(
            begin: Offset(widget.scale, widget.scale),
            end: const Offset(1, 1),
            delay: delay,
            duration: widget.duration,
            curve: AppMotion.enter,
          ),
      ],
      child: widget.child,
    );
  }
}
