import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../Client/serverpod_client.dart';

/// The catalog is static; the result is cached for the session.
class RestrictionCatalogRepository {
  const RestrictionCatalogRepository._();

  static List<RestrictionCatalogEntry>? _cache;

  /// In-flight request. Concurrent calls share a single network request;
  /// cleared on completion (success or error) so the next call retries.
  static Future<List<RestrictionCatalogEntry>>? _pending;

  static Future<List<RestrictionCatalogEntry>> load() {
    final cached = _cache;
    if (cached != null) {
      return Future<List<RestrictionCatalogEntry>>.value(cached);
    }
    return _pending ??= _fetch();
  }

  static Future<List<RestrictionCatalogEntry>> _fetch() async {
    try {
      final catalog = await serverpodClient.modules.wonkru_core.core.catalogs();
      _cache = catalog.restrictions;
      return catalog.restrictions;
    } finally {
      _pending = null;
    }
  }

  static List<RestrictionCatalogEntry> get cached => _cache ?? const [];

  static void clearCache() {
    _cache = null;
    _pending = null;
  }
}
