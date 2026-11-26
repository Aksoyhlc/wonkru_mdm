import 'dart:math';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Generates and uniqueness-checks the `slug` identity of policies.
///
/// Creation, update and cloning share one generator, so a slug stays a
/// consistent, unique short id.
class PolicySlugService {
  const PolicySlugService._();

  static const _alphabet = 'abcdefghijklmnopqrstuvwxyz0123456789';
  static const _randomLength = 8;

  static final _random = Random.secure();

  /// An empty name falls back to a `policy-<random>` base; collisions get a
  /// `-1`, `-2`… suffix. [exceptPolicyId] is not counted as a collision (a
  /// policy keeping its own slug on update).
  static Future<String> unique(
    Session session,
    String name, {
    Transaction? transaction,
    int? exceptPolicyId,
  }) async {
    var base = slugify(name);
    if (base.isEmpty) {
      base = 'policy-${_randomSuffix()}';
    }

    var slug = base;
    var counter = 1;
    while (await isTaken(
      session,
      slug,
      transaction: transaction,
      exceptPolicyId: exceptPolicyId,
    )) {
      slug = '$base-$counter';
      counter++;
    }

    return slug;
  }

  /// [exceptPolicyId] is ignored when counting a collision.
  static Future<bool> isTaken(
    Session session,
    String slug, {
    Transaction? transaction,
    int? exceptPolicyId,
  }) async {
    final row = await Policy.db.findFirstRow(
      session,
      where: (t) => t.slug.equals(slug),
      transaction: transaction,
    );

    return row != null && row.id != exceptPolicyId;
  }

  static String slugify(String value) {
    final buffer = StringBuffer();

    for (final character in value.toLowerCase().runes) {
      final replacement = _transliteration[character];
      if (replacement != null) {
        buffer.write(replacement);
        continue;
      }

      final isAsciiLetter =
          (character >= 0x61 && character <= 0x7a) ||
          (character >= 0x30 && character <= 0x39);
      buffer.write(isAsciiLetter ? String.fromCharCode(character) : '-');
    }

    // Runs of non-alphanumeric characters collapse to a single dash.
    return buffer
        .toString()
        .replaceAll(RegExp('-+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
  }

  static String _randomSuffix() {
    final buffer = StringBuffer();
    for (var i = 0; i < _randomLength; i++) {
      buffer.write(_alphabet[_random.nextInt(_alphabet.length)]);
    }
    return buffer.toString();
  }

  /// Diacritic Latin letters mapped to their ASCII counterpart: the Turkish
  /// characters the admin panel is used with, plus the Latin-1 accents.
  static const _transliteration = <int, String>{
    0xe7: 'c', 0xc7: 'c', // ç Ç
    0x11f: 'g', 0x11e: 'g', // ğ Ğ
    0xf0: 'd', 0xd0: 'd', // ð Ð
    0x131: 'i', 0x130: 'i', // ı İ
    0xf6: 'o', 0xd6: 'o', // ö Ö
    0x15f: 's', 0x15e: 's', // ş Ş
    0xfc: 'u', 0xdc: 'u', // ü Ü
    0xdf: 'ss', // ß
    0xe0: 'a', 0xe1: 'a', 0xe2: 'a', 0xe3: 'a', 0xe4: 'a', 0xe5: 'a', // à-å
    0xe8: 'e', 0xe9: 'e', 0xea: 'e', 0xeb: 'e', // è-ë
    0xec: 'i', 0xed: 'i', 0xee: 'i', 0xef: 'i', // ì-ï
    0xf1: 'n', // ñ
    0xf2: 'o', 0xf3: 'o', 0xf4: 'o', 0xf5: 'o', // ò-õ
    0xf9: 'u', 0xfa: 'u', 0xfb: 'u', // ù-û
    0xfd: 'y', 0xff: 'y', // ý ÿ
  };
}
