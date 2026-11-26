import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:wonkrumdm/Core/Constants/Enums/storage_keys.dart';
import 'package:wonkrumdm/Core/Logging/wlog.dart';
import 'package:wonkrumdm/Core/Managers/app_manager.dart';
import 'package:wonkrumdm/Core/Managers/audio_manager.dart';
import 'package:wonkrumdm/Core/Managers/battery_manager.dart';
import 'package:wonkrumdm/Core/Managers/certificate_manager.dart';
import 'package:wonkrumdm/Core/Managers/display_manager.dart';
import 'package:wonkrumdm/Core/Managers/network_manager.dart';
import 'package:wonkrumdm/Core/Managers/other_settings_manager.dart';
import 'package:wonkrumdm/Core/Managers/restriction_manager.dart';
import 'package:wonkrumdm/Core/Managers/security_manager.dart';
import 'package:wonkrumdm/Core/Managers/storage_manager.dart';
import 'package:wonkrumdm/Core/Managers/system_settings_manager.dart';
import 'package:wonkrumdm/Core/Services/sync_storage_filter.dart';
import 'package:wonkrumdm/Core/Utils/basic_storage.dart';
import 'package:wonkrumdm/Core/Utils/device_identity_helper.dart';
import 'package:wonkrumdm/Core/Utils/storage_helper.dart';

const _tag = 'DeviceDataCollector';

class DeviceDataCollector {
  static final DeviceDataCollector _instance = DeviceDataCollector._internal();

  factory DeviceDataCollector() => _instance;

  DeviceDataCollector._internal();

  final st = StorageHelper();
  final bs = BasicStorage();

  final _appManager = AppManager();
  final _audioManager = AudioManager();
  final _batteryManager = BatteryManager();
  final _certificateManager = CertificateManager();
  final _displayManager = DisplayManager();
  final _networkManager = NetworkManager();
  final _otherSettingsManager = OtherSettingsManager();
  final _restrictionManager = RestrictionManager();
  final _securityManager = SecurityManager();
  final _storageManager = StorageManager();
  final _systemSettingsManager = SystemSettingsManager();

  Future<T> _timed<T>(String label, Future<T> Function() task) async {
    final sw = Stopwatch()..start();
    try {
      return await task();
    } finally {
      sw.stop();
      WLog.i(_tag, 'collect[$label] ${sw.elapsedMilliseconds}ms');
    }
  }

  Future<Map<String, dynamic>> collectAllData() async {
    WLog.i(_tag, 'Collecting all data...');
    await bs.init();

    final stopwatch = Stopwatch()..start();

    final results = await Future.wait([
      _timed('device', getDeviceInfo),
      _timed('mdmApp', _getMdmAppInfo),
      _timed('apps', _appManager.getData),
      _timed('audio', _audioManager.getData),
      _timed('battery', _batteryManager.getData),
      _timed('certificates', _certificateManager.getData),
      _timed('display', _displayManager.getData),
      _timed('network', _networkManager.getData),
      _timed('restrictions', _restrictionManager.getData),
      _timed('security', _securityManager.getData),
      _timed('storage', _storageManager.getData),
      _timed('systemSettings', _systemSettingsManager.getData),
      _timed('otherSettings', _otherSettingsManager.getData),
      _timed('identity', () async => DeviceIdentityHelper.getDeviceId()),
    ]);

    stopwatch.stop();
    WLog.i(_tag, 'Data collected (${stopwatch.elapsedMilliseconds}ms)');

    final otherData = results[12] as Map<String, dynamic>;

    // Secrets such as tokens, the enrollment key and the command log are kept out of sync.
    final stData = SyncStorageFilter.secureStorage(st.getAllData());
    final bsData = SyncStorageFilter.basicStorage(bs.getAllData());

    return {
      'collectedAt': DateTime.now().toUtc().toIso8601String(),
      'device_uuid': results[13],
      'policy_version': st.getInt(Sk.lastPolicyVersion.name),
      'st': stData,
      'bs': bsData,
      'device': results[0],
      'mdmApp': results[1],
      'apps': results[2],
      'audio': results[3],
      'battery': results[4],
      'certificates': results[5],
      'display': results[6],
      'network': results[7],
      'restrictions': results[8],
      'security': results[9],
      'storage': results[10],
      'systemSettings': results[11],
      'otherSettings': otherData,
    };
  }

