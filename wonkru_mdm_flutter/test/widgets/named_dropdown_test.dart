import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:wonkru_mdm_flutter/Core/Init/dependency_injection.dart';
import 'package:wonkru_mdm_flutter/Core/Theme/app_theme.dart';
import 'package:wonkru_mdm_flutter/Views/Widgets/Input/app_dropdown.dart';
import 'package:wonkru_mdm_flutter/Views/Widgets/Input/named_dropdown.dart';

Future<void> pumpDropdown(
  WidgetTester tester,
  NamedDropdown<String> dropdown,
) async {
  Get.testMode = true;
  Get.reset();
  await DependencyInjection.initCore();
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(body: dropdown),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('falls back to the first item when no value is stored', (
    tester,
  ) async {
    await pumpDropdown(
      tester,
      const NamedDropdown<String>(
        name: 'mode',
        items: {'a': 'A', 'b': 'B'},
      ),
    );

    expect(find.byType(AppDropdown<String>), findsOneWidget);
    expect(find.text('A'), findsOneWidget);
  });

  testWidgets('renders a placeholder when items is empty', (tester) async {
    await pumpDropdown(
      tester,
      const NamedDropdown<String>(name: 'empty', items: {}),
    );

    expect(find.byType(AppDropdown<String>), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
