import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Core/Constants/Enums/alert_enums.dart';
import '../../../Core/Theme/design.dart';
import '../../../Logic/UI/app_toast_controller.dart';
import 'ui_alert.dart';

/// Hosts its own [Overlay] so the toast text can be selected.
class AppToastOverlay extends StatelessWidget {
  const AppToastOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppToastController>();
    return Positioned.fill(
      child: Overlay(
        initialEntries: [
          OverlayEntry(
            builder: (_) => Obx(
              () => _Toast(
                visible: controller.visible.value,
                message: controller.message.value,
                tone: controller.tone.value,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Toast extends StatefulWidget {
  const _Toast({
    required this.visible,
    required this.message,
    required this.tone,
  });
  final bool visible;
  final String message;
  final UiAlertTone tone;
  @override
  State<_Toast> createState() => _ToastState();
}

class _ToastState extends State<_Toast> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: AppMotion.base,
    reverseDuration: AppMotion.fast,
  );
  String _message = '';
  UiAlertTone _tone = UiAlertTone.info;
  bool _initialized = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      _update();
    }
    if (AppMotion.reduced(context)) _controller.value = widget.visible ? 1 : 0;
  }

  @override
  void didUpdateWidget(_Toast oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible) {
      _message = widget.message;
      _tone = widget.tone;
    }
    if (oldWidget.visible != widget.visible) _update();
  }

  void _update() {
    if (widget.visible) {
      _message = widget.message;
      _tone = widget.tone;
    }
    if (AppMotion.reduced(context)) {
      _controller.value = widget.visible ? 1 : 0;
    } else if (widget.visible) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _controller,
    builder: (context, _) {
      if (!widget.visible && _controller.isDismissed) {
        return const SizedBox.shrink();
      }
      final value = widget.visible
          ? AppMotion.enter.transform(_controller.value)
          : 1 - AppMotion.exit.transform(1 - _controller.value);
      return Positioned(
        top: AppSpacing.s16,
        right: AppSpacing.s16,
        child: IgnorePointer(
          ignoring: !widget.visible,
          child: Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(
                (1 - value) *
                    (widget.visible
                        ? AppMotion.toastDistance
                        : AppMotion.distance),
                0,
              ),
              child: Material(
                color: Colors.transparent,
                child: SizedBox(
                  width: 360,
                  child: UiAlert(message: _message, tone: _tone, toast: true),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
