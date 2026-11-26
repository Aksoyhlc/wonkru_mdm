import 'package:flutter_test/flutter_test.dart';
import 'package:wonkrumdm/Core/Managers/config_manager.dart';
import 'package:wonkrumdm/Data/Models/Features/config.dart';

/// Ranges are built from the current time so the suite stays green at any hour
/// while still covering the midnight wrap branch.
void main() {
  group('isWithinActiveTimeRange', () {
    test('an empty or null range always counts as active', () {
      expect(ConfigManager.isWithinActiveTimeRange(null), isTrue);
      expect(ConfigManager.isWithinActiveTimeRange(<String, String>{}), isTrue);
    });

    test('a time outside the range counts as inactive', () {
      final window = _outsideWindow();
      expect(ConfigManager.isWithinActiveTimeRange(window), isFalse);
    });

    test('a time inside the range counts as active', () {
      final range = _rangeContainingNow();
      expect(ConfigManager.isWithinActiveTimeRange(range), isTrue);
    });

    test('a range crossing midnight (22:00-06:00) is active only at night', () {
      final now = DateTime.now();
      final expected = now.hour >= 22 || now.hour < 6;
      expect(
        ConfigManager.isWithinActiveTimeRange(const {'22:00': '06:00'}),
        expected,
      );
    });

    test('a range crossing midnight and covering now is active', () {
      // End <= start selects the wrap branch, which keeps the current time inside.
      final now = DateTime.now();
      final range = {_hhmm(now.hour * 60 + now.minute): '00:00'};
      expect(ConfigManager.isWithinActiveTimeRange(range), isTrue);
    });

    test('an invalidly formatted range is ignored', () {
      expect(
        ConfigManager.isWithinActiveTimeRange(const {'bad': '04:00'}),
        isFalse,
      );
    });
  });

  group('isConfigActive', () {
    test('a null config is inactive', () {
      expect(ConfigManager.isConfigActive(null), isFalse);
    });

    test('a policy with isActive false is inactive', () {
      expect(
        ConfigManager.isConfigActive(DeviceConfig(isActive: false)),
        isFalse,
      );
    });

    test('isActive true and an empty range is active', () {
      expect(
        ConfigManager.isConfigActive(DeviceConfig(isActive: true)),
        isTrue,
      );
    });

    test('isActive true but a policy outside the range is inactive', () {
      final config = DeviceConfig(
        isActive: true,
        activeTimeRanges: _outsideWindow(),
      );
      expect(ConfigManager.isConfigActive(config), isFalse);
    });

    test('isActive true and a range covering now is active', () {
      final config = DeviceConfig(
        isActive: true,
        activeTimeRanges: _rangeContainingNow(),
      );
      expect(ConfigManager.isConfigActive(config), isTrue);
    });
  });
}

Map<String, String> _outsideWindow() {
  final now = DateTime.now();
  return now.hour < 12 ? const {'13:00': '14:00'} : const {'01:00': '02:00'};
}

/// The production predicate uses an exclusive end (`current >= start &&
/// current < end`), and `isWithinActiveTimeRange` reads `DateTime.now()` after
/// the test's `now`; the drift is forward-only, so the upper bound is shifted
/// two minutes ahead (`[now-1, now+2)`) to avoid falling outside the range at a
/// minute boundary. Bounds wrap mod 1440 inside `_hhmm`.
Map<String, String> _rangeContainingNow() {
  final now = DateTime.now();
  final nowMinutes = now.hour * 60 + now.minute;
  return {_hhmm(nowMinutes - 1): _hhmm(nowMinutes + 2)};
}

String _hhmm(int minutes) {
  final m = minutes % 1440;
  return '${(m ~/ 60).toString().padLeft(2, '0')}:'
      '${(m % 60).toString().padLeft(2, '0')}';
}
