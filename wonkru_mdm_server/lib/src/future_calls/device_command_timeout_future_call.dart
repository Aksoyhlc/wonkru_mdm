import 'package:serverpod/serverpod.dart';

import '../service/device_command_service.dart';

class DeviceCommandTimeoutFutureCall extends FutureCall {
  Future<void> markTimeouts(Session session) async {
    final closed = await DeviceCommandService.markTimeouts(session);

    if (closed > 0) {
      session.log(
        'DeviceCommandTimeout: marked $closed command(s) as timeout',
        metadata: {'closed': closed},
      );
    }
  }
}
