import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:base32/base32.dart';
import 'package:otp/otp.dart';
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../util/password_hasher.dart';
import '../util/totp_secret_cipher.dart';

/// If both the authenticator and the recovery codes are lost, 2FA can only be
/// cleared by an operator with shell access, using
/// `server admin passwd --email <address> --clear-totp`. That path wipes the TOTP
/// columns and the `admin_totp_sessions` rows for the user through
/// [clearForRecovery].
class AdminTwoFactorService {
  AdminTwoFactorService._();

  static const issuer = 'Wonkru MDM';

  static const _secretBytes = 20;

  static const _codeLength = 6;
  static const _intervalSeconds = 30;

  static const _recoveryCodeCount = 10;
  static const _recoveryCodeLength = 10;

  static const _recoveryAlphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  // Kept shorter than a session's life because the authId survives token refresh.
  static const verificationWindow = Duration(hours: 12);

  static const maxFailedAttempts = 5;

  static const lockoutBase = Duration(seconds: 30);

  static const lockoutCap = Duration(minutes: 15);

  static final _random = Random.secure();

  static bool isEnabled(AdminProfile profile) =>
      profile.totpSecret != null && profile.recoveryCodes != null;

  static Future<AdminTotpSetup> startSetup(
    Session session,
    AdminProfile profile, {
    String? accountLabel,
  }) async {
    final secret = _generateSecret();
    profile.totpSecret = TotpSecretCipher.encrypt(secret);
    profile.recoveryCodes = null;
    profile.totpLastUsedCounter = null;
    profile.totpFailedAttempts = 0;
    profile.totpLockedUntil = null;
    profile.updatedAt = DateTime.now().toUtc();
    await AdminProfile.db.updateRow(session, profile);

    return AdminTotpSetup(
      secret: secret,
      otpauthUri: _otpauthUri(
        accountLabel ?? profile.userId.toString(),
        secret,
      ),
    );
  }

  static Future<List<String>> confirmSetup(
    Session session,
    AdminProfile profile,
    String code,
  ) async {
    final secret = _decryptSecret(profile);
    final counter = secret == null
        ? null
        : _matchCounter(secret, code, profile);
    if (counter == null) {
      throw AdminTotpException(message: 'Code could not be verified.');
    }

    final recoveryCodes = _generateRecoveryCodes();
    final hashes = <String>[];
    for (final recoveryCode in recoveryCodes) {
      // Hash the normalized form so verification, which normalizes the input,
      // can match it.
      hashes.add(
        await PasswordHasher.hash(_normalizeRecoveryCode(recoveryCode)),
      );
    }

    profile.recoveryCodes = jsonEncode(hashes);
    profile.totpLastUsedCounter = counter;
    profile.totpFailedAttempts = 0;
    profile.totpLockedUntil = null;
    profile.updatedAt = DateTime.now().toUtc();
    await AdminProfile.db.updateRow(session, profile);

    await markVerified(session, profile);
    return recoveryCodes;
  }

  static Future<bool?> verify(
    Session session,
    AdminProfile profile,
    String code,
  ) async {
    if (!isEnabled(profile)) return false;
    if (_isLocked(profile)) return null;

    final normalized = code.trim();
    final secret = _decryptSecret(profile);
    final counter = secret == null
        ? null
        : _matchCounter(secret, code, profile);

    if (counter != null) {
      await _registerSuccess(session, profile, counter);
      await markVerified(session, profile);
      return true;
    }

    if (await _consumeRecoveryCode(session, profile, normalized)) {
      await _registerSuccess(session, profile, null);
      await markVerified(session, profile);
      return true;
    }

    final locked = await _registerFailure(session, profile);
    return locked ? null : false;
  }

  // Clearing every session prevents a stale one from counting the next secret
  // as already verified.
  static Future<void> disable(
    Session session,
    AdminProfile profile,
    String code,
  ) async {
    if (!isEnabled(profile)) {
      throw AdminTotpException(
        message: 'Two-factor authentication is not enabled.',
      );
    }
    if (_isLocked(profile)) {
      throw AdminTotpException(
        message: 'Too many failed attempts. Please try again later.',
      );
    }

    final normalized = code.trim();
    final secret = _decryptSecret(profile);
    final totpCounter = secret == null
        ? null
        : _matchCounter(secret, code, profile);
    final recoveryOk =
        totpCounter == null &&
        await _consumeRecoveryCode(session, profile, normalized);
    if (totpCounter == null && !recoveryOk) {
      final locked = await _registerFailure(session, profile);
      if (locked) {
        throw AdminTotpException(
          message: 'Too many failed attempts. Please try again later.',
        );
      }
      throw AdminTotpException(message: 'Code could not be verified.');
    }

    profile.totpSecret = null;
    profile.recoveryCodes = null;
    profile.totpLastUsedCounter = null;
    profile.totpFailedAttempts = 0;
    profile.totpLockedUntil = null;
    profile.updatedAt = DateTime.now().toUtc();
    await AdminProfile.db.updateRow(session, profile);

    await clearVerification(session, profile);
  }

