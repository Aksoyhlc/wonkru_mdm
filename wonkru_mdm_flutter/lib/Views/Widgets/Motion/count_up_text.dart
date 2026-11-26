import 'dart:async';

import 'package:flutter/material.dart';

import '../../../Core/Theme/design.dart';
import 'enter_animation.dart';

class CountUpText extends StatefulWidget {
  const CountUpText({
    super.key,
    required this.value,
    required this.format,
    required this.style,
  });
  final int? value;
  final String Function(int?) format;
  final TextStyle style;
  @override
  State<CountUpText> createState() => _CountUpTextState();
}

class _CountUpTextState extends State<CountUpText>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: AppMotion.slow,
  );
  double _from = 0;
  double _to = 0;
  bool _initialized = false;
  Timer? _entranceTimer;
  double get _value =>
      _from + (_to - _from) * AppMotion.enter.transform(_controller.value);
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final delay = EnterAnimation.remainingDelayOf(context);
      if (!AppMotion.reduced(context) && delay > Duration.zero) {
        _entranceTimer = Timer(delay, () {
          _entranceTimer = null;
          if (mounted && widget.value != null) _controller.forward(from: 0);
        });
      }
      _retarget();
    }
    if (AppMotion.reduced(context)) {
      _entranceTimer?.cancel();
      _entranceTimer = null;
      _controller.value = 1;
    }
  }

  @override
  void didUpdateWidget(CountUpText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) _retarget();
  }

  void _retarget() {
    _from = _value;
    _to = (widget.value ?? 0).toDouble();
    if (AppMotion.reduced(context) || widget.value == null) {
      _controller.value = 1;
    } else if (_entranceTimer == null) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _entranceTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _controller,
    builder: (context, _) => Text(
      widget.format(widget.value == null ? null : _value.round()),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: widget.style,
    ),
  );
}
