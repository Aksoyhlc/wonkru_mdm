import 'package:flutter/material.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../../Core/L10n/L.dart';
import '../../../Widgets/Button/app_button.dart';
import '../../../Widgets/Dialog/app_dialog_shell.dart';
import '../../../Widgets/Input/app_dropdown.dart';

Future<int?> showAssignPolicyDialog(
  BuildContext context,
  List<Policy> policies,
) {
  return showDialog<int>(
    context: context,
    builder: (_) => _AssignPolicyDialog(policies: policies),
  );
}

class _AssignPolicyDialog extends StatefulWidget {
  const _AssignPolicyDialog({required this.policies});

  final List<Policy> policies;

  @override
  State<_AssignPolicyDialog> createState() => _AssignPolicyDialogState();
}

class _AssignPolicyDialogState extends State<_AssignPolicyDialog> {
  static const _none = 'none';

  String _selected = _none;

  @override
  Widget build(BuildContext context) {
    return AppDialogShell(
      scrollable: true,
      title: L.devices.assignPolicy,
      actions: [
        AppButton.cancel(context),
        AppButton(
          label: L.devices.assign,
          onPressed: _selected == _none
              ? null
              : () => Navigator.pop(context, int.tryParse(_selected)),
        ),
      ],
      child: AppDropdown<String>(
        value: _selected,
        items: {
          _none: L.devices.selectPolicy,
          for (final policy in widget.policies) '${policy.id}': policy.name,
        },
        onChanged: (value) => setState(() => _selected = value ?? _none),
      ),
    );
  }
}
