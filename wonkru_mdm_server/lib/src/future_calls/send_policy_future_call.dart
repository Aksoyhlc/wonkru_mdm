import 'package:serverpod/serverpod.dart';
import 'package:wonkru_core_server/wonkru_core_server.dart' show DeviceAction;

import '../generated/protocol.dart';
import '../service/device_command_service.dart';

class SendPolicyFutureCall extends FutureCall<SendPolicyCall> {
  Future<void> send(Session session, SendPolicyCall? call) async {
    if (call == null) {
      return;
    }

    final policyId = call.policyId;

    final policy = await Policy.db.findById(session, policyId);
    if (policy == null) {
      session.log(
        'SendPolicy: policy not found, nothing to send',
        level: LogLevel.warning,
        metadata: {'policyId': policyId},
      );
      return;
    }

    final devices = await Device.db.find(
      session,
      where: (t) => t.policyId.equals(policyId) & t.uuid.notEquals(null),
    );

    final requestedIds = call.deviceIds;
    final targets = requestedIds == null || requestedIds.isEmpty
        ? devices
        : devices.where((device) => requestedIds.contains(device.id)).toList();

    final targetIds = [
      for (final device in targets)
        if (device.id != null) device.id!,
    ];

    // One queue row per device; connected devices are pushed right away, the
    // rest keep their pending row until they reconnect.
    final queued = await DeviceCommandService.enqueue(
      session,
      targetIds,
      DeviceAction.update_policy,
      const <String, dynamic>{},
    );
    final sent = await DeviceCommandService.flushAllFor(session, targetIds);

    session.log(
      'SendPolicy: policy update queued',
      metadata: {
        'policyId': policyId,
        'version': policy.version,
        'deviceCount': targets.length,
        'queued': queued,
        'sent': sent,
      },
    );
  }
}
