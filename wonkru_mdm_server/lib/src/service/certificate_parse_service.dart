import 'dart:convert';
import '../util/pem_codec.dart';
import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart';
import 'package:pointycastle/asn1.dart';
import 'package:pointycastle/export.dart';

import '../generated/protocol.dart';

/// The PKCS#12 container is decoded with `pointycastle` because the `Pkcs12Utils`
/// in `basic_utils` only understands the older PBES1 derivation; PBES2 stores
/// (AES-CBC with PBKDF2) are handled here directly.
class CertificateParseService {
  const CertificateParseService._();

  static const _attributeOrder = <String>['CN', 'O', 'OU', 'C', 'ST', 'L', 'E'];

  static const _attributeOids = <String, String>{
    'CN': '2.5.4.3',
    'O': '2.5.4.10',
    'OU': '2.5.4.11',
    'C': '2.5.4.6',
    'ST': '2.5.4.8',
    'L': '2.5.4.7',
    'E': '1.2.840.113549.1.9.1',
  };

  static const _dataOid = '1.2.840.113549.1.7.1';
  static const _encryptedDataOid = '1.2.840.113549.1.7.6';

  static const _certBagOid = '1.2.840.113549.1.12.10.1.3';

  static const _pbes2Oid = '1.2.840.113549.1.5.13';
  static const _pbkdf2Oid = '1.2.840.113549.1.5.12';

  static CertificateInfo parse(String certificateData, {String? password}) {
    final text = certificateData.trim();
    if (text.isEmpty) {
      throw const FormatException('Certificate data could not be read.');
    }

    if (text.contains(PemCodec.beginPkcs7)) {
      return _parsePkcs7Pem(PemCodec.extractPkcs7Pem(text));
    }
    if (text.contains(PemCodec.beginCertificate)) {
      return _parseX509Pem(text);
    }

    final bytes = PemCodec.derBytes(text);
    if (bytes == null || bytes.isEmpty) {
      throw const FormatException('Certificate data could not be read.');
    }

    return _parseBinary(bytes, password);
  }

  static CertificateInfo _parseBinary(Uint8List bytes, String? password) {
    if (bytes.first == 0x2d) {
      // 0x2d is '-': a base64-wrapped PEM body.
      final text = latin1.decode(bytes);
      if (text.contains(PemCodec.beginPkcs7)) {
        return _parsePkcs7Pem(PemCodec.extractPkcs7Pem(text));
      }
      if (text.contains(PemCodec.beginCertificate)) {
        return _parseX509Pem(text);
      }
      throw const FormatException('Unsupported certificate format.');
    }

    final ASN1Object head;
    try {
      head = ASN1Parser(bytes).nextObject();
    } catch (_) {
      throw const FormatException('Certificate could not be parsed.');
    }

    if (head is ASN1Sequence &&
        head.elements != null &&
        head.elements!.isNotEmpty) {
      final first = head.elements!.first;
      // PFX ::= SEQUENCE { version INTEGER, authSafe ContentInfo, ... }
      if (first is ASN1Integer) {
        return _parsePkcs12(bytes, password);
      }
      // ContentInfo ::= SEQUENCE { contentType OBJECT IDENTIFIER, ... }
      if (first is ASN1ObjectIdentifier) {
        return _parsePkcs7Der(bytes);
      }
    }

    return _parseX509Der(bytes, format: 'DER');
  }

