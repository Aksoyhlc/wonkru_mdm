/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _isc;

abstract class CertificateInfo
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CertificateInfo._({
    this.issuer,
    this.subject,
    this.serialNumber,
    this.validFrom,
    this.validUntil,
    this.fingerprintSha256,
    this.format,
    this.certificateType,
    this.certificatePem,
  });

  factory CertificateInfo({
    String? issuer,
    String? subject,
    String? serialNumber,
    DateTime? validFrom,
    DateTime? validUntil,
    String? fingerprintSha256,
    String? format,
    String? certificateType,
    String? certificatePem,
  }) = _CertificateInfoImpl;

  factory CertificateInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return CertificateInfo(
      issuer: jsonSerialization['issuer'] as String?,
      subject: jsonSerialization['subject'] as String?,
      serialNumber: jsonSerialization['serialNumber'] as String?,
      validFrom: jsonSerialization['validFrom'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['validFrom']),
      validUntil: jsonSerialization['validUntil'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['validUntil'],
            ),
      fingerprintSha256: jsonSerialization['fingerprintSha256'] as String?,
      format: jsonSerialization['format'] as String?,
      certificateType: jsonSerialization['certificateType'] as String?,
      certificatePem: jsonSerialization['certificatePem'] as String?,
    );
  }

  /// Formatted issuer DN, e.g. `CN=Root CA, O=Example`.
  String? issuer;

  String? subject;

  /// Uppercase hexadecimal serial number, without a `0x` prefix.
  String? serialNumber;

  DateTime? validFrom;

  DateTime? validUntil;

  /// Uppercase hexadecimal SHA-256 fingerprint of the DER body.
  String? fingerprintSha256;

  /// Detected encoding: `PEM`, `DER`, `PKCS12` or `PKCS7`.
  String? format;

  /// Kind detected from its extensions: `CA`, `CLIENT` or `SERVER`.
  String? certificateType;

  /// PEM of the first certificate; null when none could be read.
  String? certificatePem;

  /// Returns a shallow copy of this [CertificateInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CertificateInfo copyWith({
    String? issuer,
    String? subject,
    String? serialNumber,
    DateTime? validFrom = const _isc.$UndefinedDateTime(),
    DateTime? validUntil = const _isc.$UndefinedDateTime(),
    String? fingerprintSha256,
    String? format,
    String? certificateType,
    String? certificatePem,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CertificateInfo',
      if (issuer != null) 'issuer': issuer,
      if (subject != null) 'subject': subject,
      if (serialNumber != null) 'serialNumber': serialNumber,
      if (validFrom != null) 'validFrom': validFrom?.toJson(),
      if (validUntil != null) 'validUntil': validUntil?.toJson(),
      if (fingerprintSha256 != null) 'fingerprintSha256': fingerprintSha256,
      if (format != null) 'format': format,
      if (certificateType != null) 'certificateType': certificateType,
      if (certificatePem != null) 'certificatePem': certificatePem,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CertificateInfo',
      if (issuer != null) 'issuer': issuer,
      if (subject != null) 'subject': subject,
      if (serialNumber != null) 'serialNumber': serialNumber,
      if (validFrom != null) 'validFrom': validFrom?.toJson(),
      if (validUntil != null) 'validUntil': validUntil?.toJson(),
      if (fingerprintSha256 != null) 'fingerprintSha256': fingerprintSha256,
      if (format != null) 'format': format,
      if (certificateType != null) 'certificateType': certificateType,
      if (certificatePem != null) 'certificatePem': certificatePem,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CertificateInfoImpl extends CertificateInfo {
  _CertificateInfoImpl({
    String? issuer,
    String? subject,
    String? serialNumber,
    DateTime? validFrom,
    DateTime? validUntil,
    String? fingerprintSha256,
    String? format,
    String? certificateType,
    String? certificatePem,
  }) : super._(
         issuer: issuer,
         subject: subject,
         serialNumber: serialNumber,
         validFrom: validFrom,
         validUntil: validUntil,
         fingerprintSha256: fingerprintSha256,
         format: format,
         certificateType: certificateType,
         certificatePem: certificatePem,
       );

  /// Returns a shallow copy of this [CertificateInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CertificateInfo copyWith({
    Object? issuer = _Undefined,
    Object? subject = _Undefined,
    Object? serialNumber = _Undefined,
    DateTime? validFrom = const _isc.$UndefinedDateTime(),
    DateTime? validUntil = const _isc.$UndefinedDateTime(),
    Object? fingerprintSha256 = _Undefined,
    Object? format = _Undefined,
    Object? certificateType = _Undefined,
    Object? certificatePem = _Undefined,
  }) {
    return CertificateInfo(
      issuer: issuer is String? ? issuer : this.issuer,
      subject: subject is String? ? subject : this.subject,
      serialNumber: serialNumber is String? ? serialNumber : this.serialNumber,
      validFrom: validFrom is _isc.UndefinedSentinel
          ? this.validFrom
          : validFrom,
      validUntil: validUntil is _isc.UndefinedSentinel
          ? this.validUntil
          : validUntil,
      fingerprintSha256: fingerprintSha256 is String?
          ? fingerprintSha256
          : this.fingerprintSha256,
      format: format is String? ? format : this.format,
      certificateType: certificateType is String?
          ? certificateType
          : this.certificateType,
      certificatePem: certificatePem is String?
          ? certificatePem
          : this.certificatePem,
    );
  }
}
