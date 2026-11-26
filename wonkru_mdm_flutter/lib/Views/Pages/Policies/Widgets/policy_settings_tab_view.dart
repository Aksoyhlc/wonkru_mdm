import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../Core/Constants/Enums/alert_enums.dart';
import '../../../../Core/Constants/Enums/button_enums.dart';
import '../../../../Core/Constants/Enums/policy_enums.dart';
import '../../../../Core/L10n/L.dart';
import '../../../../Core/Theme/design.dart';
import '../../../../Core/Time/app_time.dart';
import '../../../../Logic/UI/input_controller.dart';
import '../../../Widgets/Alert/app_toast.dart';
import '../../../Widgets/Button/app_button.dart';
import '../../../Widgets/Card/section_card.dart';
import '../../../Widgets/Input/app_file_upload/app_file_upload.dart';
import '../../../Widgets/Input/custom_text_field.dart';
import '../../../Widgets/Input/named_dropdown.dart';
import '../../../Widgets/Input/text_controllers_owner.dart';
import '../../../Widgets/Input/uploaded_file.dart';
import '../../../Widgets/Switch/named_switch.dart';
import 'policy_field_spec.dart';
import 'policy_key_value_field.dart';
import 'policy_restriction_shortcut.dart';
import 'policy_time_ranges_field.dart';
import 'policy_tri_state_field.dart';

class PolicySettingsTabView extends StatelessWidget {
  const PolicySettingsTabView({super.key, required this.spec});

  final PolicySettingsTabSpec spec;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < spec.groups.length; i++) ...[
          if (i > 0) AppGap.v16,
          _group(context, spec.groups[i]),
        ],
      ],
    );
  }

  Widget _group(BuildContext context, PolicyFieldGroupSpec group) {
    return SectionCard(
      title: (group.title ?? spec.title).tr,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 900
              ? 3
              : constraints.maxWidth >= 560
              ? 2
              : 1;
          const spacing = 16.0;
          final width =
              (constraints.maxWidth - spacing * (columns - 1)) / columns;

          return Wrap(
            spacing: spacing,
            runSpacing: 16,
            children: [
              for (final field in group.fields)
                SizedBox(
                  width: field.fullWidth ? constraints.maxWidth : width,
                  child: _field(field),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _field(PolicyFieldSpec field) {
    final content = _fieldContent(field);

    final visibleWhenPath = field.visibleWhenPath;
    if (visibleWhenPath == null) return content;

    final name = 'policy.$visibleWhenPath';
    final controller = InputController.to.getController(name);
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final visible =
            InputController.to.getValue(name) == field.visibleWhenValue;
        return visible ? content : const SizedBox.shrink();
      },
    );
  }

  Widget _fieldContent(PolicyFieldSpec field) {
    final name = 'policy.${field.path}';
    final label = field.label.tr;
    final helper = field.helper?.tr;

    return switch (field.type) {
      PolicyFieldType.text ||
      PolicyFieldType.number ||
      PolicyFieldType.color => CustomTextField(
        name: name,
        label: label,
        helper: helper,
        keyboardType: field.type == PolicyFieldType.number
            ? field.allowDecimal
                  ? const TextInputType.numberWithOptions(decimal: true)
                  : TextInputType.number
            : null,
        textAlign: field.type == PolicyFieldType.number
            ? TextAlign.left
            : TextAlign.start,
        textDirection: field.type == PolicyFieldType.number
            ? TextDirection.ltr
            : null,
        inputFormatters: field.type == PolicyFieldType.number
            ? _numberFormatters(field)
            : null,
      ),
      PolicyFieldType.textarea => CustomTextField(
        name: name,
        label: label,
        helper: helper,
        maxLines: 3,
      ),
      PolicyFieldType.toggle => NamedSwitch(
        name: name,
        title: label,
        subtitle: helper,
      ),
      PolicyFieldType.select => NamedDropdown<String>(
        name: name,
        label: label,
        items: {
          for (final option
              in (field.options ?? const <String, String>{}).entries)
            option.key: option.value.tr,
        },
      ),
      PolicyFieldType.timeZone => NamedDropdown<String>(
        name: name,
        label: label,
        items: {
          '': L.policies.triDefault,
          for (final zone in AppTime.zoneNames) zone: zone,
        },
        fallback: '',
        searchable: true,
      ),
      PolicyFieldType.slider => _PolicySliderField(field: field),
      PolicyFieldType.keyValue => PolicyKeyValueField(
        name: name,
        label: label,
        helper: helper,
      ),
      PolicyFieldType.timeRanges => PolicyTimeRangesField(
        name: name,
        label: label,
        helper: helper,
      ),
      PolicyFieldType.tags => _PolicyTagsField(field: field),
      PolicyFieldType.fileUpload => _PolicyFileUploadField(field: field),
      PolicyFieldType.restrictionShortcut => PolicyRestrictionShortcut(
        name: name,
        title: label,
        subtitle: helper,
      ),
      PolicyFieldType.triState => PolicyTriStateField(
        name: name,
        title: label,
        subtitle: helper,
      ),
      PolicyFieldType.triStateBool => PolicyTriStateField(
        name: name,
        title: label,
        subtitle: helper,
        boolStorage: true,
      ),
    };
  }

  List<TextInputFormatter> _numberFormatters(PolicyFieldSpec field) => [
    field.allowDecimal
        ? FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
        : FilteringTextInputFormatter.digitsOnly,
    TextInputFormatter.withFunction((oldValue, newValue) {
      if (newValue.text == oldValue.text || newValue.text.isEmpty) {
        return newValue;
      }
      final value = field.allowDecimal
          ? num.tryParse(newValue.text)
          : int.tryParse(newValue.text);
      if (value == null) return oldValue;

      final max = field.max;
      if (max == null || value <= max) return newValue;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        AppToast.show(
          L.policies.valueClampedToMax.trParams({'max': max.toString()}),
          tone: UiAlertTone.warning,
        );
      });
      final clamped = max.toString();
      return TextEditingValue(
        text: clamped,
        selection: TextSelection.collapsed(offset: clamped.length),
      );
    }),
  ];
}

