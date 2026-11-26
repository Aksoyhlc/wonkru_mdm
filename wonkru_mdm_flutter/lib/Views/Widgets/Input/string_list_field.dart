import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../Core/Constants/Enums/button_enums.dart';
import '../../../Core/L10n/L.dart';
import '../../../Core/Theme/design.dart';
import '../Button/app_button.dart';
import 'custom_text_field.dart';
import 'text_controllers_owner.dart';

/// Simple text list field for adding and removing values.
///
/// Used for plain string lists such as times (`HH:mm`), user ids and package
/// names. If [validate] returns non-null, the error is shown below the field
/// and the value is not added.
class StringListField extends StatefulWidget {
  const StringListField({
    super.key,
    required this.label,
    required this.values,
    required this.onChanged,
    this.name = 'string_list',
    this.hint,
    this.helper,
    this.addLabel,
    this.emptyText,
    this.keyboardType,
    this.validate,
  });

  /// Prefix for unique field names.
  final String name;

  final String label;
  final List<String> values;
  final ValueChanged<List<String>> onChanged;
  final String? hint;
  final String? helper;
  final String? addLabel;
  final String? emptyText;
  final TextInputType? keyboardType;

  final String? Function(String value)? validate;

  @override
  State<StringListField> createState() => _StringListFieldState();
}

class _StringListFieldState extends State<StringListField>
    with TextControllersOwner<StringListField> {
  late final _draft = textController();
  String? _error;

  void _add() {
    final value = _draft.text.trim();
    if (value.isEmpty) return;

    final validationError = widget.validate?.call(value);
    if (validationError != null) {
      setState(() => _error = validationError);
      return;
    }

    if (widget.values.contains(value)) {
      _draft.clear();
      setState(() => _error = null);
      return;
    }

    widget.onChanged(<String>[...widget.values, value]);
    _draft.clear();
    setState(() => _error = null);
  }

  void _remove(String value) {
    widget.onChanged(<String>[
      for (final item in widget.values)
        if (item != value) item,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        SelectableText(
          widget.label,
          maxLines: 1,
          style: AppText.label(context).copyWith(fontSize: 11.5),
        ),
        if (widget.helper != null) ...[
          AppGap.v2,
          Text(widget.helper!, style: AppText.caption(context, size: 11)),
        ],
        AppGap.v8,
        if (widget.values.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.s8),
            child: Text(
              widget.emptyText ?? L.common.emptyList,
              style: AppText.cellSecondary(context),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.s8),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final value in widget.values) _chip(context, value),
              ],
            ),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomTextField(
                name: '${widget.name}.draft',
                controller: _draft,
                hint: widget.hint,
                dense: true,
                keyboardType: widget.keyboardType,
                showValidationError: false,
                onSubmitted: (_) => _add(),
              ),
            ),
            AppGap.h6,
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child: AppButton(
                label: widget.addLabel ?? L.common.add,
                compact: true,
                icon: LucideIcons.plus,
                variant: AppButtonVariant.secondary,
                onPressed: _add,
              ),
            ),
          ],
        ),
        if (_error != null) ...[
          AppGap.v4,
          Text(
            _error!,
            style: AppText.caption(
              context,
            ).copyWith(color: context.appColors.madder),
          ),
        ],
      ],
    );
  }

  Widget _chip(BuildContext context, String value) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.only(
        left: AppSpacing.s8,
        right: AppSpacing.s4,
        top: 3,
        bottom: 3,
      ),
      decoration: colors.outlined(fill: colors.muted, radius: AppRadius.r6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: AppText.body(context).copyWith(fontSize: 11.5)),
          AppGap.h4,
          GestureDetector(
            onTap: () => _remove(value),
            child: Icon(LucideIcons.x, size: 13, color: colors.graphite),
          ),
        ],
      ),
    );
  }
}
