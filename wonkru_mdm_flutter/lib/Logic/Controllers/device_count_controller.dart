import 'package:get/get.dart';

import '../../Data/Repositories/dashboard_repository.dart';

/// Cheap cache for the sidebar badge; on failure the badge is simply hidden.
class DeviceCountController extends GetxController {
  final totalDevices = RxnInt();

  bool _loaded = false;
  Future<void>? _pending;

  Future<void> ensureLoaded() {
    if (_loaded) return Future.value();
    return _pending ??= _load().whenComplete(() => _pending = null);
  }

  Future<void> _load() async {
    try {
      final stats = await DashboardRepository.deviceStats();
      totalDevices.value = stats.totalDevices;
      _loaded = true;
    } catch (_) {}
  }
}
