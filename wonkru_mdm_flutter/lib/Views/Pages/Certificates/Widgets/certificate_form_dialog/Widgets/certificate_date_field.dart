import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../../Core/Extensions/datetime.dart';
import '../../../../../../Core/L10n/L.dart';
import '../../../../../../Core/Theme/design.dart';
import '../../../../../Widgets/Input/custom_text_field.dart';
import '../../../../../Widgets/Input/text_controllers_owner.dart';

/// Read-only date field with a calendar suffix and a clear action, used by the
/// certificate form for the validity window.
class CertificateDateField extends StatefulWidget {
  const CertificateDateField({
    super.key,
    required this.name,
    required this.label,
    required this.value,
    required this.enabled,
    required this.onPick,
    required this.onClear,
  });

  final String name;
  final String label;
  final DateTime? value;
  final bool enabled;
  final VoidCallback onPick;
  final VoidCallback onClear;

  @override
  State<CertificateDateField> createState() => _CertificateDateFieldState();
}

class _CertificateDateFieldState extends State<CertificateDateField>
    with TextControllersOwner<CertificateDateField> {
  late final _controller = textController(widget.value?.formatDateTime() ?? '');

  @override
  void didUpdateWidget(covariant CertificateDateField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller.text = widget.value?.formatDateTime() ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomTextField(
          name: widget.name,
          controller: _controller,
          label: widget.label,
          hint: L.common.pickDate,
          readOnly: true,
          enabled: widget.enabled,
          suffixIcon: LucideIcons.calendar,
          onSuffixTap: widget.enabled ? widget.onPick : null,
          showValidationError: false,
        ),
        if (widget.value != null)
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: widget.enabled ? widget.onClear : null,
              child: Padding(
                padding: const EdgeInsets.only(top: AppSpacing.s4),
                child: Text(
                  L.common.clear,
                  style: AppText.caption(
                    context,
                    size: 11,
                  ).copyWith(color: context.appColors.loomBlue),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
