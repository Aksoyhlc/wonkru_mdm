import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../Core/Extensions/datetime.dart';
import '../../../Core/L10n/L.dart';
import '../../../Core/Theme/design.dart';
import 'custom_text_field.dart';
import 'text_controllers_owner.dart';

class DateFilterField extends StatefulWidget {
  const DateFilterField({
    super.key,
    required this.name,
    required this.label,
    required this.value,
    required this.onPick,
    required this.onClear,
    this.width = 160,
  });

  final String name;
  final String label;
  final DateTime? value;
  final VoidCallback onPick;
  final VoidCallback onClear;
  final double width;

  @override
  State<DateFilterField> createState() => _DateFilterFieldState();
}

class _DateFilterFieldState extends State<DateFilterField>
    with TextControllersOwner<DateFilterField> {
  late final _controller = textController(widget.value?.formatDate() ?? '');

  @override
  void didUpdateWidget(covariant DateFilterField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller.text = widget.value?.formatDate() ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(
            name: widget.name,
            controller: _controller,
            label: widget.label,
            hint: L.common.pickDate,
            dense: true,
            readOnly: true,
            showValidationError: false,
            suffixIcon: LucideIcons.calendar,
            onSuffixTap: widget.onPick,
          ),
          if (widget.value != null)
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: widget.onClear,
                child: Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.s2),
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
      ),
    );
  }
}
