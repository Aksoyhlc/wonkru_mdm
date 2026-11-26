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
import 'package:wonkru_mdm_server/src/generated/protocol.dart' as _ij1wyujj;
import '../device_application.dart' as _ilqdlmjj;

abstract class DeviceApplicationPage
    implements _is.SerializableModel, _is.ProtocolSerialization {
  DeviceApplicationPage._({
    required this.items,
    required this.total,
    required this.page,
    required this.perPage,
  });

  factory DeviceApplicationPage({
    required List<_ilqdlmjj.DeviceApplication> items,
    required int total,
    required int page,
    required int perPage,
  }) = _DeviceApplicationPageImpl;

  factory DeviceApplicationPage.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return DeviceApplicationPage(
      items: _ij1wyujj.Protocol()
          .deserialize<List<_ilqdlmjj.DeviceApplication>>(
            jsonSerialization['items'],
          ),
      total: jsonSerialization['total'] as int,
      page: jsonSerialization['page'] as int,
      perPage: jsonSerialization['perPage'] as int,
    );
  }

  List<_ilqdlmjj.DeviceApplication> items;

  int total;

  int page;

  int perPage;

  /// Returns a shallow copy of this [DeviceApplicationPage]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DeviceApplicationPage copyWith({
    List<_ilqdlmjj.DeviceApplication>? items,
    int? total,
    int? page,
    int? perPage,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeviceApplicationPage',
      'items': items.toJson(valueToJson: (v) => v.toJson()),
      'total': total,
      'page': page,
      'perPage': perPage,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeviceApplicationPage',
      'items': items.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'total': total,
      'page': page,
      'perPage': perPage,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _DeviceApplicationPageImpl extends DeviceApplicationPage {
  _DeviceApplicationPageImpl({
    required List<_ilqdlmjj.DeviceApplication> items,
    required int total,
    required int page,
    required int perPage,
  }) : super._(
         items: items,
         total: total,
         page: page,
         perPage: perPage,
       );

  /// Returns a shallow copy of this [DeviceApplicationPage]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DeviceApplicationPage copyWith({
    List<_ilqdlmjj.DeviceApplication>? items,
    int? total,
    int? page,
    int? perPage,
  }) {
    return DeviceApplicationPage(
      items: items ?? this.items.map((e0) => e0.copyWith()).toList(),
      total: total ?? this.total,
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
    );
  }
}
