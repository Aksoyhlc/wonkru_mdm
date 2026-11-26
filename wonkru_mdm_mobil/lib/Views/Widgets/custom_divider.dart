import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox(
        width: double.infinity,
        height: 1,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.white12, Colors.white38, Colors.white12]),
          ),
        ),
      );
}