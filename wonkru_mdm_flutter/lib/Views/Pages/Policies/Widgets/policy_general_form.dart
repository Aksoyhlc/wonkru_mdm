import 'package:flutter/material.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../../Core/L10n/L.dart';
import '../../../../Core/Theme/design.dart';
import '../../../Widgets/Input/custom_text_field.dart';
import '../../../Widgets/Switch/named_switch.dart';

/// General tab fields of the policy editor (name, slug, description, password
/// and the two switches). Name/slug changes are handled by the page so their
/// auto-slug coupling stays in one place.
class PolicyGeneralForm extends StatelessWidget {
  const PolicyGeneralForm({
    super.key,
    required this.policy,
    required this.creating,
    required this.onNameChanged,
    required this.onSlugChanged,
  });

  final Policy policy;
  final bool creating;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onSlugChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomTextField(
                name: 'policy.name',
                label: L.common.name,
                initialValue: policy.name,
                onChanged: onNameChanged,
              ),
            ),
            AppGap.h12,
            Expanded(
              child: CustomTextField(
                name: 'policy.slug',
                label: L.policies.slug,
                hint: L.policies.slugHint,
                initialValue: policy.slug ?? '',
                onChanged: onSlugChanged,
              ),
            ),
          ],
        ),
        AppGap.v12,
        CustomTextField(
          name: 'policy.description',
          label: L.common.description,
          initialValue: policy.description ?? '',
          maxLines: 3,
        ),
        AppGap.v12,
        CustomTextField(
          name: 'policy.adminPassword',
          label: L.policies.adminPassword,
          hint: creating
              ? L.policies.adminPasswordRequiredHint
              : L.policies.adminPasswordHint,
          obscureText: true,
        ),
        AppGap.v16,
        Wrap(
          spacing: 24,
          runSpacing: 8,
          children: [
            NamedSwitch(name: 'policy.isActive', title: L.common.active),
            NamedSwitch(
              name: 'policy.defaultPolicy',
              title: L.policies.defaultPolicy,
            ),
          ],
        ),
      ],
    );
  }
}
