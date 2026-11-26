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

abstract class DashboardChart
    implements _is.SerializableModel, _is.ProtocolSerialization {
  DashboardChart._({
    required this.labels,
    required this.values,
    this.colors,
  });

  factory DashboardChart({
    required List<String> labels,
    required List<int> values,
    List<String>? colors,
  }) = _DashboardChartImpl;

  factory DashboardChart.fromJson(Map<String, dynamic> jsonSerialization) {
    return DashboardChart(
      labels: _ij1wyujj.Protocol().deserialize<List<String>>(
        jsonSerialization['labels'],
      ),
      values: _ij1wyujj.Protocol().deserialize<List<int>>(
        jsonSerialization['values'],
      ),
      colors: jsonSerialization['colors'] == null
          ? null
          : _ij1wyujj.Protocol().deserialize<List<String>>(
              jsonSerialization['colors'],
            ),
    );
  }

  /// Bucket labels, in draw order.
  List<String> labels;

  /// Value of each label, in the same order.
  List<int> values;

  /// Hex colour of each value, for the charts that paint slices. Absent for
  /// series that are drawn as a single line.
  List<String>? colors;

  /// Returns a shallow copy of this [DashboardChart]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DashboardChart copyWith({
    List<String>? labels,
    List<int>? values,
    List<String>? colors = const _is.$UndefinedList<String>(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DashboardChart',
      'labels': labels.toJson(),
      'values': values.toJson(),
      if (colors != null) 'colors': colors?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DashboardChart',
      'labels': labels.toJson(),
      'values': values.toJson(),
      if (colors != null) 'colors': colors?.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _DashboardChartImpl extends DashboardChart {
  _DashboardChartImpl({
    required List<String> labels,
    required List<int> values,
    List<String>? colors,
  }) : super._(
         labels: labels,
         values: values,
         colors: colors,
       );

  /// Returns a shallow copy of this [DashboardChart]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DashboardChart copyWith({
    List<String>? labels,
    List<int>? values,
    List<String>? colors = const _is.$UndefinedList<String>(),
  }) {
    return DashboardChart(
      labels: labels ?? this.labels.map((e0) => e0).toList(),
      values: values ?? this.values.map((e0) => e0).toList(),
      colors: colors is _is.UndefinedSentinel
          ? this.colors?.map((e0) => e0).toList()
          : colors,
    );
  }
}
