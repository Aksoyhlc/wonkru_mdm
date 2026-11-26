import 'package:flutter/material.dart';

import '../../../Logic/UI/input_controller.dart';
import 'ui_switch.dart';

class NamedSwitch extends StatelessWidget {
  const NamedSwitch({
    super.key,
    required this.name,
    required this.title,
    this.subtitle,
    this.dense = false,
  });

  final String name;
  final String title;
  final String? subtitle;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final controller = InputController.to.getController(name);
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final value = InputController.to.getValue(name) == 'true';
        return UiSwitch(
          value: value,
          title: title,
          subtitle: subtitle,
          dense: dense,
          onChanged: (v) => InputController.to.setValue(name, v.toString()),
        );
      },
    );
  }
}
