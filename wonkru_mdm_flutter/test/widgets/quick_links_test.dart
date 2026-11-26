import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wonkru_mdm_flutter/Core/Constants/app_sections.dart';
import 'package:wonkru_mdm_flutter/Core/Theme/app_theme.dart';
import 'package:wonkru_mdm_flutter/Views/Pages/Dashboard/Widgets/quick_links.dart';

void main() {
  testWidgets('shortcuts wrap and do not overflow at phone width', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(412, 915);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const Scaffold(
          body: Padding(
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(child: QuickLinks()),
          ),
        ),
      ),
    );
    await tester.pump();

    final chips = find.byType(InkWell);
    expect(chips, findsNWidgets(appSections.length - 1));

    final rects = [
      for (var i = 0; i < chips.evaluate().length; i++)
        tester.getRect(chips.at(i)),
    ];
    expect(rects.map((r) => r.top).toSet().length, greaterThan(1));
    for (final rect in rects) {
      expect(rect.right, lessThanOrEqualTo(412 - 20 - 16 + 0.5));
    }
    expect(tester.takeException(), isNull);
  });
}
