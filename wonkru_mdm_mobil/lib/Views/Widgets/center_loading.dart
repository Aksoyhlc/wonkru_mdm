import 'package:flutter/material.dart';
import 'package:wonkrumdm/Core/Extensions/num.dart';
import 'package:wonkrumdm/Core/L10n/L.dart';
import 'package:wonkrumdm/Core/Theme/wonkru_theme.dart';

class CenterLoadingCard extends StatelessWidget {
  const CenterLoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: WonkruColors.accent),
              14.hh,
              Text(
                L.please_wait_loading,
                style: WonkruText.body(14, color: Colors.white70).copyWith(height: 1.3),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }
}