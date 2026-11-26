import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:wonkru_mdm_flutter/Core/Init/dependency_injection.dart';
import 'package:wonkru_mdm_flutter/Core/Theme/app_theme.dart';
import 'package:wonkru_mdm_flutter/Logic/UI/input_controller.dart';
import 'package:wonkru_mdm_flutter/Views/Widgets/Switch/named_switch.dart';

void main() {
  testWidgets('NamedSwitch writes to InputController', (tester) async {
    Get.testMode = true;
    await DependencyInjection.initCore();

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: NamedSwitch(name: 'kiosk', title: 'Kiosk'),
        ),
      ),
    );

    InputController.to.setValue('kiosk', 'true');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 10));
    expect(InputController.to.getValue('kiosk'), 'true');
  });
}
