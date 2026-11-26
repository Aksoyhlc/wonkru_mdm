import 'package:wonkrumdm/Core/Mixins/safe_executor.dart';
import 'package:wonkrumdm/Core/Utils/storage_helper.dart';

abstract class BaseLocalDataSource with SafeExecutor {
  final st = StorageHelper.instance;
}