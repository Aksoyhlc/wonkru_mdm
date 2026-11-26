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
import '../file_group.dart' as _ir7mviy8;

abstract class FileGroupRow
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  FileGroupRow._({
    required this.group,
    required this.fileCount,
  });

  factory FileGroupRow({
    required _ir7mviy8.FileGroup group,
    required int fileCount,
  }) = _FileGroupRowImpl;

  factory FileGroupRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return FileGroupRow(
      group: _icclvb2d.Protocol().deserialize<_ir7mviy8.FileGroup>(
        jsonSerialization['group'],
      ),
      fileCount: jsonSerialization['fileCount'] as int,
    );
  }

  _ir7mviy8.FileGroup group;

  int fileCount;

  /// Returns a shallow copy of this [FileGroupRow]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  FileGroupRow copyWith({
    _ir7mviy8.FileGroup? group,
    int? fileCount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FileGroupRow',
      'group': group.toJson(),
      'fileCount': fileCount,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FileGroupRow',
      'group': group.toJsonForProtocol(),
      'fileCount': fileCount,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _FileGroupRowImpl extends FileGroupRow {
  _FileGroupRowImpl({
    required _ir7mviy8.FileGroup group,
    required int fileCount,
  }) : super._(
         group: group,
         fileCount: fileCount,
       );

  /// Returns a shallow copy of this [FileGroupRow]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  FileGroupRow copyWith({
    _ir7mviy8.FileGroup? group,
    int? fileCount,
  }) {
    return FileGroupRow(
      group: group ?? this.group.copyWith(),
      fileCount: fileCount ?? this.fileCount,
    );
  }
}
