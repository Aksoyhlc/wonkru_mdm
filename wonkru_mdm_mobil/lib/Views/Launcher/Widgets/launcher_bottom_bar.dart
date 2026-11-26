import 'package:flutter/material.dart';
import 'package:wonkrumdm/Core/Constants/const.dart';
import 'package:wonkrumdm/Core/Theme/wonkru_theme.dart';
import 'package:wonkrumdm/generated/assets.dart';

import 'info_button.dart';

class LauncherBottomBar extends StatelessWidget {
  const LauncherBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          width: double.infinity,
          height: 1,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.white12, Colors.white38, Colors.white12]),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4, top: 4),
          child: Row(
            children: [
              Image.asset(
                Assets.assets.images.logo.path,
                width: 16,
                height: 16,
                color: Colors.white70,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  bottomLeftAppName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: WonkruText.body(12, color: Colors.white70, weight: FontWeight.w500),
                ),
              ),
              const LauncherInfoButton(),
            ],
          ),
        ),
      ],
    );
  }
}
