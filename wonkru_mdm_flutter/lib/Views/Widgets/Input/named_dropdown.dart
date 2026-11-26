import 'package:flutter/material.dart';

import '../../../Logic/UI/input_controller.dart';
import 'app_dropdown.dart';

/// Generic dropdown bound to a `name` key in `InputController`.
///
/// Contract: the selected value is written to `InputController` as
/// `v.toString()` and the stored value is compared against
/// `entry.key.toString()`. `T.toString()` must therefore be the wire name;
/// serverpod-generated enums provide `toString() => name` (e.g.
/// `SmtpEncryption.none` → `none`). Plain `String` keys behave the same.
class NamedDropdown<T> extends StatelessWidget {
  const NamedDropdown({
    super.key,
    required this.name,
    required this.items,
    this.label,
    this.dense = false,
    this.enabled = true,
    this.fallback,
    this.searchable,
  });

  final String name;
  final Map<T, String> items;
  final String? label;
  final bool dense;
  final bool enabled;
  final T? fallback;

  /// `null` delegates to [AppDropdown]'s automatic threshold.
  final bool? searchable;

  T? _decode() {
    final raw = InputController.to.getValue(name);
    if (raw.isEmpty) return fallback;
    for (final entry in items.entries) {
      if (entry.key.toString() == raw) return entry.key;
    }
    return fallback;
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    final controller = InputController.to.getController(name);
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        // Falling back to the first item keeps the `as T` cast safe when `T`
        // is non-nullable.
        final T value = _decode() ?? fallback ?? items.keys.first;
        return AppDropdown<T>(
          value: value,
          items: items,
          label: label,
          dense: dense,
          enabled: enabled,
          searchable: searchable,
          onChanged: (v) {
            if (v != null) InputController.to.setValue(name, v.toString());
          },
        );
      },
    );
  }
}
