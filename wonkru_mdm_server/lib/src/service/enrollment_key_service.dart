import 'dart:convert';
import 'dart:math';

import 'package:serverpod/serverpod.dart';
import 'package:wonkru_core_server/wonkru_core_server.dart';

import '../generated/protocol.dart';
import 'setting_service.dart';

/// Global, rotatable device enrollment key.
///
/// `device.register` is the only unauthenticated single-device endpoint; without
/// a key anyone could register. The key lives in `settings` under [settingKey],
/// is generated on first use with [Random.secure], and reaches the device through
/// the provisioning QR's `enrollment_key` extra. Rotating it from the panel only
/// affects new registrations: registered devices keep working with their own
/// tokens.
///
/// The key is a short, typo-resistant group string (`WNKR-XXXX-XXXX-XXXX`):
/// twelve characters of Crockford Base32 (60 bits). Input is normalized by
/// [normalize], so lowercase, missing separators and the ambiguous letters
/// `I`/`L` (→`1`) and `O` (→`0`) are accepted.
///
/// The value deliberately stays out of [SettingsFormState]: the settings form
/// rewrites every key on each save, while this secret may only change through
/// [rotate].
class EnrollmentKeyService {
  const EnrollmentKeyService._();

  static const settingKey = 'device_enrollment_key';

  /// Crockford Base32: digits and letters without the ambiguous `I`, `L`, `O`
  /// and `U`.
  static const _alphabet = '0123456789ABCDEFGHJKMNPQRSTVWXYZ';

  static const _prefix = 'WNKR';

  static const _groups = 3;

  static const _groupSize = 4;

  static final Random _random = Random.secure();

  static String generate() => _format(_randomChars());

  /// Canonicalizes a user-provided key to `WNKR-XXXX-XXXX-XXXX`, or returns
  /// `null` when it cannot be one. Case, spaces and separators are ignored, and
  /// the Crockford-ambiguous letters are folded to their digits.
  static String? normalize(String? input) {
    if (input == null) return null;

    final buffer = StringBuffer();
    for (final char in input.trim().toUpperCase().split('')) {
      switch (char) {
        case 'I':
        case 'L':
          buffer.write('1');
        case 'O':
          buffer.write('0');
        default:
          if (_alphabet.contains(char)) buffer.write(char);
      }
    }

    var chars = buffer.toString();
    if (chars.startsWith(_prefix)) {
      chars = chars.substring(_prefix.length);
    }
    if (chars.length != _groups * _groupSize) return null;

    return _format(chars);
  }

  static String _randomChars() => List<String>.generate(
    _groups * _groupSize,
    (_) => _alphabet[_random.nextInt(_alphabet.length)],
  ).join();

  static String _format(String chars) {
    final groups = <String>[
      for (var i = 0; i < chars.length; i += _groupSize)
        chars.substring(i, i + _groupSize),
    ];
    return '$_prefix-${groups.join('-')}';
  }

  static Future<String> current(
    Session session, {
    Transaction? transaction,
  }) async {
    final stored = await SettingService.raw(
      session,
      settingKey,
      transaction: transaction,
    );
    if (stored != null && stored.isNotEmpty) {
      return stored;
    }

    final key = generate();
    try {
      await Setting.db.insertRow(
        session,
        Setting(name: settingKey, value: key),
        transaction: transaction,
      );
      return key;
    } on DatabaseQueryException {
      // A concurrent first request may have written the key first
      // (`settings_name_unique`); use the winner's value.
      final winner = await SettingService.raw(
        session,
        settingKey,
        transaction: transaction,
      );
      if (winner != null && winner.isNotEmpty) {
        return winner;
      }
      rethrow;
    }
  }

  /// Generates and saves a new key. Registrations using the old key are
  /// rejected from now on.
  static Future<String> rotate(Session session) async {
    final key = generate();
    await SettingService.save(session, settingKey, key);
    return key;
  }

  /// Throws [DeviceEnrollmentRejectedException] when [provided] is not valid;
  /// the comparison is constant time.
  static Future<void> require(Session session, String? provided) async {
    final raw = provided?.trim() ?? '';
    if (raw.isEmpty) {
      throw DeviceEnrollmentRejectedException(
        message: 'Enrollment key is required.',
      );
    }

    final candidate = normalize(raw);
    if (candidate == null ||
        !constantTimeEquals(candidate, await current(session))) {
      throw DeviceEnrollmentRejectedException(
        message: 'Enrollment key is not valid.',
      );
    }
  }

  /// Compares two strings in time independent of their contents.
  ///
  /// A length difference does not short-circuit: the shorter value is scanned up
  /// to the longer one's length.
  static bool constantTimeEquals(String a, String b) {
    final left = utf8.encode(a);
    final right = utf8.encode(b);
    final length = left.length > right.length ? left.length : right.length;
    var diff = left.length ^ right.length;
    for (var i = 0; i < length; i++) {
      final x = i < left.length ? left[i] : 0;
      final y = i < right.length ? right[i] : 0;
      diff |= x ^ y;
    }
    return diff == 0;
  }
}
