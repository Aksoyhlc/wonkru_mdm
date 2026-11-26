library;

export 'wonkru_colors.dart';
export 'wonkru_text.dart';
export 'package:wonkrumdm/Views/Widgets/widgets.dart';

import 'package:flutter/material.dart';

import 'wonkru_colors.dart';
import 'wonkru_text.dart';

class WonkruTheme {
  WonkruTheme._();

  static ThemeData get data {
    return ThemeData.dark(useMaterial3: true).copyWith(
      scaffoldBackgroundColor: WonkruColors.bg,
      colorScheme: const ColorScheme.dark(
        surface: WonkruColors.bg2,
        primary: WonkruColors.accent,
        onSurface: Colors.white,
        onPrimary: WonkruColors.bg,
        error: WonkruColors.red,
        onError: WonkruColors.bg,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: WonkruColors.bg,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: WonkruColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: WonkruColors.accent, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: WonkruColors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: WonkruColors.red, width: 1.5),
        ),
        hintStyle: WonkruText.mono(13, color: WonkruColors.grayLight),
        errorStyle: WonkruText.mono(10, color: WonkruColors.red),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: WonkruColors.accent,
          foregroundColor: WonkruColors.bg,
          minimumSize: const Size(0, 54),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: WonkruColors.accent,
          foregroundColor: WonkruColors.bg,
          minimumSize: const Size(0, 54),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: WonkruColors.accent,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: WonkruColors.accent,
          side: const BorderSide(color: WonkruColors.accent),
          minimumSize: const Size(0, 54),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}