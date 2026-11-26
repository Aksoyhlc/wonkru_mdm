import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wonkru_mdm_flutter/Core/Theme/app_theme.dart';
import 'package:wonkru_mdm_flutter/Views/Widgets/Form/detail_field.dart';

Future<(Offset label, Offset value, double height)> layout(
  WidgetTester tester,
  double width,
) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(
        body: SizedBox(
          width: width,
          child: const DetailField(label: 'UUID', value: '01a0be1b-fad7'),
        ),
      ),
    ),
  );

  return (
    tester.getTopLeft(find.text('UUID')),
    tester.getTopLeft(find.text('01a0be1b-fad7')),
    tester.getSize(find.byType(DetailField)).height,
  );
}

void main() {
  testWidgets('label and value side by side in a wide field', (tester) async {
    final (label, value, height) = await layout(tester, 600);

    expect(label.dy, value.dy, reason: 'must be on the same row');
    expect(value.dx, greaterThan(label.dx));
    expect(height, 31);
  });

  testWidgets('label moves above the value in a narrow field', (tester) async {
    final (label, value, height) = await layout(tester, 300);

    expect(value.dy, greaterThan(label.dy), reason: 'must wrap below');
    expect(value.dx, label.dx, reason: 'must be left-aligned');
    expect(height, greaterThan(31));
  });
}
