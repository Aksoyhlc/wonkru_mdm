import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Core/Theme/design.dart';
import 'policy_field_spec.dart';

class PolicyEditorTabBar extends StatelessWidget {
  const PolicyEditorTabBar({
    super.key,
    required this.controller,
    required this.settingsTabs,
    required this.pivotTitles,
  });

  final TabController controller;
  final List<PolicySettingsTabSpec> settingsTabs;
  final List<String> pivotTitles;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final labelStyle = AppText.cellPrimary(
      context,
    ).copyWith(fontWeight: FontWeight.w600);
    final unselectedStyle = AppText.cellPrimary(context);

    return Container(
      decoration: colors.hairlineBottom(),
      child: TabBar(
        controller: controller,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        labelColor: colors.carbon,
        unselectedLabelColor: colors.graphite,
        indicatorColor: colors.loomBlue,
        indicatorWeight: 2,
        dividerColor: Colors.transparent,
        labelStyle: labelStyle,
        unselectedLabelStyle: unselectedStyle,
        tabs: [
          for (final tab in settingsTabs) Tab(text: tab.title.tr),
          for (final title in pivotTitles) Tab(text: title.tr),
        ],
      ),
    );
  }
}