class _PolicyFileUploadField extends StatelessWidget {
  const _PolicyFileUploadField({required this.field});

  final PolicyFieldSpec field;

  @override
  Widget build(BuildContext context) {
    final name = 'policy.${field.path}';
    final controller = InputController.to.getController(name);
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final current = InputController.to.getValue(name).trim();
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppFileUpload(
              purpose: field.purpose ?? 'launcherBackground',
              label: field.label.tr,
              helper: field.helper?.tr,
              accept: field.options?.keys.toList(),
              onUploaded: (UploadedFile file) async {
                InputController.to.setValue(name, file.path);
              },
              onRemoved: () => InputController.to.setValue(name, ''),
            ),
            if (current.isNotEmpty) ...[
              AppGap.v6,
              Text(
                current,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppText.caption(context, size: 11),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _PolicySliderField extends StatefulWidget {
  const _PolicySliderField({required this.field});

  final PolicyFieldSpec field;

  @override
  State<_PolicySliderField> createState() => _PolicySliderFieldState();
}

class _PolicySliderFieldState extends State<_PolicySliderField> {
  late final String _name = 'policy.${widget.field.path}';
  late final TextEditingController _controller = InputController.to
      .getController(_name);

  double get _min => (widget.field.min ?? 0).toDouble();

  double get _max => (widget.field.max ?? 100).toDouble();

  late final TextEditingController? _limit = widget.field.notAbovePath == null
      ? null
      : InputController.to.getController('policy.${widget.field.notAbovePath}');

  @override
  void initState() {
    super.initState();
    _controller.addListener(_sync);
    _limit?.addListener(_sync);
  }

  @override
  void dispose() {
    _controller.removeListener(_sync);
    _limit?.removeListener(_sync);
    super.dispose();
  }

  bool get _exceedsLimit {
    final limit = _limit;
    if (limit == null) return false;
    final value = double.tryParse(_controller.text.trim());
    final max = double.tryParse(limit.text.trim());
    return value != null && max != null && value > max;
  }

  void _sync() {
    if (mounted) setState(() {});
  }

  double get _value {
    final parsed = double.tryParse(_controller.text.trim());
    if (parsed == null) {
      return ((widget.field.defaultValue ?? _min).toDouble()).clamp(_min, _max);
    }
    return parsed.clamp(_min, _max);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final divisions = (_max - _min).round().clamp(1, 1000);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomTextField(
          name: _name,
          controller: _controller,
          label: widget.field.label.tr,
          helper: widget.field.helper?.tr,
          keyboardType: TextInputType.number,
          showValidationError: false,
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 3,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
            // The theme default leaves the inactive track nearly invisible on
            // the card background in dark mode, so both track colors are set
            // explicitly.
            activeTrackColor: colors.loomBlue,
            inactiveTrackColor: colors.graphite.withValues(alpha: 0.3),
            thumbColor: colors.loomBlue,
            overlayColor: colors.loomBlue.withValues(alpha: 0.12),
          ),
          child: Slider(
            value: _value,
            min: _min,
            max: _max,
            divisions: divisions,
            onChanged: (value) =>
                InputController.to.setValue(_name, value.round().toString()),
          ),
        ),
        if (_exceedsLimit)
          Text(
            L.policies.rangeInvalid,
            style: AppText.caption(
              context,
            ).copyWith(color: colors.madder),
          ),
      ],
    );
  }
}

/// Stored as a JSON array string such as `["a","b"]`; an empty or invalid
/// value is treated as an empty list.
class _PolicyTagsField extends StatefulWidget {
  const _PolicyTagsField({required this.field});

