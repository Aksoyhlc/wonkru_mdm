import 'package:wonkrumdm/Core/Constants/Enums/on_off.dart';
import 'package:wonkrumdm/Core/Utils/json_parse.dart';

/// Date/time and required-Wi-Fi settings (`other_settings`).
///
/// `auto_time` / `auto_time_zone` are tri-state: `1` on, `0` off, `2`/absent
/// default — the device is left untouched. Unknown values count as default.
class OtherSettingsConfig {
  final OnOff? autoTime;

  final OnOff? autoTimeZone;

  final String? timeZone;

  final int? time1224;

  final bool? requiredWifi;

  OtherSettingsConfig({this.autoTime, this.autoTimeZone, this.timeZone, this.time1224, this.requiredWifi});

  factory OtherSettingsConfig.fromJson(Map<String, dynamic> json) {
    return OtherSettingsConfig(
      autoTime: JsonParse.toOnOff(json['auto_time']),
      autoTimeZone: JsonParse.toOnOff(json['auto_time_zone']),
      timeZone: JsonParse.toStr(json['time_zone']),
      time1224: JsonParse.toInt(json['time_12_24']),
      requiredWifi: JsonParse.toBool(json['required_wifi']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'auto_time': autoTime?.value,
      'auto_time_zone': autoTimeZone?.value,
      'time_zone': timeZone,
      'time_12_24': time1224,
      if (requiredWifi != null) 'required_wifi': requiredWifi,
    };
  }
}
