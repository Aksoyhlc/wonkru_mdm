import 'package:flutter/material.dart';

import '../../../Core/Extensions/datetime.dart';
import '../../../Logic/Controllers/Base/paged_table_controller.dart';
import '../Input/date_filter_field.dart';

/// A [DateFilterField] bound to [filterKey]: picking stores the start of the
/// day (the end with [endOfDay]), clearing removes the filter.
class TableDateFilter extends StatelessWidget {
  const TableDateFilter({
    super.key,
    required this.name,
    required this.label,
    required this.controller,
    required this.filterKey,
    this.endOfDay = false,
  });

  final String name;
  final String label;
  final PagedTableController<Object?> controller;
  final String filterKey;
  final bool endOfDay;

  DateTime? get _value => controller.filters[filterKey] as DateTime?;

  Future<void> _pick(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _value ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 5, 12, 31),
    );
    if (picked == null) return;

    await controller.setFilter(
      filterKey,
      endOfDay ? picked.endOfDay : picked.startOfDay,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DateFilterField(
      name: name,
      label: label,
      value: _value,
      onPick: () => _pick(context),
      onClear: () => controller.setFilter(filterKey, null),
    );
  }
}
