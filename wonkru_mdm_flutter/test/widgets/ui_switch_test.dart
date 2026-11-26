import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wonkru_mdm_flutter/Core/Theme/app_theme.dart';
import 'package:wonkru_mdm_flutter/Views/Widgets/Switch/ui_switch.dart';

const _longSubtitle =
    'The user cannot configure Bluetooth settings. Toggles the '
    'DISALLOW_CONFIG_BLUETOOTH key on the "Restriction" tab.';

Future<void> _pumpInBox(
  WidgetTester tester, {
  required double width,
  required bool dense,
}) {
  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: width,
            child: UiSwitch(
              value: false,
              onChanged: (_) {},
              title: 'Bluetooth Configuration',
              subtitle: _longSubtitle,
              dense: dense,
            ),
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('long description fits a narrow column (dense)', (tester) async {
    await _pumpInBox(tester, width: 300, dense: true);

    expect(tester.takeException(), isNull);
  });

  testWidgets('long description fits a narrow column (normal)', (tester) async {
    await _pumpInBox(tester, width: 300, dense: false);

    expect(tester.takeException(), isNull);
  });

  testWidgets('shrinks to its content in a wide area', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const Scaffold(
          body: Center(
            child: UiSwitch(
              value: true,
              onChanged: null,
              title: 'Short',
              dense: true,
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    final size = tester.getSize(find.byType(UiSwitch));
    expect(size.width, lessThan(200));
  });
}
