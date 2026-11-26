import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wonkru_mdm_flutter/Core/Theme/app_theme.dart';
import 'package:wonkru_mdm_flutter/Views/Widgets/Input/custom_text_field.dart';

Future<void> _pump(WidgetTester tester, TextEditingController controller) {
  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(
        body: CustomTextField(
          name: 'swap_field',
          controller: controller,
          showValidationError: false,
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('switches to the new controller when the external one changes', (
    tester,
  ) async {
    final first = TextEditingController(text: 'old');
    final second = TextEditingController(text: 'new');
    addTearDown(second.dispose);

    await _pump(tester, first);
    expect(find.text('old'), findsOneWidget);

    // The parent swaps the controller; the field must not touch the old one.
    await _pump(tester, second);
    first.dispose();
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text('new'), findsOneWidget);
    expect(find.text('old'), findsNothing);
  });

  testWidgets('new controller changes reach the field', (tester) async {
    final first = TextEditingController(text: 'old');
    addTearDown(first.dispose);
    final second = TextEditingController(text: 'new');
    addTearDown(second.dispose);

    await _pump(tester, first);
    await _pump(tester, second);

    second.text = 'current';
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text('current'), findsOneWidget);
  });
}
