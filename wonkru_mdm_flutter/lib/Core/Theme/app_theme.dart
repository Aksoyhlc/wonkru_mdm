import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_spacing.dart';
import 'app_text.dart';

class AppTheme {
  static ThemeData light() => _build(Brightness.light, AppColors.light);
  static ThemeData dark() => _build(Brightness.dark, AppColors.dark);

  static ThemeData _build(Brightness brightness, AppColors colors) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: colors.loomBlue,
        onPrimary: brightness == Brightness.light
            ? colors.workshop
            : colors.porcelain,
        secondary: colors.graphite,
        onSecondary: colors.workshop,
        error: colors.madder,
        onError: Colors.white,
        surface: colors.workshop,
        onSurface: colors.carbon,
      ),
      scaffoldBackgroundColor: colors.porcelain,
      textTheme: AppText.textTheme(brightness),
      dividerColor: colors.border,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      hoverColor: colors.muted.withValues(alpha: 0.7),
      extensions: [colors],
    );

    return base.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: colors.workshop,
        foregroundColor: colors.carbon,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: AppText.textTheme(brightness).titleLarge,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colors.workshop,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.r8),
          side: BorderSide(color: colors.border),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.loomBlue,
        linearTrackColor: colors.muted,
      ),
      scrollbarTheme: ScrollbarThemeData(
        thickness: const WidgetStatePropertyAll(6),
        radius: const Radius.circular(AppRadius.pill),
        thumbColor: WidgetStatePropertyAll(colors.ring),
      ),
      tooltipTheme: TooltipThemeData(
        waitDuration: const Duration(milliseconds: 450),
        decoration: BoxDecoration(
          color: colors.carbon,
          borderRadius: BorderRadius.circular(AppRadius.r6),
        ),
        textStyle: TextStyle(color: colors.workshop, fontSize: 12),
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        filled: true,
        fillColor: colors.workshop,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s12,
          vertical: 11,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.r8),
          borderSide: BorderSide(color: colors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.r8),
          borderSide: BorderSide(color: colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.r8),
          borderSide: BorderSide(color: colors.loomBlue, width: 1.4),
        ),
      ),
    );
  }
}
