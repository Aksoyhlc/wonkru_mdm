import 'package:flutter/widgets.dart';

class AppMenuItem {
  const AppMenuItem({
    required this.label,
    required this.icon,
    required this.onTap,
    this.danger = false,
    this.enabled = true,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  /// Destructive action (delete, sign out); shown in red in the menu.
  final bool danger;

  final bool enabled;
}
