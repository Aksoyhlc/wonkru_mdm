import 'package:flutter_test/flutter_test.dart';
import 'package:wonkru_mdm_flutter/Core/Constants/Enums/notification_enums.dart';

void main() {
  group('NotificationType', () {
    test('values stay in sync with the server enum', () {
      expect(NotificationType.values.map((type) => type.name), ['normal']);
    });

    test('labels are Turkish and non-empty', () {
      for (final type in NotificationType.values) {
        expect(type.label, isNotEmpty, reason: type.name);
      }
      expect(NotificationType.normal.label, 'Normal');
    });

    test('keyValues produces a wire value -> label map', () {
      expect(notificationTypeKeyValues, {'normal': 'Normal'});
    });

    test('fromValue resolves known values and returns null for unknown', () {
      expect(
        notificationTypeFromValue('normal'),
        NotificationType.normal,
      );
      expect(notificationTypeFromValue('urgent'), isNull);
      expect(notificationTypeFromValue(null), isNull);
    });
  });
}
