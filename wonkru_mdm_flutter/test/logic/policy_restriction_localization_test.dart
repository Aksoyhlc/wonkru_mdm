import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:wonkru_mdm_flutter/Views/Pages/Policies/Widgets/policy_restriction_tab_view.dart';

void main() {
  final catalogKeys = _readCatalogKeys();

  group('restriction label translation keys', () {
    test('38 unique keys are read from the catalog source', () {
      if (catalogKeys == null) {
        markTestSkipped(
          'wonkru_core_server catalog source not found '
          '(standalone panel copy); parity test skipped.',
        );
        return;
      }

      expect(catalogKeys, hasLength(38));
      expect(catalogKeys.toSet(), hasLength(38));
    });

    test(
      'every catalog key maps to the policies.restriction.<key> shape',
      () {
        if (catalogKeys == null) {
          markTestSkipped(
            'Catalog source missing; key shape check skipped.',
          );
          return;
        }

        final shape = RegExp(r'^policies\.restriction\.[a-z0-9_]+$');
        final mapped = <String>{};

        for (final key in catalogKeys) {
          final translationKey = restrictionLabelKey(key);
          expect(translationKey, 'policies.restriction.$key');
          expect(
            shape.hasMatch(translationKey),
            isTrue,
            reason: 'Unexpected key shape: $translationKey',
          );
          mapped.add(translationKey);
        }

        expect(mapped, hasLength(catalogKeys.length));
      },
    );

    test('no orphan restriction.* translation keys', () {
      if (catalogKeys == null) {
        markTestSkipped('Catalog source missing; orphan check skipped.');
        return;
      }

      final translated = _readL10nRestrictionKeys();
      if (translated == null) {
        markTestSkipped(
          'lib/Core/L10n directory could not be read; orphan check skipped.',
        );
        return;
      }

      final catalog = catalogKeys.toSet();
      final orphans = translated.difference(catalog);
      expect(
        orphans,
        isEmpty,
        reason: 'Translation key not present in the catalog: $orphans',
      );

      final missing = catalog.difference(translated);
      expect(
        missing,
        isEmpty,
        reason: 'Untranslated catalog key: $missing',
      );
    });

    test('raw catalog key is not displayed on screen', () {
      if (catalogKeys == null) {
        markTestSkipped('Catalog source missing; raw-key check skipped.');
        return;
      }

      for (final key in catalogKeys) {
        final translationKey = restrictionLabelKey(key);
        final translated = translationKey.tr;
        expect(
          translated,
          isNot(translationKey),
          reason: 'Untranslated restriction key appears on screen: $key',
        );
        expect(translated, isNot(contains(key)));
      }
    });
  });
}

List<String>? _readCatalogKeys() {
  const candidates = <String>[
    '../wonkru_core_server/lib/src/catalog/restriction_catalog.dart',
    'wonkru_core_server/lib/src/catalog/restriction_catalog.dart',
  ];

  for (final path in candidates) {
    final file = File(path);
    if (!file.existsSync()) continue;

    final keys = RegExp(r"key:\s*'([^']+)'")
        .allMatches(file.readAsStringSync())
        .map((match) => match.group(1)!)
        .toList();
    if (keys.length == 38) return keys;
  }

  return null;
}

Set<String>? _readL10nRestrictionKeys() {
  final directory = Directory('lib/Core/L10n');
  if (!directory.existsSync()) return null;

  final pattern = RegExp(r'policies\.restriction\.([a-z0-9_]+)');
  final keys = <String>{};

  for (final entity in directory.listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;
    for (final match in pattern.allMatches(entity.readAsStringSync())) {
      keys.add(match.group(1)!);
    }
  }

  return keys;
}
