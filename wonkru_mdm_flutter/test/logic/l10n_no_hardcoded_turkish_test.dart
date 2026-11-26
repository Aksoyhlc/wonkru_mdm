import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Ratchet: Turkish string-literal budget under `Views/**`; only ever lower it,
/// the final target is 0.
const turkishLiteralBudget = 0;

/// Turkish string-literal budget for non-UI layers (controllers, repositories,
/// models). Comments do not count.
const nonUiTurkishLiteralBudget = 0;

const _turkishChars = 'çğıöşüÇĞİÖŞÜ';

void main() {
  test("Turkish literal budget under Views/** is not exceeded", () {
    final count = _countTurkishLiterals(Directory('lib/Views'));

    expect(
      count,
      lessThanOrEqualTo(turkishLiteralBudget),
      reason:
          'Turkish literal count: $count (budget $turkishLiteralBudget). '
          'Use the `L.<area>.<x>` translation instead of adding a literal.',
    );
  });

  test("Turkish literal budget in the Logic/Data layer is not exceeded", () {
    final count =
        _countTurkishLiterals(Directory('lib/Logic')) +
        _countTurkishLiterals(Directory('lib/Data'));

    expect(
      count,
      lessThanOrEqualTo(nonUiTurkishLiteralBudget),
      reason:
          'Turkish literal count in Logic/Data: $count. '
          'Use `L.<area>.<x>` for user text; log messages should be English.',
    );
  });
}

int _countTurkishLiterals(Directory root) {
  var total = 0;
  for (final entity in root.listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;
    total += _countInSource(entity.readAsStringSync());
  }
  return total;
}

int _countInSource(String source) {
  var count = 0;
  var i = 0;
  final n = source.length;

  while (i < n) {
    final c = source[i];

    if (c == '/' && i + 1 < n && source[i + 1] == '/') {
      i += 2;
      while (i < n && source[i] != '\n') {
        i++;
      }
      continue;
    }

    if (c == '/' && i + 1 < n && source[i + 1] == '*') {
      i += 2;
      while (i + 1 < n && !(source[i] == '*' && source[i + 1] == '/')) {
        i++;
      }
      i += 2;
      continue;
    }

    if (c == "'" || c == '"') {
      final quote = c;
      final isTriple =
          i + 2 < n && source[i + 1] == quote && source[i + 2] == quote;

      if (isTriple) {
        i += 3;
        final buffer = StringBuffer();
        while (i + 2 < n &&
            !(source[i] == quote &&
                source[i + 1] == quote &&
                source[i + 2] == quote)) {
          buffer.write(source[i]);
          i++;
        }
        i += 3;
        if (_hasTurkish(buffer.toString())) count++;
      } else {
        i++;
        final buffer = StringBuffer();
        while (i < n && source[i] != quote) {
          if (source[i] == '\\' && i + 1 < n) {
            buffer.write(source[i + 1]);
            i += 2;
            continue;
          }
          if (source[i] == '\n') break;
          buffer.write(source[i]);
          i++;
        }
        i++;
        if (_hasTurkish(buffer.toString())) count++;
      }
      continue;
    }

    i++;
  }

  return count;
}

bool _hasTurkish(String value) {
  for (final char in value.split('')) {
    if (_turkishChars.contains(char)) return true;
  }
  return false;
}
