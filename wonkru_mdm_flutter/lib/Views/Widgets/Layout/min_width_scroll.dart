import 'package:flutter/material.dart';

class MinWidthScroll extends StatelessWidget {
  const MinWidthScroll({
    super.key,
    required this.child,
    required this.minWidth,
  });

  final Widget child;

  final double minWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= minWidth) return child;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(width: minWidth, child: child),
        );
      },
    );
  }
}
