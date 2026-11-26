import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../Core/L10n/L.dart';
import '../../../Core/Theme/design.dart';
import 'text_controllers_owner.dart';

class AppDropdown<T> extends StatefulWidget {
  const AppDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.label,
    this.isExpanded = true,
    this.dense = false,
    this.enabled = true,
    this.searchable,
  });

  final T value;
  final Map<T, String> items;
  final ValueChanged<T?> onChanged;
  final String? label;
  final bool isExpanded;
  final bool dense;
  final bool enabled;

  /// `null` shows the search box automatically once the list is longer than
  /// [searchThreshold]; `true` / `false` force it on / off.
  final bool? searchable;

  /// Item count above which [searchable] `null` turns the search box on.
  static const int searchThreshold = 12;

  @override
  State<AppDropdown<T>> createState() => _AppDropdownState<T>();
}

class _AppDropdownState<T> extends State<AppDropdown<T>>
    with TextControllersOwner<AppDropdown<T>> {
  final _key = GlobalKey();
  late final _search = textController();
  OverlayEntry? _overlay;
  bool _open = false;

  bool get _searchable =>
      widget.searchable ?? widget.items.length > AppDropdown.searchThreshold;

  @override
  void didUpdateWidget(covariant AppDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.enabled) _removeOverlay();
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlay?.remove();
    _overlay = null;
    _open = false;
  }

  void _toggle() {
    if (!widget.enabled) return;
    if (_open) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _select(T? value) {
    _removeOverlay();
    if (!widget.enabled) return;
    widget.onChanged(value);
  }

  void _showOverlay() {
    final box = _key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;

    _search.clear();

    // AppShell nests its own Navigator (and Overlay) in the content area, so
    // global screen coordinates would shift the menu by the sidebar + topbar.
    final overlayState = Overlay.of(context);
    final overlayBox = overlayState.context.findRenderObject() as RenderBox?;
    if (overlayBox == null) return;

    final offset = box.localToGlobal(Offset.zero, ancestor: overlayBox);
    final trigger = offset & box.size;

    _overlay = OverlayEntry(
      builder: (_) {
        return Stack(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => _removeOverlay(),
              child: const SizedBox.expand(),
            ),
            CustomSingleChildLayout(
              delegate: _DropdownLayout(trigger),
              child: Container(
                decoration: BoxDecoration(
                  color: context.appColors.workshop,
                  borderRadius: BorderRadius.circular(AppRadius.r8),
                  border: Border.all(color: context.appColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Material(
                  type: MaterialType.transparency,
                  child: StatefulBuilder(
                    builder: (context, setOverlayState) {
                      final query = _search.text.trim().toLowerCase();
                      final entries = widget.items.entries
                          .where(
                            (entry) =>
                                query.isEmpty ||
                                entry.value.toLowerCase().contains(query),
                          )
                          .toList();

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_searchable)
                            Padding(
                              padding: AppInsets.all6,
                              child: TextField(
                                controller: _search,
                                autofocus: true,
                                style: AppText.body(
                                  context,
                                ).copyWith(fontSize: 13),
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: L.common.search,
                                  hintStyle: AppText.bodyMuted(context),
                                  prefixIcon: Icon(
                                    LucideIcons.search,
                                    size: 14,
                                    color: context.appColors.graphite,
                                  ),
                                  prefixIconConstraints: const BoxConstraints(
                                    minWidth: 30,
                                    minHeight: 24,
                                  ),
                                  suffixIcon: query.isEmpty
                                      ? null
                                      : GestureDetector(
                                          onTap: () {
                                            _search.clear();
                                            setOverlayState(() {});
                                          },
                                          child: Icon(
                                            LucideIcons.x,
                                            size: 14,
                                            color: context.appColors.graphite,
                                          ),
                                        ),
                                  suffixIconConstraints: const BoxConstraints(
                                    minWidth: 30,
                                    minHeight: 24,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: AppSpacing.s8,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.r6,
                                    ),
                                    borderSide: BorderSide(
                                      color: context.appColors.border,
                                    ),
                                  ),
                                ),
                                onChanged: (_) => setOverlayState(() {}),
                              ),
                            ),
                          Flexible(
                            child: SingleChildScrollView(
                              physics: const ClampingScrollPhysics(),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  for (final entry in entries)
                                    GestureDetector(
                                      onTap: () => _select(entry.key),
                                      child: _DropdownItem(
                                        label: entry.value,
                                        selected: entry.key == widget.value,
                                      ),
                                    ),
                                  if (entries.isEmpty)
                                    Padding(
                                      padding: AppInsets.all10,
                                      child: Text(
                                        L.common.notFound,
                                        style: AppText.bodyMuted(context),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    overlayState.insert(_overlay!);
    setState(() => _open = true);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final currentLabel = widget.items[widget.value] ?? widget.value.toString();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: widget.isExpanded
          ? CrossAxisAlignment.stretch
          : CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: EdgeInsets.only(bottom: widget.dense ? 3 : AppSpacing.s6),
            child: SelectableText(
              widget.label!,
              maxLines: 1,
              style: AppText.label(
                context,
              ).copyWith(fontSize: widget.dense ? 11.5 : 13),
            ),
          ),
        GestureDetector(
          key: _key,
          onTap: widget.enabled ? _toggle : null,
          child: Container(
            height: widget.dense ? 30 : 36,
            padding: EdgeInsets.symmetric(
              horizontal: widget.dense ? AppSpacing.s8 : AppSpacing.s10,
            ),
            decoration: BoxDecoration(
              color: widget.enabled ? colors.workshop : colors.muted,
              borderRadius: BorderRadius.circular(
                widget.dense ? AppRadius.r6 : AppRadius.r8,
              ),
              border: Border.all(
                color: _open ? colors.ring : colors.border,
                width: _open ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    currentLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.body(
                      context,
                    ).copyWith(fontSize: widget.dense ? 12.5 : 14),
                  ),
                ),
                AppGap.h4,
                Icon(
                  _open ? LucideIcons.chevronUp : LucideIcons.chevronDown,
                  size: widget.dense ? 14 : 16,
                  color: colors.graphite,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DropdownLayout extends SingleChildLayoutDelegate {
  const _DropdownLayout(this.trigger);

  final Rect trigger;

  static const _margin = AppSpacing.s8;
  static const _gap = AppSpacing.s4;
  static const _maxHeight = 240.0;

  double _spaceAbove(Size size) => (trigger.top - _gap - _margin).clamp(
    0.0,
    math.max(0.0, size.height - _margin * 2),
  );

  double _spaceBelow(Size size) =>
      math.max(0.0, size.height - _margin - trigger.bottom - _gap);

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    final size = constraints.biggest;
    final width = math.min(
      trigger.width,
      math.max(0.0, size.width - _margin * 2),
    );
    return BoxConstraints(
      minWidth: width,
      maxWidth: width,
      maxHeight: math.min(
        _maxHeight,
        math.max(_spaceAbove(size), _spaceBelow(size)),
      ),
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final top = childSize.height <= _spaceBelow(size)
        ? trigger.bottom + _gap
        : trigger.top - _gap - childSize.height;

    return Offset(
      trigger.left.clamp(
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
  bool shouldRelayout(_DropdownLayout oldDelegate) =>
      oldDelegate.trigger != trigger;
}

class _DropdownItem extends StatefulWidget {
  const _DropdownItem({required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  State<_DropdownItem> createState() => _DropdownItemState();
}

class _DropdownItemState extends State<_DropdownItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Material(
      color: Colors.transparent,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s10,
            vertical: AppSpacing.s8,
          ),
          decoration: BoxDecoration(
            color: widget.selected
                ? colors.carbon.withValues(alpha: 0.06)
                : _hovered
                ? colors.muted
                : null,
          ),
          child: Row(
            children: [
              SizedBox(
                width: 16,
                child: widget.selected
                    ? Icon(LucideIcons.check, size: 14, color: colors.carbon)
                    : null,
              ),
              AppGap.h8,
              Expanded(
                child: Text(
                  widget.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.body(context).copyWith(
                    fontWeight: widget.selected
                        ? FontWeight.w500
                        : FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
