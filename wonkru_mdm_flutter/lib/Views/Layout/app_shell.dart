import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../Core/Constants/app_breakpoints.dart';
import '../../Core/Theme/design.dart';
import 'Widgets/branch_fade_in.dart';
import 'Widgets/sidebar.dart';
import 'Widgets/timezone_warning_bar.dart';
import 'Widgets/topbar.dart';

/// The shell holds a sidebar plus a topbar and content area. The content is a
/// [StatefulNavigationShell], so each section keeps its own navigation stack and
/// URL, and returning to a section restores its open detail page.
///
/// Below [AppBreakpoints.compact] the sidebar becomes a drawer.
///
/// Width is read with [MediaQuery], not `LayoutBuilder`: the latter builds every
/// page inside a layout callback, which overflowed the stack on deep pages in
/// web debug builds.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final compact = MediaQuery.sizeOf(context).width < AppBreakpoints.compact;

    return Scaffold(
      drawer: compact
          ? Drawer(
              width: Sidebar.width,
              backgroundColor: colors.workshop,
              child: Sidebar(
                navigationShell: navigationShell,
                inDrawer: true,
              ),
            )
          : null,
      body: Row(
        children: [
          if (!compact) Sidebar(navigationShell: navigationShell),
          Expanded(
            child: Column(
              children: [
                Topbar(navigationShell: navigationShell, compact: compact),
                const TimezoneWarningBar(),
                Expanded(
                  child: ColoredBox(
                    color: colors.porcelain,
                    child: BranchFadeIn(
                      index: navigationShell.currentIndex,
                      child: navigationShell,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
