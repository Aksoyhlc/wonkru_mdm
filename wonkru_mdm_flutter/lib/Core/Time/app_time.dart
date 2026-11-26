import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

/// Single zone per install ([set]), not per user. Timestamps are carried as
/// UTC instants everywhere and converted to this zone only while formatting
/// ([format]). When unset, UTC is shown ([isConfigured] false) and the panel
/// warns.
///
/// No fixed offset: DST comes from the zone name, so the value is an IANA
/// name (`Europe/Istanbul`).
///
/// `initializeTimeZones()` must be called before the app renders.
class AppTime {
  AppTime._();

  static final AppTime instance = AppTime._();

  tz.Location? _zone;

  final zoneName = RxnString();

  /// Reads the [`zoneName`] observable so `Obx` rebuilds; reading `_zone`
  /// directly would leave `Obx` without an observable.
  bool get isConfigured => zoneName.value != null;

  tz.Location? get zone => _zone;

  void set(String? name) {
    final trimmed = name?.trim();
    final resolved = trimmed == null || trimmed.isEmpty ? null : tz.timeZoneDatabase.locations[trimmed];

    _zone = resolved;
    zoneName.value = resolved == null ? null : trimmed;
  }

  DateTime inZone(DateTime instant) => _zone == null ? instant.toUtc() : tz.TZDateTime.from(instant, _zone!);

  String format(DateTime instant, String pattern, {String? locale}) =>
      DateFormat(pattern, locale).format(inZone(instant));

  /// ~600 IANA names sorted once and cached, so they are not re-sorted on
  /// every build.
  static List<String> get zoneNames => _zoneNames ??= (tz.timeZoneDatabase.locations.keys.toList()..sort());

  static List<String>? _zoneNames;

  String get label {
    if (_zone == null) return 'UTC';

    final offset = inZone(DateTime.now()).timeZoneOffset;
    final sign = offset.isNegative ? '-' : '+';
    final hours = offset.inHours.abs().toString().padLeft(2, '0');
    final minutes = (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');

    return minutes == '00' ? 'UTC$sign$hours' : 'UTC$sign$hours:$minutes';
  }
}
