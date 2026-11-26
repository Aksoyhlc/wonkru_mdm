import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import 'panel_auth_session_manager.dart'
    if (dart.library.js_interop) 'panel_auth_session_manager_web.dart';
import 'unauthorized_gate.dart';

final serverUrl = getServerUrl();

late final Client serverpodClient;

Future<void> Function()? onUnauthorized;

final _unauthorizedGate = UnauthorizedGate();

Future<void> _handleFailedCall(
  MethodCallContext context,
  Object error,
  StackTrace stackTrace,
) => _unauthorizedGate.handle(error, onUnauthorized);

late final Future<void> serverpodSessionRestored;

Future<void> initializeServerpodClient() async {
  serverpodClient = Client(await serverUrl, onFailedCall: _handleFailedCall)
    ..cookieAuth = kIsWeb
    ..connectivityMonitor = FlutterConnectivityMonitor()
    ..authSessionManager = createPanelAuthSessionManager();
  serverpodSessionRestored = _restoreSession();
}

Future<void> _restoreSession() async {
  try {
    await serverpodClient.auth.initialize();
  } catch (_) {}
}
