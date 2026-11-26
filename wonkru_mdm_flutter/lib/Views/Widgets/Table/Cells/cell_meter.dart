import 'package:flutter/material.dart';

import '../../../../Core/Constants/Enums/alert_enums.dart';
import '../../../../Core/Theme/design.dart';

class CellMeter extends StatelessWidget {
  const CellMeter({
    super.key,
    required this.percent,
    this.label,
    this.tone = UiAlertTone.info,
    this.width = 88,
  });

  final double? percent;

  final String? label;

  final UiAlertTone tone;
  final double width;

  static UiAlertTone batteryTone(int? level) {
    if (level == null) return UiAlertTone.info;
    if (level <= 20) return UiAlertTone.danger;
    if (level <= 40) return UiAlertTone.warning;
    return UiAlertTone.success;
  }

  static UiAlertTone usageTone(double? usedPercent) {
    if (usedPercent == null) return UiAlertTone.info;
    if (usedPercent >= 90) return UiAlertTone.danger;
    if (usedPercent >= 75) return UiAlertTone.warning;
    return UiAlertTone.info;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    if (percent == null) {
      return Text('—', style: AppText.cellPrimary(context));
    }

    final value = percent!.clamp(0, 100).toDouble();
    final fill = colors.toneFg(tone);

    return SizedBox(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label ?? '${value.round()}%',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.cellPrimary(context).copyWith(color: fill),
          ),
          AppGap.v4,
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: SizedBox(
              height: 4,
              child: LinearProgressIndicator(
                value: value / 100,
                backgroundColor: colors.muted,
                valueColor: AlwaysStoppedAnimation<Color>(fill),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
