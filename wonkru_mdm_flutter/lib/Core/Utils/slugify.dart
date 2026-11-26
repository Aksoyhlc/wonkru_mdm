/// Must produce the same result as the server's `PolicySlugService.slugify`.
///
/// The panel uses it to fill the slug field live while the policy name is
/// typed; the server validates it again on save (uniqueness) and generates it
/// itself as a safety net when the slug is left empty. Both sides apply the
/// same rules: lowercase, transliterate Turkish/Latin-1 accents to ASCII,
/// collapse non-alphanumerics to single hyphens, trim leading/trailing
/// hyphens.
String slugify(String value) {
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

  return buffer
      .toString()
      .replaceAll(RegExp('-+'), '-')
      .replaceAll(RegExp(r'^-+|-+$'), '');
}

const _transliteration = <int, String>{
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
