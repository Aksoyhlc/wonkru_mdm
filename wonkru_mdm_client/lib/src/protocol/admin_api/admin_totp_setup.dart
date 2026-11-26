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

abstract class AdminTotpSetup
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AdminTotpSetup._({
    required this.secret,
    required this.otpauthUri,
  });

  factory AdminTotpSetup({
    required String secret,
    required String otpauthUri,
  }) = _AdminTotpSetupImpl;

  factory AdminTotpSetup.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminTotpSetup(
      secret: jsonSerialization['secret'] as String,
      otpauthUri: jsonSerialization['otpauthUri'] as String,
    );
  }

  /// Base32 TOTP secret.
  String secret;

  /// `otpauth://` URI for authenticator apps.
  String otpauthUri;

  /// Returns a shallow copy of this [AdminTotpSetup]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AdminTotpSetup copyWith({
    String? secret,
    String? otpauthUri,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminTotpSetup',
      'secret': secret,
      'otpauthUri': otpauthUri,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminTotpSetup',
      'secret': secret,
      'otpauthUri': otpauthUri,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _AdminTotpSetupImpl extends AdminTotpSetup {
  _AdminTotpSetupImpl({
    required String secret,
    required String otpauthUri,
  }) : super._(
         secret: secret,
         otpauthUri: otpauthUri,
       );

  /// Returns a shallow copy of this [AdminTotpSetup]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AdminTotpSetup copyWith({
    String? secret,
    String? otpauthUri,
  }) {
    return AdminTotpSetup(
      secret: secret ?? this.secret,
      otpauthUri: otpauthUri ?? this.otpauthUri,
    );
  }
}
