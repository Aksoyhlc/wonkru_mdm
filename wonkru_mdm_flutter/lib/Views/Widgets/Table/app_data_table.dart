import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../Core/Constants/Enums/table_enums.dart';
import '../../../Core/L10n/L.dart';
import '../../../Core/Theme/design.dart';
import '../../../Logic/Controllers/Base/paged_table_controller.dart';
import '../Button/app_button.dart';
import '../EmptyState/empty_state.dart';
import '../EmptyState/error_panel.dart';
import '../Loading/app_loader.dart';
import '../Motion/fade_switcher.dart';
import 'bulk_delete_button.dart';
import 'checkbox_only_selection_manager.dart';
import 'table_column.dart';
import 'table_data_source.dart';
import 'table_pager.dart';
import 'table_skeleton.dart';
import 'table_theme.dart';
import 'table_toolbar.dart';

class AppDataTable<T> extends StatefulWidget {
  const AppDataTable({
    super.key,
    required this.controller,
    required this.columns,
    this.onRowTap,
    this.onSelectionChanged,
    this.rowId,
    this.createLabel,
    this.onCreate,
    this.onBulkDelete,
    this.actions = const [],
    this.selectable = false,
    this.emptyTitle,
    this.emptySubtitle,
    this.emptyActionLabel,
    this.onEmptyAction,
    this.searchHint,
    this.searchWidth = 300,
    this.showSearch = true,
    this.showRefresh = true,
    this.showColumnPicker = true,
    this.toolbarTrailing,
    this.filterBar,
    this.rowHeight = AppSpacing.rowHeight,
  });

  final PagedTableController<T> controller;
  final List<AppColumn<T>> columns;
  final void Function(T row)? onRowTap;
  final void Function(Set<T> rows)? onSelectionChanged;

  /// With it, checked rows are written to the controller's selection as ids
  /// (rows without an id are skipped) and the table becomes selectable.
  final int? Function(T row)? rowId;

  /// A "new" button at the head of [actions]; also the empty state's action
  /// unless [emptyActionLabel]/[onEmptyAction] are given.
  final String? createLabel;
  final VoidCallback? onCreate;

  final Future<int> Function()? onBulkDelete;

  final List<Widget> actions;
  final bool selectable;
  final String? emptyTitle;
  final String? emptySubtitle;
  final String? emptyActionLabel;
  final VoidCallback? onEmptyAction;
  final String? searchHint;
  final double searchWidth;
  final bool showSearch;
  final bool showRefresh;

  final bool showColumnPicker;

  final Widget? toolbarTrailing;

  final Widget? filterBar;

  final double rowHeight;

  @override
  State<AppDataTable<T>> createState() => _AppDataTableState<T>();
}

class _AppDataTableState<T> extends State<AppDataTable<T>> {
  late TableDataSource<T> _source;
  Worker? _rowsWorker;
  Worker? _pageWorker;
  final DataPagerController _pagerController = DataPagerController();
  final Set<int> _selectedIndexes = <int>{};

  final CheckboxOnlySelectionManager _selectionManager =
      CheckboxOnlySelectionManager();

  final Set<String> _hidden = <String>{};

  @override
  void initState() {
    super.initState();
    for (final column in widget.columns) {
      if (!column.visible) _hidden.add(column.title);
    }
    _wireSource();
    _ensureLoaded();
  }

