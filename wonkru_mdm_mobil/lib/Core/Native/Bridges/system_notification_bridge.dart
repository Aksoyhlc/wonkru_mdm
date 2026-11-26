import 'package:wonkrumdm/Core/Native/Bridges/base_bridge.dart';
import 'package:wonkrumdm/Core/Native/Generated/system_notification_api.g.dart';

class SystemNotificationBridge extends BaseBridge {
  static final SystemNotificationBridge _instance = SystemNotificationBridge._internal();
  factory SystemNotificationBridge() => _instance;
  SystemNotificationBridge._internal();

  final _api = SystemNotificationAPI();

  @override
  String get bridgeName => "SystemNotificationBridge";

  Future<void> showNotification({
    required String title,
    required String message,
    String? priority,
    bool playSound = true,
    bool vibrate = true,
  }) async {
    await safeExecute(
      () async => await _api.showNotification(
        title: title,
        message: message,
        priority: priority,
        playSound: playSound,
        vibrate: vibrate,
      ),
    );
  }
}
