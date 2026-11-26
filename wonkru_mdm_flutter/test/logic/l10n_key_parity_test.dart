import 'package:flutter_test/flutter_test.dart';

import 'l10n_fragments.dart';

void main() {
  group('key parity', () {
    for (final entry in l10nFragments.entries) {
      final area = entry.key;
      final fragment = entry.value;

      test('$area: TR and EN have the same key set', () {
        expect(
          fragment.tr.keys.toSet(),
          fragment.en.keys.toSet(),
          reason: '$area TR/EN keys diverged',
        );
      });
    }

    test('no duplicate keys across areas', () {
      final owner = <String, String>{};
      final duplicates = <String>[];

      for (final entry in l10nFragments.entries) {
        for (final key in entry.value.tr.keys) {
          final previous = owner[key];
          if (previous != null) {
            duplicates.add('$key ($previous -> ${entry.key})');
          }
          owner[key] = entry.key;
        }
      }

      expect(duplicates, isEmpty, reason: 'Duplicate keys: $duplicates');
    });
  });
}
