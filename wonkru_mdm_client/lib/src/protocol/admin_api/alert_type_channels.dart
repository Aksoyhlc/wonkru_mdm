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
import '../enums/system_alert_type.dart' as _iqc8m4x7;

/// Not a table. Serverpod has no enum-keyed map, so `system_alert_routing`'s
/// on-disk `type_channels` map is carried as a list of records.
abstract class AlertTypeChannels
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AlertTypeChannels._({
    required this.type,
    required this.channels,
  });

  factory AlertTypeChannels({
    required _iqc8m4x7.SystemAlertType type,
    required List<String> channels,
  }) = _AlertTypeChannelsImpl;

  factory AlertTypeChannels.fromJson(Map<String, dynamic> jsonSerialization) {
    return AlertTypeChannels(
      type: _iqc8m4x7.SystemAlertType.fromJson(
        (jsonSerialization['type'] as String),
      ),
      channels: _icclvb2d.Protocol().deserialize<List<String>>(
        jsonSerialization['channels'],
      ),
    );
  }

  _iqc8m4x7.SystemAlertType type;

  /// Selected channels; every record carries at least one.
  List<String> channels;

  /// Returns a shallow copy of this [AlertTypeChannels]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AlertTypeChannels copyWith({
    _iqc8m4x7.SystemAlertType? type,
    List<String>? channels,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AlertTypeChannels',
      'type': type.toJson(),
      'channels': channels.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AlertTypeChannels',
      'type': type.toJson(),
      'channels': channels.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _AlertTypeChannelsImpl extends AlertTypeChannels {
  _AlertTypeChannelsImpl({
    required _iqc8m4x7.SystemAlertType type,
    required List<String> channels,
  }) : super._(
         type: type,
         channels: channels,
       );

  /// Returns a shallow copy of this [AlertTypeChannels]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AlertTypeChannels copyWith({
    _iqc8m4x7.SystemAlertType? type,
    List<String>? channels,
  }) {
    return AlertTypeChannels(
      type: type ?? this.type,
      channels: channels ?? this.channels.map((e0) => e0).toList(),
    );
  }
}
