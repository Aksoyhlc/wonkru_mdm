import 'package:flutter/material.dart';

import '../../../../Core/L10n/L.dart';
import '../../../../Logic/UI/input_controller.dart';
import '../../../Widgets/Switch/ui_segmented_switch.dart';
import 'policy_settings_codec.dart';

class PolicyTriStateField extends StatelessWidget {
  const PolicyTriStateField({
    super.key,
    required this.name,
    required this.title,
    this.subtitle,
    this.boolStorage = false,
  });

  final String name;
  final String title;
  final String? subtitle;
  final bool boolStorage;

  @override
  Widget build(BuildContext context) {
    final controller = InputController.to.getController(name);
    final items = boolStorage
        ? <String, String>{
            '': L.policies.triDefault,
            'true': L.common.active,
            'false': L.common.inactive,
          }
        : <String, String>{
            '2': L.policies.triDefault,
            '1': L.common.active,
            '0': L.common.inactive,
          };
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final raw = InputController.to.getValue(name);
        final value = boolStorage
            ? normalizeTriStateBool(raw)
            : normalizeTriStateInt(raw);
        return UiSegmentedSwitch<String>(
          title: title,
          subtitle: subtitle,
          value: value,
          items: items,
          onChanged: (v) => InputController.to.setValue(name, v),
        );
      },
    );
  }
}