  // Verify the MAC before decrypting so a wrong password surfaces as a clear
  // error instead of a decryption failure.
  static List<Uint8List> _pkcs12Certificates(
    Uint8List bytes,
    String? password,
  ) {
    final ASN1Pfx pfx;
    try {
      pfx = ASN1Pfx.fromSequence(
        ASN1Parser(bytes).nextObject() as ASN1Sequence,
      );
    } catch (_) {
      throw const FormatException('PKCS12 file could not be read.');
    }

    final passwordText = password ?? '';
    final formatted = Pkcs12Utils.formatPkcs12Password(
      Uint8List.fromList(passwordText.codeUnits),
    );
    final utf8Password = Uint8List.fromList(utf8.encode(passwordText));

    final content = pfx.authSafe.content;
    if (content is! ASN1OctetString || content.octets == null) {
      throw const FormatException('PKCS12 file could not be read.');
    }
    final authSafe = content.octets!;

    final macData = pfx.macData;
    if (macData != null) {
      _verifyPkcs12Mac(macData, authSafe, formatted);
    }

    final ASN1AuthenticatedSafe authenticatedSafe;
    try {
      authenticatedSafe = ASN1AuthenticatedSafe.fromSequence(
        ASN1Parser(authSafe).nextObject() as ASN1Sequence,
      );
    } catch (_) {
      throw const FormatException('PKCS12 file could not be read.');
    }

    final certificates = <Uint8List>[];
    for (final info in authenticatedSafe.info) {
      try {
        final contentType = info.contentType.objectIdentifierAsString;
        if (contentType == _dataOid) {
          certificates.addAll(
            _certificatesFromSafeContents(
              (info.content! as ASN1OctetString).octets!,
            ),
          );
        } else if (contentType == _encryptedDataOid) {
          final encryptedData = ASN1EncryptedData.fromSequence(
            info.content! as ASN1Sequence,
          );
          final encryptedContentInfo = encryptedData.encryptedContentInfo;
          final encrypted = encryptedContentInfo.encryptedContent;
          if (encrypted == null) {
            continue;
          }

          final decrypted = _decryptPbe(
            encryptedContentInfo.contentEncryptionAlgorithm,
            encrypted,
            formatted,
            utf8Password,
          );
          certificates.addAll(_certificatesFromSafeContents(decrypted));
        }
      } on FormatException {
        rethrow;
      } catch (_) {
        throw const FormatException('PKCS12 file could not be read.');
      }
    }

    return certificates;
  }

  // Unsupported digests skip verification; the decryption path still rejects a
  // wrong password.
  static void _verifyPkcs12Mac(
    ASN1MacData macData,
    Uint8List authSafe,
    Uint8List formattedPassword,
  ) {
    final digestOid =
        macData.mac.digestAlgorithm.algorithm.objectIdentifierAsString;
    final digest = digestOid == null ? null : _digestForOid(digestOid);
    if (digest == null) {
      return;
    }

    final generator = PKCS12ParametersGenerator(digest)
      ..init(
        formattedPassword,
        macData.macSalt,
        macData.iterationCount.toInt(),
      );
    final key = generator.generateDerivedMacParameters(digest.digestSize);
    final hmac = HMac.withDigest(digest)..init(key);
    final computed = hmac.process(authSafe);

    if (!_constantTimeEquals(computed, macData.mac.digest)) {
      throw const FormatException(
        'Incorrect PKCS12 password or corrupt file.',
      );
    }
  }

  // PBES2 derives the key from the UTF-8 password (what OpenSSL writes), with
  // the BMP encoding as a fallback for other producers. PBES1 always uses the
  // BMP encoding defined by PKCS#12.
  static Uint8List _decryptPbe(
    ASN1AlgorithmIdentifier algorithm,
    Uint8List data,
    Uint8List formattedPassword,
    Uint8List utf8Password,
  ) {
    final oid = algorithm.algorithm.objectIdentifierAsString;
    if (oid == _pbes2Oid) {
      return _decryptPbes2(
        algorithm,
        data,
        <Uint8List>[utf8Password, formattedPassword],
      );
    }
    return _decryptPbes1(algorithm, data, formattedPassword);
  }

