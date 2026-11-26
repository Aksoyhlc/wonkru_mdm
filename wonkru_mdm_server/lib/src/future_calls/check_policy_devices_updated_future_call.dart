import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../service/system_alert_dispatcher.dart';
import '../util/device_label.dart';

/// Runs a while after a policy version bump and looks for devices that have not
/// picked the new version up yet.
class CheckPolicyDevicesUpdatedFutureCall
    extends FutureCall<CheckPolicyDevicesCall> {
  Future<void> check(Session session, CheckPolicyDevicesCall? call) async {
    if (call == null) {
      return;
    }

    final policyId = call.policyId;
    final expectedVersion = call.expectedVersion;

    final policy = await Policy.db.findById(session, policyId);
    if (policy == null) {
      session.log(
        'CheckPolicyDevicesUpdated: policy not found, nothing to check',
        level: LogLevel.warning,
        metadata: {'policyId': policyId, 'expectedVersion': expectedVersion},
      );
      return;
    }

    final outdated = await Device.db.find(
      session,
      where: (t) =>
          t.policyId.equals(policyId) &
          (t.policyVersion.equals(null) | (t.policyVersion < expectedVersion)),
      orderByList: (t) => [t.id.asc()],
    );

    if (outdated.isEmpty) {
      session.log(
        'CheckPolicyDevicesUpdated: no devices pending update',
        level: LogLevel.debug,
        metadata: {'policyId': policyId, 'expectedVersion': expectedVersion},
      );
      return;
    }

    session.log(
      'CheckPolicyDevicesUpdated: devices still on an older policy version',
      level: LogLevel.warning,
      metadata: {
        'policyId': policyId,
        'policyName': policy.name,
        'expectedVersion': expectedVersion,
        'outdatedCount': outdated.length,
        'deviceIds': outdated.map((device) => device.id).toList(),
      },
    );

    final policyLabel = policy.name.isEmpty ? '#${policy.id}' : policy.name;
    final title =
        'Policy update pending: $policyLabel '
        '(v$expectedVersion)';
    final body =
        '${outdated.length} devices have not received the policy update yet.\n'
        '${_formatDeviceList(outdated)}';

    try {
      final recipientCount = await SystemAlertDispatcher.dispatch(
        session,
        type: SystemAlertType.policy_update_pending,
        title: title,
        message: body,
        data: {
          'policy_id': policyId,
          'policy_version': expectedVersion,
          'device_ids': [for (final device in outdated) device.id],
        },
      );

      session.log(
        'CheckPolicyDevicesUpdated: policy-update alert dispatched',
        level: LogLevel.info,
        metadata: {
          'policyId': policyId,
          'expectedVersion': expectedVersion,
          'outdatedCount': outdated.length,
          'recipientCount': recipientCount,
        },
      );
    } catch (error, stackTrace) {
      // Device detection is complete even if the alert cannot be sent; the job
      // does not fail.
      session.log(
        'CheckPolicyDevicesUpdated: policy-update alert could not be dispatched',
        level: LogLevel.error,
        exception: error,
        stackTrace: stackTrace,
        metadata: {'policyId': policyId, 'expectedVersion': expectedVersion},
      );
    }
  }

  static String _formatDeviceList(List<Device> devices) {
    final lines = <String>[
      for (final device in devices.take(10))
        '- ${deviceShortLabel(device)} (id: ${device.id}, '
            'policy_version: ${device.policyVersion ?? 'null'})',
    ];

    final remaining = devices.length - 10;
    if (remaining > 0) {
      lines.add('+$remaining more devices');
    }

    return lines.join('\n');
  }
}
