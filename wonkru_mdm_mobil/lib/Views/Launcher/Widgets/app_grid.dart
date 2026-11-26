import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wonkrumdm/Logic/UI/launcher_controller.dart';
import 'package:wonkrumdm/Views/Launcher/Widgets/app_item.dart';

class AppGridView extends StatelessWidget {
  const AppGridView({super.key});

  @override
  Widget build(BuildContext context) {
    final lc = LauncherController.to;

    return Obx(() {
      final apps = lc.installedApps;
      final columns = lc.columns;

      return GridView.builder(
        physics: const BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1,
        ),
        itemCount: apps.length,
        itemBuilder: (context, index) => AppItem(app: apps[index]),
      );
    });
  }
}
