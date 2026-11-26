import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wonkru_mdm_flutter/Core/L10n/Language.dart';

void main() {
  group('AppTranslations.resolveLocale', () {
    test('a stored choice wins over the device languages', () {
      expect(
        AppTranslations.resolveLocale(
          storedTag: 'tr',
          deviceLocales: const [Locale('en', 'US')],
        ),
        AppTranslations.tr,
      );
    });

    test('an unsupported stored tag is ignored', () {
      expect(
        AppTranslations.resolveLocale(
          storedTag: 'de',
          deviceLocales: const [Locale('tr', 'TR')],
        ),
        AppTranslations.tr,
      );
    });

    test('falls back to the first supported device language', () {
      expect(
        AppTranslations.resolveLocale(
          deviceLocales: const [Locale('de', 'DE'), Locale('en', 'US')],
        ),
        AppTranslations.en,
      );
      expect(
        AppTranslations.resolveLocale(
          deviceLocales: const [Locale('tr', 'TR')],
        ),
        AppTranslations.tr,
      );
    });

    test('unsupported or absent device languages default to English', () {
      expect(AppTranslations.resolveLocale(), AppTranslations.en);
      expect(
        AppTranslations.resolveLocale(
          deviceLocales: const [Locale('de', 'DE')],
        ),
        AppTranslations.en,
      );
    });
  });
}
