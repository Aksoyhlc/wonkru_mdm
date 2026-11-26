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

abstract class Setting
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Setting._({
    this.id,
    required this.name,
    this.value,
    this.createdAt,
    this.updatedAt,
  });

  factory Setting({
    int? id,
    required String name,
    String? value,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _SettingImpl;

  factory Setting.fromJson(Map<String, dynamic> jsonSerialization) {
    return Setting(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      value: jsonSerialization['value'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  /// Stored as text; may contain JSON.
  String? value;

  DateTime? createdAt;

  DateTime? updatedAt;

  /// Returns a shallow copy of this [Setting]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Setting copyWith({
    int? id,
    String? name,
    String? value,
    DateTime? createdAt = const _isc.$UndefinedDateTime(),
    DateTime? updatedAt = const _isc.$UndefinedDateTime(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Setting',
      if (id != null) 'id': id,
      'name': name,
      if (value != null) 'value': value,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Setting',
      if (id != null) 'id': id,
      'name': name,
      if (value != null) 'value': value,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SettingImpl extends Setting {
  _SettingImpl({
    int? id,
    required String name,
    String? value,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         name: name,
         value: value,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Setting]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Setting copyWith({
    Object? id = _Undefined,
    String? name,
    Object? value = _Undefined,
    DateTime? createdAt = const _isc.$UndefinedDateTime(),
    DateTime? updatedAt = const _isc.$UndefinedDateTime(),
  }) {
    return Setting(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      value: value is String? ? value : this.value,
      createdAt: createdAt is _isc.UndefinedSentinel
          ? this.createdAt
          : createdAt,
      updatedAt: updatedAt is _isc.UndefinedSentinel
          ? this.updatedAt
          : updatedAt,
    );
  }
}
