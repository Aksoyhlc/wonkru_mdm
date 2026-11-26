import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:wonkru_mdm_flutter/Core/Init/dependency_injection.dart';
import 'package:wonkru_mdm_flutter/Core/Theme/app_theme.dart';
import 'package:wonkru_mdm_flutter/Views/Widgets/Input/app_dropdown.dart';

Map<String, String> _items(int count) => {
  for (var i = 0; i < count; i++) '$i': 'Item $i',
};

Future<void> _pump(
  WidgetTester tester,
  Map<String, String> items, {
  bool? searchable,
}) async {
  Get.testMode = true;
  Get.reset();
  await DependencyInjection.initCore();
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(
        body: AppDropdown<String>(
          // Not a key: the trigger must not echo an item label into the finder.
          value: 'selected',
          items: items,
          searchable: searchable,
          onChanged: (_) {},
        ),
      ),
    ),
  );
  await tester.pump();
}

Future<void> _open(WidgetTester tester) async {
  await tester.tap(find.byType(AppDropdown<String>));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
}

void main() {
  testWidgets('opens over a Material-less root overlay and filters', (
    tester,
  ) async {
    await _pump(tester, {'a': 'Alpha', 'b': 'Beta'}, searchable: true);
    await _open(tester);

    expect(tester.takeException(), isNull);
    expect(find.byType(TextField), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Beta');
    await tester.pump();

    expect(find.text('Beta'), findsWidgets);
    expect(find.text('Alpha'), findsNothing);
  });

  testWidgets('auto-enables search above the threshold', (tester) async {
    await _pump(tester, _items(AppDropdown.searchThreshold + 1));
    await _open(tester);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('stays search-less at or below the threshold', (tester) async {
    await _pump(tester, _items(5));
    await _open(tester);
    expect(find.byType(TextField), findsNothing);
  });

  testWidgets('searchable: false keeps a long list search-less', (
    tester,
  ) async {
    await _pump(tester, _items(20), searchable: false);
    await _open(tester);
    expect(find.byType(TextField), findsNothing);
  });
}
