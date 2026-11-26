import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wonkru_mdm_flutter/Views/Widgets/Layout/app_tile_grid.dart';

Future<List<double>> tileWidths(
  WidgetTester tester, {
  required double width,
  required double minTileWidth,
  int count = 4,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, 600);
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: width,
          child: AppTileGrid(
            minTileWidth: minTileWidth,
            spacing: 16,
            runSpacing: 16,
            children: [
              for (var i = 0; i < count; i++)
                SizedBox(key: ValueKey('t$i'), height: 40),
            ],
          ),
        ),
      ),
    ),
  );

  return [
    for (var i = 0; i < count; i++)
      tester.getSize(find.byKey(ValueKey('t$i'))).width,
  ];
}

void main() {
  testWidgets('collapses to a single full-width column on a narrow screen', (
    tester,
  ) async {
    final widths = await tileWidths(tester, width: 380, minTileWidth: 220);

    expect(widths, everyElement(380.0));
  });

  testWidgets('splits into columns on a wide screen, no leftover space', (
    tester,
  ) async {
    final widths = await tileWidths(tester, width: 1000, minTileWidth: 220);

    expect(widths, everyElement(238.0));
    expect(widths.reduce((a, b) => a + b) + 3 * 16, 1000);
  });

  testWidgets('no extra split when boxes do not exceed columns', (
    tester,
  ) async {
    final widths = await tileWidths(
      tester,
      width: 1000,
      minTileWidth: 220,
      count: 2,
    );

    expect(widths, everyElement(492.0));
  });
}
