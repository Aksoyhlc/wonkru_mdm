import 'package:flutter/material.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart'
    show AlertTypeChannels;

import '../../../../Core/Constants/Enums/alert_enums.dart';
import '../../../../Core/Constants/Enums/system_alert_enums.dart';
import '../../../../Core/L10n/L.dart';
import '../../../../Core/Theme/design.dart';
import '../../../Widgets/Alert/app_toast.dart';
import '../../../Widgets/Switch/ui_switch.dart';

/// SMS is not offered: the server has no SMS sender.
class AlertChannelsField extends StatelessWidget {
  const AlertChannelsField({
    super.key,
    required this.values,
    required this.onChanged,
  });

  final List<AlertTypeChannels> values;
  final ValueChanged<List<AlertTypeChannels>> onChanged;

  static List<String> get _knownTypes => [
    for (final type in SystemAlertType.values) type.name,
  ];

  static Map<String, String> get _channelLabels => <String, String>{
    'database': L.settings.channelDatabase,
    'mail': L.common.email,
  };

  static const _channels = <String>['database', 'mail'];

  List<String> get _orderedTypes {
    final present = {for (final entry in values) entry.type.name};
    return <String>[
      for (final type in _knownTypes)
        if (present.contains(type)) type,
      for (final type in present)
        if (!_knownTypes.contains(type)) type,
    ];
  }

  AlertTypeChannels? _entry(String type) {
    for (final entry in values) {
      if (entry.type.name == type) return entry;
    }
    return null;
  }

  void _toggle(String type, String channel, bool enabled) {
    final entry = _entry(type);
    final current = List<String>.of(entry?.channels ?? const <String>[]);

    if (enabled) {
      if (!current.contains(channel)) current.add(channel);
    } else {
      if (current.length <= 1) {
        AppToast.show(L.settings.channelRequired, tone: UiAlertTone.warning);
        return;
      }
      current.remove(channel);
    }

    onChanged([
      for (final item in values)
        if (item.type.name != type)
          item
        else
          AlertTypeChannels(type: item.type, channels: current),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final types = _orderedTypes;

    if (types.isEmpty) {
      return Text(
        L.settings.noAlertTypes,
        style: AppText.cellSecondary(context),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < types.length; i++) ...[
          if (i > 0) Divider(height: 20, thickness: 1, color: colors.border),
          _row(context, types[i]),
        ],
      ],
    );
  }

  Widget _row(BuildContext context, String type) {
    final selected = _entry(type)?.channels ?? const <String>[];
    final label = systemAlertTypeFromValue(type)?.label ?? type;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SelectableText(
          label,
          maxLines: 1,
          style: AppText.label(context).copyWith(fontWeight: FontWeight.w600),
        ),
        AppGap.v6,
        Wrap(
          spacing: 16,
          runSpacing: 4,
          children: [
            for (final channel in _channels)
              UiSwitch(
                value: selected.contains(channel),
                title: _channelLabels[channel] ?? channel,
                dense: true,
                onChanged: (enabled) => _toggle(type, channel, enabled),
              ),
          ],
        ),
      ],
    );
  }
}
