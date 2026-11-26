import 'package:flutter/material.dart';

import '../Extensions/context.dart';
import 'app_colors.dart';

class AppText {
  const AppText._();

  static const fontFamily = 'Quicksand';

  static TextStyle pageTitle(BuildContext context) => _style(
    context.appColors.carbon,
    size: 15,
    weight: FontWeight.w700,
    letterSpacing: -0.1,
  );

  static TextStyle sectionTitle(BuildContext context) =>
      _style(context.appColors.carbon, size: 15, weight: FontWeight.w600);

  static TextStyle cardTitle(BuildContext context) =>
      _style(context.appColors.carbon, size: 13.5, weight: FontWeight.w600);

  static TextStyle body(BuildContext context) => _style(context.appColors.carbon, size: 13, height: 1.4);

  static TextStyle bodyMuted(BuildContext context) => _style(context.appColors.graphite, size: 13, height: 1.4);

  static TextStyle label(BuildContext context) => _style(context.appColors.carbon, size: 12.5, weight: FontWeight.w500);

  static TextStyle fieldLabel(BuildContext context) =>
      _style(context.appColors.graphite, size: 11, weight: FontWeight.w500);

  static TextStyle columnHeader(BuildContext context) =>
      _style(context.appColors.graphite, size: 12, weight: FontWeight.w600);

  static TextStyle cellPrimary(BuildContext context) =>
      _style(context.appColors.carbon, size: 13, weight: FontWeight.w500);

  static TextStyle cellSecondary(BuildContext context) => _style(context.appColors.graphite, size: 11.5);

  static TextStyle caption(BuildContext context, {double size = 11.5}) =>
      _style(context.appColors.graphite, size: size, height: 1.35);

  static TextStyle badge(BuildContext context, Color color) => _style(color, size: 11.5, weight: FontWeight.w600);

  static TextStyle button(BuildContext context, Color color) => _style(color, size: 13, weight: FontWeight.w600);

  static TextStyle mono(
    Color color, {
    double size = 12,
    FontWeight weight = FontWeight.w500,
  }) => TextStyle(
    fontFamily: fontFamily,
    fontSize: size,
    fontWeight: weight,
    color: color,
    letterSpacing: 0.1,
  );

  static TextStyle _style(
    Color color, {
    required double size,
    FontWeight weight = FontWeight.w400,
    double? height,
    double? letterSpacing,
  }) => TextStyle(
    fontFamily: fontFamily,
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: height,
    letterSpacing: letterSpacing,
  );

  static TextTheme textTheme(Brightness brightness) {
    final palette = brightness == Brightness.dark ? AppColors.dark : AppColors.light;
    final base = palette.carbon;
    final muted = palette.graphite;
    return TextTheme(
      displayLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: base,
        letterSpacing: -0.6,
        height: 1.15,
      ),
      headlineMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: base,
        letterSpacing: -0.4,
        height: 1.2,
      ),
      titleLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: base,
        letterSpacing: -0.2,
      ),
      titleMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: base,
      ),
      bodyLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: base,
        height: 1.45,
      ),
      bodyMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: muted,
        height: 1.4,
      ),
      labelLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: base,
      ),
      labelSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: muted,
        letterSpacing: 0.1,
      ),
    );
  }
}
