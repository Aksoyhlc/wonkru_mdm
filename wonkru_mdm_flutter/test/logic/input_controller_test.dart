import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:wonkru_mdm_flutter/Logic/UI/input_controller.dart';

void main() {
  setUp(() {
    Get.testMode = true;
    if (Get.isRegistered<InputController>()) {
      Get.delete<InputController>(force: true);
    }
    Get.put(InputController(), permanent: true);
  });

  tearDown(() {
    if (Get.isRegistered<InputController>()) {
      Get.delete<InputController>(force: true);
    }
  });

  testWidgets('getController creates once and keeps value', (tester) async {
    final c = InputController.to;
    final a = c.getController('x', defaultValue: 'hello');
    final b = c.getController('x');
    expect(identical(a, b), isTrue);
    expect(c.getValue('x'), 'hello');
  });

  testWidgets('validator marks field invalid', (tester) async {
    final c = InputController.to;
    c.getController('name');
    c.addValidator('name', (v) => v.isEmpty ? 'gerekli' : '');
    await tester.pump();
    expect(c.validateAll(), isFalse);
    expect(c.getValidationError('name'), 'gerekli');
    c.setValue('name', 'ali');
    // setValue applies the value at the end of the next frame; an empty test
    // tree has no running frame, so schedule one explicitly.
    tester.binding.scheduleFrame();
    await tester.pump();
    expect(c.validateAll(), isTrue);
  });
}
