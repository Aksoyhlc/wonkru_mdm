import 'package:wonkrumdm/Core/Utils/json_parse.dart';

class AudioConfig {
  final int? fixedVolume;

  final bool? fixedVolumePolicy;

  final int? minVolume;

  final int? maxVolume;

  AudioConfig({this.fixedVolume, this.fixedVolumePolicy, this.minVolume, this.maxVolume});

  factory AudioConfig.fromJson(Map<String, dynamic> json) {
    return AudioConfig(
      fixedVolume: JsonParse.toInt(json['fixed_volume']),
      fixedVolumePolicy: JsonParse.toBool(json['fixed_volume_policy']),
      minVolume: JsonParse.toInt(json['min_volume']),
      maxVolume: JsonParse.toInt(json['max_volume']),
    );
  }
}
