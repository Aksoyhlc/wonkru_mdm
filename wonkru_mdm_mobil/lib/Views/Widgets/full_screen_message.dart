import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wonkrumdm/Core/Constants/Enums/global.dart';
import 'package:wonkrumdm/Core/Extensions/num.dart';
import 'package:wonkrumdm/Core/Extensions/string.dart';
import 'package:wonkrumdm/Core/Theme/wonkru_theme.dart';
import 'package:wonkrumdm/Views/Widgets/wonkru_backdrop.dart';

class FullScreenMessage extends StatefulWidget {
  FullScreenMessage({
    super.key,
    this.title,
    required this.message,
    this.buttonText,
    this.onTap,
    this.onReady,
    this.back = false,
    this.icon = false,
    this.isLoading = false,
    this.type,
    this.messageFontSize = 16,
    this.titleFontSize = 24,
    this.extras,
  });
  final String? title;
  final String message;
  final String? buttonText;
  final Function()? onTap;
  final Function()? onReady;
  final bool back;
  final bool icon;
  final bool isLoading;
  final MessageType? type;
  final double messageFontSize;
  final double titleFontSize;
  final List<Widget>? extras;

  @override
  State<FullScreenMessage> createState() => _FullScreenMessageState();
}

class _FullScreenMessageState extends State<FullScreenMessage> {
  Color get color {
    switch (widget.type) {
      case MessageType.success:
        return WonkruColors.green;
      case MessageType.info:
        return Colors.white70;
      case MessageType.warning:
        return WonkruColors.accent;
      case MessageType.error:
        return WonkruColors.red;
      default:
        return Colors.white;
    }
  }

  IconData get _icon {
    switch (widget.type) {
      case MessageType.success:
        return Icons.check_circle_outline_rounded;
      case MessageType.error:
        return Icons.error_outline_rounded;
      case MessageType.warning:
        return Icons.warning_amber_rounded;
      case MessageType.info:
        return Icons.info_outline_rounded;
      default:
        return Icons.message_rounded;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.onReady == null) return;
      widget.onReady!();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WonkruColors.bg,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const WonkruBackdrop(),
          SafeArea(
            child: Column(
              children: [
                if (widget.back)
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.arrow_back, color: Colors.white70, size: 22),
                    ),
                  ),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: ZoomIn(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.isLoading) ...[
                              const CircularProgressIndicator(color: WonkruColors.accent),
                              20.hh,
                            ],
                            if (widget.icon) ...[
                              Icon(_icon, color: color, size: 36),
                              16.hh,
                            ],
                            if (widget.title.isNotNullOrEmpty)
                              Text(
                                widget.title!,
                                textAlign: TextAlign.center,
                                style: WonkruText.body(
                                  widget.titleFontSize,
                                  color: Colors.white,
                                  weight: FontWeight.w600,
                                ).copyWith(height: 1.2),
                              ),
                            if (widget.title.isNotNullOrEmpty) 10.hh,
                            Text(
                              widget.message,
                              style: WonkruText.body(widget.messageFontSize, color: Colors.white70).copyWith(height: 1.4),
                              textAlign: TextAlign.center,
                            ),
                            if (widget.buttonText.isNotNullOrEmpty) ...[
                              28.hh,
                              InkWell(
                                onTap: widget.onTap,
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: color == Colors.white ? WonkruColors.accent : color,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 28),
                                  child: Text(
                                    widget.buttonText!,
                                    style: WonkruText.body(14, color: WonkruColors.bg, weight: FontWeight.w600).copyWith(height: 1.2),
                                  ),
                                ),
                              ),
                            ],
                            if (widget.extras != null) ...[
                              16.hh,
                              ...widget.extras!,
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
