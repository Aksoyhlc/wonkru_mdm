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
import 'enums/app_source_type.dart' as _iroy7u8c;

abstract class Application
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Application._({
    this.id,
    required this.packageName,
    required this.appName,
    this.developerName,
    this.iconUrl,
    this.category,
    this.sourceType,
    bool? isSystemApp,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  }) : isSystemApp = isSystemApp ?? false;

  factory Application({
    int? id,
    required String packageName,
    required String appName,
    String? developerName,
    String? iconUrl,
    String? category,
    _iroy7u8c.AppSourceType? sourceType,
    bool? isSystemApp,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) = _ApplicationImpl;

  factory Application.fromJson(Map<String, dynamic> jsonSerialization) {
    return Application(
      id: jsonSerialization['id'] as int?,
      packageName: jsonSerialization['packageName'] as String,
      appName: jsonSerialization['appName'] as String,
      developerName: jsonSerialization['developerName'] as String?,
      iconUrl: jsonSerialization['iconUrl'] as String?,
      category: jsonSerialization['category'] as String?,
      sourceType: jsonSerialization['sourceType'] == null
          ? null
          : _iroy7u8c.AppSourceType.fromJson(
              (jsonSerialization['sourceType'] as String),
            ),
      isSystemApp: jsonSerialization['isSystemApp'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['isSystemApp']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String packageName;

  String appName;

  String? developerName;

  String? iconUrl;

  String? category;

  _iroy7u8c.AppSourceType? sourceType;

  bool isSystemApp;

  DateTime? createdAt;

  DateTime? updatedAt;

  DateTime? deletedAt;

  /// Returns a shallow copy of this [Application]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Application copyWith({
    int? id,
    String? packageName,
    String? appName,
    String? developerName,
    String? iconUrl,
    String? category,
    _iroy7u8c.AppSourceType? sourceType,
    bool? isSystemApp,
    DateTime? createdAt = const _isc.$UndefinedDateTime(),
    DateTime? updatedAt = const _isc.$UndefinedDateTime(),
    DateTime? deletedAt = const _isc.$UndefinedDateTime(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Application',
      if (id != null) 'id': id,
      'packageName': packageName,
      'appName': appName,
      if (developerName != null) 'developerName': developerName,
      if (iconUrl != null) 'iconUrl': iconUrl,
      if (category != null) 'category': category,
      if (sourceType != null) 'sourceType': sourceType?.toJson(),
      'isSystemApp': isSystemApp,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Application',
      if (id != null) 'id': id,
      'packageName': packageName,
      'appName': appName,
      if (developerName != null) 'developerName': developerName,
      if (iconUrl != null) 'iconUrl': iconUrl,
      if (category != null) 'category': category,
      if (sourceType != null) 'sourceType': sourceType?.toJson(),
      'isSystemApp': isSystemApp,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ApplicationImpl extends Application {
  _ApplicationImpl({
    int? id,
    required String packageName,
    required String appName,
    String? developerName,
    String? iconUrl,
    String? category,
    _iroy7u8c.AppSourceType? sourceType,
    bool? isSystemApp,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) : super._(
         id: id,
         packageName: packageName,
         appName: appName,
         developerName: developerName,
         iconUrl: iconUrl,
         category: category,
         sourceType: sourceType,
         isSystemApp: isSystemApp,
         createdAt: createdAt,
         updatedAt: updatedAt,
         deletedAt: deletedAt,
       );

  /// Returns a shallow copy of this [Application]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Application copyWith({
    Object? id = _Undefined,
    String? packageName,
    String? appName,
    Object? developerName = _Undefined,
    Object? iconUrl = _Undefined,
    Object? category = _Undefined,
    Object? sourceType = _Undefined,
    bool? isSystemApp,
    DateTime? createdAt = const _isc.$UndefinedDateTime(),
    DateTime? updatedAt = const _isc.$UndefinedDateTime(),
    DateTime? deletedAt = const _isc.$UndefinedDateTime(),
  }) {
    return Application(
      id: id is int? ? id : this.id,
      packageName: packageName ?? this.packageName,
      appName: appName ?? this.appName,
      developerName: developerName is String?
          ? developerName
          : this.developerName,
      iconUrl: iconUrl is String? ? iconUrl : this.iconUrl,
      category: category is String? ? category : this.category,
      sourceType: sourceType is _iroy7u8c.AppSourceType?
          ? sourceType
          : this.sourceType,
      isSystemApp: isSystemApp ?? this.isSystemApp,
      createdAt: createdAt is _isc.UndefinedSentinel
          ? this.createdAt
          : createdAt,
      updatedAt: updatedAt is _isc.UndefinedSentinel
          ? this.updatedAt
          : updatedAt,
      deletedAt: deletedAt is _isc.UndefinedSentinel
          ? this.deletedAt
          : deletedAt,
    );
  }
}
