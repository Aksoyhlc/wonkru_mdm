import 'package:flutter/material.dart';

import 'wonkru_colors.dart';

class WonkruText {
  WonkruText._();

  static TextStyle display(double size, {Color? color}) => TextStyle(
        fontFamily: 'BebasNeue',
        fontSize: size,
        color: color ?? WonkruColors.cream,
        letterSpacing: size * 0.025,
        height: 1.0,
      );

  static TextStyle body(double size, {Color? color, FontWeight weight = FontWeight.w300}) => TextStyle(
        fontFamily: 'DMSans',
        fontSize: size,
        color: color ?? WonkruColors.cream,
        fontWeight: weight,
        height: 1.7,
      );

  static TextStyle mono(double size, {Color? color, double spacing = 0.04}) => TextStyle(
        fontFamily: 'DMMono',
        fontSize: size,
        color: color ?? WonkruColors.grayLight,
        letterSpacing: size * spacing,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );
}