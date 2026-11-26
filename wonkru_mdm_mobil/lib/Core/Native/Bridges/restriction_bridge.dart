import 'package:wonkrumdm/Core/Native/Bridges/base_bridge.dart';
import 'package:wonkrumdm/Core/Native/Generated/restriction_api.g.dart';

class RestrictionBridge extends BaseBridge {
  static final RestrictionBridge _instance = RestrictionBridge._internal();
  factory RestrictionBridge() => _instance;
  RestrictionBridge._internal();

  final _api = RestrictionAPI();

  @override
  String get bridgeName => "RestrictionBridge";

  Future<bool> setBulk(Map<String?, bool?> restrictions) async {
    final (success, _) = await mdmResultSafeCall<Object>(
      () async => await _api.setBulkRestrictions(restrictions),
      logMessage: "$bridgeName: Bulk restrictions applied.",
    );
    return success;
  }

  Future<bool> setRestriction(String key, bool enabled) async {
    final (success, _) = await mdmResultSafeCall<Object>(
      () async => await _api.setRestriction(key, enabled),
      logMessage: "$bridgeName: Single restriction applied.",
    );
    return success;
  }

  Future<bool> isRestrictionActive(String key) async {
    final (success, data) = await mdmResultSafeCall<bool>(
      () async => await _api.isRestrictionActive(key),
      logMessage: "$bridgeName: Restriction status ($key) checked.",
    );
    return (success && data == true);
  }
}
