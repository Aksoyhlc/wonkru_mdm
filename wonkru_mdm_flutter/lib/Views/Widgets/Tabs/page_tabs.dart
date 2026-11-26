import 'package:flutter/material.dart';

import '../../../Core/Theme/design.dart';

class PageTabs extends StatelessWidget {
  const PageTabs({super.key, required this.labels});

  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      decoration: colors.hairlineBottom(fill: colors.workshop),
      child: TabBar(
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        labelColor: colors.carbon,
        unselectedLabelColor: colors.graphite,
        indicatorColor: colors.loomBlue,
        indicatorWeight: 2,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        overlayColor: WidgetStatePropertyAll(colors.hover),
        labelPadding: AppInsets.h16,
        labelStyle: AppText.label(context).copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppText.label(context),
        tabs: [for (final label in labels) Tab(height: 42, text: label)],
      ),
    );
  }
}
