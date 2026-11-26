import 'package:flutter/material.dart';
import 'package:wonkrumdm/Core/Constants/ext.dart';
import 'package:wonkrumdm/Logic/UI/launcher_controller.dart';
import 'package:wonkrumdm/Views/Widgets/cached_network_image.dart';
import 'package:wonkrumdm/Views/Widgets/wonkru_backdrop.dart';

class LauncherBackground extends StatelessWidget {
  const LauncherBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final lc = LauncherController.to;
    final bg = lc.background;

    if (bg == null) {
      return _buildDefaultBackground();
    }

    switch (bg.type) {
      case 'image':
        return _buildImageBackground(bg.image);
      case 'color':
        return _buildColorBackground(bg.color);
      case 'gradient':
        return _buildGradientBackground();
      default:
        return _buildDefaultBackground();
    }
  }

  Widget _buildDefaultBackground() => const WonkruBackdrop();

  Widget _buildImageBackground(String? imageUrl) {
    // The server emits absolute URLs; relative or empty values are unusable.
    if (imageUrl == null || imageUrl.isEmpty || !imageUrl.startsWith('http')) {
      return _buildDefaultBackground();
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: _buildDefaultBackground(),
          errorWidget: _buildDefaultBackground(),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withValues(alpha: 0.3), Colors.black.withValues(alpha: 0.5)],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildColorBackground(String? colorHex) {
    final color = parseColor(colorHex);
    return color == null ? _buildDefaultBackground() : ColoredBox(color: color);
  }

  Widget _buildGradientBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
      ),
    );
  }
}

