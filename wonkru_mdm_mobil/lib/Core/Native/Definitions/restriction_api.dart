import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/Core/Native/Generated/restriction_api.g.dart',
    dartOptions: DartOptions(),
    kotlinOut: 'android/app/src/main/kotlin/com/wonkrumdm/api/RestrictionAPI.g.kt',
    kotlinOptions: KotlinOptions(package: 'com.wonkrumdm.api.restriction'),
  ),
)
@HostApi()
abstract class RestrictionAPI {
  Map<String, Object?> setRestriction(String key, bool enabled);

  Map<String, Object?> setBulkRestrictions(Map<String?, bool?> restrictions);

  Map<String, Object?> isRestrictionActive(String key);
}