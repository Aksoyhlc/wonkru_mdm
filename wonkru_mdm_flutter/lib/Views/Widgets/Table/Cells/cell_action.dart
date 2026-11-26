import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../Core/L10n/L.dart';
import '../../Menu/app_menu_item.dart';

/// Row-facing alias for [AppMenuItem]; table row menus and page-header "more"
/// menus share the same model and code path.
class CellAction extends AppMenuItem {
  const CellAction({
    required super.label,
    required super.icon,
    required super.onTap,
    super.danger,
    super.enabled,
  });

  CellAction.edit(VoidCallback onTap, {String? label})
    : this(
        label: label ?? L.common.edit,
        icon: LucideIcons.pencil,
        onTap: onTap,
      );

  CellAction.delete(VoidCallback onTap, {String? label})
    : this(
        label: label ?? L.common.delete,
        icon: LucideIcons.trash2,
        onTap: onTap,
        danger: true,
      );
}
