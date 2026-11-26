import 'dart:async';

import 'package:wonkrumdm/Core/Logging/wlog.dart';
import 'package:wonkrumdm/Core/Native/Generated/app_api.g.dart';

const String _tag = 'AppEventHandler';

class AppEventHandler extends AppEventApi {
  final _installResultController = StreamController<InstallResult>.broadcast();
  final _appStatusController = StreamController<AppStatusChange>.broadcast();

  final Map<String, Completer<bool>> _pendingInstallCompleters = {};

  Stream<InstallResult> get installResultStream => _installResultController.stream;
  Stream<AppStatusChange> get appStatusStream => _appStatusController.stream;

  void registerPendingInstall(String packageName, Completer<bool> completer) {
    _pendingInstallCompleters[packageName] = completer;
  }

  void unregisterPendingInstall(String packageName) {
    _pendingInstallCompleters.remove(packageName);
  }

  @override
  void onAppStatusChanged(String packageName, String eventType) {
    WLog.i(_tag, "Native Event: $packageName -> $eventType");
    _appStatusController.add(AppStatusChange(packageName: packageName, eventType: eventType));
  }

  @override
  void onInstallResult(String packageName, bool success, String message) {
    WLog.i(_tag, "Install result: $packageName -> ${success ? 'Success' : 'Error'} ($message)");
    final completer = _pendingInstallCompleters.remove(packageName);
    if (completer != null && !completer.isCompleted) {
      completer.complete(success);
    }
    _installResultController.add(InstallResult(packageName: packageName, success: success, message: message));
  }

  void dispose() {
    _installResultController.close();
    _appStatusController.close();
  }
}

class InstallResult {
  final String packageName;
  final bool success;
  final String message;

  InstallResult({required this.packageName, required this.success, required this.message});
}

class AppStatusChange {
  final String packageName;
  final String eventType;

  AppStatusChange({required this.packageName, required this.eventType});
}