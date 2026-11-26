import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/Core/Native/Generated/system_notification_api.g.dart',
    dartOptions: DartOptions(),
    kotlinOut: 'android/app/src/main/kotlin/com/wonkrumdm/api/SystemNotificationApi.g.kt',
    kotlinOptions: KotlinOptions(package: 'com.wonkrumdm.api.system_notification'),
  ),
)
@HostApi()
abstract class SystemNotificationAPI {
  @async
  void showNotification({
    required String title,
    required String message,
    String? priority,
    bool playSound = true,
    bool vibrate = true,
  });
}