  static Future<Map<String, dynamic>> getDeviceInfo() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;

      return {
        'manufacturer': androidInfo.manufacturer,
        'model': androidInfo.model,
        'brand': androidInfo.brand,
        'device': androidInfo.device,
        'product': androidInfo.product,
        'board': androidInfo.board,
        'hardware': androidInfo.hardware,
        'host': androidInfo.host,
        'bootloader': androidInfo.bootloader,
        'display': androidInfo.display,
        'fingerprint': androidInfo.fingerprint,
        'id': androidInfo.id,
        'tags': androidInfo.tags,
        'type': androidInfo.type,
        'version': {
          'release': androidInfo.version.release,
          'sdkInt': androidInfo.version.sdkInt,
          'codename': androidInfo.version.codename,
          'baseOS': androidInfo.version.baseOS,
          'incremental': androidInfo.version.incremental,
          'previewSdkInt': androidInfo.version.previewSdkInt,
          'securityPatch': androidInfo.version.securityPatch,
        },
        'supportedAbis': androidInfo.supportedAbis,
        'supported32BitAbis': androidInfo.supported32BitAbis,
        'supported64BitAbis': androidInfo.supported64BitAbis,
        'isPhysicalDevice': androidInfo.isPhysicalDevice,
        'isLowRamDevice': androidInfo.isLowRamDevice,
        'systemFeatures': androidInfo.systemFeatures,
      };
    } catch (e, st) {
      WLog.e(_tag, 'Failed to get device info', error: e, stackTrace: st);
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> _getMdmAppInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();

      return {
        'appName': packageInfo.appName,
        'packageName': packageInfo.packageName,
        'version': packageInfo.version,
        'buildNumber': packageInfo.buildNumber,
        'buildSignature': packageInfo.buildSignature,
        'installerStore': packageInfo.installerStore,
      };
    } catch (e, st) {
      WLog.e(_tag, 'Failed to get MDM app info', error: e, stackTrace: st);
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> collectQuickStatus() async {
    final results = await Future.wait([
      _batteryManager.getData(),
      _networkManager.getData(),
      _storageManager.getData(),
      _securityManager.getData(),
    ]);

    return {
      'collectedAt': DateTime.now().toUtc().toIso8601String(),
      'battery': results[0],
      'network': results[1],
      'storage': results[2],
      'security': results[3],
    };
  }

  Future<Map<String, dynamic>> collectSelectedData(List<String> managerNames) async {
    final data = <String, dynamic>{'collectedAt': DateTime.now().toUtc().toIso8601String()};

    for (final name in managerNames) {
      switch (name.toLowerCase()) {
        case 'device':
          data['device'] = await getDeviceInfo();
          break;
        case 'apps':
          data['apps'] = await _appManager.getData();
          break;
        case 'mdmapp':
          data['mdmApp'] = await _getMdmAppInfo();
          break;
        case 'audio':
          data['audio'] = await _audioManager.getData();
          break;
        case 'battery':
          data['battery'] = await _batteryManager.getData();
          break;
        case 'certificates':
          data['certificates'] = await _certificateManager.getData();
          break;
        case 'datetime':
          final other = await _otherSettingsManager.getData();
          data['dateTime'] = other['dateTime'];
          break;
        case 'display':
          data['display'] = await _displayManager.getData();
          break;
        case 'network':
          data['network'] = await _networkManager.getData();
          break;
        case 'restrictions':
          data['restrictions'] = await _restrictionManager.getData();
          break;
        case 'security':
          data['security'] = await _securityManager.getData();
          break;
        case 'storage':
          data['storage'] = await _storageManager.getData();
          break;
        case 'systemsettings':
          data['systemSettings'] = await _systemSettingsManager.getData();
          break;
        case 'identity':
          data['device_uuid'] = DeviceIdentityHelper.getDeviceId();
          break;
        case 'othersettings':
          data['otherSettings'] = await _otherSettingsManager.getData();
          break;
      }
    }

    data['device_uuid'] = DeviceIdentityHelper.getDeviceId();

    return data;
  }
}