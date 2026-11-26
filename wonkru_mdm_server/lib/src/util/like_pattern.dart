library;

/// `%`, `_`, and `\` are special in PostgreSQL `LIKE`; unescaped, a `_` search
/// matches any character and `%` matches every row. The user's text is matched
/// literally.
String likeContains(String term) {
  final escaped = term
      .replaceAll(r'\', r'\\')
      .replaceAll('%', r'\%')
      .replaceAll('_', r'\_');
  return '%$escaped%';
}
