import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';
import 'package:wonkru_core_server/wonkru_core_server.dart';

import '../generated/protocol.dart';

/// Devices are not Serverpod users: they carry the opaque token issued at
/// enrollment, and only its SHA-256 is stored in [Device.authToken], so a leaked
/// database does not leak usable device credentials. Every device RPC except
/// `register` authenticates through [requireDevice].
class DeviceAuthService {
  const DeviceAuthService._();

  // Plaintext tokens are 43-character base64url strings, so a hex-64 value is
  // always a stored hash; the migration relies on that to hash rows idempotently.
  static final hashPattern = RegExp(r'^[0-9a-f]{64}$');

  // Unsalted SHA-256 is enough here: the token has 256 bits of entropy, so the
  // hash only has to make the stored value useless as a credential.
  static String hashToken(String token) =>
      sha256.convert(utf8.encode(token)).toString();

  static Future<Device> requireDevice(Session session, String? token) async {
    final normalized = token?.trim();
    if (normalized == null || normalized.isEmpty) {
      throw DeviceUnauthenticatedException(
        message: 'Missing device token.',
      );
    }

    final device = await Device.db.findFirstRow(
      session,
      where: (t) => t.authToken.equals(hashToken(normalized)),
    );

    if (device == null) {
      throw DeviceUnauthenticatedException(
        message: 'Unknown device token.',
      );
    }

    return device;
  }
}
