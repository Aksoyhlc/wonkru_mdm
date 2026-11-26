import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.porcelain,
    required this.workshop,
    required this.carbon,
    required this.graphite,
    required this.loomBlue,
    required this.madder,
    required this.border,
    required this.muted,
    required this.success,
    required this.warning,
    required this.ring,
    required this.surfaceSubtle,
    required this.hover,
    required this.selected,
    required this.info,
    required this.successSoft,
    required this.successBorder,
    required this.warningSoft,
    required this.warningBorder,
    required this.dangerSoft,
    required this.dangerBorder,
    required this.infoSoft,
    required this.infoBorder,
    required this.chartPurple,
    required this.chartTeal,
  });

  final Color porcelain;
  final Color workshop;
  final Color carbon;
  final Color graphite;
  final Color loomBlue;
  final Color madder;

  final Color border;
  final Color muted;
  final Color success;
  final Color warning;

  final Color ring;
  final Color surfaceSubtle;
  final Color hover;
  final Color selected;
  final Color info;

  final Color successSoft;
  final Color successBorder;
  final Color warningSoft;
  final Color warningBorder;
  final Color dangerSoft;
  final Color dangerBorder;
  final Color infoSoft;
  final Color infoBorder;

  /// Extra hues for chart palettes (no semantic meaning).
  final Color chartPurple;
  final Color chartTeal;

  static const light = AppColors(
    porcelain: Color(0xFFFFFFFF),
    workshop: Color(0xFFFFFFFF),
    carbon: Color(0xFF1F1F1F),
    graphite: Color(0xFF707070),
    loomBlue: Color(0xFF343434),
    madder: Color(0xFFD14343),
    border: Color(0xFFE6E6E6),
    muted: Color(0xFFF5F5F5),
    success: Color(0xFF1F8A5B),
    warning: Color(0xFFC47B20),
    ring: Color(0xFF8A8A8A),
    surfaceSubtle: Color(0xFFFAFAFA),
    hover: Color(0xFFF6F6F6),
    selected: Color(0xFFEFEFEF),
    info: Color(0xFF5C5C5C),
    successSoft: Color(0xFFEDF6F2),
    successBorder: Color(0xFFC7E2D6),
    warningSoft: Color(0xFFFAF4ED),
    warningBorder: Color(0xFFF0DEC7),
    dangerSoft: Color(0xFFFBF0F0),
    dangerBorder: Color(0xFFF4D0D0),
    infoSoft: Color(0xFFF7F7F7),
    infoBorder: Color(0xFFDDDDDD),
    chartPurple: Color(0xFF6B4EAA),
    chartTeal: Color(0xFF0E7490),
  );

  static const dark = AppColors(
    porcelain: Color(0xFF0D0D0D),
    workshop: Color(0xFF171717),
    carbon: Color(0xFFF3F1ED),
    graphite: Color(0xFFAEA9A0),
    loomBlue: Color(0xFFE1D7C5),
    madder: Color(0xFFF87171),
    border: Color(0xFF343330),
    muted: Color(0xFF222221),
    success: Color(0xFF4ADE80),
    warning: Color(0xFFFBBF24),
    ring: Color(0xFFA99A7E),
    surfaceSubtle: Color(0xFF1C1C1B),
    hover: Color(0xFF252524),
    selected: Color(0xFF302D27),
    info: Color(0xFFC9B89A),
    successSoft: Color(0xFF1B2B2A),
    successBorder: Color(0xFF244C3A),
    warningSoft: Color(0xFF292822),
    warningBorder: Color(0xFF504423),
    dangerSoft: Color(0xFF292228),
    dangerBorder: Color(0xFF4F3136),
    infoSoft: Color(0xFF23211D),
    infoBorder: Color(0xFF484237),
    chartPurple: Color(0xFFA78BFA),
    chartTeal: Color(0xFF22D3EE),
  );

  @override
  AppColors copyWith({
    Color? porcelain,
    Color? workshop,
    Color? carbon,
    Color? graphite,
    Color? loomBlue,
    Color? madder,
    Color? border,
    Color? muted,
    Color? success,
    Color? warning,
    Color? ring,
    Color? surfaceSubtle,
    Color? hover,
    Color? selected,
    Color? info,
    Color? successSoft,
    Color? successBorder,
    Color? warningSoft,
    Color? warningBorder,
    Color? dangerSoft,
    Color? dangerBorder,
    Color? infoSoft,
    Color? infoBorder,
    Color? chartPurple,
    Color? chartTeal,
  }) => AppColors(
    porcelain: porcelain ?? this.porcelain,
    workshop: workshop ?? this.workshop,
    carbon: carbon ?? this.carbon,
    graphite: graphite ?? this.graphite,
    loomBlue: loomBlue ?? this.loomBlue,
    madder: madder ?? this.madder,
    border: border ?? this.border,
    muted: muted ?? this.muted,
    success: success ?? this.success,
    warning: warning ?? this.warning,
    ring: ring ?? this.ring,
    surfaceSubtle: surfaceSubtle ?? this.surfaceSubtle,
    hover: hover ?? this.hover,
    selected: selected ?? this.selected,
    info: info ?? this.info,
    successSoft: successSoft ?? this.successSoft,
    successBorder: successBorder ?? this.successBorder,
    warningSoft: warningSoft ?? this.warningSoft,
    warningBorder: warningBorder ?? this.warningBorder,
    dangerSoft: dangerSoft ?? this.dangerSoft,
    dangerBorder: dangerBorder ?? this.dangerBorder,
    infoSoft: infoSoft ?? this.infoSoft,
    infoBorder: infoBorder ?? this.infoBorder,
    chartPurple: chartPurple ?? this.chartPurple,
    chartTeal: chartTeal ?? this.chartTeal,
  );

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      porcelain: Color.lerp(porcelain, other.porcelain, t)!,
      workshop: Color.lerp(workshop, other.workshop, t)!,
      carbon: Color.lerp(carbon, other.carbon, t)!,
      graphite: Color.lerp(graphite, other.graphite, t)!,
      loomBlue: Color.lerp(loomBlue, other.loomBlue, t)!,
      madder: Color.lerp(madder, other.madder, t)!,
      border: Color.lerp(border, other.border, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      ring: Color.lerp(ring, other.ring, t)!,
      surfaceSubtle: Color.lerp(surfaceSubtle, other.surfaceSubtle, t)!,
      hover: Color.lerp(hover, other.hover, t)!,
      selected: Color.lerp(selected, other.selected, t)!,
      info: Color.lerp(info, other.info, t)!,
      successSoft: Color.lerp(successSoft, other.successSoft, t)!,
      successBorder: Color.lerp(successBorder, other.successBorder, t)!,
      warningSoft: Color.lerp(warningSoft, other.warningSoft, t)!,
      warningBorder: Color.lerp(warningBorder, other.warningBorder, t)!,
      dangerSoft: Color.lerp(dangerSoft, other.dangerSoft, t)!,
      dangerBorder: Color.lerp(dangerBorder, other.dangerBorder, t)!,
      infoSoft: Color.lerp(infoSoft, other.infoSoft, t)!,
      infoBorder: Color.lerp(infoBorder, other.infoBorder, t)!,
      chartPurple: Color.lerp(chartPurple, other.chartPurple, t)!,
      chartTeal: Color.lerp(chartTeal, other.chartTeal, t)!,
    );
  }
}
