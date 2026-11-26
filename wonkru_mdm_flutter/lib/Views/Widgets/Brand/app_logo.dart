import 'package:flutter/material.dart';

/// The `dark`/`light` in the asset names describe ink colour, not theme: the
/// light theme uses the dark-stroked file and the dark theme the cream one.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.height = 32});

  final double height;

  static const double _aspectRatio = 1000 / 385;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final asset = isDark
        ? 'assets/images/wonkrumdm-logo-light.png'
        : 'assets/images/wonkrumdm-logo-dark.png';

    return Image.asset(
      asset,
      height: height,
      width: height * _aspectRatio,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.medium,
      semanticLabel: 'Wonkru MDM',
    );
  }
}
