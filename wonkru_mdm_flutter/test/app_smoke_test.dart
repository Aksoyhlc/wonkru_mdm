import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:wonkru_mdm_flutter/Core/Init/dependency_injection.dart';
import 'package:wonkru_mdm_flutter/app.dart';

void main() {
  testWidgets('WonkruApp renders home and provides a Shad theme', (
    tester,
  ) async {
    Get.testMode = true;
    await DependencyInjection.initCore();
    await tester.pumpWidget(
      const WonkruApp(
        home: Scaffold(body: ShadButton(child: Text('Tamam'))),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Tamam'), findsOneWidget);
  });
}
