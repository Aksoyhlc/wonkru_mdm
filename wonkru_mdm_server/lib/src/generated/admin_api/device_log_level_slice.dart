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

abstract class DeviceLogLevelSlice
    implements _is.SerializableModel, _is.ProtocolSerialization {
  DeviceLogLevelSlice._({
    required this.label,
    required this.level,
    required this.count,
    required this.color,
  });

  factory DeviceLogLevelSlice({
    required String label,
    required int level,
    required int count,
    required String color,
  }) = _DeviceLogLevelSliceImpl;

  factory DeviceLogLevelSlice.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeviceLogLevelSlice(
      label: jsonSerialization['label'] as String,
      level: jsonSerialization['level'] as int,
      count: jsonSerialization['count'] as int,
      color: jsonSerialization['color'] as String,
    );
  }

  /// Level name, e.g. `ERROR`.
  String label;

  /// Level value the rows carry, e.g. 4.
  int level;

  int count;

  String color;

  /// Returns a shallow copy of this [DeviceLogLevelSlice]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DeviceLogLevelSlice copyWith({
    String? label,
    int? level,
    int? count,
    String? color,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeviceLogLevelSlice',
      'label': label,
      'level': level,
      'count': count,
      'color': color,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeviceLogLevelSlice',
      'label': label,
      'level': level,
      'count': count,
      'color': color,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _DeviceLogLevelSliceImpl extends DeviceLogLevelSlice {
  _DeviceLogLevelSliceImpl({
    required String label,
    required int level,
    required int count,
    required String color,
  }) : super._(
         label: label,
         level: level,
         count: count,
         color: color,
       );

  /// Returns a shallow copy of this [DeviceLogLevelSlice]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DeviceLogLevelSlice copyWith({
    String? label,
    int? level,
    int? count,
    String? color,
  }) {
    return DeviceLogLevelSlice(
      label: label ?? this.label,
      level: level ?? this.level,
      count: count ?? this.count,
      color: color ?? this.color,
    );
  }
}
