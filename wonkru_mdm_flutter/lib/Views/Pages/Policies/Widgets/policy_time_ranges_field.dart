import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../Core/Constants/Enums/button_enums.dart';
import '../../../../Core/L10n/L.dart';
import '../../../../Core/Theme/design.dart';
import '../../../../Logic/UI/input_controller.dart';
import '../../../Widgets/Button/app_button.dart';
import '../../../Widgets/Button/app_icon_button.dart';

class PolicyTimeRangesField extends StatefulWidget {
  const PolicyTimeRangesField({
    super.key,
    required this.name,
    required this.label,
    this.helper,
  });

  final String name;
  final String label;
  final String? helper;

  @override
  State<PolicyTimeRangesField> createState() => _PolicyTimeRangesFieldState();
}

class _PolicyTimeRangesFieldState extends State<PolicyTimeRangesField> {
  final List<_TimeRangeRow> _rows = <_TimeRangeRow>[];

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
        final start = _parseTime(entry.key.toString());
        final end = _parseTime(entry.value?.toString() ?? '');
        if (start == null || end == null) continue;
        _rows.add(_TimeRangeRow(start: start, end: end));
      }
    } catch (_) {}
  }

  void _publish() {
    final object = <String, String>{};
    for (final row in _rows) {
      final start = row.start;
      final end = row.end;
      if (start == null || end == null) continue;
      object[_formatTime(start)] = _formatTime(end);
    }

    final encoded = jsonEncode(object);
    if (encoded == _serialized) return;
    _serialized = encoded;
    InputController.to.setValue(widget.name, encoded);
  }

  void _addRow() {
    setState(() => _rows.add(_TimeRangeRow()));
  }

  void _removeRow(_TimeRangeRow row) {
    setState(() => _rows.remove(row));
    row.dispose();
    _publish();
  }

  Future<void> _pick(_TimeRangeRow row, {required bool start}) async {
    final current = start ? row.start : row.end;
    final picked = await showTimePicker(
      context: context,
      initialTime:
          current ??
          (start
              ? const TimeOfDay(hour: 8, minute: 0)
              : const TimeOfDay(hour: 17, minute: 0)),
    );
    if (picked == null) return;

    setState(() {
      if (start) {
        row.start = picked;
      } else {
        row.end = picked;
      }
    });
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
          Text(widget.helper!, style: AppText.caption(context, size: 11)),
        ],
        AppGap.v8,
        if (_rows.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.s8),
            child: Text(
              L.policies.noTimeRanges,
              style: AppText.cellSecondary(context),
            ),
          )
        else
          for (final row in _rows)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.s8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: _TimeButton(
                      label: L.common.start,
                      value: row.start,
                      onTap: () => _pick(row, start: true),
                    ),
                  ),
                  AppGap.h8,
                  Expanded(
                    child: _TimeButton(
                      label: L.common.end,
                      value: row.end,
                      onTap: () => _pick(row, start: false),
                    ),
                  ),
                  AppGap.h6,
                  AppIconButton(
                    icon: LucideIcons.trash2,
                    tooltip: L.common.remove,
                    onPressed: () => _removeRow(row),
                  ),
                ],
              ),
            ),
        Align(
          alignment: Alignment.centerLeft,
          child: AppButton(
            label: L.policies.addTimeRange,
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

class _TimeRangeRow {
  _TimeRangeRow({this.start, this.end});

  TimeOfDay? start;
  TimeOfDay? end;

  void dispose() {}
}

class _TimeButton extends StatelessWidget {
  const _TimeButton({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final TimeOfDay? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final text = value == null ? '--:--' : _formatTime(value!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: AppText.caption(context, size: 11)),
        AppGap.v4,
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.r8),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s12,
              vertical: AppSpacing.s10,
            ),
            decoration: colors.outlined(fill: colors.workshop),
            child: Row(
              children: [
                Icon(LucideIcons.clock, size: 14, color: colors.graphite),
                AppGap.h8,
                Text(text, style: AppText.body(context)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

String _formatTime(TimeOfDay time) =>
    '${time.hour.toString().padLeft(2, '0')}:'
    '${time.minute.toString().padLeft(2, '0')}';

TimeOfDay? _parseTime(String value) {
  final parts = value.split(':');
  if (parts.length != 2) return null;

  final hour = int.tryParse(parts[0]);
  final minute = int.tryParse(parts[1]);
  if (hour == null || minute == null) return null;
  if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;

  return TimeOfDay(hour: hour, minute: minute);
}
