import 'package:wonkrumdm/Core/Logging/wlog.dart';
import 'package:wonkrumdm/Core/Utils/json_parse.dart';
import 'package:wonkrumdm/Data/Models/Core/wlog_config.dart';

import 'index.dart';

const _tag = 'DeviceConfig';

class DeviceConfig {
  final int? id;
  final String? name;
  final String? slug;
  final String? description;
  final int? version;
  final bool isActive;
  final bool defaultPolicy;

  final LauncherConfig? launcherConfig;
  final BatteryConfig? batterySettings;
  final StoragePolicy? storageSettings;
  final AudioConfig? audioSettings;
  final DisplayConfig? displaySettings;
  final SecurityConfig? securitySettings;
  final RestrictPolicy? restrictionSettings;
  final AppConfig? appSettings;
  final CertificateSettings? certificateSettings;
  final OtherSettingsConfig? otherSettings;
  final FilePolicyConfig? fileSettings;
  final SyncSettingsConfig? syncSettings;
  final WLogConfig? wlogConfig;

  final Map<String, String>? activeTimeRanges;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  DeviceConfig({
    this.id,
    this.name,
    this.slug,
    this.description,
    this.version,
    this.isActive = true,
    this.defaultPolicy = false,
    this.launcherConfig,
    this.batterySettings,
    this.storageSettings,
    this.audioSettings,
    this.displaySettings,
    this.securitySettings,
    this.restrictionSettings,
    this.appSettings,
    this.certificateSettings,
    this.otherSettings,
    this.fileSettings,
    this.syncSettings,
    this.wlogConfig,
    this.activeTimeRanges,
    this.createdAt,
    this.updatedAt,
  });

  List<ManagedApp>? get applications => appSettings?.managedApps;

  List<CertificatePolicy>? get certificates => certificateSettings?.policies;

  /// Tolerant parse: every section is parsed independently via [JsonParse.nested],
  /// so a corrupt field drops only its own section/field and this factory never
  /// throws on known type mismatches.
  factory DeviceConfig.fromJson(Map<String, dynamic> json) {
    final other = JsonParse.toMap(json['other_settings']);
    final filesToDelete = other?['files_to_delete'];

    return DeviceConfig(
      id: JsonParse.toInt(json['id']),
      name: JsonParse.toStr(json['name']),
      slug: JsonParse.toStr(json['slug']),
      description: JsonParse.toStr(json['description']),
      version: JsonParse.toInt(json['version']),
      isActive: JsonParse.toBool(json['is_active']) ?? true,
      defaultPolicy: JsonParse.toBool(json['default_policy']) ?? false,

      launcherConfig: _guard(
        'launcher',
        () => LauncherConfig.fromPolicyPayload(json),
      ),

      batterySettings: JsonParse.nested(
        json['battery_settings'],
        BatteryConfig.fromJson,
        field: 'battery_settings',
      ),
      storageSettings: JsonParse.nested(
        json['storage_settings'],
        StoragePolicy.fromJson,
        field: 'storage_settings',
      ),
      audioSettings: JsonParse.nested(
        json['audio_settings'],
        AudioConfig.fromJson,
        field: 'audio_settings',
      ),
      displaySettings: JsonParse.nested(
        json['display_settings'],
        DisplayConfig.fromJson,
        field: 'display_settings',
      ),
      securitySettings: JsonParse.nested(
        json['security_settings'],
        SecurityConfig.fromJson,
        field: 'security_settings',
      ),
      restrictionSettings: JsonParse.nested(
        json['restriction_settings'],
        RestrictPolicy.fromJson,
        field: 'restriction_settings',
      ),
      appSettings: JsonParse.nested(
        json['applications'],
        AppConfig.fromJson,
        field: 'applications',
      ),
      certificateSettings: json['certificates'] != null
          ? _guard(
              'certificates',
              () => CertificateSettings.fromJson(json['certificates']),
            )
          : null,

      activeTimeRanges: _parseTimeRanges(json['active_time_ranges']),

      otherSettings: other != null && other.isNotEmpty
          ? JsonParse.nested(
              other,
              OtherSettingsConfig.fromJson,
              field: 'other_settings',
            )
          : null,

      fileSettings: (json['files'] != null || filesToDelete != null)
          ? _guard(
              'files',
              () => FilePolicyConfig.fromJson({
                'files': json['files'],
                'files_to_delete': filesToDelete,
              }),
            )
          : null,

      syncSettings: JsonParse.nested(
        json['sync_settings'],
        SyncSettingsConfig.fromJson,
        field: 'sync_settings',
      ),
      wlogConfig: JsonParse.nested(
        json['wlog_config'],
        WLogConfig.fromJson,
        field: 'wlog_config',
      ),

      createdAt: JsonParse.toDate(json['created_at']),
      updatedAt: JsonParse.toDate(json['updated_at']),
    );
  }

  /// Maps a start time to an end time, e.g. `{"08:00": "18:00"}`; non-string
  /// values are skipped.
  static Map<String, String>? _parseTimeRanges(Object? raw) {
    final map = JsonParse.toMap(raw);
    if (map == null) return null;
    return {
      for (final entry in map.entries)
        if (entry.value != null) entry.key: entry.value.toString(),
    };
  }

  static T? _guard<T>(String field, T Function() parse) {
    try {
      return parse();
    } catch (e, st) {
      WLog.w(
        _tag,
        '$field could not be parsed; ignoring',
        error: e,
        stackTrace: st,
      );
      return null;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'version': version,
      'is_active': isActive,
      'default_policy': defaultPolicy,
      'applications': appSettings?.managedApps?.map((e) => e).toList(),
      'certificates': certificateSettings?.policies
          .map((e) => e.toJson())
          .toList(),
      'other_settings': otherSettings?.toJson(),
      'file_settings': fileSettings != null
          ? {
              'files': fileSettings!.policies.map((e) => e.toJson()).toList(),
              'files_to_delete': fileSettings!.filesToDelete,
            }
          : null,
      'sync_settings': syncSettings?.toJson(),
      'wlog_config': wlogConfig?.toJson(),
      'active_time_ranges': activeTimeRanges,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
