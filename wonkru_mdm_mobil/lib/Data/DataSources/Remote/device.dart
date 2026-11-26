import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';
import 'package:wonkrumdm/Core/Constants/Enums/storage_keys.dart';
import 'package:wonkrumdm/Core/Logging/wlog.dart';
import 'package:wonkrumdm/Core/Services/device_data_collector.dart';
import 'package:wonkrumdm/Core/Services/enrollment_recovery.dart';
import 'package:wonkrumdm/Core/Utils/device_identity_helper.dart';
import 'package:wonkrumdm/Core/Utils/storage_helper.dart';
import 'package:wonkrumdm/Data/DataSources/Remote/base_api.dart';
import 'package:wonkrumdm/Data/DataSources/Remote/device_rpc_mapper.dart';
import 'package:wonkrumdm/Data/DataSources/Remote/serverpod_gateway.dart';

class DeviceAPI extends BaseApi {
  static const _tag = 'DeviceAPI';

  static const noPolicyMessage = 'Policy not found';

  /// Runs [call] with the local uuid; on an identity mismatch
  /// ([DeviceIdentityMismatchException]) it adopts the server's identity and
  /// retries once. Never re-registers.
  Future<T> _withIdentity<T>(Future<T> Function(String deviceUuid) call) async {
    try {
      return await call(DeviceIdentityHelper.getDeviceId());
    } on DeviceIdentityMismatchException catch (e) {
      if (!EnrollmentRecovery.adoptIdentity(e)) rethrow;
      return call(DeviceIdentityHelper.getDeviceId());
    }
  }

  Future<(bool, Map<String, dynamic>)> getConfig() async {
    final token = DeviceIdentityHelper.getToken();
    if (token == null || token.isEmpty) {
      lastMessage = 'No device token; register first';
      return (false, emptyMap);
    }
    try {
      final response = await _withIdentity(
        (deviceUuid) => ServerpodGateway.instance.client.device.config(
          DeviceConfigRequest(deviceUuid: deviceUuid, token: token),
        ),
      );
      if (response.deviceCode != null && response.deviceCode!.isNotEmpty) {
        DeviceIdentityHelper.saveCode(response.deviceCode!);
      }
      final raw = response.policy;
      if (raw == null || raw.isEmpty) {
        // Policy removed/not assigned. Deliberate: the caller does not delete
        // the local config, so the device keeps the last applied settings.
        lastMessage = noPolicyMessage;
        return (false, emptyMap);
      }
      final map = jsonDecode(raw) as Map<String, dynamic>;
      lastMessage = '';
      return (true, map);
    } catch (e, st) {
      lastMessage = 'Could not fetch config';
      WLog.e(_tag, lastMessage, error: e, stackTrace: st);
      EnrollmentRecovery.onRpcError(e);
      return (false, emptyMap);
    }
  }

  Future<(bool, Map<String, dynamic>)> sync({
    List<String>? managerNames,
  }) async {
    final token = DeviceIdentityHelper.getToken();
    if (token == null || token.isEmpty) {
      lastMessage = 'No device token';
      return (false, emptyMap);
    }

    final collector = DeviceDataCollector();
    final data = managerNames != null && managerNames.isNotEmpty
        ? await collector.collectSelectedData(managerNames)
        : await collector.collectAllData();
    final syncType = (managerNames ?? []).isEmpty ? 'full' : 'dynamic';

    try {
      final response = await _withIdentity(
        (deviceUuid) => ServerpodGateway.instance.client.device.sync(
          DeviceRpcMapper.syncRequest(
            deviceUuid: deviceUuid,
            token: token,
            syncType: syncType,
            data: data,
          ),
        ),
      );
      StorageHelper.instance.setInt(
        Sk.lastSync.name,
        DateTime.now().millisecondsSinceEpoch,
      );
      if (response.deviceCode.isNotEmpty) {
        DeviceIdentityHelper.saveCode(response.deviceCode);
      }
      return (true, <String, dynamic>{'device_code': response.deviceCode});
    } catch (e, st) {
      lastMessage = 'Sync failed';
      WLog.e(_tag, lastMessage, error: e, stackTrace: st);
      EnrollmentRecovery.onRpcError(e);
      return (false, emptyMap);
    }
  }

