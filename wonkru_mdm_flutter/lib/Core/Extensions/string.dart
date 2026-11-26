import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension StringExtension on String? {
  bool get isNullOrEmpty =>
      this == null || this!.isEmpty || this == "null" || this == "NULL";

  int toInt() {
    int? parse = int.tryParse(this ?? "");
    return parse ?? 0;
  }

  bool get isNotNullOrEmpty => !isNullOrEmpty;
  Color get color {
    try {
      var hexColor = (this ?? "").toUpperCase().replaceAll("#", "");
      if (hexColor.length == 6) {
        hexColor = "FF$hexColor";
      }

      return Color(int.parse(hexColor, radix: 16));
    } catch (e) {
      return Colors.transparent;
    }
  }

  String get fileExtension {
    var list = (this ?? "").trim().split(".");
    var last = list.isEmpty ? "" : list.last;
    if (last.contains("?")) {
      last = last.split("?").first;
    }
    return last;
  }

  String short({int limit = 99, bool dot = true}) {
    var text = this ?? "";
    if (text.length < limit) {
      return text.substring(0, text.length).replaceAll("\n", " ");
    } else {
      return "${text.substring(0, limit).replaceAll("\n", " ")}${dot ? "..." : ""}";
    }
  }

  void copy() {
    Clipboard.setData(ClipboardData(text: this ?? ""));
  }

  String get toDateTime {
    var a = DateTime.tryParse(this ?? "");
    if (a == null) {
      return "";
    }
    return a.toString().split(".").first;
  }
}
