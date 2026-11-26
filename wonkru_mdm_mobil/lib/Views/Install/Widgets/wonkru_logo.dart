import 'package:flutter/material.dart';
import 'package:wonkrumdm/generated/assets.dart';

class WonkruLogo extends StatelessWidget {
  final double size;

  const WonkruLogo({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(Assets.assets.images.logo.path, fit: BoxFit.contain),
    );
  }
}