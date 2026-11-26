import 'package:flutter_test/flutter_test.dart';
import 'package:wonkrumdm/Data/DataSources/Remote/device_register.dart';

void main() {
  final info = <String, dynamic>{
    'manufacturer': 'Samsung',
    'model': 'SM-X200',
    'brand': 'samsung',
    'id': 'SER123',
    'version': {'release': '14', 'sdkInt': 34},
  };

  test('device fields, code, and enrollment key are mapped', () {
    final request = buildRegisterRequest(
      info,
      deviceCode: ' ABC123 ',
      enrollmentKey: ' key ',
    );

    expect(request.manufacturer, 'Samsung');
    expect(request.model, 'SM-X200');
    expect(request.brand, 'samsung');
    expect(request.serialNo, 'SER123');
    expect(request.version?.release, '14');
    expect(request.version?.sdkInt, 34);
    expect(request.deviceCode, 'ABC123');
    expect(request.enrollmentKey, 'key');
  });

  test('empty code and key are sent as null', () {
    final request = buildRegisterRequest(
      const {},
      deviceCode: '  ',
      enrollmentKey: '',
    );

    expect(request.deviceCode, isNull);
    expect(request.enrollmentKey, isNull);
    expect(request.version, isNull);
  });

  test('the key is written to the enrollmentKey field on the wire', () {
    final json = buildRegisterRequest(info, enrollmentKey: 'k').toJson();

    expect(json['enrollmentKey'], 'k');
  });
}
