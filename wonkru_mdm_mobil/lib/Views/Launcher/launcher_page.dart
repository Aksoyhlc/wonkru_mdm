import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wonkrumdm/Core/Constants/Enums/launcher_mode_enums.dart';
import 'package:wonkrumdm/Core/Theme/wonkru_theme.dart';
import 'package:wonkrumdm/Logic/UI/launcher_controller.dart';
import 'package:wonkrumdm/Views/Launcher/Widgets/app_grid.dart';
import 'package:wonkrumdm/Views/Launcher/Widgets/app_list.dart';
import 'package:wonkrumdm/Views/Launcher/Widgets/launcher_background.dart';
import 'package:wonkrumdm/Views/Launcher/Widgets/launcher_bottom_bar.dart';
import 'package:wonkrumdm/Views/Launcher/Widgets/launcher_status_bar.dart';
import 'package:wonkrumdm/generated/assets.dart';

class LauncherPage extends StatelessWidget {
  const LauncherPage({super.key});

  @override
  Widget build(BuildContext context) {
    final lc = LauncherController.to;
    final size = MediaQuery.sizeOf(context);
    final inset = (size.width * 0.06).clamp(16.0, 48.0);
    final logoSize = (size.shortestSide * 0.325).clamp(0.0, 240.0);
    final navInset = MediaQuery.paddingOf(context).bottom;
    final bottomPad = navInset > 16 ? navInset - 16 : 0.0;

    return Scaffold(
      backgroundColor: WonkruColors.bg,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const LauncherBackground(),
          Align(
            alignment: const Alignment(0, -0.02),
            child: Obx(
              () => Image.asset(
                Assets.assets.images.logo.path,
                width: logoSize,
                height: logoSize,
                fit: BoxFit.contain,
                color: WonkruColors.accent.withValues(alpha: lc.installedApps.isEmpty ? 0.8 : 0.18),
                excludeFromSemantics: true,
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(inset, 20, inset, bottomPad),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const LauncherStatusBar(),
                  const SizedBox(height: 12),
                  const SizedBox(
                    width: double.infinity,
                    height: 1,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [Colors.white12, Colors.white38, Colors.white12]),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Obx(() {
                        if (lc.installedApps.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return lc.layoutType == LayoutType.list
                            ? const AppListView()
                            : const AppGridView();
                      }),
                    ),
                  ),
                  const LauncherBottomBar(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
