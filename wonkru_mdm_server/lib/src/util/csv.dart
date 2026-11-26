library;

import 'dart:convert';
import 'dart:typed_data';

final _formulaPrefix = RegExp(r'^[=+\-@\t\r]');

/// Prevents CSV/formula injection: a value starting with `=`, `+`, `-`, `@`
/// (or tab/CR) that is not a number gets a leading `'`, otherwise Excel and
/// LibreOffice would execute it as a formula. Device-supplied names and log
/// messages are attacker-controlled.
String csvCell(String value) {
  var cell = value;
  if (_formulaPrefix.hasMatch(cell) && num.tryParse(cell) == null) {
    cell = "'$cell";
  }

  if (cell.contains(',') ||
      cell.contains('"') ||
      cell.contains('\n') ||
      cell.contains('\r')) {
    return '"${cell.replaceAll('"', '""')}"';
  }

  return cell;
}

/// Builds a CSV document: a header row followed by one row per [rows], every
/// cell escaped with [csvCell]. Lines end with `\n`.
String csvDocument(Iterable<String> headers, Iterable<Iterable<String>> rows) {
  final buffer = StringBuffer()..writeln(headers.map(csvCell).join(','));
  for (final row in rows) {
    buffer.writeln(row.map(csvCell).join(','));
  }
  return buffer.toString();
}

/// UTF-8 encodes [csv] as a binary body for an endpoint response.
ByteData csvBytes(String csv) =>
    ByteData.sublistView(Uint8List.fromList(utf8.encode(csv)));
