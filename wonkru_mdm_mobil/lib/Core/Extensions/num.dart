import 'package:flutter/cupertino.dart';

extension NumExtension on num {
  Widget get hh => SizedBox(height: toDouble());

  Widget get ww => SizedBox(width: toDouble());
}
