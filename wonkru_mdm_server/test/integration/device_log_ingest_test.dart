import 'package:test/test.dart';
import 'package:wonkru_core_server/wonkru_core_server.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';

import 'support/device_enrollment.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given device.log', (sessionBuilder, endpoints) {
    test('in a batch log submission each entry writes its own '
        'sessionId', () async {
      final registered = await endpoints.device.register(
        sessionBuilder,
        await enrolled(sessionBuilder, model: 'log'),
      );
      final stamp = DateTime.now().toUtc().toIso8601String();
      final count = await endpoints.device.log(
        sessionBuilder,
        DeviceLogRequest(
          deviceUuid: registered.uuid,
          token: registered.token,
          sessionId: 'batch',
          entries: [
            DeviceLogEntry(
              timestamp: stamp,
              level: LogLevel.info,
              message: 'a',
              sessionId: 's1',
            ),
            DeviceLogEntry(
              timestamp: stamp,
              level: LogLevel.info,
              message: 'b',
            ),
          ],
        ),
      );
      expect(count, 2);

      final rows = await DeviceLog.db.find(
        sessionBuilder.build(),
        where: (t) => t.message.inSet({'a', 'b'}),
        orderBy: (t) => t.id,
      );
      expect(rows.map((r) => r.sessionId), ['s1', 'batch']);
    });
  });
}
