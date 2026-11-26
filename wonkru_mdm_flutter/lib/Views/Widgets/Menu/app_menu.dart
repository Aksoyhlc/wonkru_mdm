import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../Core/Theme/design.dart';
import 'app_menu_item.dart';

/// Panel's dropdown menu: opens a list below the trigger.
///
/// Uses its own overlay instead of Material's `PopupMenuButton` so border,
/// radius, row height and hover color come from the panel tokens rather than
/// Material's defaults. The menu aligns to the trigger's right edge, flipping
/// left or opening above when it would overflow; positions are computed after
/// the menu is measured, so there is no guessing.
class AppMenu extends StatefulWidget {
  const AppMenu({
    super.key,
    required this.items,
    required this.child,
    this.header,
    this.tooltip,
    this.minWidth = 170,
    this.maxWidth = 280,
  });

  /// Menu options. If empty the trigger is still drawn but the menu does not
  /// open.
  final List<AppMenuItem> items;

  final Widget child;

  /// Non-clickable title shown above the list (e.g. the user name).
  final String? header;

  final String? tooltip;

  final double minWidth;
  final double maxWidth;

  static const double itemHeight = 34;

  @override
  State<AppMenu> createState() => _AppMenuState();
}

class _AppMenuState extends State<AppMenu> {
  final _controller = OverlayPortalController();

  Rect _triggerRect = Rect.zero;

  void _toggle() {
    if (_controller.isShowing) {
      _controller.hide();
      return;
    }
    if (widget.items.isEmpty) return;

    final box = context.findRenderObject() as RenderBox?;
    final overlayBox =
        Overlay.of(context).context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize || overlayBox == null) return;

    _triggerRect =
        box.localToGlobal(Offset.zero, ancestor: overlayBox) & box.size;
    _controller.show();
  }

  @override
  Widget build(BuildContext context) {
    final trigger = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _toggle,
      child: widget.child,
    );

    return OverlayPortal(
      controller: _controller,
      overlayChildBuilder: _overlay,
      child: widget.tooltip == null
          ? trigger
          : Tooltip(message: widget.tooltip!, child: trigger),
    );
  }

  Widget _overlay(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _controller.hide,
          ),
        ),
        CustomSingleChildLayout(
          delegate: _AppMenuLayout(_triggerRect),
          child: _card(context),
        ),
      ],
    );
  }

  Widget _card(BuildContext context) {
    final colors = context.appColors;

    return Shortcuts(
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.escape): DismissIntent(),
      },
      child: Actions(
        actions: {
          DismissIntent: CallbackAction<DismissIntent>(
            onInvoke: (_) {
              _controller.hide();
              return null;
            },
          ),
        },
        child: Focus(
          autofocus: true,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: widget.minWidth,
              maxWidth: widget.maxWidth,
            ),
            child: Container(
              padding: AppInsets.v4,
              decoration: BoxDecoration(
                color: colors.workshop,
                borderRadius: BorderRadius.circular(AppRadius.r8),
                border: Border.all(color: colors.border),
                boxShadow: [
                  BoxShadow(
                    color: colors.carbon.withValues(alpha: 0.12),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (widget.header != null) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.cellPaddingH,
                        AppSpacing.s8,
                        AppSpacing.cellPaddingH,
                        AppSpacing.s8,
                      ),
                      child: Text(
                        widget.header!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.cellPrimary(
                          context,
                        ).copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Divider(height: 1, thickness: 1, color: colors.border),
                    AppGap.v4,
                  ],
                  for (final item in widget.items)
                    _AppMenuRow(
                      item: item,
                      onSelected: () {
                        _controller.hide();
                        item.onTap();
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AppMenuRow extends StatefulWidget {
  const _AppMenuRow({required this.item, required this.onSelected});

  final AppMenuItem item;
  final VoidCallback onSelected;

  @override
  State<_AppMenuRow> createState() => _AppMenuRowState();
}

class _AppMenuRowState extends State<_AppMenuRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final item = widget.item;
    final foreground = item.danger ? colors.madder : colors.carbon;

    return MouseRegion(
      cursor: item.enabled
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: item.enabled ? widget.onSelected : null,
        child: Opacity(
          opacity: item.enabled ? 1 : 0.45,
          child: Container(
            height: AppMenu.itemHeight,
            color: _hovered && item.enabled
                ? colors.surfaceSubtle
                : Colors.transparent,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.cellPaddingH,
            ),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  size: 15,
                  color: item.danger ? colors.madder : colors.graphite,
                ),
                AppGap.h10,
                Expanded(
                  child: Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.body(context).copyWith(color: foreground),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AppMenuLayout extends SingleChildLayoutDelegate {
  const _AppMenuLayout(this.trigger);

  final Rect trigger;

  static const double _margin = AppSpacing.s8;

  static const double _gap = AppSpacing.s4;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      BoxConstraints.loose(
        Size(
          constraints.maxWidth - _margin * 2,
          constraints.maxHeight - _margin * 2,
        ),
      );

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final fitsBelow =
        trigger.bottom + _gap + childSize.height <= size.height - _margin;
    final top = fitsBelow
        ? trigger.bottom + _gap
        : trigger.top - _gap - childSize.height;

    final left = trigger.right - childSize.width;

    return Offset(
      left.clamp(
        _margin,
        math.max(_margin, size.width - childSize.width - _margin),
      ),
      top.clamp(
        _margin,
        math.max(_margin, size.height - childSize.height - _margin),
      ),
    );
  }

  @override
  bool shouldRelayout(_AppMenuLayout oldDelegate) =>
      oldDelegate.trigger != trigger;
}
