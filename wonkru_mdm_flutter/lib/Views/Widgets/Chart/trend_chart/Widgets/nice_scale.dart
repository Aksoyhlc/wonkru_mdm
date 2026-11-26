import 'dart:math' as math;

/// Rounds a peak value up to a "nice" axis maximum split into readable ticks.
class NiceScale {
  const NiceScale(this.step, this.ticks);

  final int step;
  final int ticks;

  int get max => step * ticks;

  static const _targetTicks = 4;

  factory NiceScale.of(int peak) {
    if (peak <= _targetTicks) return const NiceScale(1, _targetTicks);

    final raw = peak / _targetTicks;
    final magnitude = math.pow(10, (math.log(raw) / math.ln10).floor()).toInt();
    final residual = raw / magnitude;
    final nice = residual <= 1
        ? 1
        : residual <= 2
        ? 2
        : residual <= 5
        ? 5
        : 10;
    final step = nice * magnitude;
    return NiceScale(step, (peak / step).ceil());
  }
}
