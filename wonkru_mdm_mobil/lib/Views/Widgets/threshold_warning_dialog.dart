import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wonkrumdm/Core/L10n/L.dart';
import 'package:wonkrumdm/Core/Theme/wonkru_theme.dart';
import 'package:wonkrumdm/Core/Extensions/num.dart';

class ThresholdWarningDialog extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color color;
  final String buttonText;

  ThresholdWarningDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.icon,
    required this.color,
    String? buttonText,
  })  : buttonText = buttonText ?? L.ok_button,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: WonkruColors.bg2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 48, color: color),
              ),
              20.hh,
              Text(
                title,
                textAlign: TextAlign.center,
                style: WonkruText.body(22, color: WonkruColors.cream, weight: FontWeight.bold),
              ),
              12.hh,
              Text(
                message,
                textAlign: TextAlign.center,
                style: WonkruText.body(16, color: WonkruColors.creamDim, weight: FontWeight.w300).copyWith(height: 1.5),
              ),
              32.hh,
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: WonkruColors.cream,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    buttonText,
                    style: WonkruText.body(16, color: WonkruColors.bg, weight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showThresholdWarning({
  required String title,
  required String message,
  required IconData icon,
  required Color color,
}) {
  Get.dialog(
    ThresholdWarningDialog(
      title: title,
      message: message,
      icon: icon,
      color: color,
    ),
    barrierDismissible: false,
  );
}