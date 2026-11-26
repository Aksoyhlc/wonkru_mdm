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
import 'package:wonkru_mdm_client/src/protocol/protocol.dart' as _icclvb2d;
import '../admin_api/device_log_row.dart' as _io7cer32;

abstract class DeviceLogPage
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DeviceLogPage._({
    required this.items,
    required this.total,
    required this.page,
    required this.perPage,
  });

  factory DeviceLogPage({
    required List<_io7cer32.DeviceLogRow> items,
    required int total,
    required int page,
    required int perPage,
  }) = _DeviceLogPageImpl;

  factory DeviceLogPage.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeviceLogPage(
      items: _icclvb2d.Protocol().deserialize<List<_io7cer32.DeviceLogRow>>(
        jsonSerialization['items'],
      ),
      total: jsonSerialization['total'] as int,
      page: jsonSerialization['page'] as int,
      perPage: jsonSerialization['perPage'] as int,
    );
  }

  List<_io7cer32.DeviceLogRow> items;

  int total;

  int page;

  int perPage;

  /// Returns a shallow copy of this [DeviceLogPage]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DeviceLogPage copyWith({
    List<_io7cer32.DeviceLogRow>? items,
    int? total,
    int? page,
    int? perPage,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeviceLogPage',
      'items': items.toJson(valueToJson: (v) => v.toJson()),
      'total': total,
      'page': page,
      'perPage': perPage,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeviceLogPage',
      'items': items.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'total': total,
      'page': page,
      'perPage': perPage,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _DeviceLogPageImpl extends DeviceLogPage {
  _DeviceLogPageImpl({
    required List<_io7cer32.DeviceLogRow> items,
    required int total,
    required int page,
    required int perPage,
  }) : super._(
         items: items,
         total: total,
         page: page,
         perPage: perPage,
       );

  /// Returns a shallow copy of this [DeviceLogPage]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DeviceLogPage copyWith({
    List<_io7cer32.DeviceLogRow>? items,
    int? total,
    int? page,
    int? perPage,
  }) {
    return DeviceLogPage(
      items: items ?? this.items.map((e0) => e0.copyWith()).toList(),
      total: total ?? this.total,
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
    );
  }
}