  @override
  void didUpdateWidget(covariant AppDataTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _rowsWorker?.dispose();
      _pageWorker?.dispose();
      _wireSource();
      _ensureLoaded();
    } else if (oldWidget.columns != widget.columns) {
      _source.updateColumns(_visibleColumns);
    }
  }

  void _ensureLoaded() {
    if (widget.controller.hasLoaded) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !widget.controller.hasLoaded) {
        widget.controller.load();
      }
    });
  }

  @override
  void dispose() {
    _rowsWorker?.dispose();
    _pageWorker?.dispose();
    super.dispose();
  }

  void _wireSource() {
    final controller = widget.controller;
    _source = TableDataSource<T>(
      items: List<T>.of(controller.rows),
      columns: _visibleColumns,
      onPageChange: controller.setPage,
    );
    _rowsWorker = ever<List<T>>(controller.rows, (rows) {
      _source.update(rows);
      // The grid's selection drops with new rows; clear it upstream too so a
      // stale "N selected" count isn't shown.
      if (_selectedIndexes.isEmpty) return;
      _selectedIndexes.clear();
      _emitSelection(<T>{});
    });
    _pageWorker = ever<int>(controller.page, (page) {
      _pagerController.selectedPageIndex = page;
    });
  }

  List<AppColumn<T>> get _visibleColumns {
    final shown = widget.columns.where((c) => !_hidden.contains(c.title));
    return [
      ...shown.where((c) => c.freeze == AppColumnFreeze.start),
      ...shown.where((c) => c.freeze == AppColumnFreeze.none),
      ...shown.where((c) => c.freeze == AppColumnFreeze.end),
    ];
  }

  /// Nothing is frozen on the left: `SfDataGrid` freezes a contiguous block from
  /// the left edge, and with a checkbox column that block starts with the
  /// checkbox — freezing the left either pins the checkbox or narrows the
  /// scrollable area. Only the right actions column stays fixed, via
  /// [_frozenEnd].
  int get _frozenStart => 0;

  int get _frozenEnd =>
      _visibleColumns.where((c) => c.freeze == AppColumnFreeze.end).length;

  void _toggleColumn(String title, bool visible) {
    setState(() {
      if (visible) {
        _hidden.remove(title);
      } else {
        _hidden.add(title);
      }
    });
    _source.updateColumns(_visibleColumns);
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    return Obx(() {
      final error = controller.error.value;
      final firstLoad = controller.loading.value && controller.rows.isEmpty;

      final colors = context.appColors;

      return Padding(
        padding: AppInsets.all16,
        child: Container(
          decoration: colors.outlined(fill: colors.workshop),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TableToolbar(
                onSearch: controller.setSearch,
                onRefresh: controller.reload,
                actions: _actions,
                searchHint: widget.searchHint,
                searchWidth: widget.searchWidth,
                showSearch: widget.showSearch,
                showRefresh: widget.showRefresh,
                trailing: widget.toolbarTrailing,
                columns: widget.showColumnPicker
                    ? [
                        for (final column in widget.columns)
                          if (column.hideable) column.title,
                      ]
                    : const [],
                hiddenColumns: _hidden,
                onColumnToggle: _toggleColumn,
              ),
              ?widget.filterBar,
              Expanded(
                child: FadeSwitcher(child: _body(context, firstLoad, error)),
              ),
              if (error == null && controller.rows.isNotEmpty)
                TablePager(
                  pageCount: controller.pageCount,
                  delegate: _source,
                  controller: _pagerController,
                  total: controller.total.value,
                  page: controller.page.value,
                  perPage: controller.pageSize.value,
                  onPerPageChanged: controller.setPageSize,
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget _body(BuildContext context, bool firstLoad, String? error) {
    final controller = widget.controller;

    if (error != null) {
      return ErrorPanel(
        key: const ValueKey('error'),
        message: error,
        onRetry: controller.reload,
      );
    }
    if (firstLoad) {
      return LayoutBuilder(
        key: const ValueKey('loading'),
        builder: (context, constraints) => TableSkeleton(
          widths: _columnWidths(_visibleColumns, constraints.maxWidth),
          rowHeight: widget.rowHeight,
          checkboxWidth: _selectable ? _checkboxWidth : 0,
        ),
      );
    }
    if (controller.rows.isEmpty) {
      return EmptyState(
        key: const ValueKey('empty'),
        title: widget.emptyTitle ?? L.common.notFound,
        subtitle: widget.emptySubtitle,
        actionLabel: widget.emptyActionLabel ?? widget.createLabel,
        onAction: widget.onEmptyAction ?? widget.onCreate,
      );
    }

    return Stack(
      key: const ValueKey('content'),
      children: [
        Positioned.fill(child: _buildGrid(context)),
        if (controller.loading.value)
          Positioned.fill(
            child: IgnorePointer(
              child: ColoredBox(
                color: context.appColors.workshop.withValues(alpha: 0.45),
                child: const Center(child: AppLoader(size: 22)),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildGrid(BuildContext context) {
    final columns = _visibleColumns;
    final colors = context.appColors;

    return LayoutBuilder(
      builder: (context, constraints) {
        final widths = _columnWidths(columns, constraints.maxWidth);

        return SfDataGridTheme(
          data: AppTableTheme.of(context),
          child: SfDataGrid(
            source: _source,
            columns: [
              for (var i = 0; i < columns.length; i++)
                GridColumn(
                  columnName: 'col_$i',
                  width: widths[i],
                  minimumWidth: columns[i].minWidth,
                  allowSorting: false,
                  label: _headerLabel(context, columns[i]),
                ),
            ],
            allowSorting: false,
            allowColumnsResizing: true,
            columnResizeMode: ColumnResizeMode.onResize,
            onColumnResizeUpdate: (_) => true,
            columnWidthMode: ColumnWidthMode.none,
            gridLinesVisibility: GridLinesVisibility.horizontal,
            headerGridLinesVisibility: GridLinesVisibility.horizontal,
            rowHeight: widget.rowHeight,
            headerRowHeight: AppSpacing.headerHeight,
            frozenColumnsCount: _frozenStart,
            footerFrozenColumnsCount: _frozenEnd,
            selectionMode: _selectable
                ? SelectionMode.multiple
                : SelectionMode.none,
            selectionManager: _selectionManager,
            showCheckboxColumn: _selectable,
            checkboxColumnSettings: DataGridCheckboxColumnSettings(
              width: _checkboxWidth,
              backgroundColor: colors.workshop,
            ),
            highlightRowOnHover: true,
            onCellTap: _needsCellTap(columns) ? _handleCellTap : null,
            onSelectionChanged:
                _selectable &&
                    (widget.onSelectionChanged != null || widget.rowId != null)
                ? _handleSelectionChanged
                : null,
          ),
        );
      },
    );
  }

  /// Spreads leftover width to `expand` columns (or, if none, proportionally to
  /// non-frozen columns) so the table fills the page and the actions column
  /// stays right-aligned. If the columns already overflow, widths are kept.
  List<double> _columnWidths(List<AppColumn<T>> columns, double available) {
    final widths = [for (final column in columns) column.width];
    if (available.isInfinite || columns.isEmpty) return widths;

    final usable = available - (_selectable ? _checkboxWidth : 0);
    final total = widths.fold<double>(0, (sum, width) => sum + width);
    final extra = usable - total;
    if (extra <= 1) return widths;

    final targets = <int>[
      for (var i = 0; i < columns.length; i++)
        if (columns[i].expand) i,
    ];
    final fallback = <int>[
      for (var i = 0; i < columns.length; i++)
        if (columns[i].freeze == AppColumnFreeze.none) i,
    ];
    final indexes = targets.isNotEmpty ? targets : fallback;
    if (indexes.isEmpty) return widths;

    final base = indexes.fold<double>(0, (sum, i) => sum + widths[i]);
    for (final i in indexes) {
      widths[i] += extra * (widths[i] / base);
    }
    return widths;
  }

  static const double _checkboxWidth = 44;

  bool _needsCellTap(List<AppColumn<T>> columns) =>
      widget.onRowTap != null || columns.any((column) => column.sortable);

  Widget _headerLabel(BuildContext context, AppColumn<T> column) {
    final colors = context.appColors;
    final sortKey = column.sortKey;
    final active = column.sortable && widget.controller.sortBy.value == sortKey;

    final label = Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.cellPaddingH),
      alignment: column.align,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              column.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.columnHeader(context),
            ),
          ),
          if (column.sortable) ...[
            AppGap.h4,
            Icon(
              active
                  ? (widget.controller.sortAsc.value
                        ? LucideIcons.arrowUp
                        : LucideIcons.arrowDown)
                  : LucideIcons.chevronsUpDown,
              size: 12,
              color: active ? colors.loomBlue : colors.border,
            ),
          ],
        ],
      ),
    );

    if (column.tooltip == null) return label;
    return Tooltip(message: column.tooltip!, child: label);
  }

  static const _headerRowCount = 1;

  void _handleCellTap(DataGridCellTapDetails details) {
    // The grid's row index counts the header row: header is 0, first data row
    // is 1.
    final rowIndex = details.rowColumnIndex.rowIndex - _headerRowCount;

    if (rowIndex < 0) {
      _handleHeaderTap(details.column.columnName);
      return;
    }

    final rows = widget.controller.rows;
    if (rowIndex < rows.length) {
      widget.onRowTap?.call(rows[rowIndex]);
    }
  }

  void _handleHeaderTap(String columnName) {
    // Grid column names are fixed as `col_<index>` (see _buildGrid).
    final columns = _visibleColumns;
    final index = int.tryParse(columnName.replaceFirst('col_', ''));
    if (index == null || index < 0 || index >= columns.length) return;

    final target = columns[index];
    if (!target.sortable) return;

    final controller = widget.controller;
    final key = target.sortKey;
    final ascending = controller.sortBy.value == key
        ? !controller.sortAsc.value
        : true;
    controller.setSort(key, ascending);
  }

  void _handleSelectionChanged(
    List<DataGridRow> addedRows,
    List<DataGridRow> removedRows,
  ) {
    for (final row in addedRows) {
      final index = _indexOf(row);
      if (index != null) _selectedIndexes.add(index);
    }
    for (final row in removedRows) {
      final index = _indexOf(row);
      if (index != null) _selectedIndexes.remove(index);
    }

    final rows = widget.controller.rows;
    _emitSelection({
      for (final index in _selectedIndexes)
        if (index >= 0 && index < rows.length) rows[index],
    });
  }

  void _emitSelection(Set<T> rows) {
    widget.onSelectionChanged?.call(rows);
    final rowId = widget.rowId;
    if (rowId != null) {
      widget.controller.setSelection(rows.map(rowId).whereType<int>().toSet());
    }
  }

  bool get _selectable => widget.selectable || widget.rowId != null;

  List<Widget> get _actions {
    final onCreate = widget.onCreate;
    final onBulkDelete = widget.onBulkDelete;
    final selected = widget.controller.selected;

    return [
      if (widget.createLabel != null && onCreate != null)
        AppButton(
          label: widget.createLabel!,
          compact: true,
          icon: LucideIcons.plus,
          onPressed: onCreate,
        ),
      ...widget.actions,
      if (onBulkDelete != null)
        Obx(
          () => selected.isEmpty
              ? const SizedBox.shrink()
              : BulkDeleteButton(
                  label: L.common.delete,
                  onDelete: onBulkDelete,
                ),
        ),
    ];
  }

  int? _indexOf(DataGridRow row) {
    final cells = row.getCells();
    if (cells.isEmpty) return null;
    final value = cells.first.value;
    return value is String ? int.tryParse(value) : null;
  }
}
