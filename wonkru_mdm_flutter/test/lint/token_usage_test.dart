import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Spacing and radius values that have a token must be written with it.
/// Off-scale values (e.g. 7, 18) stay literal on purpose and are allowed.
void main() {
  const spacingScale = {2, 4, 6, 8, 10, 12, 14, 16, 20, 24, 32};
  const radiusScale = {2, 3, 4, 6, 8, 10, 12, 16, 999};

  final number = RegExp(r'(?<![\w.])(\d+)(?:\.0)?(?![\w.])');
  final rules = <String, (RegExp, Set<int>)>{
    'SizedBox gap -> AppGap': (
      RegExp(r'SizedBox\((?:height|width): ?([^,()]+)\)'),
      spacingScale,
    ),
    'EdgeInsets -> AppSpacing / AppInsets': (
      RegExp(r'EdgeInsets(?:Directional)?\.\w+\(([^()]*)\)'),
      spacingScale,
    ),
    'circular -> AppRadius': (
      RegExp(r'Radius\.circular\(([^()]*)\)'),
      radiusScale,
    ),
  };

  test('layout values on the token scale use tokens', () {
    final violations = <String>[];
    final files = Directory('lib/Views')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'));

    for (final file in files) {
      final source = file.readAsStringSync();
      for (final MapEntry(key: rule, value: (pattern, scale))
          in rules.entries) {
        for (final match in pattern.allMatches(source)) {
          final onScale = number
              .allMatches(match.group(1)!)
              .map((m) => int.parse(m.group(1)!))
              .where(scale.contains);
          if (onScale.isNotEmpty) {
            final line = '\n'.allMatches(source.substring(0, match.start));
            violations.add(
              '${file.path}:${line.length + 1} $rule: ${match.group(0)}',
            );
          }
        }
      }
    }

    expect(violations, isEmpty, reason: violations.join('\n'));
  });
}
