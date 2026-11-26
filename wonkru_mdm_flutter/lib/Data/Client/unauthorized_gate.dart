import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

class UnauthorizedGate {
  bool _busy = false;

  bool get isBusy => _busy;

  Future<void> handle(Object error, Future<void> Function()? handler) async {
    if (handler == null || _busy || !isUnauthorized(error)) return;

    _busy = true;
    try {
      await handler();
    } finally {
      _busy = false;
    }
  }

  static bool isUnauthorized(Object error) =>
      error is ServerpodClientUnauthorized || error is ServerpodClientForbidden;
}
