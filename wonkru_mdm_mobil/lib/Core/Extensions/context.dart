import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  Future to(Widget widget, [String? name]) {
    return Navigator.push(this, redirect(widget, name));
  }

  Future toReplace(Widget widget, [String? name]) {
    return Navigator.pushReplacement(this, redirect(widget, name));
  }

  Future toRemove(Widget widget) {
    return Navigator.pushAndRemoveUntil(
        this, redirect(widget, ""), (route) => false);
  }

  void back() {
    return Navigator.pop(this);
  }

  MaterialPageRoute<dynamic> redirect(Widget widget, String? name) =>
      MaterialPageRoute(
          builder: (context) => widget, settings: RouteSettings(name: name));
}