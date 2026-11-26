import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../Core/L10n/L.dart';
import '../../../Core/Theme/design.dart';

class TablePager extends StatelessWidget {
  const TablePager({
    super.key,
    required this.pageCount,
    required this.delegate,
    this.controller,
    this.total = 0,
    this.page = 0,
    this.perPage = 20,
    this.onPerPageChanged,
    this.perPageOptions = const [10, 25, 50, 100],
  });

  final int pageCount;
  final DataPagerDelegate delegate;

  /// Keeps [SfDataPager]'s internal page index in sync with external state.
  final DataPagerController? controller;

  final int total;

  final int page;

  final int perPage;
  final ValueChanged<int>? onPerPageChanged;
  final List<int> perPageOptions;

  static const double _itemSize = 32;

  /// Deliberately larger than [_itemSize]: `SfDataPager` adds its own padding
  /// around the buttons, and at a tight height the selected page's circle gets
  /// clipped.
  static const double _pagerHeight = 44;

  bool get _hasPages => pageCount > 1;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    // Built inside LayoutBuilder so that when there's nothing to show, the
    // border and padding are skipped too, leaving no empty strip.
    return LayoutBuilder(
      builder: (context, constraints) {
        // On narrow widths the range text drops first, then the per-page
        // selector; the page buttons always stay visible.
        final showRange = constraints.maxWidth >= 520;
        final showPerPage =
            onPerPageChanged != null && constraints.maxWidth >= 680;

        if (!_hasPages && !showRange && !showPerPage) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s14,
            vertical: AppSpacing.s4,
          ),
          decoration: BoxDecoration(
            color: colors.workshop,
            border: Border(top: BorderSide(color: colors.border)),
          ),
          child: Row(
            children: [
              if (showRange)
                Flexible(
                  child: Text(
                    _rangeLabel(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.bodyMuted(context),
                  ),
                ),
              if (showPerPage) ...[
                AppGap.h16,
                Text(L.common.perPage, style: AppText.bodyMuted(context)),
                AppGap.h8,
                _perPageSelector(context),
              ],
              AppGap.h8,
              // Sizes are explicit: `SfDataPager`'s 50px default overflows the
              // box and clips the selected page's circle.
              if (_hasPages)
                Expanded(
                  child: SizedBox(
                    height: _pagerHeight,
                    child: SfDataPager(
                      pageCount: pageCount.toDouble(),
                      delegate: delegate,
                      controller: controller,
                      visibleItemsCount: 5,
                      itemWidth: _itemSize,
                      itemHeight: _itemSize,
                      navigationItemWidth: _itemSize,
                      navigationItemHeight: _itemSize,
                      itemPadding: EdgeInsets.zero,
                      onPageNavigationEnd: (_) {},
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  String _rangeLabel() {
    if (total <= 0) {
      return L.common.pageNumber.trParams({'page': '${page + 1}'});
    }
    final first = page * perPage + 1;
    final last = ((page + 1) * perPage).clamp(0, total);
    return L.common.range.trParams({
      'total': '$total',
      'first': '$first',
      'last': '$last',
    });
  }

  Widget _perPageSelector(BuildContext context) {
    final colors = context.appColors;

    return PopupMenuButton<int>(
      tooltip: L.common.perPageTooltip,
      position: PopupMenuPosition.over,
      color: colors.workshop,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.r8),
        side: BorderSide(color: colors.border),
      ),
      onSelected: onPerPageChanged,
      itemBuilder: (_) => [
        for (final option in perPageOptions)
          PopupMenuItem<int>(
            value: option,
            height: 34,
            child: Text('$option', style: AppText.body(context)),
          ),
      ],
      child: Container(
        height: 28,
        padding: AppInsets.h10,
        decoration: colors.outlined(radius: AppRadius.r6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$perPage', style: AppText.label(context)),
            AppGap.h4,
            Icon(Icons.expand_more, size: 15, color: colors.graphite),
          ],
        ),
      ),
    );
  }
}
