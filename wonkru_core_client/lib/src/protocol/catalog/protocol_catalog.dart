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
import 'package:wonkru_core_client/src/protocol/protocol.dart' as _ibadcrbv;
import '../catalog/device_action_info.dart' as _iyfp9g7n;
import '../catalog/restriction_catalog_entry.dart' as _i11ird9j;

/// Not persisted; served to the panel over the protocol via `CoreEndpoint.catalogs`.
abstract class ProtocolCatalog
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ProtocolCatalog._({
    required this.restrictions,
    required this.deviceActions,
    required this.enumValues,
  });

  factory ProtocolCatalog({
    required List<_i11ird9j.RestrictionCatalogEntry> restrictions,
    required List<_iyfp9g7n.DeviceActionInfo> deviceActions,
    required Map<String, List<String>> enumValues,
  }) = _ProtocolCatalogImpl;

  factory ProtocolCatalog.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProtocolCatalog(
      restrictions: _ibadcrbv.Protocol()
          .deserialize<List<_i11ird9j.RestrictionCatalogEntry>>(
            jsonSerialization['restrictions'],
          ),
      deviceActions: _ibadcrbv.Protocol()
          .deserialize<List<_iyfp9g7n.DeviceActionInfo>>(
            jsonSerialization['deviceActions'],
          ),
      enumValues: _ibadcrbv.Protocol().deserialize<Map<String, List<String>>>(
        jsonSerialization['enumValues'],
      ),
    );
  }

  List<_i11ird9j.RestrictionCatalogEntry> restrictions;

  List<_iyfp9g7n.DeviceActionInfo> deviceActions;

  Map<String, List<String>> enumValues;

  /// Returns a shallow copy of this [ProtocolCatalog]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ProtocolCatalog copyWith({
    List<_i11ird9j.RestrictionCatalogEntry>? restrictions,
    List<_iyfp9g7n.DeviceActionInfo>? deviceActions,
    Map<String, List<String>>? enumValues,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'wonkru_core.ProtocolCatalog',
      'restrictions': restrictions.toJson(valueToJson: (v) => v.toJson()),
      'deviceActions': deviceActions.toJson(valueToJson: (v) => v.toJson()),
      'enumValues': enumValues.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'wonkru_core.ProtocolCatalog',
      'restrictions': restrictions.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'deviceActions': deviceActions.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'enumValues': enumValues.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _ProtocolCatalogImpl extends ProtocolCatalog {
  _ProtocolCatalogImpl({
    required List<_i11ird9j.RestrictionCatalogEntry> restrictions,
    required List<_iyfp9g7n.DeviceActionInfo> deviceActions,
    required Map<String, List<String>> enumValues,
  }) : super._(
         restrictions: restrictions,
         deviceActions: deviceActions,
         enumValues: enumValues,
       );

  /// Returns a shallow copy of this [ProtocolCatalog]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ProtocolCatalog copyWith({
    List<_i11ird9j.RestrictionCatalogEntry>? restrictions,
    List<_iyfp9g7n.DeviceActionInfo>? deviceActions,
    Map<String, List<String>>? enumValues,
  }) {
    return ProtocolCatalog(
      restrictions:
          restrictions ?? this.restrictions.map((e0) => e0.copyWith()).toList(),
      deviceActions:
          deviceActions ??
          this.deviceActions.map((e0) => e0.copyWith()).toList(),
      enumValues:
          enumValues ??
          this.enumValues.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0.map((e1) => e1).toList(),
            ),
          ),
    );
  }
}
