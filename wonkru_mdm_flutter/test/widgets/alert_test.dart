import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:wonkru_mdm_flutter/Core/Constants/Enums/alert_enums.dart';
import 'package:wonkru_mdm_flutter/Core/Init/dependency_injection.dart';
import 'package:wonkru_mdm_flutter/Logic/UI/app_toast_controller.dart';
import 'package:wonkru_mdm_flutter/Views/Widgets/Alert/app_toast.dart';
import 'package:wonkru_mdm_flutter/app.dart';

void main() {
  testWidgets('AppToast.show surfaces the message in the overlay', (
    tester,
  ) async {
    Get.testMode = true;
    await DependencyInjection.initCore();
    await tester.pumpWidget(
      const WonkruApp(home: Scaffold(body: SizedBox())),
    );
    await tester.pump();

    AppToast.show('Kaydedildi', tone: UiAlertTone.success);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Kaydedildi'), findsOneWidget);
    Get.find<AppToastController>().dismiss();
  });
}
