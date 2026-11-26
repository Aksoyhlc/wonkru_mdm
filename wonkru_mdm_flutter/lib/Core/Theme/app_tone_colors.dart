import 'package:flutter/material.dart';

import '../Constants/Enums/alert_enums.dart';
import 'app_colors.dart';

extension AppToneColorsX on AppColors {
  Color toneFg(UiAlertTone tone) => switch (tone) {
    UiAlertTone.success => success,
    UiAlertTone.warning => warning,
    UiAlertTone.danger => madder,
    UiAlertTone.info => info,
  };

  Color toneSoft(UiAlertTone tone) => switch (tone) {
    UiAlertTone.success => successSoft,
    UiAlertTone.warning => warningSoft,
    UiAlertTone.danger => dangerSoft,
    UiAlertTone.info => infoSoft,
  };

  Color toneBorder(UiAlertTone tone) => switch (tone) {
    UiAlertTone.success => successBorder,
    UiAlertTone.warning => warningBorder,
    UiAlertTone.danger => dangerBorder,
    UiAlertTone.info => infoBorder,
  };

  /// Accent for icons and meters; `info` uses the brand accent.
  Color toneAccent(UiAlertTone tone) => switch (tone) {
    UiAlertTone.success => success,
    UiAlertTone.warning => warning,
    UiAlertTone.danger => madder,
    UiAlertTone.info => loomBlue,
  };
}
