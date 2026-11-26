import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wonkrumdm/Core/Constants/Enums/launcher_mode_enums.dart';
import 'package:wonkrumdm/Core/Constants/ext.dart';
import 'package:wonkrumdm/Core/Extensions/num.dart';
import 'package:wonkrumdm/Core/L10n/L.dart';
import 'package:wonkrumdm/Core/Native/Generated/app_api.g.dart';
import 'package:wonkrumdm/Core/Theme/wonkru_theme.dart';
import 'package:wonkrumdm/Data/Models/Features/managed_app.dart';
import 'package:wonkrumdm/Logic/Common/device_controller.dart';
import 'package:wonkrumdm/Logic/UI/launcher_controller.dart';
import 'package:wonkrumdm/Views/Widgets/cached_network_image.dart';

class AppItem extends StatelessWidget {
  final NativeAppInfo app;

  const AppItem({super.key, required this.app});

  @override
  Widget build(BuildContext context) {
    ManagedApp? appInfo = DeviceController.to.config.value.appSettings?.managedApps
        ?.where((element) => element.packageName == app.packageName)
        .firstOrNull;

    final lc = LauncherController.to;
    final showLabel = lc.showLabel;
    final borderRadius = lc.itemDisplay?.borderRadius?.toDouble() ?? 14.0;
    final bgColor = parseColor(lc.itemDisplay?.backgroundColor);
    final labelColor = parseColor(lc.itemDisplay?.labelColor);
    final labelFontSize = lc.itemDisplay?.labelFontSize ?? 12.0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => lc.launchApp(app),
        onLongPress: (lc.itemDisplay?.longPressSettingsOpen ?? false) ? () => lc.openAppSettings(app) : null,
        borderRadius: BorderRadius.circular(borderRadius),
        splashColor: WonkruColors.creamFaint,
        highlightColor: WonkruColors.creamFaint,
        child: Container(
          decoration: BoxDecoration(
            color: (bgColor ?? WonkruColors.surface).withValues(alpha: .7),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: WonkruColors.creamBorder),
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildAppIcon(_getIconSize(lc.iconSize), lc, appInfo),
              if (showLabel) ...[
                7.hh,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    appInfo?.customAppName ?? app.appName ?? L.unknown_app,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: WonkruText.body(
                      labelFontSize,
                      color: labelColor ?? WonkruColors.creamDim,
                      weight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppIcon(double size, LauncherController lc, ManagedApp? appInfo) {
    return Obx(() {
      final icon = app.packageName != null ? LauncherController.to.getAppIcon(app.packageName!) : null;
      if (icon != null || appInfo?.application?.iconUrl != null) {
        return appInfo?.application?.iconUrl != null
            ? CachedNetworkImage(imageUrl: appInfo!.application!.iconUrl!, width: size, height: size, fit: BoxFit.cover)
            : Image.memory(icon!, width: size, height: size, fit: BoxFit.cover);
      }
      return Icon(Icons.android_outlined, color: WonkruColors.creamDim, size: size);
    });
  }

  double _getIconSize(IconSize iconSize) {
    switch (iconSize) {
      case IconSize.small:
        return 25;
      case IconSize.medium:
        return 40;
      case IconSize.large:
        return 50;
    }
  }
}