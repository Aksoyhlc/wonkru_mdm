import 'dart:async';

import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';
import 'package:wonkrumdm/Core/Logging/wlog.dart';
import 'package:wonkrumdm/Core/Services/enrollment_recovery.dart';
import 'package:wonkrumdm/Core/Utils/device_identity_helper.dart';
import 'package:wonkrumdm/Data/DataSources/Remote/base_api.dart';
import 'package:wonkrumdm/Data/DataSources/Remote/serverpod_gateway.dart';

const _tag = 'DeviceNotificationApi';

class DeviceNotificationApi extends BaseApi {
  Future<bool> ack(String notificationUuid) async {
    final token = DeviceIdentityHelper.getToken();
    if (token == null || token.isEmpty) return false;
    try {
      return await ServerpodGateway.instance.client.device.notificationAck(
        DeviceNotificationAckRequest(
          deviceUuid: DeviceIdentityHelper.getDeviceId(),
          token: token,
          notificationUuid: notificationUuid,
        ),
      );
    } catch (e, st) {
      WLog.w(_tag, 'Could not send notification ack', error: e, stackTrace: st);
      EnrollmentRecovery.onRpcError(e);
      return false;
    }
  }
}
