import 'dart:convert';
import 'dart:typed_data';

/// PEM/base64 text handling for X.509 certificates and PKCS7 bundles.
class PemCodec {
  const PemCodec._();

  static const beginCertificate = '-----BEGIN CERTIFICATE-----';
  static const endCertificate = '-----END CERTIFICATE-----';
  static const beginPkcs7 = '-----BEGIN PKCS7-----';
  static const endPkcs7 = '-----END PKCS7-----';

  /// Normalises [certificateData] (a PEM block or bare DER/base64 bytes) to a
  /// PEM string, or null when it cannot be read.
  static String? certificateToPem(String certificateData) {
    final text = certificateData.trim();
    if (text.isEmpty) {
      return null;
    }

    final begin = text.indexOf(beginCertificate);
    if (begin >= 0) {
      final end = text.indexOf(endCertificate, begin);
      if (end < 0) {
        return null;
      }

      return '${text.substring(begin, end + endCertificate.length)}\n';
    }

    final bytes = derBytes(text);
    if (bytes == null || bytes.isEmpty || bytes.first != 0x30) {
      return null;
    }

    return certificateFromDer(bytes);
  }

  /// Narrows [text] to its PKCS7 PEM block, or returns it unchanged.
  static String extractPkcs7Pem(String text) {
    final begin = text.indexOf(beginPkcs7);
    if (begin < 0) {
      return text;
    }

    final end = text.indexOf(endPkcs7, begin);
    if (end < 0) {
      return text;
    }

    return '${text.substring(begin, end + endPkcs7.length)}\n';
  }

  /// Wraps [bytes] in a PEM block with [label], 64 characters per line.
  static String wrap(Uint8List bytes, String label) {
    final body = base64.encode(bytes);
    final lines = <String>['-----BEGIN $label-----'];
    for (var i = 0; i < body.length; i += 64) {
      lines.add(body.substring(i, (i + 64).clamp(0, body.length)));
    }
    lines.add('-----END $label-----');

    return '${lines.join('\n')}\n';
  }

  static String certificateFromDer(Uint8List der) => wrap(der, 'CERTIFICATE');

  /// Decodes [text] as base64 when it looks like base64, otherwise as Latin-1
  /// bytes; null when empty.
  static Uint8List? derBytes(String text) {
    final compact = text.replaceAll(RegExp(r'\s'), '');
    if (compact.isNotEmpty && isBase64(compact)) {
      try {
        return base64.decode(compact);
      } on FormatException {
        // Fall through to the raw byte encoding.
      }
    }

    final bytes = latin1.encode(text);
    return bytes.isEmpty ? null : bytes;
  }

  static bool isBase64(String value) =>
      RegExp(r'^[A-Za-z0-9+/]+={0,2}$').hasMatch(value);
}
