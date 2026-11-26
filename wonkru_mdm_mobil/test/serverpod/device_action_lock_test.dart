import 'package:flutter_test/flutter_test.dart';
import 'package:wonkrumdm/Core/Constants/Enums/device_action.dart';
import 'package:wonkrumdm/Core/Managers/device_action_manager.dart';

void main() {
  tearDown(() => DeviceActionManager().lockNowOverride = null);

  test('ack returns success when the lock succeeds', () async {
    DeviceActionManager().lockNowOverride = () async => true;

    final result = await DeviceActionManager().executeAction(
      DeviceAction.lockNow,
    );

    expect(result, isNotNull);
    expect(result!.$1, isTrue);
  });

  test('ack does not return success when the native lock fails', () async {
    DeviceActionManager().lockNowOverride = () async => false;

    final result = await DeviceActionManager().executeAction(
      DeviceAction.lockNow,
    );

    expect(result, isNotNull);
    expect(result!.$1, isFalse);
  });
}
