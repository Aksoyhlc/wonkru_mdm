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
import '../admin_api/device_group_row.dart' as _i56yjze9;

abstract class DeviceGroupPage
    implements _is.SerializableModel, _is.ProtocolSerialization {
  DeviceGroupPage._({
    required this.items,
    required this.total,
    required this.page,
    required this.perPage,
  });

  factory DeviceGroupPage({
    required List<_i56yjze9.DeviceGroupRow> items,
    required int total,
    required int page,
    required int perPage,
  }) = _DeviceGroupPageImpl;

  factory DeviceGroupPage.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeviceGroupPage(
      items: _ij1wyujj.Protocol().deserialize<List<_i56yjze9.DeviceGroupRow>>(
        jsonSerialization['items'],
      ),
      total: jsonSerialization['total'] as int,
      page: jsonSerialization['page'] as int,
      perPage: jsonSerialization['perPage'] as int,
    );
  }

  List<_i56yjze9.DeviceGroupRow> items;

  int total;

  int page;

  int perPage;

  /// Returns a shallow copy of this [DeviceGroupPage]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DeviceGroupPage copyWith({
    List<_i56yjze9.DeviceGroupRow>? items,
    int? total,
    int? page,
    int? perPage,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeviceGroupPage',
      'items': items.toJson(valueToJson: (v) => v.toJson()),
      'total': total,
      'page': page,
      'perPage': perPage,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeviceGroupPage',
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

class _DeviceGroupPageImpl extends DeviceGroupPage {
  _DeviceGroupPageImpl({
    required List<_i56yjze9.DeviceGroupRow> items,
    required int total,
    required int page,
    required int perPage,
  }) : super._(
         items: items,
         total: total,
         page: page,
         perPage: perPage,
       );

  /// Returns a shallow copy of this [DeviceGroupPage]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DeviceGroupPage copyWith({
    List<_i56yjze9.DeviceGroupRow>? items,
    int? total,
    int? page,
    int? perPage,
  }) {
    return DeviceGroupPage(
      items: items ?? this.items.map((e0) => e0.copyWith()).toList(),
      total: total ?? this.total,
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
    );
  }
}
