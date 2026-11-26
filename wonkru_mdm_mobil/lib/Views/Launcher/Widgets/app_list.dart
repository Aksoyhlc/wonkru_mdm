import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wonkrumdm/Core/Native/Generated/app_api.g.dart';
import 'package:wonkrumdm/Core/L10n/L.dart';
import 'package:wonkrumdm/Logic/UI/launcher_controller.dart';

class AppListView extends StatelessWidget {
  const AppListView({super.key});

  @override
  Widget build(BuildContext context) {
    final lc = LauncherController.to;

    return Obx(() {
      final apps = lc.installedApps;

      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: apps.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _AppListItem(app: apps[index]),
          );
        },
      );
    });
  }
}

class _AppListItem extends StatelessWidget {
  final NativeAppInfo app;

  const _AppListItem({required this.app});

  @override
  Widget build(BuildContext context) {
    final lc = LauncherController.to;
    final iconSize = _getIconSize(lc.iconSize);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => lc.launchApp(app),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          ),
          child: Row(
            children: [
              _buildAppIcon(iconSize, lc),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  app.appName ?? L.unknown_app,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.white.withOpacity(0.5),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppIcon(double size, LauncherController lc) {
    return Obx(() {
      final icon = app.packageName != null
          ? lc.getAppIcon(app.packageName!)
          : null;
      if (icon != null) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.memory(
            icon,
            width: size,
            height: size,
            fit: BoxFit.cover,
          ),
        );
      }
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(Icons.android, color: Colors.white70, size: size * 0.6),
      );
    });
  }

  double _getIconSize(iconSize) {
    switch (iconSize.value) {
      case 'small':
        return 40;
      case 'large':
        return 56;
      default:
        return 48;
    }
  }
}