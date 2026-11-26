import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../Core/Theme/design.dart';
import '../../../../Core/Utils/pretty_json.dart';

class DeviceSyncJsonCard extends StatefulWidget {
  const DeviceSyncJsonCard({
    super.key,
    required this.title,
    required this.json,
  });

  final String title;

  final String json;

  @override
  State<DeviceSyncJsonCard> createState() => _DeviceSyncJsonCardState();
}

class _DeviceSyncJsonCardState extends State<DeviceSyncJsonCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final pretty = _pretty(widget.json);

    return Container(
      decoration: colors.outlined(fill: colors.workshop),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.s16,
                AppSpacing.s10,
                AppSpacing.s12,
                AppSpacing.s10,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.sectionTitle(
                        context,
                      ).copyWith(fontSize: 14),
                    ),
                  ),
                  Icon(
                    _expanded ? LucideIcons.chevronUp : LucideIcons.chevronDown,
                    size: 16,
                    color: colors.graphite,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded)
            Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: colors.border)),
              ),
              padding: AppInsets.all12,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 360),
                child: SingleChildScrollView(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SelectableText(
                      pretty,
                      style: AppText.mono(colors.carbon, size: 12),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  static String _pretty(String raw) =>
      raw.trim().isEmpty ? '—' : prettyJson(raw);
}
