import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../Core/L10n/L.dart';
import '../../../Core/Theme/design.dart';

class PermissionList extends StatelessWidget {
  const PermissionList({super.key, this.value});

  /// `ApplicationVersion.permissions` JSON object; null/empty means an empty
  /// list.
  final String? value;

  /// Returns the permission names from the JSON object, sorted alphabetically.
  /// Malformed or empty input yields an empty list; never throws.
  static List<String> namesOf(String? raw) {
    if (raw == null || raw.trim().isEmpty) return const [];

    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map) {
        return [
          for (final key in decoded.keys)
            if ('$key'.isNotEmpty) '$key',
        ]..sort();
      }
    } catch (_) {}

    return const [];
  }

  @override
  Widget build(BuildContext context) {
    final names = namesOf(value);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(L.common.permissions, style: AppText.cellPrimary(context)),
        AppGap.v8,
        if (names.isEmpty)
          Text(
            L.common.noPermissions,
            style: AppText.caption(context, size: 12),
          )
        else
          for (final name in names)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.s6),
              child: Text(name, style: AppText.cellSecondary(context)),
            ),
      ],
    );
  }
}
