import 'package:flutter/material.dart';

import 'package:wonkrumdm/Core/Constants/Enums/restriction.dart';
import 'package:wonkrumdm/Core/Native/Bridges/restriction_bridge.dart';
import 'package:wonkrumdm/Core/Theme/wonkru_theme.dart';

class BtRestrictionTile extends StatefulWidget {
  const BtRestrictionTile({
    super.key,
    required this.restriction,
    required this.bridge,
    required this.onChanged,
  });

  final Restriction restriction;
  final RestrictionBridge bridge;
  final VoidCallback onChanged;

  @override
  State<BtRestrictionTile> createState() => _BtRestrictionTileState();
}

class _BtRestrictionTileState extends State<BtRestrictionTile> {
  bool? _active;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final active = await widget.bridge.isRestrictionActive(widget.restriction.value);
    if (mounted) setState(() => _active = active);
  }

  Future<void> _toggle(bool value) async {
    setState(() => _loading = true);
    await widget.bridge.setRestriction(widget.restriction.value, value);
    if (mounted) {
      setState(() {
        _active = value;
        _loading = false;
      });
      widget.onChanged();
    }
  }

  String get _label {
    final v = widget.restriction.value;
    return v.replaceAll('_', ' ').replaceFirst('no ', '').replaceFirst('disallow ', '');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: WonkruColors.surface.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: SwitchListTile(
        title: Text(
          _label,
          style: WonkruText.body(14, color: Colors.white, weight: FontWeight.w500).copyWith(height: 1.2),
        ),
        subtitle: Text(
          widget.restriction.value,
          style: WonkruText.body(11, color: Colors.white60).copyWith(height: 1.2),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        value: _active ?? false,
        onChanged: _loading ? null : (v) => _toggle(v),
        activeTrackColor: WonkruColors.accent,
        activeThumbColor: WonkruColors.bg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}