import 'package:flutter/material.dart';

import '../../../Core/Theme/design.dart';

class SidebarSectionLabel extends StatelessWidget {
  const SidebarSectionLabel({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s10,
        AppSpacing.s6,
        AppSpacing.s10,
        AppSpacing.s6,
      ),
      child: Text(
        label.toUpperCase(),
        style: AppText.columnHeader(
          context,
        ).copyWith(fontSize: 10.5, letterSpacing: 0.9),
      ),
    );
  }
}
