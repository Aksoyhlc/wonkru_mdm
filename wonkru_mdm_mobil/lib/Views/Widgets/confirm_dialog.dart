import 'package:flutter/material.dart';
import 'package:wonkrumdm/Core/Extensions/num.dart';
import 'package:wonkrumdm/Core/L10n/L.dart';
import 'package:wonkrumdm/Core/Theme/wonkru_theme.dart';

Future<bool?> confirmDialog({
  required BuildContext context,
  required String message,
  Widget? content,
  Function()? onConfirm,
  bool cancelShow = true,
  String cancelText = "",
  String confirmText = "",
}) async {
  if (cancelText.isEmpty) cancelText = L.no;
  if (confirmText.isEmpty) confirmText = L.yes;
  return await showDialog<bool>(
    context: context,
    builder: (context) {
      return Material(
        color: Colors.transparent,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.35),
                          offset: const Offset(0, 8),
                          blurRadius: 24,
                        ),
                      ],
                      color: WonkruColors.bg2,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        content ??
                            Text(
                              message,
                              style: WonkruText.body(15, color: Colors.white).copyWith(height: 1.35),
                              textAlign: TextAlign.center,
                            ),
                        10.hh,
                        Row(
                          mainAxisAlignment: cancelShow ? MainAxisAlignment.center : MainAxisAlignment.end,
                          children: [
                            if (cancelShow)
                              Expanded(
                                child: InkWell(
                                  onTap: () => Navigator.pop(context),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(color: WonkruColors.accent),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                                    margin: const EdgeInsets.only(top: 10, left: 10),
                                    child: Center(
                                      child: Text(
                                        cancelText,
                                        style: WonkruText.body(16, color: WonkruColors.accent),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            if (cancelShow) 20.ww,
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context, true);
                                  onConfirm?.call();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: WonkruColors.accent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                                  margin: const EdgeInsets.only(top: 10, left: 10),
                                  child: Center(
                                    child: Text(
                                      confirmText,
                                      style: WonkruText.body(16, color: WonkruColors.bg, weight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}