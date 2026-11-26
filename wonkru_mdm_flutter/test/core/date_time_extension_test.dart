import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:wonkru_mdm_flutter/Core/Extensions/datetime.dart';
import 'package:wonkru_mdm_flutter/Core/Time/app_time.dart';

void main() {
  tzdata.initializeTimeZones();

  setUp(() => AppTime.instance.set(null));

  test('time is shown in the configured zone', () {
    AppTime.instance.set('Europe/Istanbul');

    expect(
      DateTime.utc(2026, 9, 25, 19, 40).formatDateTime(),
      '25.09.2026 22:40',
    );
    expect(DateTime.utc(2026, 9, 25, 19, 40).formatTime(), '22:40');
  });

  test('UTC is shown when no zone is set', () {
    expect(
      DateTime.utc(2026, 9, 25, 19, 40).formatDateTime(),
      '25.09.2026 19:40',
    );
  });

  test('second and date formats also follow the zone', () {
    AppTime.instance.set('Europe/Istanbul');

    expect(
      DateTime.utc(
        2026,
        9,
        25,
        19,
        40,
        7,
      ).formatDateTime('dd.MM.yyyy HH:mm:ss'),
      '25.09.2026 22:40:07',
    );
    expect(DateTime.utc(2026, 9, 25, 19, 40).formatDate(), '25.09.2026');
  });

  test('the zone can shift the day', () {
    AppTime.instance.set('Europe/Istanbul');

    expect(DateTime.utc(2026, 9, 25, 22, 30).formatDate(), '26.09.2026');
  });
}
