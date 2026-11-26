import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wonkrumdm/Core/Theme/wonkru_theme.dart';

enum PopupPosition { auto, topLeft, topRight, bottomLeft, bottomRight, top, bottom, left, right }

enum PopupAnimationType { fade, scale, slide, scaleAndFade }

class CustomPopupMenuTheme {
  final Color backgroundColor;
  final Color shadowColor;
  final Color textColor;
  final Color iconColor;
  final Color hoverColor;
  final Color disabledColor;
  final double borderRadius;
  final double elevation;
  final EdgeInsets itemPadding;
  final EdgeInsets menuPadding;
  final double itemHeight;
  final double menuWidth;
  final TextStyle textStyle;

  CustomPopupMenuTheme({
    this.backgroundColor = Colors.white,
    this.shadowColor = Colors.black26,
    Color? textColor,
    Color? iconColor,
    this.hoverColor = Colors.grey,
    this.disabledColor = Colors.grey,
    this.borderRadius = 12.0,
    this.elevation = 8.0,
    this.itemPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.menuPadding = EdgeInsets.zero,
    this.itemHeight = 48.0,
    this.menuWidth = 240.0,
    TextStyle? textStyle,
  })  : textColor = textColor ?? WonkruColors.bg,
        iconColor = iconColor ?? WonkruColors.accent,
        textStyle = textStyle ?? WonkruText.body(15, color: WonkruColors.bg, weight: FontWeight.w500);

  factory CustomPopupMenuTheme.dark() {
    return CustomPopupMenuTheme(
      backgroundColor: WonkruColors.bg2,
      textColor: WonkruColors.cream,
      iconColor: WonkruColors.accent,
      hoverColor: WonkruColors.creamFaint,
      textStyle: WonkruText.body(15, color: WonkruColors.cream, weight: FontWeight.w500),
    );
  }
}

class CustomPopupMenuItem {
  final String title;
  final IconData? icon;
  final Widget? customIcon;
  final VoidCallback? onTap;
  final bool enabled;
  final bool isDivider;
  final String? subtitle;
  final Widget? trailing;
  final Color? textColor;
  final Color? iconColor;

  const CustomPopupMenuItem({
    required this.title,
    this.icon,
    this.customIcon,
    this.onTap,
    this.enabled = true,
    this.isDivider = false,
    this.subtitle,
    this.trailing,
    this.textColor,
    this.iconColor,
  });

  const CustomPopupMenuItem.divider()
    : title = '',
      icon = null,
      customIcon = null,
      onTap = null,
      enabled = true,
      isDivider = true,
      subtitle = null,
      trailing = null,
      textColor = null,
      iconColor = null;
}

class PopupMenuConfig {
  final PopupPosition position;
  final PopupAnimationType animationType;
  final Duration animationDuration;
  final CustomPopupMenuTheme theme;
  final bool barrierDismissible;
  final Color? barrierColor;
  final bool useHapticFeedback;
  final EdgeInsets margin;
  final double? maxHeight;
  final bool showArrow;
  final double arrowSize;
  final double? menuWidth;

  PopupMenuConfig({
    this.position = PopupPosition.auto,
    this.animationType = PopupAnimationType.scaleAndFade,
    this.animationDuration = const Duration(milliseconds: 200),
    CustomPopupMenuTheme? theme,
    this.barrierDismissible = true,
    this.barrierColor,
    this.useHapticFeedback = true,
    this.margin = const EdgeInsets.all(8.0),
    this.maxHeight,
    this.showArrow = false,
    this.arrowSize = 8.0,
    this.menuWidth,
  }) : theme = theme ?? CustomPopupMenuTheme();
}

class _PopupMenuWidget extends StatefulWidget {
  final List<CustomPopupMenuItem> items;
  final Offset position;
  final Size buttonSize;
  final PopupMenuConfig config;
  final VoidCallback onDismiss;

  const _PopupMenuWidget({
    required this.items,
    required this.position,
    required this.buttonSize,
    required this.config,
    required this.onDismiss,
  });

  @override
  State<_PopupMenuWidget> createState() => _PopupMenuWidgetState();
}

