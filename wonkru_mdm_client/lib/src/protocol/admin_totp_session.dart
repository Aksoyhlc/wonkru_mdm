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

/// Two-factor verification state for one admin session.
///
/// Verification is session-bound: the row matches the session id ([sessionId])
/// and counts only until [verifiedUntil], so verifying on one device does not
/// open another session. [userId] lets disabling 2FA drop the verification of
/// all sessions at once; otherwise old sessions would count as verified under
/// the new secret.
abstract class AdminTotpSession
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AdminTotpSession._({
    this.id,
    required this.userId,
    required this.sessionId,
    required this.verifiedUntil,
    required this.createdAt,
  });

  factory AdminTotpSession({
    int? id,
    required _isc.UuidValue userId,
    required String sessionId,
    required DateTime verifiedUntil,
    required DateTime createdAt,
  }) = _AdminTotpSessionImpl;

  factory AdminTotpSession.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminTotpSession(
      id: jsonSerialization['id'] as int?,
      userId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      sessionId: jsonSerialization['sessionId'] as String,
      verifiedUntil: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['verifiedUntil'],
      ),
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _isc.UuidValue userId;

  /// `AuthenticationInfo.authId` (the JWT refresh token).
  String sessionId;

  DateTime verifiedUntil;

  DateTime createdAt;

  /// Returns a shallow copy of this [AdminTotpSession]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AdminTotpSession copyWith({
    int? id,
    _isc.UuidValue? userId,
    String? sessionId,
    DateTime? verifiedUntil,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminTotpSession',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'sessionId': sessionId,
      'verifiedUntil': verifiedUntil.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminTotpSession',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'sessionId': sessionId,
      'verifiedUntil': verifiedUntil.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminTotpSessionImpl extends AdminTotpSession {
  _AdminTotpSessionImpl({
    int? id,
    required _isc.UuidValue userId,
    required String sessionId,
    required DateTime verifiedUntil,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         sessionId: sessionId,
         verifiedUntil: verifiedUntil,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AdminTotpSession]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AdminTotpSession copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? userId,
    String? sessionId,
    DateTime? verifiedUntil,
    DateTime? createdAt,
  }) {
    return AdminTotpSession(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      sessionId: sessionId ?? this.sessionId,
      verifiedUntil: verifiedUntil ?? this.verifiedUntil,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
