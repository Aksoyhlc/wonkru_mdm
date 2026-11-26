import 'package:flutter/material.dart';

import '../../../Core/L10n/L.dart';
import '../Input/app_dropdown.dart';

class FilterDropdown extends StatelessWidget {
  const FilterDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  FilterDropdown.ternary({
    super.key,
    required this.label,
    required Object? current,
    required ValueChanged<bool?> onSelected,
    String? allLabel,
    String? trueLabel,
    String? falseLabel,
  }) : value = boolKey(current),
       items = {
         all: allLabel ?? L.common.all,
         'true': trueLabel ?? L.common.yes,
         'false': falseLabel ?? L.common.no,
       },
       onChanged = ((key) => onSelected(boolValue(key)));

  static const all = 'all';

  final String label;
  final String value;
  final Map<String, String> items;
  final ValueChanged<String> onChanged;

  static String boolKey(Object? value) => switch (value) {
    true => 'true',
    false => 'false',
    _ => all,
  };

  static bool? boolValue(String key) => switch (key) {
    'true' => true,
    'false' => false,
    _ => null,
  };

  @override
  Widget build(BuildContext context) {
    return AppDropdown<String>(
      value: value,
      items: items,
      label: label,
      dense: true,
      onChanged: (selected) => onChanged(selected ?? all),
    );
  }
}
