import 'dart:async';

import 'package:flutter/material.dart';

import '../../../Logic/Controllers/Base/paged_table_controller.dart';
import '../Input/custom_text_field.dart';
import '../Input/text_controllers_owner.dart';

/// Typing sets the trimmed value after a debounce; the box empties when the
/// filter is removed.
class TableTextFilter extends StatefulWidget {
  const TableTextFilter({
    super.key,
    required this.name,
    required this.label,
    required this.controller,
    required this.filterKey,
    this.hint,
    this.keepEmpty = false,
  });

  final String name;
  final String label;
  final PagedTableController<Object?> controller;
  final String filterKey;
  final String? hint;
  final bool keepEmpty;

  @override
  State<TableTextFilter> createState() => _TableTextFilterState();
}

class _TableTextFilterState extends State<TableTextFilter>
    with TextControllersOwner<TableTextFilter> {
  late final _text = textController();
  Timer? _debounce;

  @override
  void didUpdateWidget(covariant TableTextFilter oldWidget) {
    super.didUpdateWidget(oldWidget);
    final cleared = !widget.controller.filters.containsKey(widget.filterKey);
    if (cleared && _debounce?.isActive != true && _text.text.isNotEmpty) {
      _text.clear();
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final trimmed = value.trim();
      widget.controller.setFilter(
        widget.filterKey,
        trimmed.isEmpty && !widget.keepEmpty ? null : trimmed,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      name: widget.name,
      controller: _text,
      label: widget.label,
      hint: widget.hint,
      dense: true,
      showValidationError: false,
      onChanged: _onChanged,
    );
  }
}
