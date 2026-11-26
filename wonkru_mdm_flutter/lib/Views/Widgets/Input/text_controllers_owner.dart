import 'package:flutter/widgets.dart';

mixin TextControllersOwner<T extends StatefulWidget> on State<T> {
  final _owned = <TextEditingController>[];

  TextEditingController textController([String? text]) {
    final controller = TextEditingController(text: text);
    _owned.add(controller);
    return controller;
  }

  @override
  void dispose() {
    for (final controller in _owned) {
      controller.dispose();
    }
    super.dispose();
  }
}
