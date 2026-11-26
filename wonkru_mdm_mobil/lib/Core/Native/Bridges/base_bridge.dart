import 'package:wonkrumdm/Core/Mixins/safe_executor.dart';

abstract class BaseBridge with SafeExecutor {
  String get bridgeName;
}
