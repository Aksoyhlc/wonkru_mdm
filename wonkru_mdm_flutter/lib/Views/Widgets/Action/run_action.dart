import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../Core/Constants/Enums/alert_enums.dart';
import '../../../Core/Errors/server_error_message.dart';
import '../../../Core/L10n/L.dart';
import '../Alert/app_toast.dart';
import '../Dialog/confirm_dialog.dart';

/// With [context], toasts are skipped once it is unmounted.
Future<bool> runAction(
  Future<void> Function() action, {
  String? success,
  String? failure,
  BuildContext? context,
}) async {
  bool visible() => context == null || context.mounted;

  try {
    await action();
    if (success != null && visible()) {
      AppToast.show(success, tone: UiAlertTone.success);
    }
    return true;
  } catch (e) {
    if (visible()) {
      AppToast.show(
        (failure ?? L.common.operationFailed).trParams({
          'error': serverErrorMessage(e),
        }),
        tone: UiAlertTone.danger,
      );
    }
    return false;
  }
}

Future<bool> confirmAndRun(
  BuildContext context, {
  String? title,
  required String message,
  required Future<void> Function() action,
  String? success,
  String? failure,
}) async {
  final confirmed = await confirmDialog(
    context: context,
    title: title,
    message: message,
  );
  if (confirmed != true) return false;

  return runAction(action, success: success, failure: failure);
}