  static Future<bool> isVerified(Session session) async {
    final authId = session.authenticated?.authId;
    if (authId == null || authId.isEmpty) return false;

    final row = await AdminTotpSession.db.findFirstRow(
      session,
      where: (t) => t.sessionId.equals(authId),
    );
    if (row == null) return false;

    return row.verifiedUntil.isAfter(DateTime.now().toUtc());
  }

  // Uses upsert rather than find-and-add so two concurrent verifications cannot
  // violate the sessionId unique index.
  static Future<void> markVerified(
    Session session,
    AdminProfile profile,
  ) async {
    final authId = session.authenticated?.authId;
    if (authId == null || authId.isEmpty) return;

    final now = DateTime.now().toUtc();
    await AdminTotpSession.db.upsertRow(
      session,
      AdminTotpSession(
        userId: profile.userId,
        sessionId: authId,
        verifiedUntil: now.add(verificationWindow),
        createdAt: now,
      ),
      conflictColumns: (t) => <Column>[t.sessionId],
      updateColumns: (t) => <Column>[t.verifiedUntil],
    );
  }

  static Future<void> clearVerification(
    Session session,
    AdminProfile profile, {
    Transaction? transaction,
  }) async {
    await AdminTotpSession.db.deleteWhere(
      session,
      where: (t) => t.userId.equals(profile.userId),
      transaction: transaction,
    );
  }

  /// Operator recovery: wipes 2FA state without asking for a code.
  ///
  /// Only the admin CLI calls this, and that path already requires shell
  /// access to the server. Regular users must go through [disable], which
  /// verifies a TOTP or recovery code first.
  static Future<void> clearForRecovery(
    Session session,
    AdminProfile profile, {
    required Transaction transaction,
  }) async {
    profile
      ..totpSecret = null
      ..recoveryCodes = null
      ..totpLastUsedCounter = null
      ..totpFailedAttempts = 0
      ..totpLockedUntil = null
      ..updatedAt = DateTime.now().toUtc();
    await AdminProfile.db.updateRow(
      session,
      profile,
      columns: (t) => [
        t.totpSecret,
        t.recoveryCodes,
        t.totpLastUsedCounter,
        t.totpFailedAttempts,
        t.totpLockedUntil,
        t.updatedAt,
      ],
      transaction: transaction,
    );
    await clearVerification(session, profile, transaction: transaction);
  }

  static Future<int> purgeExpiredVerifications(Session session) async {
    final deleted = await AdminTotpSession.db.deleteWhere(
      session,
      where: (t) => t.verifiedUntil < DateTime.now().toUtc(),
    );
    return deleted.length;
  }

  static String? _decryptSecret(AdminProfile profile) {
    final stored = profile.totpSecret;
    if (stored == null || stored.isEmpty) return null;

    try {
      return TotpSecretCipher.decrypt(stored);
    } on FormatException {
      return null;
    } on StateError {
      return null;
    }
  }

  static bool _isLocked(AdminProfile profile) {
    final until = profile.totpLockedUntil;
    return until != null && until.isAfter(DateTime.now().toUtc());
  }

  static int remainingLockSeconds(AdminProfile profile) {
    final until = profile.totpLockedUntil;
    if (until == null) return 0;
    final remaining = until.difference(DateTime.now().toUtc()).inSeconds;
    return remaining < 0 ? 0 : remaining;
  }

  static Future<void> _registerSuccess(
    Session session,
    AdminProfile profile,
    int? counter,
  ) async {
    profile.totpFailedAttempts = 0;
    profile.totpLockedUntil = null;
    if (counter != null) profile.totpLastUsedCounter = counter;
    profile.updatedAt = DateTime.now().toUtc();
    await AdminProfile.db.updateRow(session, profile);
  }

  static Future<bool> _registerFailure(
    Session session,
    AdminProfile profile,
  ) async {
    final attempts = profile.totpFailedAttempts + 1;
    profile.totpFailedAttempts = attempts;
    final now = DateTime.now().toUtc();
    var locked = false;
    if (attempts >= maxFailedAttempts) {
      profile.totpLockedUntil = now.add(_lockDuration(attempts));
      locked = true;
    }
    profile.updatedAt = now;
    await AdminProfile.db.updateRow(session, profile);
    return locked;
  }

