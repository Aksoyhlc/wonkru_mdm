import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../Core/Constants/app_breakpoints.dart';
import '../../../Core/L10n/L.dart';
import '../../../Core/Theme/design.dart';
import '../Button/app_icon_button.dart';
import '../Input/text_controllers_owner.dart';
import '../Search/app_search_field.dart';

class TableToolbar extends StatefulWidget {
  const TableToolbar({
    super.key,
    required this.onSearch,
    required this.onRefresh,
    this.actions = const [],
    this.searchHint,
    this.searchWidth = 300,
    this.showSearch = true,
    this.showRefresh = true,
    this.trailing,
    this.columns = const [],
    this.hiddenColumns = const {},
    this.onColumnToggle,
  });

  final ValueChanged<String> onSearch;
  final VoidCallback onRefresh;
  final List<Widget> actions;
  final String? searchHint;
  final double searchWidth;
  final bool showSearch;
  final bool showRefresh;

  final Widget? trailing;

  final List<String> columns;

  final Set<String> hiddenColumns;

  final void Function(String title, bool visible)? onColumnToggle;

  @override
  State<TableToolbar> createState() => _TableToolbarState();
}

class _TableToolbarState extends State<TableToolbar>
    with TextControllersOwner<TableToolbar> {
  late final _searchController = textController();
  Timer? _searchDebounce;

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(
      const Duration(milliseconds: 300),
      () => widget.onSearch(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final showPicker =
        widget.columns.isNotEmpty && widget.onColumnToggle != null;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s14,
        vertical: AppSpacing.s10,
      ),
      decoration: colors.hairlineBottom(fill: colors.workshop),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < AppBreakpoints.narrow;
          final actions = _actions(context, showPicker: showPicker);

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    if (widget.showSearch) Expanded(child: _search(context)),
                    if (widget.showSearch && widget.showRefresh) AppGap.h8,
                    if (widget.showRefresh) _refresh(),
                  ],
                ),
                if (widget.trailing != null) ...[
                  AppGap.v8,
                  widget.trailing!,
                ],
                if (actions.isNotEmpty) ...[
                  AppGap.v8,
                  Wrap(
                    alignment: WrapAlignment.end,
                    spacing: AppSpacing.s8,
                    runSpacing: AppSpacing.s8,
                    children: actions,
                  ),
                ],
              ],
            );
          }

          return Row(
            children: [
              if (widget.showSearch)
                SizedBox(
                  width: math.min(
                    widget.searchWidth,
                    constraints.maxWidth * 0.4,
                  ),
                  child: _search(context),
                ),
              if (widget.showSearch && widget.showRefresh) AppGap.h8,
              if (widget.showRefresh) _refresh(),
              if (widget.trailing != null) ...[
                AppGap.h8,
                widget.trailing!,
              ],
              AppGap.h16,
              // The column picker and actions are right-aligned as one group. In
              // a horizontal scroll the row is infinitely wide, so right
              // alignment alone doesn't work: the row is widened to at least
              // the visible area and scrolls when it overflows.
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: constraints.maxWidth,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          for (var i = 0; i < actions.length; i++) ...[
                            if (i > 0) AppGap.h8,
                            actions[i],
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _search(BuildContext context) => AppSearchField(
    controller: _searchController,
    onChanged: _onSearchChanged,
    hintText: widget.searchHint,
    showClear: true,
  );

  Widget _refresh() => AppIconButton(
    icon: LucideIcons.refreshCw,
    tooltip: L.common.refresh,
    onPressed: widget.onRefresh,
  );

  List<Widget> _actions(BuildContext context, {required bool showPicker}) => [
    if (showPicker) _columnPicker(context),
    ...widget.actions,
  ];

  Widget _columnPicker(BuildContext context) {
    final colors = context.appColors;

    return PopupMenuButton<String>(
      tooltip: L.common.columns,
      position: PopupMenuPosition.under,
      color: colors.workshop,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.r8),
        side: BorderSide(color: colors.border),
      ),
      // Selection is handled in the item so the menu stays open. Popup items
      // are built once when the menu opens and don't rebuild when the table
      // redraws, so visibility lives in a menu-local copy and each item redraws
      // via its own `setState`.
      itemBuilder: (_) {
        final hidden = {...widget.hiddenColumns};
        return [
          for (final title in widget.columns)
            PopupMenuItem<String>(
              value: title,
              height: 36,
              padding: EdgeInsets.zero,
              child: StatefulBuilder(
                builder: (_, setItemState) {
                  final visible = !hidden.contains(title);
                  return InkWell(
                    onTap: () {
                      setItemState(() {
                        if (visible) {
                          hidden.add(title);
                        } else {
                          hidden.remove(title);
                        }
                      });
                      widget.onColumnToggle!(title, !visible);
                    },
                    child: Padding(
                      padding: AppInsets.h12,
                      child: Row(
                        children: [
                          Icon(
                            visible ? LucideIcons.check : LucideIcons.minus,
                            size: 14,
                            color: visible ? colors.loomBlue : colors.graphite,
                          ),
                          AppGap.h10,
                          Expanded(
                            child: Text(title, style: AppText.body(context)),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ];
      },
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: colors.outlined(radius: AppRadius.r6),
        child: Icon(LucideIcons.columns3, size: 15, color: colors.carbon),
      ),
    );
  }
}
