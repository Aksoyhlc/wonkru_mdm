import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../Core/Constants/app_breakpoints.dart';
import '../../../Core/Constants/app_sections.dart';
import '../../../Core/L10n/L.dart';
import '../../../Core/Router/app_routes.dart';
import '../../../Core/Theme/design.dart';
import '../../../Logic/Controllers/devices_controller.dart';
import '../../../Logic/Controllers/theme_controller.dart';
import '../../Widgets/Button/app_icon_button.dart';
import '../../Widgets/Input/text_controllers_owner.dart';
import '../../Widgets/Search/app_search_field.dart';
import 'language_menu.dart';
import 'notification_bell.dart';
import 'scale_menu.dart';
import 'user_menu.dart';

/// On narrow screens a menu button appears, the search field shrinks then hides,
/// and the account menu collapses to just the avatar, so fixed widths cannot
/// overflow the bar.
class Topbar extends StatefulWidget {
  const Topbar({super.key, required this.navigationShell, this.compact = false, this.userName, this.onSignOut});

  final StatefulNavigationShell navigationShell;

  final bool compact;

  static const double height = 56;

  final String? userName;
  final VoidCallback? onSignOut;

  @override
  State<Topbar> createState() => _TopbarState();
}

class _TopbarState extends State<Topbar> with TextControllersOwner<Topbar> {
  late final _search = textController();

  void _submitSearch(String value) {
    context.go(AppRoutes.devices);
    unawaited(Get.find<DevicesController>().setSearch(value.trim()));
  }

  String _title(int index) => index >= 0 && index < appSections.length ? appSections[index].label : L.common.profile;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final shell = widget.navigationShell;
    final theme = Get.find<ThemeController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: Topbar.height,
      padding: EdgeInsets.symmetric(horizontal: widget.compact ? AppSpacing.s10 : 18),
      decoration: colors.hairlineBottom(fill: colors.workshop),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final showSearch = constraints.maxWidth >= AppBreakpoints.narrow;

          return Row(
            children: [
              if (widget.compact) ...[
                AppIconButton(
                  icon: LucideIcons.menu,
                  tooltip: L.common.menu,
                  onPressed: Scaffold.of(context).openDrawer,
                ),
                AppGap.h10,
              ],
              Expanded(
                child: Text(
                  _title(shell.currentIndex),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.pageTitle(context).copyWith(letterSpacing: -0.2),
                ),
              ),
              if (showSearch) ...[
                SizedBox(
                  width: math.min(AppBreakpoints.searchWidth, constraints.maxWidth * 0.35),
                  child: AppSearchField(
                    controller: _search,
                    hintText: L.common.deviceSearch,
                    onSubmitted: _submitSearch,
                    showClear: true,
                  ),
                ),
                AppGap.h12,
              ],
              const ScaleMenu(),
              AppGap.h8,
              AppIconButton(
                icon: isDark ? LucideIcons.sun : LucideIcons.moon,
                tooltip: isDark ? L.common.themeLight : L.common.themeDark,
                onPressed: theme.toggle,
              ),
              AppGap.h8,
              const LanguageMenu(),
              AppGap.h12,
              const NotificationBell(),
              SizedBox(width: widget.compact ? AppSpacing.s8 : AppSpacing.s12),
              UserMenu(userName: widget.userName, onSignOut: widget.onSignOut, compact: widget.compact),
            ],
          );
        },
      ),
    );
  }
}