  static Uint8List _decryptPbes2(
    ASN1AlgorithmIdentifier algorithm,
    Uint8List data,
    List<Uint8List> passwords,
  ) {
    final params = algorithm.parameters as ASN1Sequence;
    final kdf = ASN1AlgorithmIdentifier.fromSequence(
      params.elements![0] as ASN1Sequence,
    );
    final scheme = ASN1AlgorithmIdentifier.fromSequence(
      params.elements![1] as ASN1Sequence,
    );

    if (kdf.algorithm.objectIdentifierAsString != _pbkdf2Oid) {
      throw const FormatException('Unsupported certificate encryption.');
    }

    final kdfParams = kdf.parameters as ASN1Sequence;
    final salt = (kdfParams.elements![0] as ASN1OctetString).octets!;
    final iterations = (kdfParams.elements![1] as ASN1Integer).integer!.toInt();

    var prfOid = '1.2.840.113549.2.7'; // hmacWithSHA1 default
    int? keyLength;
    for (final element in kdfParams.elements!.skip(2)) {
      if (element is ASN1Integer) {
        keyLength = element.integer!.toInt();
      } else if (element is ASN1Sequence) {
        prfOid =
            ASN1AlgorithmIdentifier.fromSequence(
              element,
            ).algorithm.objectIdentifierAsString ??
            prfOid;
      }
    }

    final schemeOid = scheme.algorithm.objectIdentifierAsString;
    final BlockCipher Function() cipher;
    final int defaultKeyLength;
    switch (schemeOid) {
      case '2.16.840.1.101.3.4.1.2':
        cipher = AESEngine.new;
        defaultKeyLength = 16;
      case '2.16.840.1.101.3.4.1.22':
        cipher = AESEngine.new;
        defaultKeyLength = 24;
      case '2.16.840.1.101.3.4.1.42':
        cipher = AESEngine.new;
        defaultKeyLength = 32;
      case '1.2.840.113549.3.7':
        cipher = DESedeEngine.new;
        defaultKeyLength = 24;
      default:
        throw const FormatException('Unsupported certificate encryption.');
    }

    final iv = (scheme.parameters as ASN1OctetString).octets!;
    final length = keyLength ?? defaultKeyLength;

    for (final password in passwords) {
      try {
        final derivator = PBKDF2KeyDerivator(
          HMac.withDigest(_prfForOid(prfOid)),
        )..init(Pbkdf2Parameters(salt, iterations, length));
        final key = derivator.process(password);
        return _decryptCbc(cipher(), key, iv, data);
      } on FormatException {
        rethrow;
      } catch (_) {
        // Wrong encoding or wrong password; try the next candidate.
      }
    }

    throw const FormatException('Incorrect PKCS12 password or corrupt file.');
  }

  static Uint8List _decryptPbes1(
    ASN1AlgorithmIdentifier algorithm,
    Uint8List data,
    Uint8List formattedPassword,
  ) {
    final params = algorithm.parameters as ASN1Sequence;
    final salt = (params.elements![0] as ASN1OctetString).octets!;
    final iterations = (params.elements![1] as ASN1Integer).integer!.toInt();
    final generator = PKCS12ParametersGenerator(Digest('SHA-1'))
      ..init(formattedPassword, salt, iterations);

    const supported = <String>{
      '1.2.840.113549.1.12.1.1',
      '1.2.840.113549.1.12.1.2',
      '1.2.840.113549.1.12.1.3',
      '1.2.840.113549.1.12.1.4',
      '1.2.840.113549.1.12.1.5',
      '1.2.840.113549.1.12.1.6',
    };
    final oid = algorithm.algorithm.objectIdentifierAsString;
    if (oid == null || !supported.contains(oid)) {
      throw const FormatException('Unsupported certificate encryption.');
    }

    try {
      switch (oid) {
        case '1.2.840.113549.1.12.1.1':
          return _decryptRc4(generator.generateDerivedParameters(16), data);
        case '1.2.840.113549.1.12.1.2':
          return _decryptRc4(generator.generateDerivedParameters(5), data);
        case '1.2.840.113549.1.12.1.3':
          return _decryptPbes1Cbc(DESedeEngine.new, 24, generator, data);
        case '1.2.840.113549.1.12.1.4':
          return _decryptPbes1Cbc(DESedeEngine.new, 16, generator, data);
        case '1.2.840.113549.1.12.1.5':
          return _decryptPbes1Cbc(RC2Engine.new, 16, generator, data);
        default:
          return _decryptPbes1Cbc(RC2Engine.new, 5, generator, data);
      }
    } catch (_) {
      // A wrong password usually manifests as broken PKCS#7 padding.
      throw const FormatException('Incorrect PKCS12 password or corrupt file.');
    }
  }

