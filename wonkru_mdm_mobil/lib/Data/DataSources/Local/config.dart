import 'package:wonkrumdm/Core/Logging/wlog.dart';
import 'package:wonkrumdm/Data/DataSources/Local/base_local_data_source.dart';
import 'package:wonkrumdm/Data/Models/Features/config.dart';

const _tag = 'LocalConfig';

class LocalConfig extends BaseLocalDataSource {
  Future<bool> saveConfig(Map<String, dynamic> data) async {
    try {
      st.setJson('device_config', data);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  static DeviceConfig? parse(Map<String, dynamic> data) {
    try {
      return DeviceConfig.fromJson(Map<String, dynamic>.from(data));
    } catch (e, s) {
      WLog.e(_tag, 'Config parse error', error: e, stackTrace: s);
      return null;
    }
  }

  DeviceConfig? getConfig() {
    final data = st.getJson('device_config');
    if (data == null || data.isEmpty) return null;
    return parse(Map<String, dynamic>.from(data));
  }
}
