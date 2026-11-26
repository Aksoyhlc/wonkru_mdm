import 'package:flutter/material.dart';

/// Motion rules: interaction animations stay at or below [slow] (350ms),
/// except [chart] and the login shake. Entrances use `enter`, exits use
/// `exit`; no bounce/elastic. Only opacity and transform are animated.
class AppMotion {
  const AppMotion._();

  static const Duration fast = Duration(milliseconds: 150);

  static const Duration base = Duration(milliseconds: 220);

  static const Duration slow = Duration(milliseconds: 350);

  static const Duration chart = Duration(milliseconds: 450);

  static const Duration stagger = Duration(milliseconds: 50);

  static const Duration dialog = Duration(milliseconds: 180);
  static const Duration shake = Duration(milliseconds: 360);
  static const Duration bell = Duration(milliseconds: 400);
  static const Duration pulse = Duration(seconds: 2);
  static const Duration shimmer = Duration(milliseconds: 1400);

  static const double distance = 8;
  static const double cardDistance = 12;
  static const double toastDistance = 24;
  static const double hoverLift = 2;
  static const double dialogScale = 0.96;
  static const double badgeScale = 1.2;
  static const double bellRotation = 0.2094395102; // 12 degrees in radians.

  static const Curve enter = Curves.easeOutCubic;

  static const Curve exit = Curves.easeInCubic;

  static bool reduced(BuildContext context) =>
      MediaQuery.disableAnimationsOf(context);

  static Duration of(BuildContext context, Duration duration) =>
      reduced(context) ? Duration.zero : duration;
}
