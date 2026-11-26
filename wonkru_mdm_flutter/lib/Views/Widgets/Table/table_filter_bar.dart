import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../Core/L10n/L.dart';
import '../../../Core/Theme/design.dart';
import '../Badge/status_badge.dart';

class TableFilterBar extends StatefulWidget {
  const TableFilterBar({
    super.key,
    required this.fields,
    this.activeCount = 0,
    this.onClear,
    this.fieldWidth = 190,
    this.initiallyOpen = false,
  });

  final List<Widget> fields;

  final int activeCount;

  final VoidCallback? onClear;

  final double fieldWidth;

  final bool initiallyOpen;

  @override
  State<TableFilterBar> createState() => _TableFilterBarState();
}

class _TableFilterBarState extends State<TableFilterBar> {
  late bool _open = widget.initiallyOpen;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    if (widget.fields.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: colors.hairlineBottom(fill: colors.workshop),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () => setState(() => _open = !_open),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s14,
                vertical: AppSpacing.s8,
              ),
              child: Row(
                children: [
                  Icon(
                    _open ? LucideIcons.chevronDown : LucideIcons.chevronRight,
                    size: 15,
                    color: colors.graphite,
                  ),
                  AppGap.h6,
                  Icon(
                    LucideIcons.listFilter,
                    size: 15,
                    color: colors.graphite,
                  ),
                  AppGap.h6,
                  Text(L.common.filters, style: AppText.label(context)),
                  if (widget.activeCount > 0) ...[
                    AppGap.h8,
                    StatusBadge(label: '${widget.activeCount}'),
                  ],
                  const Spacer(),
                  if (widget.activeCount > 0 && widget.onClear != null)
                    TextButton.icon(
                      onPressed: widget.onClear,
                      icon: Icon(
                        LucideIcons.x,
                        size: 14,
                        color: colors.graphite,
                      ),
                      label: Text(
                        L.common.clear,
                        style: AppText.label(context),
                      ),
                      style: TextButton.styleFrom(
                        minimumSize: const Size(0, 28),
                        padding: AppInsets.h8,
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (_open)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.s14,
                0,
                AppSpacing.s14,
                AppSpacing.s12,
              ),
              child: Wrap(
                spacing: AppSpacing.s8,
                runSpacing: AppSpacing.s8,
                children: [
                  for (final field in widget.fields)
                    SizedBox(width: widget.fieldWidth, child: field),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