class _PopupMenuWidgetState extends State<_PopupMenuWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _animationController.forward();

    if (widget.config.useHapticFeedback) {
      HapticFeedback.lightImpact();
    }
  }

  void _setupAnimations() {
    _animationController = AnimationController(duration: widget.config.animationDuration, vsync: this);

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));

    _scaleAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildAnimatedMenu(Widget child) {
    switch (widget.config.animationType) {
      case PopupAnimationType.fade:
        return FadeTransition(opacity: _fadeAnimation, child: child);
      case PopupAnimationType.scale:
        return ScaleTransition(scale: _scaleAnimation, child: child);
      case PopupAnimationType.slide:
        return SlideTransition(position: _slideAnimation, child: child);
      case PopupAnimationType.scaleAndFade:
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(scale: _scaleAnimation, child: child),
        );
    }
  }

  Offset _calculateMenuPosition(Size screenSize, Size menuSize) {
    double x = widget.position.dx;
    double y = widget.position.dy + widget.buttonSize.height;

    if (widget.config.position == PopupPosition.auto) {
      if (x + menuSize.width > screenSize.width - widget.config.margin.right) {
        x = widget.position.dx + widget.buttonSize.width - menuSize.width;
      }

      if (y + menuSize.height > screenSize.height - widget.config.margin.bottom) {
        y = widget.position.dy - menuSize.height;
      }
    } else {
      switch (widget.config.position) {
        case PopupPosition.topLeft:
          x = widget.position.dx;
          y = widget.position.dy - menuSize.height;
          break;
        case PopupPosition.topRight:
          x = widget.position.dx + widget.buttonSize.width - menuSize.width;
          y = widget.position.dy - menuSize.height;
          break;
        case PopupPosition.bottomLeft:
          x = widget.position.dx;
          y = widget.position.dy + widget.buttonSize.height;
          break;
        case PopupPosition.bottomRight:
          x = widget.position.dx + widget.buttonSize.width - menuSize.width;
          y = widget.position.dy + widget.buttonSize.height;
          break;
        case PopupPosition.left:
          x = widget.position.dx - menuSize.width;
          y = widget.position.dy;
          break;
        case PopupPosition.right:
          x = widget.position.dx + widget.buttonSize.width;
          y = widget.position.dy;
          break;
        case PopupPosition.top:
          x = widget.position.dx + (widget.buttonSize.width - menuSize.width) / 2;
          y = widget.position.dy - menuSize.height;
          break;
        case PopupPosition.bottom:
          x = widget.position.dx + (widget.buttonSize.width - menuSize.width) / 2;
          y = widget.position.dy + widget.buttonSize.height;
          break;
        case PopupPosition.auto:
          break;
      }
    }

    x = x.clamp(widget.config.margin.left, screenSize.width - menuSize.width - widget.config.margin.right);
    y = y.clamp(widget.config.margin.top, screenSize.height - menuSize.height - widget.config.margin.bottom);

    return Offset(x, y);
  }

  Widget _buildMenuItem(CustomPopupMenuItem item, int index) {
    if (item.isDivider) {
      return Container(
        height: 1,
        margin: const EdgeInsets.symmetric(vertical: 4),
        color: widget.config.theme.textColor.withOpacity(0.1),
      );
    }

    return _MenuItemWidget(
      item: item,
      theme: widget.config.theme,
      onTap: () {
        if (widget.config.useHapticFeedback) {
          HapticFeedback.selectionClick();
        }
        _animationController.reverse().then((_) {
          widget.onDismiss();
          item.onTap?.call();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final menuWidth = widget.config.menuWidth ?? widget.config.theme.menuWidth;
    final menuSize = Size(menuWidth, widget.items.length * widget.config.theme.itemHeight);

    final menuPosition = _calculateMenuPosition(screenSize, menuSize);

    return Positioned(
      left: menuPosition.dx,
      top: menuPosition.dy,
      child: _buildAnimatedMenu(
        Material(
          elevation: widget.config.theme.elevation,
          shadowColor: widget.config.theme.shadowColor,
          borderRadius: BorderRadius.circular(widget.config.theme.borderRadius),
          child: Container(
            width: menuWidth,
            constraints: widget.config.maxHeight != null ? BoxConstraints(maxHeight: widget.config.maxHeight!) : null,
            padding: widget.config.theme.menuPadding,
            decoration: BoxDecoration(
              color: widget.config.theme.backgroundColor,
              borderRadius: BorderRadius.circular(widget.config.theme.borderRadius),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: widget.items.asMap().entries.map((entry) => _buildMenuItem(entry.value, entry.key)).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuItemWidget extends StatefulWidget {
  final CustomPopupMenuItem item;
  final CustomPopupMenuTheme theme;
  final VoidCallback onTap;

  const _MenuItemWidget({required this.item, required this.theme, required this.onTap});

  @override
  State<_MenuItemWidget> createState() => _MenuItemWidgetState();
}

class _MenuItemWidgetState extends State<_MenuItemWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.item.enabled ? widget.onTap : null,
        borderRadius: BorderRadius.circular(widget.theme.borderRadius),
        child: Container(
          height: widget.theme.itemHeight,
          padding: widget.theme.itemPadding,
          decoration: BoxDecoration(
            color: _isHovered && widget.item.enabled ? widget.theme.hoverColor.withOpacity(0.1) : null,
            borderRadius: BorderRadius.circular(widget.theme.borderRadius),
          ),
          child: Row(
            children: [
              if (widget.item.icon != null || widget.item.customIcon != null) ...[
                SizedBox(
                  width: 24,
                  height: 24,
                  child:
                      widget.item.customIcon ??
                      Icon(
                        widget.item.icon,
                        color: widget.item.enabled
                            ? (widget.item.iconColor ?? widget.theme.iconColor)
                            : widget.theme.disabledColor,
                        size: 22,
                      ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.item.title,
                      style: widget.theme.textStyle.copyWith(
                        color: widget.item.enabled
                            ? (widget.item.textColor ?? widget.theme.textColor)
                            : widget.theme.disabledColor,
                      ),
                    ),
                    if (widget.item.subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        widget.item.subtitle!,
                        style: widget.theme.textStyle.copyWith(
                          fontSize: 12,
                          color: widget.item.enabled
                              ? widget.theme.textColor.withOpacity(0.6)
                              : widget.theme.disabledColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (widget.item.trailing != null) ...[const SizedBox(width: 8), widget.item.trailing!],
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> showCustomPopupMenu({
  required BuildContext context,
  required GlobalKey buttonKey,
  required List<CustomPopupMenuItem> items,
  PopupMenuConfig? config,
}) async {
  final overlay = Overlay.of(context);
  final renderBox = buttonKey.currentContext?.findRenderObject() as RenderBox?;
  final finalConfig = config ?? PopupMenuConfig();

  if (renderBox == null) {
    debugPrint('CustomPopupMenu: Button key context is null');
    return;
  }

  final buttonSize = renderBox.size;
  final buttonPosition = renderBox.localToGlobal(Offset.zero);

  late OverlayEntry overlayEntry;

  void dismissMenu() {
    overlayEntry.remove();
  }

  overlayEntry = OverlayEntry(
    builder: (context) => Stack(
      children: [
        if (finalConfig.barrierDismissible)
          Positioned.fill(
            child: GestureDetector(
              onTap: dismissMenu,
              behavior: HitTestBehavior.translucent,
              child: Container(color: finalConfig.barrierColor ?? Colors.transparent),
            ),
          ),
        _PopupMenuWidget(
          items: items,
          position: buttonPosition,
          buttonSize: buttonSize,
          config: finalConfig,
          onDismiss: dismissMenu,
        ),
      ],
    ),
  );

  overlay.insert(overlayEntry);
}

extension CustomPopupMenuExtension on GlobalKey {
  Future<void> showPopupMenu({
    required BuildContext context,
    required List<CustomPopupMenuItem> items,
    PopupMenuConfig? config,
  }) async {
    await showCustomPopupMenu(context: context, buttonKey: this, items: items, config: config ?? PopupMenuConfig());
  }
}