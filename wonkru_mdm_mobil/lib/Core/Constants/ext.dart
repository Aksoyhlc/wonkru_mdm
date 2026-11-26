import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wonkrumdm/Core/Theme/wonkru_theme.dart';

import 'Enums/global.dart';

void controllerInjection() {}

void bottomMessage(String message, {String? title, MessageType type = MessageType.error, int seconds = 5}) {
  String tit = "";
  Color backgroundColor = WonkruColors.red;
  Color textColor = WonkruColors.cream;
  if (type == MessageType.success) {
    tit = "Operation Successful";
    backgroundColor = WonkruColors.green;
  } else if (type == MessageType.warning) {
    tit = "Warning";
    backgroundColor = WonkruColors.accent;
  } else if (type == MessageType.error) {
    tit = "Operation Failed";
    backgroundColor = WonkruColors.red;
  } else if (type == MessageType.info) {
    tit = "Information";
    backgroundColor = WonkruColors.grayLight;
  } else {
    tit = "";
    backgroundColor = WonkruColors.bg2;
  }
  if (title != null) tit = title;
  print(message);
  Get.snackbar(
    "",
    "",
    titleText: Text(
      tit,
      style: WonkruText.body(16, color: textColor, weight: FontWeight.bold),
    ),
    snackPosition: SnackPosition.BOTTOM,
    messageText: Text(message, style: WonkruText.body(16, color: textColor)),
    margin: EdgeInsets.only(bottom: 20, right: 10, left: 10),
    backgroundColor: backgroundColor,
    colorText: textColor,
    duration: Duration(seconds: seconds),
  );
}

bool isMobile() {
  if (Platform.isAndroid || Platform.isIOS) {
    return true;
  } else {
    return false;
  }
}

void hideKeyboard() {
  if (isMobile()) {
    FocusManager.instance.primaryFocus?.unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }
}

int parseParamInt(dynamic value, int defaultValue) {
  if (value == null) return defaultValue;
  if (value is int) return value;
  return int.tryParse(value.toString()) ?? defaultValue;
}

Color? parseColor(String? colorHex) {
  if (colorHex == null || colorHex.isEmpty) return null;

  try {
    String hex = colorHex.replaceFirst('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  } catch (_) {
    return null;
  }
}
