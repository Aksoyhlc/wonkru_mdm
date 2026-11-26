import 'package:flutter/material.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../Core/Extensions/string.dart';
import '../../../Core/L10n/L.dart';
import '../../../Core/Theme/design.dart';
import '../EmptyState/empty_state.dart';

class DistributionChart extends StatelessWidget {
  const DistributionChart({super.key, required this.chart});

  final DashboardChart chart;

  /// Fallback series hues when the payload carries no color: the four semantic
  /// tones then the two chart-only hues, so the palette follows the theme.
  static List<Color> _palette(AppColors colors) => [
    colors.loomBlue,
    colors.success,
    colors.warning,
    colors.madder,
    colors.chartPurple,
    colors.chartTeal,
  ];

  @override
  Widget build(BuildContext context) {
    if (chart.labels.isEmpty) {
      return EmptyState(title: L.common.noData);
    }

    final colors = context.appColors;
    final maxValue = chart.values.fold<int>(
      1,
      (max, value) => value > max ? value : max,
    );
    final total = chart.values.fold<int>(0, (sum, value) => sum + value);

    return Column(
      children: [
        for (var i = 0; i < chart.labels.length; i++) ...[
          if (i > 0) AppGap.v12,
          _row(context, colors, i, maxValue, total),
        ],
      ],
    );
  }

  Widget _row(
    BuildContext context,
    AppColors colors,
    int index,
    int maxValue,
    int total,
  ) {
    final value = index < chart.values.length ? chart.values[index] : 0;
    final factor = maxValue == 0 ? 0.0 : value / maxValue;
    final share = total == 0 ? 0.0 : value * 100 / total;
    final color = _colorAt(index, colors);

    return Tooltip(
      message: '${chart.labels[index]}: $value (%${share.toStringAsFixed(1)})',
      waitDuration: const Duration(milliseconds: 400),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(AppRadius.r2),
            ),
          ),
          AppGap.h8,
          SizedBox(
            width: 104,
            child: Text(
              chart.labels[index],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.body(context).copyWith(fontSize: 12.5),
            ),
          ),
          AppGap.h10,
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.r4),
              child: Container(
                height: 8,
                color: colors.muted,
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: value == 0 ? 0 : factor.clamp(0.02, 1.0),
                  child: Container(color: color),
                ),
              ),
            ),
          ),
          AppGap.h12,
          SizedBox(
            width: 36,
            child: Text(
              '$value',
              textAlign: TextAlign.right,
              style: AppText.cellPrimary(context),
            ),
          ),
          SizedBox(
            width: 48,
            child: Text(
              '%${share.toStringAsFixed(share >= 10 || share == 0 ? 0 : 1)}',
              textAlign: TextAlign.right,
              style: AppText.caption(context),
            ),
          ),
        ],
      ),
    );
  }

  Color _colorAt(int index, AppColors colors) {
    final palette = _palette(colors);
    final hex = chart.colors != null && index < chart.colors!.length
        ? chart.colors![index]
        : null;
    if (hex == null) return palette[index % palette.length];

    final parsed = hex.color;
    return parsed == Colors.transparent
        ? palette[index % palette.length]
        : parsed;
  }
}
