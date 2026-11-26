import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Views reach the server only through controllers.
void main() {
  test('views do not import repositories or the client', () {
    final forbidden = RegExp(
      r"^import '[^']*Data/(Repositories|Client)/",
      multiLine: true,
    );
    final offenders = Directory('lib/Views')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'))
        .where((file) => forbidden.hasMatch(file.readAsStringSync()))
        .map((file) => file.path)
        .toList();

    expect(offenders, isEmpty, reason: offenders.join('\n'));
  });
}
