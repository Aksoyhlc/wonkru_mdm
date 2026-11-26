import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../Core/Constants/Enums/button_enums.dart';
import '../../../../Core/L10n/L.dart';
import '../../../../Core/Theme/design.dart';
import '../../../../Logic/UI/input_controller.dart';
import '../../../Widgets/Button/app_button.dart';
import '../../../Widgets/Button/app_icon_button.dart';
import '../../../Widgets/Input/custom_text_field.dart';

/// Edits key/value pairs and stores them as a compact JSON object under
/// [name] in the `InputController` (e.g. `{"start":"09:00"}`). Every change
/// re-serializes into that same key; external value changes rebuild the rows.
class PolicyKeyValueField extends StatefulWidget {
  const PolicyKeyValueField({
    super.key,
    required this.name,
    required this.label,
    this.helper,
  });

  final String name;
  final String label;
  final String? helper;

  @override
  State<PolicyKeyValueField> createState() => _PolicyKeyValueFieldState();
}

class _PolicyKeyValueFieldState extends State<PolicyKeyValueField> {
  final List<_KeyValueRow> _rows = <_KeyValueRow>[];

  late final TextEditingController _value;
  String _serialized = '';

  @override
  void initState() {
    super.initState();
    _value = InputController.to.getController(widget.name);
    _serialized = _value.text;
    _parse(_value.text);
    _value.addListener(_onExternalChange);
  }

  @override
  void dispose() {
    _value.removeListener(_onExternalChange);
    for (final row in _rows) {
      row.dispose();
    }
    super.dispose();
  }

  void _onExternalChange() {
    if (_value.text == _serialized) return;
    _serialized = _value.text;
    if (mounted) {
      setState(() => _parse(_value.text));
    }
  }

  void _parse(String raw) {
    for (final row in _rows) {
      row.dispose();
    }
    _rows.clear();

    final text = raw.trim();
    if (text.isEmpty) return;

    try {
      final decoded = jsonDecode(text);
      if (decoded is! Map) return;
      for (final entry in decoded.entries) {
        _rows.add(
          _KeyValueRow(
            key: entry.key.toString(),
            value: entry.value?.toString() ?? '',
            onChanged: _publish,
          ),
        );
      }
    } catch (_) {}
  }

  void _publish() {
    final object = <String, String>{};
    for (final row in _rows) {
      final key = row.keyController.text.trim();
      if (key.isEmpty) continue;
      object[key] = row.valueController.text;
    }
    final encoded = jsonEncode(object);
    if (encoded == _serialized) return;
    _serialized = encoded;
    InputController.to.setValue(widget.name, encoded);
  }

  void _addRow() {
    setState(() {
      _rows.add(_KeyValueRow(key: '', value: '', onChanged: _publish));
    });
  }

  void _removeRow(_KeyValueRow row) {
    setState(() => _rows.remove(row));
    row.dispose();
    _publish();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.label,
          style: AppText.label(context).copyWith(fontSize: 11.5),
        ),
        if (widget.helper != null) ...[
          AppGap.v2,
          Text(
            widget.helper!,
            style: AppText.caption(context, size: 11),
          ),
        ],
        AppGap.v8,
        for (final row in _rows) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CustomTextField(
                  name: '${widget.name}.${row.id}.key',
                  controller: row.keyController,
                  hint: L.policies.hintKey,
                  showValidationError: false,
                  onChanged: (_) => _publish(),
                ),
              ),
              AppGap.h8,
              Expanded(
                child: CustomTextField(
                  name: '${widget.name}.${row.id}.value',
                  controller: row.valueController,
                  hint: L.policies.hintValue,
                  showValidationError: false,
                  onChanged: (_) => _publish(),
                ),
              ),
              AppGap.h6,
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.s2),
                child: AppIconButton(
                  icon: LucideIcons.trash2,
                  tooltip: L.common.remove,
                  onPressed: () => _removeRow(row),
                ),
              ),
            ],
          ),
          AppGap.v8,
        ],
        Align(
          alignment: Alignment.centerLeft,
          child: AppButton(
            label: L.common.add,
            compact: true,
            icon: LucideIcons.plus,
            variant: AppButtonVariant.secondary,
            onPressed: _addRow,
          ),
        ),
      ],
    );
  }
}

class _KeyValueRow {
  _KeyValueRow({
    required String key,
    required String value,
    required this.onChanged,
  }) : keyController = TextEditingController(text: key),
       valueController = TextEditingController(text: value) {
    keyController.addListener(onChanged);
    valueController.addListener(onChanged);
  }

  final TextEditingController keyController;
  final TextEditingController valueController;
  final VoidCallback onChanged;

  static int _counter = 0;
  final int id = _counter++;

  void dispose() {
    keyController.removeListener(onChanged);
    valueController.removeListener(onChanged);
    keyController.dispose();
    valueController.dispose();
  }
}
