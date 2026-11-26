import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../Core/L10n/L.dart';
import '../../../Core/Router/app_routes.dart';
import '../../../Core/Theme/design.dart';
import '../../../Logic/Controllers/auth_controller.dart';
import '../../Widgets/Menu/app_menu.dart';
import '../../Widgets/Menu/app_menu_item.dart';

/// Drawn with the panel's own [AppMenu] instead of a Material popup so it looks
/// the same as the row action menus in tables.
class UserMenu extends StatelessWidget {
  const UserMenu({
    super.key,
    this.userName,
    this.onSignOut,
    this.compact = false,
  });

  final String? userName;
  final VoidCallback? onSignOut;

  final bool compact;

  void _signOut() {
    final callback = onSignOut;
    if (callback != null) {
      callback();
      return;
    }
    unawaited(Get.find<AuthController>().signOut());
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final name = userName ?? L.common.userPlaceholder;

    return AppMenu(
      tooltip: L.common.account,
      header: name,
      items: [
        AppMenuItem(
          label: L.common.profile,
          icon: LucideIcons.user,
          onTap: () => context.go(AppRoutes.profile),
        ),
        AppMenuItem(
          label: L.common.signOut,
          icon: LucideIcons.logOut,
          danger: true,
          onTap: _signOut,
        ),
      ],
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.loomBlue.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(color: colors.border),
            ),
            child: Icon(LucideIcons.user, size: 15, color: colors.loomBlue),
          ),
          if (!compact) ...[
            AppGap.h8,
            Text(name, style: AppText.cellPrimary(context)),
            AppGap.h4,
            Icon(LucideIcons.chevronDown, size: 15, color: colors.graphite),
          ],
        ],
      ),
    );
  }
}
