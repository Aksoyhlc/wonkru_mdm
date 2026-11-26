import 'package:wonkrumdm/Core/Utils/storage_helper.dart';

class BaseRepository {
  final st = StorageHelper.instance;

  bool hasValidCache(String key, {int minutes = 60}) {
    final lastTimeStr = st.getString(key);
    if (lastTimeStr == null) return false;

    final lastTime = DateTime.tryParse(lastTimeStr);
    if (lastTime == null) return false;

    final diff = DateTime.now().difference(lastTime);

    return diff.inMinutes < minutes;
  }
}