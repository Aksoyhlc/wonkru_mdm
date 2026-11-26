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
import 'package:serverpod/serverpod.dart' as _is;
import 'package:wonkru_core_server/src/generated/protocol.dart' as _isn6ihzf;
import '../enums/device_action.dart' as _ibozxiug;

abstract class DeviceActionInfo
    implements _is.SerializableModel, _is.ProtocolSerialization {
  DeviceActionInfo._({
    required this.action,
    required this.isBulkAction,
    required this.requiresConfirmation,
    required this.expectedResponse,
    this.packageParamKey,
    required this.defaultParams,
  });

  factory DeviceActionInfo({
    required _ibozxiug.DeviceAction action,
    required bool isBulkAction,
    required bool requiresConfirmation,
    required String expectedResponse,
    String? packageParamKey,
    required Map<String, String> defaultParams,
  }) = _DeviceActionInfoImpl;

  factory DeviceActionInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeviceActionInfo(
      action: _ibozxiug.DeviceAction.fromJson(
        (jsonSerialization['action'] as String),
      ),
      isBulkAction: _is.BoolJsonExtension.fromJson(
        jsonSerialization['isBulkAction'],
      ),
      requiresConfirmation: _is.BoolJsonExtension.fromJson(
        jsonSerialization['requiresConfirmation'],
      ),
      expectedResponse: jsonSerialization['expectedResponse'] as String,
      packageParamKey: jsonSerialization['packageParamKey'] as String?,
      defaultParams: _isn6ihzf.Protocol().deserialize<Map<String, String>>(
        jsonSerialization['defaultParams'],
      ),
    );
  }

  _ibozxiug.DeviceAction action;

  bool isBulkAction;

  bool requiresConfirmation;

  /// Expected response type: `json` or `message`.
  String expectedResponse;

  String? packageParamKey;

  /// Defaults filled for missing params, keyed in snake_case.
  Map<String, String> defaultParams;

  /// Returns a shallow copy of this [DeviceActionInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DeviceActionInfo copyWith({
    _ibozxiug.DeviceAction? action,
    bool? isBulkAction,
    bool? requiresConfirmation,
    String? expectedResponse,
    String? packageParamKey,
    Map<String, String>? defaultParams,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'wonkru_core.DeviceActionInfo',
      'action': action.toJson(),
      'isBulkAction': isBulkAction,
      'requiresConfirmation': requiresConfirmation,
      'expectedResponse': expectedResponse,
      if (packageParamKey != null) 'packageParamKey': packageParamKey,
      'defaultParams': defaultParams.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'wonkru_core.DeviceActionInfo',
      'action': action.toJson(),
      'isBulkAction': isBulkAction,
      'requiresConfirmation': requiresConfirmation,
      'expectedResponse': expectedResponse,
      if (packageParamKey != null) 'packageParamKey': packageParamKey,
      'defaultParams': defaultParams.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DeviceActionInfoImpl extends DeviceActionInfo {
  _DeviceActionInfoImpl({
    required _ibozxiug.DeviceAction action,
    required bool isBulkAction,
    required bool requiresConfirmation,
    required String expectedResponse,
    String? packageParamKey,
    required Map<String, String> defaultParams,
  }) : super._(
         action: action,
         isBulkAction: isBulkAction,
         requiresConfirmation: requiresConfirmation,
         expectedResponse: expectedResponse,
         packageParamKey: packageParamKey,
         defaultParams: defaultParams,
       );

  /// Returns a shallow copy of this [DeviceActionInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DeviceActionInfo copyWith({
    _ibozxiug.DeviceAction? action,
    bool? isBulkAction,
    bool? requiresConfirmation,
    String? expectedResponse,
    Object? packageParamKey = _Undefined,
    Map<String, String>? defaultParams,
  }) {
    return DeviceActionInfo(
      action: action ?? this.action,
      isBulkAction: isBulkAction ?? this.isBulkAction,
      requiresConfirmation: requiresConfirmation ?? this.requiresConfirmation,
      expectedResponse: expectedResponse ?? this.expectedResponse,
      packageParamKey: packageParamKey is String?
          ? packageParamKey
          : this.packageParamKey,
      defaultParams:
          defaultParams ??
          this.defaultParams.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0,
            ),
          ),
    );
  }
}