  // Steps are clamped before shifting: `1 << steps` overflows at 64 bits for
  // large values and `lockoutBase * (1 << steps)` would go negative or zero, so
  // the lockoutCap comparison would fail and the lock would land in the past,
  // silently disabling brute-force protection. 30s * 2^5 already exceeds the
  // cap, hence the ceiling of 5.
  static Duration _lockDuration(int attempts) {
    final steps = attempts - maxFailedAttempts;
    final cappedSteps = steps < 0 ? 0 : (steps > 5 ? 5 : steps);
    final duration = lockoutBase * (1 << cappedSteps);
    return duration > lockoutCap ? lockoutCap : duration;
  }

  static int? _matchCounter(
    String secret,
    String code,
    AdminProfile profile,
  ) {
    final candidate = code.trim();
    if (candidate.length != _codeLength) return null;

    final now = DateTime.now().millisecondsSinceEpoch;
    final currentStep = (now / 1000 / _intervalSeconds).floor();
    final lastUsed = profile.totpLastUsedCounter;

    for (final step in const [-1, 0, 1]) {
      final counter = currentStep + step;
      if (lastUsed != null && counter <= lastUsed) continue;
      final expected = OTP.generateTOTPCodeString(
        secret,
        now + step * _intervalSeconds * 1000,
        length: _codeLength,
        interval: _intervalSeconds,
        algorithm: Algorithm.SHA1,
        isGoogle: true,
      );
      if (OTP.constantTimeVerification(candidate, expected)) return counter;
    }
    return null;
  }

  // Re-reads and removes the matching hash, so a concurrent request using the
  // same code finds it gone and fails.
  static Future<bool> _consumeRecoveryCode(
    Session session,
    AdminProfile profile,
    String code,
  ) async {
    final stored = profile.recoveryCodes;
    if (stored == null || stored.isEmpty || code.isEmpty) return false;

    final candidate = _normalizeRecoveryCode(code);
    if (candidate.isEmpty) return false;

    final List<String> hashes;
    try {
      hashes = (jsonDecode(stored) as List).cast<String>();
    } catch (_) {
      return false;
    }

    // Argon2 verification is expensive, so it runs outside the transaction; the
    // actual consumption is guarded by a locked read instead.
    var matchedIndex = -1;
    for (var i = 0; i < hashes.length; i++) {
      if (await PasswordHasher.verify(password: candidate, hash: hashes[i])) {
        matchedIndex = i;
        break;
      }
    }
    if (matchedIndex < 0) return false;
    final matchedHash = hashes[matchedIndex];

    final fresh = await AdminProfile.db.findFirstRow(
      session,
      where: (t) => t.id.equals(profile.id!),
    );
    final freshCodes = fresh?.recoveryCodes;
    if (fresh == null || freshCodes == null) return false;

    final List<String> current;
    try {
      current = (jsonDecode(freshCodes) as List).cast<String>();
    } catch (_) {
      return false;
    }

    if (!current.remove(matchedHash)) return false;

    final newJson = jsonEncode(current);
    // Update the caller's object too: `_registerSuccess` runs after this and
    // would otherwise write the old value back.
    profile.recoveryCodes = newJson;
    fresh.recoveryCodes = newJson;
    fresh.updatedAt = DateTime.now().toUtc();
    await AdminProfile.db.updateRow(session, fresh);
    return true;
  }

  static String _normalizeRecoveryCode(String code) {
    final alphanumeric = code.toUpperCase().replaceAll(RegExp('[^A-Z0-9]'), '');
    if (alphanumeric.length != _recoveryCodeLength) return '';
    return alphanumeric;
  }

  static String _generateSecret() {
    final bytes = List<int>.generate(_secretBytes, (_) => _random.nextInt(256));
    return base32.encode(Uint8List.fromList(bytes));
  }

  static List<String> _generateRecoveryCodes() {
    return List<String>.generate(_recoveryCodeCount, (_) {
      final chars = List<String>.generate(
        _recoveryCodeLength,
        (_) => _recoveryAlphabet[_random.nextInt(_recoveryAlphabet.length)],
      );
      return '${chars.sublist(0, 5).join()}-${chars.sublist(5).join()}';
    });
  }

  static String _otpauthUri(String account, String secret) {
    final label = Uri.encodeComponent('$issuer:$account');
    return 'otpauth://totp/$label'
        '?secret=${Uri.encodeQueryComponent(secret)}'
        '&issuer=${Uri.encodeQueryComponent(issuer)}'
        '&algorithm=SHA1'
        '&digits=$_codeLength'
        '&period=$_intervalSeconds';
  }
}
