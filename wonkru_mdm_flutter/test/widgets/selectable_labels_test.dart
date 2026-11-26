import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';
import 'package:wonkru_mdm_flutter/Core/Init/dependency_injection.dart';
import 'package:wonkru_mdm_flutter/Core/L10n/L.dart';
import 'package:wonkru_mdm_flutter/Core/Theme/app_theme.dart';
import 'package:wonkru_mdm_flutter/Views/Pages/Settings/Widgets/alert_channels_field.dart';
import 'package:wonkru_mdm_flutter/Views/Widgets/Input/app_dropdown.dart';
import 'package:wonkru_mdm_flutter/Views/Widgets/Input/custom_text_field.dart';
import 'package:wonkru_mdm_flutter/Views/Widgets/Input/string_list_field.dart';

Finder _selectable(String text) =>
    find.byWidgetPredicate((w) => w is SelectableText && w.data == text);

Future<void> _pump(WidgetTester tester, Widget child) async {
  Get.testMode = true;
  Get.reset();
  await DependencyInjection.initCore();
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(body: child),
    ),
  );
  await tester.pump();
}

void _noop(String? _) {}

void main() {
  testWidgets('CustomTextField label is selectable', (tester) async {
    await _pump(
      tester,
      const CustomTextField(
        name: 'brand',
        label: 'Brand name',
        showValidationError: false,
      ),
    );
    expect(_selectable('Brand name'), findsOneWidget);
  });

  testWidgets('AppDropdown label is selectable', (tester) async {
    await _pump(
      tester,
      const AppDropdown<String>(
        value: 'a',
        items: {'a': 'A'},
        label: 'Timezone',
        onChanged: _noop,
      ),
    );
    expect(_selectable('Timezone'), findsOneWidget);
  });

  testWidgets('StringListField label is selectable', (tester) async {
    await _pump(
      tester,
      StringListField(
        label: 'Clean times',
        values: const [],
        onChanged: (_) {},
      ),
    );
    expect(_selectable('Clean times'), findsOneWidget);
  });

  testWidgets('AlertChannelsField type label is selectable', (tester) async {
    await _pump(
      tester,
      AlertChannelsField(
        values: [
          AlertTypeChannels(
            type: SystemAlertType.device_offline,
            channels: const ['database'],
          ),
        ],
        onChanged: (_) {},
      ),
    );
    expect(_selectable(L.common.alertDeviceOffline), findsOneWidget);
  });
}
