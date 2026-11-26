import 'dart:async';

import 'package:get/get.dart';

import '../../Core/Constants/Enums/alert_enums.dart';

class AppToastController extends GetxController {
  static AppToastController get to => Get.find<AppToastController>();

  final message = ''.obs;
  final tone = UiAlertTone.info.obs;
  final visible = false.obs;

  Timer? _timer;

  void show(
    String msg, {
    UiAlertTone tone = UiAlertTone.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    _timer?.cancel();
    message.value = msg;
    this.tone.value = tone;
    visible.value = true;
    _timer = Timer(duration, () => dismiss());
  }

  void dismiss() {
    _timer?.cancel();
    visible.value = false;
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