  static Uint8List _decryptRc4(KeyParameter parameters, Uint8List data) {
    final engine = RC4Engine()..init(false, parameters);
    return engine.process(data);
  }

  static Uint8List _decryptPbes1Cbc(
    BlockCipher Function() cipher,
    int keyLength,
    PKCS12ParametersGenerator generator,
    Uint8List data,
  ) {
    final parameters = generator.generateDerivedParametersWithIV(
      keyLength,
      cipher().blockSize,
    );
    return _decryptCbc(
      cipher(),
      (parameters.parameters as KeyParameter).key,
      parameters.iv,
      data,
    );
  }

  static Uint8List _decryptCbc(
    BlockCipher cipher,
    Uint8List key,
    Uint8List iv,
    Uint8List data,
  ) {
    final padded = PaddedBlockCipherImpl(
      PKCS7Padding(),
      CBCBlockCipher(cipher),
    );
    padded.init(
      false,
      PaddedBlockCipherParameters(
        ParametersWithIV(KeyParameter(key), iv),
        null,
      ),
    );
    return padded.process(data);
  }

  static List<Uint8List> _certificatesFromSafeContents(Uint8List bytes) {
    final safeContents = ASN1SafeContents.fromSequence(
      ASN1Parser(bytes).nextObject() as ASN1Sequence,
    );

    final certificates = <Uint8List>[];
    for (final bag in safeContents.safeBags) {
      if (bag.bagId.objectIdentifierAsString != _certBagOid) {
        continue;
      }

      final certBag = ASN1CertBag.fromSequence(bag.bagValue as ASN1Sequence);
      final value = certBag.certValue;
      if (value is ASN1OctetString && value.octets != null) {
        certificates.add(value.octets!);
      }
    }

    return certificates;
  }

  static CertificateInfo _parseX509Pem(String certificateData) {
    final pem = PemCodec.certificateToPem(certificateData);
    if (pem == null) {
      throw const FormatException('Certificate data could not be read.');
    }

    final X509CertificateData certificate;
    try {
      certificate = X509Utils.x509CertificateFromPem(pem);
    } catch (_) {
      throw const FormatException('Certificate could not be parsed.');
    }

    return _infoFromX509(certificate, format: 'PEM');
  }

  static CertificateInfo _parseX509Der(
    Uint8List der, {
    required String format,
  }) {
    final pem = PemCodec.certificateFromDer(der);

    final X509CertificateData certificate;
    try {
      certificate = X509Utils.x509CertificateFromPem(pem);
    } catch (_) {
      throw const FormatException('Certificate could not be parsed.');
    }

    return _infoFromX509(certificate, format: format, certificatePem: pem);
  }

  static CertificateInfo _parsePkcs12(Uint8List bytes, String? password) {
    final certificates = _pkcs12Certificates(bytes, password);
    if (certificates.isEmpty) {
      throw const FormatException('No certificate found in the PKCS12 file.');
    }

    return _parseX509Der(certificates.first, format: 'PKCS12');
  }

  static CertificateInfo _parsePkcs7Der(Uint8List bytes) {
    try {
      return _parsePkcs7Pem(PemCodec.wrap(bytes, 'PKCS7'));
    } on FormatException {
      rethrow;
    } catch (_) {
      throw const FormatException('PKCS7 file could not be parsed.');
    }
  }

  static CertificateInfo _parsePkcs7Pem(String pem) {
    final Pkcs7CertificateData bundle;
    try {
      bundle = X509Utils.pkcs7fromPem(pem);
    } catch (_) {
      throw const FormatException('PKCS7 file could not be parsed.');
    }

    final certificates = bundle.certificates ?? const <X509CertificateData>[];
    if (certificates.isEmpty) {
      throw const FormatException('No certificate found in the PKCS7 file.');
    }

    // `pkcs7fromPem` does not compute the SHA-256 thumbprint; rebuild it from
    // the body.
    final certificate = certificates.first;
    final plain = certificate.plain;
    String? fingerprint;
    if (plain != null) {
      try {
        fingerprint = CryptoUtils.getHash(
          CryptoUtils.getBytesFromPEMString(plain),
          algorithmName: 'SHA-256',
        );
      } catch (_) {
        fingerprint = null;
      }
    }

    return _infoFromX509(
      certificate,
      format: 'PKCS7',
      fingerprint: fingerprint,
      certificatePem: plain,
    );
  }

