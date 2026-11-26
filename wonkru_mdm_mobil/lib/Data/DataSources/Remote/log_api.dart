import 'dart:async';

import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';
import 'package:wonkrumdm/Core/Logging/wlog.dart';
import 'package:wonkrumdm/Core/Services/enrollment_recovery.dart';
import 'package:wonkrumdm/Core/Utils/device_identity_helper.dart';
import 'package:wonkrumdm/Data/DataSources/Remote/base_api.dart';
import 'package:wonkrumdm/Data/DataSources/Remote/device_rpc_mapper.dart';
import 'package:wonkrumdm/Data/DataSources/Remote/serverpod_gateway.dart';
import 'package:wonkrumdm/Data/Models/Core/log_entry.dart';

const _tag = 'LogApi';

class LogApi extends BaseApi {
  Future<bool> sendLogs({required List<LogEntry> entries, String authToken = '', int maxRetries = 3}) async {
    if (entries.isEmpty) return false;

    final token = DeviceIdentityHelper.getToken();
    if (token == null || token.isEmpty) return false;

    for (int attempt = 0; attempt < maxRetries; attempt++) {
      try {
        await ServerpodGateway.instance.client.device.log(
          DeviceLogRequest(
            deviceUuid: DeviceIdentityHelper.getDeviceId(),
            token: token,
            sessionId: entries.first.sessionId,
            entries: DeviceRpcMapper.logEntries(entries),
          ),
        );
        return true;
      } catch (e, st) {
        WLog.w(_tag, 'Could not send logs', error: e, stackTrace: st);
        if (EnrollmentRecovery.adoptIdentity(e)) {
          continue;
        }
        if (EnrollmentRecovery.isUnauthenticated(e)) {
          unawaited(EnrollmentRecovery.handle(e));
          break;
        }
        if (attempt < maxRetries - 1) {
          final delaySeconds = (1 << attempt).clamp(1, 60);
          await Future.delayed(Duration(seconds: delaySeconds));
        }
      }
    }

    return false;
  }
}
