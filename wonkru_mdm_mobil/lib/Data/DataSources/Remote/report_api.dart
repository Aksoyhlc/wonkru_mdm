import 'dart:async';

import 'package:wonkrumdm/Core/Logging/wlog.dart';
import 'package:wonkrumdm/Core/Constants/Enums/report_type.dart';
import 'package:wonkrumdm/Core/Services/enrollment_recovery.dart';
import 'package:wonkrumdm/Core/Utils/device_identity_helper.dart';
import 'package:wonkrumdm/Data/DataSources/Remote/base_api.dart';
import 'package:wonkrumdm/Data/DataSources/Remote/device_rpc_mapper.dart';
import 'package:wonkrumdm/Data/DataSources/Remote/serverpod_gateway.dart';

const _tag = 'ReportRemoteDataSource';

class ReportRemoteDataSource extends BaseApi {
  Future<(bool, String)> sendReport({required ReportType type, Map<String, dynamic>? payload}) async {
    return sendReportRaw(type: type.value, payload: payload);
  }

  Future<(bool, String)> sendReportRaw({required String type, Map<String, dynamic>? payload}) async {
    final token = DeviceIdentityHelper.getToken();
    if (token == null || token.isEmpty) return (false, 'No device token');

    WLog.v(_tag, 'sendReport payload: type=$type');

    try {
      await ServerpodGateway.instance.client.device.report(
        DeviceRpcMapper.reportRequest(
          deviceUuid: DeviceIdentityHelper.getDeviceId(),
          token: token,
          type: type,
          payload: payload,
        ),
      );
      return (true, '');
    } catch (e, st) {
      lastMessage = 'Could not send report';
      WLog.e(_tag, lastMessage, error: e, stackTrace: st);
      EnrollmentRecovery.onRpcError(e);
      return (false, lastMessage);
    }
  }
}
