import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';
import 'package:wonkrumdm/Core/L10n/L.dart';
import 'package:wonkrumdm/Core/Logging/wlog.dart';
import 'package:wonkrumdm/Core/Managers/network_manager.dart';
import 'package:wonkrumdm/Core/Network/dio_factory.dart';
import 'package:wonkrumdm/Core/Services/device_data_collector.dart';
import 'package:wonkrumdm/Core/Utils/device_identity_helper.dart';
import 'package:wonkrumdm/Core/Utils/enrollment_key_store.dart';
import 'package:wonkrumdm/Data/DataSources/Remote/serverpod_gateway.dart';

/// Resolves the bootstrap CA download URL from the server address.
///
/// The CA is served on the same origin as the agent's server address (the
/// reverse proxy routes `/downloads/*` there too), so the scheme, host and port
/// are taken from [base] and only the path is applied. A user-supplied address
/// wins and is used as-is; a pathless one (the field hint `http://@host` leads
/// users to omit the path) gets the CA route appended. Returns `null` for an
/// invalid address.
Uri? resolveBootstrapCaUri({required String base, String? userValue}) {
  const caPath = '/downloads/local-ca';
  final user = userValue?.trim() ?? '';

  if (user.isNotEmpty) {
    final parsed = Uri.tryParse(user);
    if (parsed == null || parsed.host.isEmpty) return null;
    if (parsed.path.isEmpty || parsed.path == '/') {
      return parsed.replace(path: caPath);
    }
    return parsed;
  }

  final baseUri = Uri.tryParse(base);
  if (baseUri == null || baseUri.host.isEmpty) return null;
  return baseUri.replace(path: caPath, query: null, fragment: null);
}

String? normalizeBootstrapCaFingerprint(String value) {
  final fingerprint = value.replaceAll(RegExp(r'[:\s]'), '').toLowerCase();
  return RegExp(r'^[0-9a-f]{64}$').hasMatch(fingerprint) ? fingerprint : null;
}

class BootstrapCaFingerprintException implements Exception {
  const BootstrapCaFingerprintException();
}

String? _certificateFingerprint(String pem) {
  const begin = '-----BEGIN CERTIFICATE-----';
  const end = '-----END CERTIFICATE-----';
  final certificate = pem.trim();
  if (!certificate.startsWith(begin) || !certificate.endsWith(end)) {
    return null;
  }
  final body = certificate
      .substring(begin.length, certificate.length - end.length)
      .replaceAll(RegExp(r'\s'), '');
  if (body.isEmpty) return null;
  try {
    final der = base64Decode(body);
    return sha256.convert(der).toString();
  } on FormatException {
    return null;
  }
}

/// [info] is the output of `DeviceDataCollector.getDeviceInfo()`. Blank device
/// code / enrollment key are sent as `null`; the server rejects keyless
/// registration with [DeviceEnrollmentRejectedException].
DeviceRegisterRequest buildRegisterRequest(
  Map<String, dynamic> info, {
  String? deviceCode,
  String? enrollmentKey,
}) {
  final version = info['version'] as Map<String, dynamic>?;
  String? blankToNull(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }

  return DeviceRegisterRequest(
    deviceCode: blankToNull(deviceCode),
    manufacturer: info['manufacturer'] as String?,
    model: info['model'] as String?,
    brand: info['brand'] as String?,
    serialNo: info['id'] as String?,
    version: version == null
        ? null
        : DeviceVersionInfo(
            release: version['release'] as String?,
            sdkInt: version['sdkInt'] as int?,
          ),
    enrollmentKey: blankToNull(enrollmentKey),
  );
}

class DeviceRegister {
  static const _tag = 'DeviceRegister';
  final Dio _dio = DioFactory.create(
    sendTimeout: Duration(seconds: 10),
    connectTimeout: Duration(seconds: 10),
    receiveTimeout: Duration(seconds: 10),
  );

  Future<Uint8List?> downloadBootstrapCa(
    Uri caUri, {
    String? expectedFingerprint,
  }) async {
    if (caUri.scheme != 'https' && caUri.scheme != 'http') return null;
    final fingerprint = normalizeBootstrapCaFingerprint(
      expectedFingerprint ?? '',
    );
    if (fingerprint == null &&
        (caUri.scheme == 'http' || expectedFingerprint != null)) {
      throw const BootstrapCaFingerprintException();
    }

    try {
      WLog.i(_tag, 'Downloading Bootstrap CA: $caUri');
      final response = await _dio.get<List<int>>(
        caUri.toString(),
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          headers: {'Accept': 'application/octet-stream'},
        ),
      );

      final data = response.data;
      if (response.statusCode != 200 || data == null || data.isEmpty) {
        WLog.w(
          _tag,
          'Bootstrap CA download failed. status=${response.statusCode}',
        );
        return null;
      }
      // The server turns a 404 into build-page HTML when `web/app` is not
      // built; verify the body is actually a PEM certificate.
      final body = utf8.decode(data, allowMalformed: true);
      if (fingerprint != null && _certificateFingerprint(body) != fingerprint) {
        throw const BootstrapCaFingerprintException();
      }
      if (!body.contains('-----BEGIN CERTIFICATE-----')) {
        WLog.w(_tag, 'Bootstrap CA response is not a PEM certificate');
        return null;
      }
      WLog.i(_tag, 'Bootstrap CA downloaded (${data.length} bytes)');
      return Uint8List.fromList(data);
    } on DioException catch (e) {
      WLog.w(_tag, 'Bootstrap CA download error: ${e.message}');
      return null;
    }
  }

  Future<(String?, String?, String?)> register({String? deviceCode}) async {
    var code = DeviceIdentityHelper.getCode();
    var uuid = DeviceIdentityHelper.getUuid();
    final token = DeviceIdentityHelper.getToken();

    if (code != null && uuid != null && token != null) {
      return (code, uuid, null);
    }

    if (token == null) {
      await DeviceIdentityHelper.clearEnrollment();
      code = null;
      uuid = null;
    }

    final isConnected = await NetworkManager.instance.isOnline();
    if (!isConnected) {
      return (null, null, 'No network connection');
    }

    final info = await DeviceDataCollector.getDeviceInfo();
    final keyStore = EnrollmentKeyStore.instance;

    try {
      final gateway = ServerpodGateway.instance..init();
      final response = await gateway.client.device.register(
        buildRegisterRequest(
          info,
          deviceCode: deviceCode,
          enrollmentKey: keyStore.key,
        ),
      );

      DeviceIdentityHelper.saveRegistration(response.code, response.uuid);
      DeviceIdentityHelper.saveToken(response.token);
      return (response.code, response.uuid, null);
    } on DeviceEnrollmentRejectedException catch (e) {
      // Wrong/missing key: retrying with the same key is pointless. The marker
      // stops automatic recovery until a new key is entered.
      WLog.e(_tag, 'Enrollment key rejected: ${e.message}');
      keyStore.markRejected();
      return (null, null, L.enrollment_key_rejected);
    } catch (e, st) {
      // The raw error text is never shown to the user; details are logged and
      // the caller falls back to its localized message.
      WLog.e(_tag, 'Registration failed', error: e, stackTrace: st);
      return (null, null, null);
    }
  }
}
