import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';
import 'package:wonkru_mdm_flutter/Core/L10n/L.dart';
import 'package:wonkru_mdm_flutter/Core/Theme/app_theme.dart';
import 'package:wonkru_mdm_flutter/Views/Pages/Devices/Widgets/device_summary_strip.dart';

Future<List<Rect>> pumpStrip(WidgetTester tester, double width) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, 900);
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: DeviceSummaryStrip(
            device: Device(code: '0K6PUE', batteryLevel: 100),
            onlineMinutes: 5,
          ),
        ),
      ),
    ),
  );

  final tiles = find.text(L.common.battery).evaluate().isEmpty
      ? <Rect>[]
      : [
          for (final label in [
            L.common.battery,
            L.common.storage,
            L.common.status,
          ])
            tester.getRect(find.text(label)),
        ];
  return tiles;
}

void main() {
  testWidgets('tiles collapse to two columns on a phone, no overflow', (
    tester,
  ) async {
    final tiles = await pumpStrip(tester, 412);

    expect(tiles[1].top, tiles[0].top);
    expect(tiles[2].top, greaterThan(tiles[0].top));
    expect(tester.takeException(), isNull);
  });

  testWidgets('stays on a single row on a wide screen', (tester) async {
    final tiles = await pumpStrip(tester, 1200);

    expect(tiles[1].top, tiles[0].top);
    expect(tiles[2].top, tiles[0].top);
    expect(tester.takeException(), isNull);
  });

  testWidgets('online state follows the given threshold', (tester) async {
    final lastSeen = DateTime.now().subtract(const Duration(minutes: 30));

    Future<void> pumpWith(int onlineMinutes) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: DeviceSummaryStrip(
              device: Device(code: '0K6PUE', lastSeenAt: lastSeen),
              onlineMinutes: onlineMinutes,
            ),
          ),
        ),
      );
    }

    await pumpWith(60);
    expect(find.text(L.common.online), findsOneWidget);

    await pumpWith(5);
    expect(find.text(L.common.offline), findsOneWidget);
  });
}
