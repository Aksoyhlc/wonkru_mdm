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
import '../application.dart' as _inh16wtc;

abstract class ApplicationPage
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ApplicationPage._({
    required this.items,
    required this.total,
    required this.page,
    required this.perPage,
    this.versionCounts,
  });

  factory ApplicationPage({
    required List<_inh16wtc.Application> items,
    required int total,
    required int page,
    required int perPage,
    Map<int, int>? versionCounts,
  }) = _ApplicationPageImpl;

  factory ApplicationPage.fromJson(Map<String, dynamic> jsonSerialization) {
    return ApplicationPage(
      items: _ij1wyujj.Protocol().deserialize<List<_inh16wtc.Application>>(
        jsonSerialization['items'],
      ),
      total: jsonSerialization['total'] as int,
      page: jsonSerialization['page'] as int,
      perPage: jsonSerialization['perPage'] as int,
      versionCounts: jsonSerialization['versionCounts'] == null
          ? null
          : _ij1wyujj.Protocol().deserialize<Map<int, int>>(
              jsonSerialization['versionCounts'],
            ),
    );
  }

  List<_inh16wtc.Application> items;

  int total;

  int page;

  int perPage;

  /// `applicationId` -> total version count, active or not; computed in one query.
  Map<int, int>? versionCounts;

  /// Returns a shallow copy of this [ApplicationPage]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ApplicationPage copyWith({
    List<_inh16wtc.Application>? items,
    int? total,
    int? page,
    int? perPage,
    Map<int, int>? versionCounts = const _is.$UndefinedMap<int, int>(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ApplicationPage',
      'items': items.toJson(valueToJson: (v) => v.toJson()),
      'total': total,
      'page': page,
      'perPage': perPage,
      if (versionCounts != null) 'versionCounts': versionCounts?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ApplicationPage',
      'items': items.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'total': total,
      'page': page,
      'perPage': perPage,
      if (versionCounts != null) 'versionCounts': versionCounts?.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _ApplicationPageImpl extends ApplicationPage {
  _ApplicationPageImpl({
    required List<_inh16wtc.Application> items,
    required int total,
    required int page,
    required int perPage,
    Map<int, int>? versionCounts,
  }) : super._(
         items: items,
         total: total,
         page: page,
         perPage: perPage,
         versionCounts: versionCounts,
       );

  /// Returns a shallow copy of this [ApplicationPage]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ApplicationPage copyWith({
    List<_inh16wtc.Application>? items,
    int? total,
    int? page,
    int? perPage,
    Map<int, int>? versionCounts = const _is.$UndefinedMap<int, int>(),
  }) {
    return ApplicationPage(
      items: items ?? this.items.map((e0) => e0.copyWith()).toList(),
      total: total ?? this.total,
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      versionCounts: versionCounts is _is.UndefinedSentinel
          ? this.versionCounts?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0,
              ),
            )
          : versionCounts,
    );
  }
}