  final PolicyFieldSpec field;

  @override
  State<_PolicyTagsField> createState() => _PolicyTagsFieldState();
}

class _PolicyTagsFieldState extends State<_PolicyTagsField>
    with TextControllersOwner<_PolicyTagsField> {
  late final String _name = 'policy.${widget.field.path}';
  late final TextEditingController _value = InputController.to.getController(
    _name,
  );
  late final _draft = textController();

  List<String> _tags = <String>[];
  String _serialized = '';

  @override
  void initState() {
    super.initState();
    _serialized = _value.text;
    _tags = _decode(_value.text);
    _value.addListener(_onExternalChange);
  }

  @override
  void dispose() {
    _value.removeListener(_onExternalChange);
    super.dispose();
  }

  void _onExternalChange() {
    if (_value.text == _serialized) return;
    _serialized = _value.text;
    if (mounted) {
      setState(() => _tags = _decode(_value.text));
    }
  }

  List<String> _decode(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return <String>[];
    try {
      final decoded = jsonDecode(text);
      if (decoded is List) {
        return [for (final item in decoded) item.toString()];
      }
    } catch (_) {}
    return <String>[];
  }

  void _publish(List<String> tags) {
    final encoded = jsonEncode(tags);
    if (encoded == _serialized) return;
    _serialized = encoded;
    InputController.to.setValue(_name, encoded);
  }

  void _addTag() {
    final tag = _draft.text.trim();
    if (tag.isEmpty) return;
    _draft.clear();
    if (_tags.contains(tag)) return;
    setState(() => _tags = <String>[..._tags, tag]);
    _publish(_tags);
  }

  void _removeTag(String tag) {
    setState(() => _tags = _tags.where((t) => t != tag).toList());
    _publish(_tags);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.field.label.tr,
          style: AppText.label(context).copyWith(fontSize: 11.5),
        ),
        if (widget.field.helper != null) ...[
          AppGap.v2,
          Text(
            widget.field.helper!.tr,
            style: AppText.caption(context, size: 11),
          ),
        ],
        AppGap.v8,
        if (_tags.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.s8),
            child: Text(
              L.policies.noTags,
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
                for (final tag in _tags) _chip(context, tag),
              ],
            ),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomTextField(
                name: '$_name.draft',
                controller: _draft,
                hint: L.policies.addValueHint,
                showValidationError: false,
                onSubmitted: (_) => _addTag(),
              ),
            ),
            AppGap.h6,
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child: AppButton(
                label: L.common.add,
                compact: true,
                icon: LucideIcons.plus,
                variant: AppButtonVariant.secondary,
                onPressed: _addTag,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _chip(BuildContext context, String tag) {
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
          Text(
            tag,
            style: AppText.body(context).copyWith(fontSize: 11.5),
          ),
          AppGap.h4,
          GestureDetector(
            onTap: () => _removeTag(tag),
            child: Icon(LucideIcons.x, size: 13, color: colors.graphite),
          ),
        ],
      ),
    );
  }
}
