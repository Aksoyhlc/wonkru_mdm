import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:wonkrumdm/Core/Managers/Stream/ack_envelope.dart';

void main() {
  test('error envelope carries success:false', () {
    final decoded = jsonDecode(encodeAckPayload({'status': 'error', 'message': 'boom'})) as Map;
    expect(decoded['success'], false);
    expect(decoded['status'], 'error');
    expect(decoded['message'], 'boom');
  });

  test('success envelope carries success:true', () {
    final decoded = jsonDecode(encodeAckPayload({'status': 'success', 'latitude': 1.0})) as Map;
    expect(decoded['success'], true);
    expect(decoded['latitude'], 1.0);
  });

  test('empty result counts as an error', () {
    final decoded = jsonDecode(encodeAckPayload(null)) as Map;
    expect(decoded['success'], false);
  });
}
