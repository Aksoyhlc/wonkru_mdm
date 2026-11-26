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
import '../file_asset.dart' as _ie4nhfmj;

abstract class FilePage
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  FilePage._({
    required this.items,
    required this.total,
    required this.page,
    required this.perPage,
  });

  factory FilePage({
    required List<_ie4nhfmj.FileAsset> items,
    required int total,
    required int page,
    required int perPage,
  }) = _FilePageImpl;

  factory FilePage.fromJson(Map<String, dynamic> jsonSerialization) {
    return FilePage(
      items: _icclvb2d.Protocol().deserialize<List<_ie4nhfmj.FileAsset>>(
        jsonSerialization['items'],
      ),
      total: jsonSerialization['total'] as int,
      page: jsonSerialization['page'] as int,
      perPage: jsonSerialization['perPage'] as int,
    );
  }

  List<_ie4nhfmj.FileAsset> items;

  int total;

  /// One-based page number.
  int page;

  int perPage;

  /// Returns a shallow copy of this [FilePage]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  FilePage copyWith({
    List<_ie4nhfmj.FileAsset>? items,
    int? total,
    int? page,
    int? perPage,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FilePage',
      'items': items.toJson(valueToJson: (v) => v.toJson()),
      'total': total,
      'page': page,
      'perPage': perPage,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FilePage',
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

class _FilePageImpl extends FilePage {
  _FilePageImpl({
    required List<_ie4nhfmj.FileAsset> items,
    required int total,
    required int page,
    required int perPage,
  }) : super._(
         items: items,
         total: total,
         page: page,
         perPage: perPage,
       );

  /// Returns a shallow copy of this [FilePage]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  FilePage copyWith({
    List<_ie4nhfmj.FileAsset>? items,
    int? total,
    int? page,
    int? perPage,
  }) {
    return FilePage(
      items: items ?? this.items.map((e0) => e0.copyWith()).toList(),
      total: total ?? this.total,
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
    );
  }
}
