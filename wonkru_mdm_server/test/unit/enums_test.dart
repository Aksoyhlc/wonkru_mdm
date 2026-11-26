import 'package:test/test.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';

/// Pins the wire values of app-specific enums.
///
/// All are `serialized: byName`, and the names are persisted in the database.
/// Renaming or reordering one must fail here and requires a data repair.
/// Serverpod owns the generated `fromJson`/`toJson` round-trip, which is not
/// tested here.
void main() {
  final wireValues = <String, (List<Enum>, List<String>)>{
    'AdminAccountStatus': (AdminAccountStatus.values, ['active', 'disabled']),
    'SmtpEncryption': (SmtpEncryption.values, ['none', 'tls', 'ssl']),
    'StorageDisk': (StorageDisk.values, ['private', 'public']),
    'PanelTheme': (PanelTheme.values, ['light', 'dark', 'system']),
    'AppSourceType': (
      AppSourceType.values,
      ['apk', 'play_store', 'app_store', 'other'],
    ),
  };

  for (final MapEntry(key: name, value: (values, expected))
      in wireValues.entries) {
    test('$name wire values do not change', () {
      expect(values.map((value) => value.name), expected);
    });
  }
}
