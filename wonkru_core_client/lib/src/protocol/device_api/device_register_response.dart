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

abstract class DeviceRegisterResponse
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DeviceRegisterResponse._({
    required this.code,
    required this.uuid,
    required this.token,
  });

  factory DeviceRegisterResponse({
    required String code,
    required String uuid,
    required String token,
  }) = _DeviceRegisterResponseImpl;

  factory DeviceRegisterResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return DeviceRegisterResponse(
      code: jsonSerialization['code'] as String,
      uuid: jsonSerialization['uuid'] as String,
      token: jsonSerialization['token'] as String,
    );
  }

  String code;

  String uuid;

  String token;

  /// Returns a shallow copy of this [DeviceRegisterResponse]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DeviceRegisterResponse copyWith({
    String? code,
    String? uuid,
    String? token,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'wonkru_core.DeviceRegisterResponse',
      'code': code,
      'uuid': uuid,
      'token': token,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'wonkru_core.DeviceRegisterResponse',
      'code': code,
      'uuid': uuid,
      'token': token,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _DeviceRegisterResponseImpl extends DeviceRegisterResponse {
  _DeviceRegisterResponseImpl({
    required String code,
    required String uuid,
    required String token,
  }) : super._(
         code: code,
         uuid: uuid,
         token: token,
       );

  /// Returns a shallow copy of this [DeviceRegisterResponse]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DeviceRegisterResponse copyWith({
    String? code,
    String? uuid,
    String? token,
  }) {
    return DeviceRegisterResponse(
      code: code ?? this.code,
      uuid: uuid ?? this.uuid,
      token: token ?? this.token,
    );
  }
}
