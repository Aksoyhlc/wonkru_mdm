import 'package:flutter/foundation.dart' show setEquals;
import 'package:flutter_test/flutter_test.dart';

import 'l10n_fragments.dart';

/// GetX placeholder: `@name` not preceded by a letter or digit. Email parts
/// like `ornek@firma.com` do not count; `.@extension` does.
final _placeholder = RegExp(r'(?<![A-Za-z0-9])@([a-z_][a-z0-9_]*)');

Set<String> _placeholders(String value) => {
  for (final match in _placeholder.allMatches(value)) match.group(1)!,
};

/// A dropped placeholder in one language causes a runtime error.
void main() {
  for (final entry in l10nFragments.entries) {
    final area = entry.key;
    final fragment = entry.value;

    test('$area: placeholders match in both languages', () {
      final mismatches = <String>[];

      for (final key in fragment.tr.keys) {
        final en = fragment.en[key];
        if (en == null) continue;

        final trPlaceholders = _placeholders(fragment.tr[key]!);
        final enPlaceholders = _placeholders(en);
        if (!setEquals(trPlaceholders, enPlaceholders)) {
          mismatches.add(
            '$key: tr=$trPlaceholders en=$enPlaceholders',
          );
        }
      }

      expect(mismatches, isEmpty, reason: '$area: $mismatches');
    });
  }
}