  static CertificateInfo _infoFromX509(
    X509CertificateData certificate, {
    required String format,
    String? fingerprint,
    String? certificatePem,
  }) {
    final tbs = certificate.tbsCertificate;
    if (tbs == null) {
      throw const FormatException('Certificate data could not be read.');
    }

    final validity = tbs.validity;

    return CertificateInfo(
      issuer: _nameToString(tbs.issuer),
      subject: _nameToString(tbs.subject),
      serialNumber: tbs.serialNumber.toRadixString(16).toUpperCase(),
      validFrom: validity.notBefore.toUtc(),
      validUntil: validity.notAfter.toUtc(),
      fingerprintSha256: fingerprint ?? certificate.sha256Thumbprint,
      format: format,
      certificateType: _certificateType(certificate),
      certificatePem: certificatePem ?? certificate.plain,
    );
  }

  static String _certificateType(X509CertificateData certificate) {
    final tbs = certificate.tbsCertificate;
    final extensions = tbs?.extensions;
    if (extensions != null) {
      if (extensions.cA == true) {
        return 'CA';
      }
      final keyUsage = extensions.keyUsage;
      if (keyUsage != null && keyUsage.contains(KeyUsage.KEY_CERT_SIGN)) {
        return 'CA';
      }
      final extKeyUsage = extensions.extKeyUsage;
      if (extKeyUsage != null) {
        if (extKeyUsage.contains(ExtendedKeyUsage.CLIENT_AUTH)) {
          return 'CLIENT';
        }
        if (extKeyUsage.contains(ExtendedKeyUsage.SERVER_AUTH)) {
          return 'SERVER';
        }
      }
    }

    final issuer = tbs?.issuer;
    final subject = tbs?.subject;
    if (issuer != null && subject != null && _sameName(issuer, subject)) {
      return 'CA';
    }

    return 'CLIENT';
  }

  static String? _nameToString(Map<String, String?>? name) {
    if (name == null || name.isEmpty) {
      return null;
    }

    final parts = <String>[];
    for (final attribute in _attributeOrder) {
      final value = name[_attributeOids[attribute]];
      if (value != null && value.isNotEmpty) {
        parts.add('$attribute=$value');
      }
    }

    return parts.isEmpty ? null : parts.join(', ');
  }

  static bool _sameName(
    Map<String, String?> first,
    Map<String, String?> second,
  ) {
    for (final oid in _attributeOids.values) {
      if ((first[oid] ?? '') != (second[oid] ?? '')) {
        return false;
      }
    }

    return true;
  }

  static bool _constantTimeEquals(Uint8List a, Uint8List b) {
    if (a.length != b.length) {
      return false;
    }

    var difference = 0;
    for (var i = 0; i < a.length; i++) {
      difference |= a[i] ^ b[i];
    }

    return difference == 0;
  }

  static Digest? _digestForOid(String oid) => switch (oid) {
    '1.3.14.3.2.26' => Digest('SHA-1'),
    '2.16.840.1.101.3.4.2.4' => Digest('SHA-224'),
    '2.16.840.1.101.3.4.2.1' => Digest('SHA-256'),
    '2.16.840.1.101.3.4.2.2' => Digest('SHA-384'),
    '2.16.840.1.101.3.4.2.3' => Digest('SHA-512'),
    _ => null,
  };

  static Digest _prfForOid(String oid) => switch (oid) {
    '1.2.840.113549.2.7' => Digest('SHA-1'),
    '1.2.840.113549.2.8' => Digest('SHA-224'),
    '1.2.840.113549.2.9' => Digest('SHA-256'),
    '1.2.840.113549.2.10' => Digest('SHA-384'),
    '1.2.840.113549.2.11' => Digest('SHA-512'),
    _ => throw const FormatException('Unsupported certificate encryption.'),
  };
}
