import 'package:wonkrumdm/Core/Utils/file_cache.dart';

extension FileCacheExt on String {
  Future<String?> cached({Duration? cacheDuration}) async {
    if (cacheDuration != null) {
      FileCache.instance.cacheDuration = cacheDuration;
    }
    return await FileCache.instance.downloadAndCache(this);
  }

  Future<String?> get cachedPath async {
    return await FileCache.instance.getCachedPath(this);
  }
}
