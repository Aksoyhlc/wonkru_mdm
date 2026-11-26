import 'package:flutter/widgets.dart' show Brightness;
import 'package:shadcn_ui/shadcn_ui.dart';

import 'app_colors.dart';

class ShadThemeBuilder {
  const ShadThemeBuilder._();

  static ShadThemeData light() => ShadThemeData(
    brightness: Brightness.light,
    colorScheme: ShadZincColorScheme.light(
      background: AppColors.light.porcelain,
      card: AppColors.light.workshop,
      cardForeground: AppColors.light.carbon,
      popover: AppColors.light.workshop,
      popoverForeground: AppColors.light.carbon,
      accent: AppColors.light.selected,
      accentForeground: AppColors.light.carbon,
      secondary: AppColors.light.muted,
      secondaryForeground: AppColors.light.carbon,
      foreground: AppColors.light.carbon,
      muted: AppColors.light.surfaceSubtle,
      mutedForeground: AppColors.light.graphite,
      primary: AppColors.light.loomBlue,
      primaryForeground: AppColors.light.workshop,
      border: AppColors.light.border,
      input: AppColors.light.border,
      destructive: AppColors.light.madder,
      ring: AppColors.light.ring,
    ),
  );

  static ShadThemeData dark() => ShadThemeData(
    brightness: Brightness.dark,
    colorScheme: ShadZincColorScheme.dark(
      background: AppColors.dark.porcelain,
      card: AppColors.dark.workshop,
      cardForeground: AppColors.dark.carbon,
      popover: AppColors.dark.workshop,
      popoverForeground: AppColors.dark.carbon,
      accent: AppColors.dark.selected,
      accentForeground: AppColors.dark.carbon,
      secondary: AppColors.dark.muted,
      secondaryForeground: AppColors.dark.carbon,
      foreground: AppColors.dark.carbon,
      muted: AppColors.dark.surfaceSubtle,
      mutedForeground: AppColors.dark.graphite,
      primary: AppColors.dark.loomBlue,
      primaryForeground: AppColors.dark.porcelain,
      border: AppColors.dark.border,
      input: AppColors.dark.border,
      destructive: AppColors.dark.madder,
      ring: AppColors.dark.ring,
    ),
  );
}
