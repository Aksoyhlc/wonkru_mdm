import '../../../Core/Constants/Enums/alert_enums.dart';
import '../../../Logic/UI/app_toast_controller.dart';

class AppToast {
  AppToast._();

  static void show(
    String message, {
    UiAlertTone tone = UiAlertTone.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    AppToastController.to.show(message, tone: tone, duration: duration);
  }
}
