import 'package:flutter/material.dart';

import '../../../../Core/L10n/L.dart';
import '../../../../Logic/UI/input_controller.dart';
import '../../../Widgets/Switch/ui_segmented_switch.dart';
import 'policy_settings_codec.dart';

/// Three-state selection bound to a restriction key.
///
/// [name] is the full `InputController` key (e.g.
/// `policy.restriction_settings.no_camera`); the value is `'2'` (default —
/// untouched on device), `'1'` (restrict) or `'0'` (allow). An empty value
/// counts as default. This shares state with the "Restrictions" tab, so
/// changing either place updates the other.
class PolicyRestrictionShortcut extends StatelessWidget {
  const PolicyRestrictionShortcut({
    super.key,
    required this.name,
    required this.title,
    this.subtitle,
  });

  final String name;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final controller = InputController.to.getController(name);
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final raw = InputController.to.getValue(name).trim();
        final value = raw == restrictionRestrict || raw == restrictionAllow
            ? raw
            : restrictionDefault;
        return UiSegmentedSwitch<String>(
          title: title,
          subtitle: subtitle,
          value: value,
          items: <String, String>{
            restrictionDefault: L.policies.restrictionStateDefault,
            restrictionRestrict: L.policies.restrictionStateRestrict,
            restrictionAllow: L.common.allow,
          },
          onChanged: (v) => InputController.to.setValue(name, v),
        );
      },
    );
  }
}
