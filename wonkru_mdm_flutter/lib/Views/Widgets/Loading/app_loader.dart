import 'package:flutter/material.dart';

import '../../../Core/Theme/design.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({super.key, this.size = 18});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: context.appColors.loomBlue,
      ),
    );
  }
}
