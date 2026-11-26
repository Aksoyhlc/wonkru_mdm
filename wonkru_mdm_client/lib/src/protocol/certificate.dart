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
import 'package:wonkru_core_client/wonkru_core_client.dart' as _inc4d0tr;

abstract class Certificate
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Certificate._({
    this.id,
    required this.name,
    this.description,
    required this.certificateType,
    required this.certificateData,
    this.privateKeyData,
    required this.format,
    this.issuer,
    this.subject,
    this.serialNumber,
    this.fingerprintSha256,
    this.validFrom,
    this.validUntil,
    bool? isActive,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.filePath,
    this.fileHash,
    this.password,
  }) : isActive = isActive ?? true;

  factory Certificate({
    int? id,
    required String name,
    String? description,
    required _inc4d0tr.CertificateType certificateType,
    required String certificateData,
    String? privateKeyData,
    required _inc4d0tr.CertificateFormat format,
    String? issuer,
    String? subject,
    String? serialNumber,
    String? fingerprintSha256,
    DateTime? validFrom,
    DateTime? validUntil,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    String? filePath,
    String? fileHash,
    String? password,
  }) = _CertificateImpl;

  factory Certificate.fromJson(Map<String, dynamic> jsonSerialization) {
    return Certificate(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      certificateType: _inc4d0tr.CertificateType.fromJson(
        (jsonSerialization['certificateType'] as String),
      ),
      certificateData: jsonSerialization['certificateData'] as String,
      privateKeyData: jsonSerialization['privateKeyData'] as String?,
      format: _inc4d0tr.CertificateFormat.fromJson(
        (jsonSerialization['format'] as String),
      ),
      issuer: jsonSerialization['issuer'] as String?,
      subject: jsonSerialization['subject'] as String?,
      serialNumber: jsonSerialization['serialNumber'] as String?,
      fingerprintSha256: jsonSerialization['fingerprintSha256'] as String?,
      validFrom: jsonSerialization['validFrom'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['validFrom']),
      validUntil: jsonSerialization['validUntil'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['validUntil'],
            ),
      isActive: jsonSerialization['isActive'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
      filePath: jsonSerialization['filePath'] as String?,
      fileHash: jsonSerialization['fileHash'] as String?,
      password: jsonSerialization['password'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  String? description;

  _inc4d0tr.CertificateType certificateType;

  /// PEM encoded.
  String certificateData;

  /// PEM encoded.
  String? privateKeyData;

  _inc4d0tr.CertificateFormat format;

  String? issuer;

  String? subject;

  String? serialNumber;

  String? fingerprintSha256;

  DateTime? validFrom;

  DateTime? validUntil;

  bool isActive;

  DateTime? createdAt;

  DateTime? updatedAt;

  DateTime? deletedAt;

  String? filePath;

  String? fileHash;

  String? password;

  /// Returns a shallow copy of this [Certificate]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Certificate copyWith({
    int? id,
    String? name,
    String? description,
    _inc4d0tr.CertificateType? certificateType,
    String? certificateData,
    String? privateKeyData,
    _inc4d0tr.CertificateFormat? format,
    String? issuer,
    String? subject,
    String? serialNumber,
    String? fingerprintSha256,
    DateTime? validFrom = const _isc.$UndefinedDateTime(),
    DateTime? validUntil = const _isc.$UndefinedDateTime(),
    bool? isActive,
    DateTime? createdAt = const _isc.$UndefinedDateTime(),
    DateTime? updatedAt = const _isc.$UndefinedDateTime(),
    DateTime? deletedAt = const _isc.$UndefinedDateTime(),
    String? filePath,
    String? fileHash,
    String? password,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Certificate',
      if (id != null) 'id': id,
      'name': name,
      if (description != null) 'description': description,
      'certificateType': certificateType.toJson(),
      'certificateData': certificateData,
      if (privateKeyData != null) 'privateKeyData': privateKeyData,
      'format': format.toJson(),
      if (issuer != null) 'issuer': issuer,
      if (subject != null) 'subject': subject,
      if (serialNumber != null) 'serialNumber': serialNumber,
      if (fingerprintSha256 != null) 'fingerprintSha256': fingerprintSha256,
      if (validFrom != null) 'validFrom': validFrom?.toJson(),
      if (validUntil != null) 'validUntil': validUntil?.toJson(),
      'isActive': isActive,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      if (filePath != null) 'filePath': filePath,
      if (fileHash != null) 'fileHash': fileHash,
      if (password != null) 'password': password,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Certificate',
      if (id != null) 'id': id,
      'name': name,
      if (description != null) 'description': description,
      'certificateType': certificateType.toJson(),
      'certificateData': certificateData,
      if (privateKeyData != null) 'privateKeyData': privateKeyData,
      'format': format.toJson(),
      if (issuer != null) 'issuer': issuer,
      if (subject != null) 'subject': subject,
      if (serialNumber != null) 'serialNumber': serialNumber,
      if (fingerprintSha256 != null) 'fingerprintSha256': fingerprintSha256,
      if (validFrom != null) 'validFrom': validFrom?.toJson(),
      if (validUntil != null) 'validUntil': validUntil?.toJson(),
      'isActive': isActive,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      if (filePath != null) 'filePath': filePath,
      if (fileHash != null) 'fileHash': fileHash,
      if (password != null) 'password': password,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CertificateImpl extends Certificate {
  _CertificateImpl({
    int? id,
    required String name,
    String? description,
    required _inc4d0tr.CertificateType certificateType,
    required String certificateData,
    String? privateKeyData,
    required _inc4d0tr.CertificateFormat format,
    String? issuer,
    String? subject,
    String? serialNumber,
    String? fingerprintSha256,
    DateTime? validFrom,
    DateTime? validUntil,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    String? filePath,
    String? fileHash,
    String? password,
  }) : super._(
         id: id,
         name: name,
         description: description,
         certificateType: certificateType,
         certificateData: certificateData,
         privateKeyData: privateKeyData,
         format: format,
         issuer: issuer,
         subject: subject,
         serialNumber: serialNumber,
         fingerprintSha256: fingerprintSha256,
         validFrom: validFrom,
         validUntil: validUntil,
         isActive: isActive,
         createdAt: createdAt,
         updatedAt: updatedAt,
         deletedAt: deletedAt,
         filePath: filePath,
         fileHash: fileHash,
         password: password,
       );

  /// Returns a shallow copy of this [Certificate]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Certificate copyWith({
    Object? id = _Undefined,
    String? name,
    Object? description = _Undefined,
    _inc4d0tr.CertificateType? certificateType,
    String? certificateData,
    Object? privateKeyData = _Undefined,
    _inc4d0tr.CertificateFormat? format,
    Object? issuer = _Undefined,
    Object? subject = _Undefined,
    Object? serialNumber = _Undefined,
    Object? fingerprintSha256 = _Undefined,
    DateTime? validFrom = const _isc.$UndefinedDateTime(),
    DateTime? validUntil = const _isc.$UndefinedDateTime(),
    bool? isActive,
    DateTime? createdAt = const _isc.$UndefinedDateTime(),
    DateTime? updatedAt = const _isc.$UndefinedDateTime(),
    DateTime? deletedAt = const _isc.$UndefinedDateTime(),
    Object? filePath = _Undefined,
    Object? fileHash = _Undefined,
    Object? password = _Undefined,
  }) {
    return Certificate(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      certificateType: certificateType ?? this.certificateType,
      certificateData: certificateData ?? this.certificateData,
      privateKeyData: privateKeyData is String?
          ? privateKeyData
          : this.privateKeyData,
      format: format ?? this.format,
      issuer: issuer is String? ? issuer : this.issuer,
      subject: subject is String? ? subject : this.subject,
      serialNumber: serialNumber is String? ? serialNumber : this.serialNumber,
      fingerprintSha256: fingerprintSha256 is String?
          ? fingerprintSha256
          : this.fingerprintSha256,
      validFrom: validFrom is _isc.UndefinedSentinel
          ? this.validFrom
          : validFrom,
      validUntil: validUntil is _isc.UndefinedSentinel
          ? this.validUntil
          : validUntil,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt is _isc.UndefinedSentinel
          ? this.createdAt
          : createdAt,
      updatedAt: updatedAt is _isc.UndefinedSentinel
          ? this.updatedAt
          : updatedAt,
      deletedAt: deletedAt is _isc.UndefinedSentinel
          ? this.deletedAt
          : deletedAt,
      filePath: filePath is String? ? filePath : this.filePath,
      fileHash: fileHash is String? ? fileHash : this.fileHash,
      password: password is String? ? password : this.password,
    );
  }
}
