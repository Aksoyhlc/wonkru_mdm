import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart' hide LogLevel;

import '../catalog/device_action_metadata.dart';
import '../catalog/restriction_catalog.dart';
import '../generated/protocol.dart';

class CoreEndpoint extends Endpoint {
  /// The public catalog carries no secrets, so no login is required.
  @override
  bool get requireLogin => false;

  Future<ProtocolCatalog> catalogs(Session session) async => buildCatalog();

  /// Returned by [catalogs]; separate so the module's table-less models can be
  /// tested without `withServerpod` (embedded database).
  @visibleForTesting
  static ProtocolCatalog buildCatalog() => ProtocolCatalog(
    restrictions: RestrictionCatalog.all,
    deviceActions: DeviceActionMetadata.all,
    enumValues: _enumValues,
  );

  /// Shared enum name → ordered wire values. Every enum is `serialized: byName`,
  /// so the wire value is the case name; the order follows the enum declaration
  /// so the panel's option lists stay aligned with the server.
  static final Map<String, List<String>> _enumValues =
      Map<String, List<String>>.unmodifiable(<String, List<String>>{
        'DeviceAction': _wireValues(DeviceAction.values),
        'DeviceCommandStatus': _wireValues(DeviceCommandStatus.values),
        'DeviceReportType': _wireValues(DeviceReportType.values),
        'LogLevel': _wireValues(LogLevel.values),
        'NotificationType': _wireValues(NotificationType.values),
        'NotificationDeliveryStatus': _wireValues(
          NotificationDeliveryStatus.values,
        ),
        'CertificateAction': _wireValues(CertificateAction.values),
        'CertificateType': _wireValues(CertificateType.values),
        'CertificateFormat': _wireValues(CertificateFormat.values),
        'FileOperationType': _wireValues(FileOperationType.values),
        'PolicyApplicationAction': _wireValues(PolicyApplicationAction.values),
        'AppAutoUpdatePolicy': _wireValues(AppAutoUpdatePolicy.values),
        'PermissionPolicy': _wireValues(PermissionPolicy.values),
      });

  static List<String> _wireValues(Iterable<Enum> values) =>
      List<String>.unmodifiable(values.map((value) => value.name));
}
