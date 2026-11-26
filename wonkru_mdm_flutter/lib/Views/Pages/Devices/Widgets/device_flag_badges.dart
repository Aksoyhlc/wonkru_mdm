import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../Core/Constants/Enums/alert_enums.dart';
import '../../../../Core/Theme/design.dart';
import '../../../Widgets/Badge/status_badge.dart';

/// Renders a row of true/false status flags, skipping null values.
///
/// Each entry is `(label, value, negativeWhenTrue)`: when the third element is
/// true, a `true` value is shown as danger instead of success.
class DeviceFlagBadges extends StatelessWidget {
  const DeviceFlagBadges({super.key, required this.flags});

  final List<(String, bool?, bool)> flags;

  @override
  Widget build(BuildContext context) {
    final badges = <Widget>[];

    for (final (label, value, negativeWhenTrue) in flags) {
      if (value == null) continue;
      final isNegative = negativeWhenTrue ? value : !value;
      badges.add(
        StatusBadge(
          label: label,
          tone: isNegative ? UiAlertTone.danger : UiAlertTone.success,
          icon: value ? LucideIcons.check : LucideIcons.x,
        ),
      );
    }

    if (badges.isEmpty) return Text('—', style: AppText.body(context));

    return Wrap(spacing: 4, runSpacing: 4, children: badges);
  }
}
