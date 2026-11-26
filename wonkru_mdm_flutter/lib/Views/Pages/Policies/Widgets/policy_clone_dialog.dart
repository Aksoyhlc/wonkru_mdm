import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Core/Constants/Enums/alert_enums.dart';
import '../../../../Core/L10n/L.dart';
import '../../../../Core/Theme/design.dart';
import '../../../Widgets/Alert/app_toast.dart';
import '../../../Widgets/Button/app_button.dart';
import '../../../Widgets/Dialog/app_dialog_shell.dart';
import '../../../Widgets/Input/text_controllers_owner.dart';

Future<String?> showPolicyCloneDialog(
  BuildContext context, {
  required String defaultName,
}) {
  return showDialog<String>(
    context: context,
    builder: (_) => _ClonePolicyDialog(defaultName: defaultName),
  );
}

class _ClonePolicyDialog extends StatefulWidget {
  const _ClonePolicyDialog({required this.defaultName});

  final String defaultName;

  @override
  State<_ClonePolicyDialog> createState() => _ClonePolicyDialogState();
}

class _ClonePolicyDialogState extends State<_ClonePolicyDialog>
    with TextControllersOwner<_ClonePolicyDialog> {
  late final _name = textController(
    L.policies.copyNameSuffix.trParams({
      'name': widget.defaultName,
    }),
  );

  void _confirm() {
    final value = _name.text.trim();
    if (value.isEmpty) {
      AppToast.show(L.policies.nameRequired, tone: UiAlertTone.warning);
      return;
    }
    Navigator.pop(context, value);
  }

  @override
  Widget build(BuildContext context) {
    return AppDialogShell(
      scrollable: true,
      title: L.policies.cloneTitle,
      actions: [
        AppButton.cancel(context),
        AppButton(label: L.common.copy, onPressed: _confirm),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            L.policies.newNameLabel,
            style: AppText.caption(
              context,
              size: 12,
            ).copyWith(fontWeight: FontWeight.w500),
          ),
          AppGap.v6,
          TextField(
            controller: _name,
            autofocus: true,
            decoration: InputDecoration(labelText: L.common.name),
            onSubmitted: (_) => _confirm(),
          ),
        ],
      ),
    );
  }
}
