import 'dart:convert';
import 'dart:math';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'device_auth_service.dart';
import 'setting_service.dart';

class DeviceService {
  const DeviceService._();

  static const uniqueCodeLength = 6;

  static const observerCodeLength = 9;

  /// Upper bound accepted for a client-supplied device code (`char(36)`).
  static const maxCodeLength = 36;

  static const _alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  static final Random _random = Random.secure();

  static String randomCode(int length) {
    final buffer = StringBuffer();
    for (var i = 0; i < length; i++) {
      buffer.write(_alphabet[_random.nextInt(_alphabet.length)]);
    }
    return buffer.toString();
  }

  static Future<String> generateUniqueCode(
    Session session, {
    Transaction? transaction,
  }) async {
    for (var attempt = 0; attempt < 100; attempt++) {
      final code = randomCode(uniqueCodeLength);
      final taken = await Device.db.findFirstRow(
        session,
        where: (t) => t.code.equals(code),
        transaction: transaction,
      );
      if (taken == null) {
        return code;
      }
    }
    throw StateError('Could not allocate a unique device code');
  }

  static Future<String> generateUniqueUuid(
    Session session, {
    Transaction? transaction,
  }) async {
    for (var attempt = 0; attempt < 100; attempt++) {
      final uuid = const Uuid().v7();
      final taken = await Device.db.findFirstRow(
        session,
        where: (t) => t.uuid.equals(uuid),
        transaction: transaction,
      );
      if (taken == null) {
        return uuid;
      }
    }
    throw StateError('Could not allocate a unique device uuid');
  }

  static const authTokenBytes = 32;

  static String randomAuthToken() {
    final bytes = List<int>.generate(
      authTokenBytes,
      (_) => _random.nextInt(256),
    );
    return base64Url.encode(bytes).replaceAll('=', '');
  }

  /// Returns the **plaintext** token; callers store only
  /// [DeviceAuthService.hashToken] of it and hand the plaintext to the device
  /// once.
  static Future<String> generateUniqueAuthToken(
    Session session, {
    Transaction? transaction,
  }) async {
    for (var attempt = 0; attempt < 100; attempt++) {
      final token = randomAuthToken();
      final taken = await Device.db.findFirstRow(
        session,
        where: (t) => t.authToken.equals(DeviceAuthService.hashToken(token)),
        transaction: transaction,
      );
      if (taken == null) {
        return token;
      }
    }
    throw StateError('Could not allocate a unique device auth token');
  }

  static String? sanitizeCode(String? raw) {
    if (raw == null || raw.isEmpty) {
      return null;
    }

    final normalized = raw.trim().toUpperCase().replaceAll(
      RegExp('[^A-Z0-9_-]'),
      '',
    );

    if (normalized.isEmpty || normalized.length > maxCodeLength) {
      return null;
    }

    return normalized;
  }

  static Future<String> resolveDeviceCode(
    Session session,
    String? provided, {
    Transaction? transaction,
  }) async {
    final sanitized = sanitizeCode(provided);

    if (sanitized != null) {
      final taken = await Device.db.findFirstRow(
        session,
        where: (t) => t.code.equals(sanitized),
        transaction: transaction,
      );
      if (taken == null) {
        return sanitized;
      }
    }

    return generateUniqueCode(session, transaction: transaction);
  }

  /// Only `policyId` and `updatedAt` are written; `policyVersion` is the version
  /// the device applied and arrives through sync. Throws when the policy does not
  /// exist.
  static Future<int> assignPolicy(
    Session session,
    List<int> deviceIds,
    int policyId, {
    Transaction? transaction,
  }) async {
    final ids = deviceIds.toSet();
    if (ids.isEmpty) {
      return 0;
    }

    final policy = await Policy.db.findById(
      session,
      policyId,
      transaction: transaction,
    );
    if (policy == null) {
      throw Exception('Policy $policyId does not exist.');
    }

    final updated = await Device.db.updateWhere(
      session,
      where: (t) => t.id.inSet(ids),
      columnValues: (t) => [
        t.policyId(policyId),
        t.updatedAt(DateTime.now().toUtc()),
      ],
      transaction: transaction,
    );
    return updated.length;
  }

  /// Fills in uuid, code and default policy before a device is persisted.
  /// `createdAt` is set on the first write and `updatedAt` follows every save.
  static Future<void> applySavingDefaults(
    Session session,
    Device device, {
    Transaction? transaction,
  }) async {
    final now = DateTime.now().toUtc();
    device
      ..createdAt ??= now
      ..updatedAt = now;

    if (device.uuid == null || device.uuid!.isEmpty) {
      device.uuid = await generateUniqueUuid(session, transaction: transaction);
    }

    if (device.code.isEmpty) {
      device.code = randomCode(observerCodeLength);
    }

    if (device.policyId == null) {
      final defaultPolicyId = await SettingService.getInt(
        session,
        SettingService.defaultPolicyKey,
        transaction: transaction,
      );
      // The setting may point at a deleted policy; writing that id would fail
      // the whole insert with a foreign-key violation.
      if (defaultPolicyId != null &&
          await Policy.db.findById(
                session,
                defaultPolicyId,
                transaction: transaction,
              ) !=
              null) {
        device.policyId = defaultPolicyId;
      }
    }
  }
}