  Future<(bool requestStatus, bool passStatus)> checkPassword(
    String password,
  ) async {
    final token = DeviceIdentityHelper.getToken();
    if (token == null || token.isEmpty) return (false, false);
    try {
      final ok = await _withIdentity(
        (deviceUuid) => ServerpodGateway.instance.client.device.passwordCheck(
          DevicePasswordCheckRequest(
            deviceUuid: deviceUuid,
            token: token,
            password: password,
          ),
        ),
      );
      return (true, ok);
    } catch (e, st) {
      lastMessage = 'Password check failed';
      WLog.e(_tag, lastMessage, error: e, stackTrace: st);
      EnrollmentRecovery.onRpcError(e);
      return (false, false);
    }
  }

  Future<(bool, Map<String, dynamic>)> policyChange(int policyId) async {
    final token = DeviceIdentityHelper.getToken();
    if (token == null || token.isEmpty) return (false, emptyMap);
    try {
      final ok = await _withIdentity(
        (deviceUuid) => ServerpodGateway.instance.client.device.policyChange(
          DevicePolicyChangeRequest(
            deviceUuid: deviceUuid,
            token: token,
            policyId: policyId,
          ),
        ),
      );
      return (ok, emptyMap);
    } catch (e, st) {
      lastMessage = 'Policy change failed';
      WLog.e(_tag, lastMessage, error: e, stackTrace: st);
      EnrollmentRecovery.onRpcError(e);
      return (false, emptyMap);
    }
  }

  /// Files larger than the server's default 50 MB limit are rejected.
  Future<(bool, Map<String, dynamic>)> uploadFile(String filePath) async {
    final token = DeviceIdentityHelper.getToken();
    if (token == null || token.isEmpty) {
      lastMessage = 'No device token';
      return (false, emptyMap);
    }

    final file = File(filePath);
    if (!await file.exists()) {
      lastMessage = 'File not found: $filePath';
      return (false, emptyMap);
    }

    try {
      final bytes = await file.readAsBytes();
      final fileName = filePath.split(Platform.pathSeparator).last;
      final dotIndex = fileName.lastIndexOf('.');
      final fileExtension = dotIndex > 0 && dotIndex < fileName.length - 1
          ? fileName.substring(dotIndex + 1)
          : null;

      // Uploads can take a while: use the upload-specific client instead of the
      // short-timeout general one.
      final response = await _withIdentity(
        (deviceUuid) => ServerpodGateway.instance.uploadClient.device.uploadFile(
          DeviceFileUploadRequest(
            deviceUuid: deviceUuid,
            token: token,
            fileName: fileName,
            fileExtension: fileExtension,
            byteData: bytes.buffer.asByteData(
              bytes.offsetInBytes,
              bytes.lengthInBytes,
            ),
          ),
        ),
      );
      return (
        true,
        <String, dynamic>{
          'id': response.id,
          'name': response.name,
          'file_path': response.filePath,
          'size_bytes': response.sizeBytes,
          'public_url': response.publicUrl,
        },
      );
    } on DeviceRequestInvalidException catch (e) {
      lastMessage = switch (e.field) {
        'byteData' => 'File too large',
        'fileExtension' => 'Unsupported file type',
        _ => 'File rejected',
      };
      WLog.w(_tag, '$lastMessage: ${e.message}');
      return (false, emptyMap);
    } catch (e, st) {
      lastMessage = 'File upload failed';
      WLog.e(_tag, lastMessage, error: e, stackTrace: st);
      EnrollmentRecovery.onRpcError(e);
      return (false, emptyMap);
    }
  }
}
