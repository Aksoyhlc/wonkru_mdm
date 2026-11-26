import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'l10n_fragments.dart';

/// Resolves `String get x => '<key>'.tr;` lines in `L/<area>_l.dart` into
/// accessor name -> key. `\s` (including newline) is used because long getters
/// may be split across lines.
final _getter = RegExp(r"String get (\w+)\s*=>\s*'([^']+)'\.tr;");

Map<String, String> _accessorsFor(String base) {
  final file = File('lib/Core/L10n/L/${base}_l.dart');
  expect(file.existsSync(), isTrue, reason: '${file.path} not found');
  final source = file.readAsStringSync();
  return {
    for (final match in _getter.allMatches(source))
      match.group(1)!: match.group(2)!,
  };
}

void main() {
  for (final entry in l10nFragments.entries) {
    final area = entry.key;
    final fragment = entry.value;

    group('$area accessors', () {
      test('every key has an accessor', () {
        final mapped = _accessorsFor(fragment.base).values.toSet();
        final missing = fragment.tr.keys
            .where((key) => !mapped.contains(key))
            .toList();

        expect(missing, isEmpty, reason: '$area missing accessors: $missing');
      });

      test('every accessor points to an existing key', () {
        final known = {...fragment.tr.keys, ...fragment.en.keys};
        final orphans = <String>[];

        for (final accessor in _accessorsFor(fragment.base).entries) {
          if (!known.contains(accessor.value)) {
            orphans.add('${accessor.key} -> ${accessor.value}');
          }
        }

        expect(orphans, isEmpty, reason: '$area dead accessors: $orphans');
      });
    });
  }
}
