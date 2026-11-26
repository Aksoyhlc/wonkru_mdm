import 'package:flutter/material.dart';

import 'package:wonkrumdm/Core/Theme/wonkru_colors.dart';
import 'package:wonkrumdm/Core/Theme/wonkru_text.dart';

enum ButtonVariant { primary, secondary, ghost, danger }

class CustomButton extends StatefulWidget {
  final String label;
  final ButtonVariant variant;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool loading;

  const CustomButton({
    super.key,
    required this.label,
    required this.variant,
    this.onTap,
    this.icon,
    this.loading = false,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ac = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 90),
  );
  late final Animation<double> _scale = Tween<double>(
    begin: 1,
    end: 0.97,
  ).animate(CurvedAnimation(parent: _ac, curve: Curves.easeInOut));

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bg = switch (widget.variant) {
      ButtonVariant.primary => WonkruColors.accent,
      ButtonVariant.secondary => Colors.transparent,
      ButtonVariant.ghost => Colors.transparent,
      ButtonVariant.danger => WonkruColors.red,
    };
    final fg = switch (widget.variant) {
      ButtonVariant.primary => WonkruColors.bg,
      ButtonVariant.secondary => Colors.white,
      ButtonVariant.ghost => Colors.white70,
      ButtonVariant.danger => Colors.white,
    };
    final border = switch (widget.variant) {
      ButtonVariant.primary => null,
      ButtonVariant.secondary => Border.all(color: Colors.white38),
      ButtonVariant.ghost => Border.all(color: Colors.white24),
      ButtonVariant.danger => null,
    };

    return GestureDetector(
      onTapDown: (_) => _ac.forward(),
      onTapUp: (_) {
        _ac.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _ac.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: double.infinity,
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: widget.onTap == null ? bg.withValues(alpha: 0.45) : bg,
            border: border,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.loading)
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 1.8, color: fg),
                )
              else if (widget.icon != null)
                Icon(widget.icon, size: 18, color: fg),
              if (widget.icon != null || widget.loading)
                const SizedBox(width: 10),
              Flexible(
                child: Text(
                  widget.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: WonkruText.body(
                    15,
                    color: fg,
                    weight: FontWeight.w500,
                  ).copyWith(letterSpacing: 0.3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
