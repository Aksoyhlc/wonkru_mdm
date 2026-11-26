import 'package:flutter/material.dart';

import '../../../Core/Constants/Enums/button_enums.dart';
import '../../../Core/L10n/L.dart';
import '../../../Core/Theme/design.dart';

/// Off the spacing scale on purpose: tuned to the icon's optical width.
const _iconGap = SizedBox(width: 7);

class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.onAsync,
    this.primary = true,
    this.danger = false,
    this.variant,
    this.expand = false,
    this.icon,
    this.trailingIcon,
    this.compact = false,
    this.loading = false,
    this.tooltip,
    this.fontSize,
    this.iconSize,
  });

  factory AppButton.cancel(
    BuildContext context, {
    String? label,
    Object? result,
    bool enabled = true,
    bool compact = false,
  }) => AppButton(
    label: label ?? L.common.cancel,
    variant: AppButtonVariant.secondary,
    compact: compact,
    onPressed: enabled ? () => Navigator.pop(context, result) : null,
  );

  final String label;
  final VoidCallback? onPressed;

  /// Async alternative to [onPressed]: the button shows its loader and ignores
  /// taps until the future completes.
  final Future<void> Function()? onAsync;

  final bool primary;
  final bool danger;
  final AppButtonVariant? variant;
  final bool expand;
  final IconData? icon;
  final IconData? trailingIcon;
  final bool compact;
  final bool loading;
  final String? tooltip;
  final double? fontSize;
  final double? iconSize;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _hover = false;
  bool _running = false;

  bool get _loading => widget.loading || _running;

  VoidCallback? get _onTap {
    final onAsync = widget.onAsync;
    if (onAsync == null) return widget.onPressed;

    return () async {
      setState(() => _running = true);
      try {
        await onAsync();
      } finally {
        if (mounted) setState(() => _running = false);
      }
    };
  }

  static Color _onColor(Color dark, Color background) =>
      background.computeLuminance() > 0.5 ? dark : Colors.white;

  AppButtonVariant get _variant {
    if (widget.variant != null) return widget.variant!;
    if (widget.danger) return AppButtonVariant.danger;
    if (widget.primary) return AppButtonVariant.primary;
    return AppButtonVariant.secondary;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final onTap = _onTap;
    final enabled = onTap != null && !_loading;
    final variant = _variant;

    late Color bg;
    late Color fg;
    late Color border;
    switch (variant) {
      case AppButtonVariant.primary:
        bg = enabled
            ? (_hover
                  ? Color.lerp(colors.loomBlue, colors.carbon, 0.12)!
                  : colors.loomBlue)
            : colors.muted;
        fg = enabled
            ? Theme.of(context).colorScheme.onPrimary
            : colors.graphite;
        border = bg;
      case AppButtonVariant.secondary:
        bg = enabled ? (_hover ? colors.muted : colors.workshop) : colors.muted;
        fg = colors.carbon;
        border = colors.border;
      case AppButtonVariant.ghost:
        bg = enabled && _hover ? colors.muted : Colors.transparent;
        fg = colors.carbon;
        border = Colors.transparent;
      case AppButtonVariant.danger:
        bg = enabled
            ? (_hover ? colors.madder.withValues(alpha: 0.9) : colors.madder)
            : colors.muted;
        fg = Colors.white;
        border = bg;
      case AppButtonVariant.carbon:
        bg = enabled
            ? (_hover ? colors.carbon.withValues(alpha: 0.85) : colors.carbon)
            : colors.muted;
        fg = enabled ? _onColor(colors.porcelain, bg) : colors.graphite;
        border = bg;
    }

    final label = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_loading)
          SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(strokeWidth: 1.8, color: fg),
          )
        else if (widget.icon != null)
          Icon(widget.icon, size: widget.iconSize ?? 16, color: fg),
        if (_loading || widget.icon != null) _iconGap,
        Flexible(
          child: Text(
            widget.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.button(context, fg).copyWith(
              fontSize: widget.fontSize ?? 13,
              fontWeight: FontWeight.w500,
              height: 1,
            ),
          ),
        ),
        if (widget.trailingIcon != null) ...[
          _iconGap,
          Icon(widget.trailingIcon, size: widget.iconSize ?? 15, color: fg),
        ],
      ],
    );

    final child = AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      height: widget.compact ? 32 : 38,
      width: widget.expand ? double.infinity : null,
      padding: EdgeInsets.symmetric(
        horizontal: widget.compact ? AppSpacing.s10 : AppSpacing.s14,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.r8),
        border: Border.all(color: border),
      ),
      child: Align(
        alignment: Alignment.center,
        widthFactor: widget.expand ? null : 1,
        child: label,
      ),
    );

    final button = MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.r8),
          onTap: enabled ? onTap : null,
          child: child,
        ),
      ),
    );
    return widget.tooltip == null
        ? button
        : Tooltip(message: widget.tooltip!, child: button);
  }
}
