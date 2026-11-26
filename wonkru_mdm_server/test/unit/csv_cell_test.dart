import 'package:test/test.dart';
import 'package:wonkru_mdm_server/src/util/csv.dart';

void main() {
  group('csvCell', () {
    test('a plain value is left as-is', () {
      expect(csvCell('Tablet 7'), 'Tablet 7');
      expect(csvCell(''), '');
    });

    test('a value containing a separator, quote, or newline is quoted', () {
      expect(csvCell('a,b'), '"a,b"');
      expect(csvCell('say "hello"'), '"say ""hello"""');
      expect(csvCell('two\nlines'), '"two\nlines"');
    });

    test('text that starts like a formula does not execute in a spreadsheet', () {
      // A device-supplied app name or log message must not turn a cell into a
      // formula.
      for (final hostile in [
        '=HYPERLINK("http://x","click")',
        '+1+cmd|calc',
        '-2+3',
        '@SUM(A1)',
        '\tsecret',
      ]) {
        expect(
          csvCell(hostile),
          anyOf(startsWith("'"), startsWith('"\'')),
          reason: hostile,
        );
      }
      expect(csvCell('=1,2'), '"\'=1,2"');
    });

    test('negative or signed numbers stay as numbers', () {
      expect(csvCell('-12'), '-12');
      expect(csvCell('-0.5'), '-0.5');
      expect(csvCell('+7'), '+7');
    });
  });
}
