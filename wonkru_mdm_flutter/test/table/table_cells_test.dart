import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:wonkru_mdm_flutter/Core/Constants/Enums/table_enums.dart';
import 'package:wonkru_mdm_flutter/Core/Constants/Enums/alert_enums.dart';
import 'package:wonkru_mdm_flutter/Core/L10n/L.dart';
import 'package:wonkru_mdm_flutter/Core/Theme/app_theme.dart';
import 'package:wonkru_mdm_flutter/Views/Widgets/Table/Cells/cell_chips.dart';
import 'package:wonkru_mdm_flutter/Views/Widgets/Table/Cells/cell_date.dart';
import 'package:wonkru_mdm_flutter/Views/Widgets/Table/Cells/cell_meter.dart';
import 'package:wonkru_mdm_flutter/Views/Widgets/Table/Cells/cell_primary.dart';
import 'package:wonkru_mdm_flutter/Views/Widgets/Table/Cells/cell_text.dart';
import 'package:wonkru_mdm_flutter/Views/Widgets/Table/table_column.dart';

Future<void> _pump(WidgetTester tester, Widget child) {
  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(body: Center(child: child)),
    ),
  );
}

void main() {
  group('CellMeter tones', () {
    test('battery level takes a tone by threshold', () {
      expect(CellMeter.batteryTone(null), UiAlertTone.info);
      expect(CellMeter.batteryTone(8), UiAlertTone.danger);
      expect(CellMeter.batteryTone(20), UiAlertTone.danger);
      expect(CellMeter.batteryTone(35), UiAlertTone.warning);
      expect(CellMeter.batteryTone(40), UiAlertTone.warning);
      expect(CellMeter.batteryTone(87), UiAlertTone.success);
    });

    test('usage ratio takes a tone by threshold', () {
      expect(CellMeter.usageTone(null), UiAlertTone.info);
      expect(CellMeter.usageTone(12), UiAlertTone.info);
      expect(CellMeter.usageTone(75), UiAlertTone.warning);
      expect(CellMeter.usageTone(95), UiAlertTone.danger);
    });
  });

  group('AppColumn', () {
    test('copyWith changes only visibility', () {
      final column = AppColumn<int>(
        title: 'Device',
        cell: (row) => Text('$row'),
        width: 220,
        sortKey: 'name',
        freeze: AppColumnFreeze.start,
      );

      final hidden = column.copyWith(visible: false);

      expect(hidden.visible, isFalse);
      expect(hidden.title, 'Device');
      expect(hidden.width, 220);
      expect(hidden.sortable, isTrue);
      expect(hidden.sortKey, 'name');
      expect(hidden.freeze, AppColumnFreeze.start);
    });
  });

  testWidgets('CellText renders an empty value as a dash', (tester) async {
    await _pump(tester, const CellText('   '));
    expect(find.text('—'), findsOneWidget);
  });

  testWidgets('CellPrimary shows name and subtitle together', (tester) async {
    await _pump(
      tester,
      const CellPrimary(title: 'Register 01', subtitle: '0K6PUE'),
    );
    expect(find.text('Register 01'), findsOneWidget);
    expect(find.text('0K6PUE'), findsOneWidget);
  });

  testWidgets('CellChips collects the overflowing ones as +N', (tester) async {
    await _pump(
      tester,
      const CellChips(['Depot', 'Register', 'Ankara', 'İzmir'], maxVisible: 2),
    );

    expect(find.text('Depot'), findsOneWidget);
    expect(find.text('Register'), findsOneWidget);
    expect(find.text('Ankara'), findsNothing);
    expect(find.text('+2'), findsOneWidget);
  });

  testWidgets('CellDate writes relative and full date', (tester) async {
    final date = DateTime.now().subtract(const Duration(hours: 3));
    await _pump(tester, CellDate(date));

    expect(
      find.text(L.common.timeHoursAgo.trParams({'count': '3'})),
      findsOneWidget,
    );
    expect(find.textContaining(':'), findsOneWidget);
  });
}
