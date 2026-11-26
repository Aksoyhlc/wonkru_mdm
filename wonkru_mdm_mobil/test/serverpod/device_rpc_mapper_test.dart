import 'package:flutter_test/flutter_test.dart';
import 'package:wonkrumdm/Core/Constants/Enums/log_level.dart';
import 'package:wonkrumdm/Data/DataSources/Remote/device_rpc_mapper.dart';
import 'package:wonkrumdm/Data/Models/Core/log_entry.dart';

void main() {
  test('sync payload does not carry device_uuid/device_code/sync_type', () {
    final request = DeviceRpcMapper.syncRequest(
      deviceUuid: 'u1',
      token: 't1',
      syncType: 'full',
      data: {
        'device_uuid': 'u1',
        'device_code': 'C1',
        'sync_type': 'full',
        'battery': {'level': 80},
      },
    );
    expect(request.deviceUuid, 'u1');
    expect(request.token, 't1');
    expect(request.syncType, 'full');
    expect(request.payload.contains('device_uuid'), isFalse);
    expect(request.payload.contains('battery'), isTrue);
  });

  test('log entries are mapped to the server model (level name)', () {
    final entries = DeviceRpcMapper.logEntries([
      LogEntry(
        id: 'e1',
        timestamp: '2026-09-22T00:00:00Z',
        level: LogLevel.info.value,
        tag: 'T',
        message: 'm',
      ),
    ]);
    // LogLevel serializes by name, so the wire value is the lowercase member name.
    expect(entries.single.level.name, 'info');
    expect(entries.single.id, 'e1');
  });

  test('report payload becomes a JSON string', () {
    final request = DeviceRpcMapper.reportRequest(
      deviceUuid: 'u1',
      token: 't1',
      type: 'wifi_changed',
      payload: {'ssid': 'x'},
    );
    expect(request.payload, '{"ssid":"x"}');
  });
}
