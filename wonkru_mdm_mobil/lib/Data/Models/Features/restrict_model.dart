import 'package:wonkrumdm/Core/Constants/Enums/on_off.dart';
import 'package:wonkrumdm/Core/Utils/json_parse.dart';

/// A single user restriction: `value` is tri-state — `1` restricts, `0` allows,
/// `2` (or missing/unknown) is default: the device is left untouched.
class RestrictModel {
  String? name;
  String? key;
  int? apiLevel;
  OnOff? value;

  RestrictModel({this.name, this.key, this.apiLevel, this.value = OnOff.def});

  RestrictModel.fromJson(Map<String, dynamic> json) {
    name = JsonParse.toStr(json['name']);
    key = JsonParse.toStr(json['key']);
    apiLevel = JsonParse.toInt(json['api_level']);
    value = JsonParse.toOnOffOrDef(json['value']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'key': key,
      'api_level': apiLevel,
      'value': value?.value ?? OnOff.def.value,
    };
  }
}
