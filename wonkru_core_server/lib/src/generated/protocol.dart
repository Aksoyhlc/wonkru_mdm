/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/protocol.dart' as _isp;
import 'package:serverpod/serverpod.dart' as _is;
import 'catalog/device_action_info.dart' as _ixdbi6ns;
import 'catalog/protocol_catalog.dart' as _i1nmi3vv;
import 'catalog/restriction_catalog_entry.dart' as _imtxgw4b;
import 'device_api/device_config_request.dart' as _i6naazhz;
import 'device_api/device_config_response.dart' as _iwis7jh8;
import 'device_api/device_enrollment_rejected_exception.dart' as _i4584h7a;
import 'device_api/device_file_upload_request.dart' as _iwvtvt2w;
import 'device_api/device_file_upload_response.dart' as _i8w1k6sf;
import 'device_api/device_identity_mismatch_exception.dart' as _i7fbuzd1;
import 'device_api/device_log_entry.dart' as _ity7ns8b;
import 'device_api/device_log_request.dart' as _iygkntpd;
import 'device_api/device_notification_ack_request.dart' as _isnpoa55;
import 'device_api/device_password_check_request.dart' as _i1d789es;
import 'device_api/device_policy_change_request.dart' as _iatb2fxo;
import 'device_api/device_register_request.dart' as _isezr9ni;
import 'device_api/device_register_response.dart' as _ighbnj3w;
import 'device_api/device_report_request.dart' as _i4958h6i;
import 'device_api/device_request_invalid_exception.dart' as _izd6hc1b;
import 'device_api/device_stream_message.dart' as _ivtuvzpv;
import 'device_api/device_sync_request.dart' as _iz27z66x;
import 'device_api/device_sync_response.dart' as _irbo78yl;
import 'device_api/device_unauthenticated_exception.dart' as _i2yac1rh;
import 'device_api/device_version_info.dart' as _i6ssk22y;
import 'enums/app_auto_update_policy.dart' as _i55nrgys;
import 'enums/certificate_action.dart' as _id4i1lsk;
import 'enums/certificate_format.dart' as _ijjp6588;
import 'enums/certificate_type.dart' as _ib1q49f6;
import 'enums/device_action.dart' as _id4nn3q6;
import 'enums/device_command_status.dart' as _ib1qc3xz;
import 'enums/device_report_type.dart' as _ibvghvux;
import 'enums/file_operation_type.dart' as _ialsmhvy;
import 'enums/log_level.dart' as _ismocxf7;
import 'enums/notification_delivery_status.dart' as _iddiyhy2;
import 'enums/notification_type.dart' as _ij5x7qg1;
import 'enums/permission_policy.dart' as _ivt7swit;
import 'enums/policy_application_action.dart' as _immaegpe;
export 'catalog/device_action_info.dart';
export 'catalog/protocol_catalog.dart';
export 'catalog/restriction_catalog_entry.dart';
export 'device_api/device_config_request.dart';
export 'device_api/device_config_response.dart';
export 'device_api/device_enrollment_rejected_exception.dart';
export 'device_api/device_file_upload_request.dart';
export 'device_api/device_file_upload_response.dart';
export 'device_api/device_identity_mismatch_exception.dart';
export 'device_api/device_log_entry.dart';
export 'device_api/device_log_request.dart';
export 'device_api/device_notification_ack_request.dart';
export 'device_api/device_password_check_request.dart';
export 'device_api/device_policy_change_request.dart';
export 'device_api/device_register_request.dart';
export 'device_api/device_register_response.dart';
export 'device_api/device_report_request.dart';
export 'device_api/device_request_invalid_exception.dart';
export 'device_api/device_stream_message.dart';
export 'device_api/device_sync_request.dart';
export 'device_api/device_sync_response.dart';
export 'device_api/device_unauthenticated_exception.dart';
export 'device_api/device_version_info.dart';
export 'enums/app_auto_update_policy.dart';
export 'enums/certificate_action.dart';
export 'enums/certificate_format.dart';
export 'enums/certificate_type.dart';
export 'enums/device_action.dart';
export 'enums/device_command_status.dart';
export 'enums/device_report_type.dart';
export 'enums/file_operation_type.dart';
export 'enums/log_level.dart';
export 'enums/notification_delivery_status.dart';
export 'enums/notification_type.dart';
export 'enums/permission_policy.dart';
export 'enums/policy_application_action.dart';

class Protocol extends _is.DatabaseSerializationManager
    implements _is.DatabaseProtocolDeserializationProvider {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  final Set<_is.SerializationManager> _hostProtocols = {};

  @override
  _is.ProtocolDeserialization get deserializationMetadata =>
      _is.ProtocolDeserialization.cached(
        this,
        types: const [
          _is.getType<_ixdbi6ns.DeviceActionInfo>,
          _is.getType<_i1nmi3vv.ProtocolCatalog>,
          _is.getType<_imtxgw4b.RestrictionCatalogEntry>,
          _is.getType<_i6naazhz.DeviceConfigRequest>,
          _is.getType<_iwis7jh8.DeviceConfigResponse>,
          _is.getType<_i4584h7a.DeviceEnrollmentRejectedException>,
          _is.getType<_iwvtvt2w.DeviceFileUploadRequest>,
          _is.getType<_i8w1k6sf.DeviceFileUploadResponse>,
          _is.getType<_i7fbuzd1.DeviceIdentityMismatchException>,
          _is.getType<_ity7ns8b.DeviceLogEntry>,
          _is.getType<_iygkntpd.DeviceLogRequest>,
          _is.getType<_isnpoa55.DeviceNotificationAckRequest>,
          _is.getType<_i1d789es.DevicePasswordCheckRequest>,
          _is.getType<_iatb2fxo.DevicePolicyChangeRequest>,
          _is.getType<_isezr9ni.DeviceRegisterRequest>,
          _is.getType<_ighbnj3w.DeviceRegisterResponse>,
          _is.getType<_i4958h6i.DeviceReportRequest>,
          _is.getType<_izd6hc1b.DeviceRequestInvalidException>,
          _is.getType<_ivtuvzpv.DeviceStreamMessage>,
          _is.getType<_iz27z66x.DeviceSyncRequest>,
          _is.getType<_irbo78yl.DeviceSyncResponse>,
          _is.getType<_i2yac1rh.DeviceUnauthenticatedException>,
          _is.getType<_i6ssk22y.DeviceVersionInfo>,
          _is.getType<_i55nrgys.AppAutoUpdatePolicy>,
          _is.getType<_id4i1lsk.CertificateAction>,
          _is.getType<_ijjp6588.CertificateFormat>,
          _is.getType<_ib1q49f6.CertificateType>,
          _is.getType<_id4nn3q6.DeviceAction>,
          _is.getType<_ib1qc3xz.DeviceCommandStatus>,
          _is.getType<_ibvghvux.DeviceReportType>,
          _is.getType<_ialsmhvy.FileOperationType>,
          _is.getType<_ismocxf7.LogLevel>,
          _is.getType<_iddiyhy2.NotificationDeliveryStatus>,
          _is.getType<_ij5x7qg1.NotificationType>,
          _is.getType<_ivt7swit.PermissionPolicy>,
          _is.getType<_immaegpe.PolicyApplicationAction>,
          _is.getType<_ixdbi6ns.DeviceActionInfo?>,
          _is.getType<_i1nmi3vv.ProtocolCatalog?>,
          _is.getType<_imtxgw4b.RestrictionCatalogEntry?>,
          _is.getType<_i6naazhz.DeviceConfigRequest?>,
          _is.getType<_iwis7jh8.DeviceConfigResponse?>,
          _is.getType<_i4584h7a.DeviceEnrollmentRejectedException?>,
          _is.getType<_iwvtvt2w.DeviceFileUploadRequest?>,
          _is.getType<_i8w1k6sf.DeviceFileUploadResponse?>,
          _is.getType<_i7fbuzd1.DeviceIdentityMismatchException?>,
          _is.getType<_ity7ns8b.DeviceLogEntry?>,
          _is.getType<_iygkntpd.DeviceLogRequest?>,
          _is.getType<_isnpoa55.DeviceNotificationAckRequest?>,
          _is.getType<_i1d789es.DevicePasswordCheckRequest?>,
          _is.getType<_iatb2fxo.DevicePolicyChangeRequest?>,
          _is.getType<_isezr9ni.DeviceRegisterRequest?>,
          _is.getType<_ighbnj3w.DeviceRegisterResponse?>,
          _is.getType<_i4958h6i.DeviceReportRequest?>,
          _is.getType<_izd6hc1b.DeviceRequestInvalidException?>,
          _is.getType<_ivtuvzpv.DeviceStreamMessage?>,
          _is.getType<_iz27z66x.DeviceSyncRequest?>,
          _is.getType<_irbo78yl.DeviceSyncResponse?>,
          _is.getType<_i2yac1rh.DeviceUnauthenticatedException?>,
          _is.getType<_i6ssk22y.DeviceVersionInfo?>,
          _is.getType<_i55nrgys.AppAutoUpdatePolicy?>,
          _is.getType<_id4i1lsk.CertificateAction?>,
          _is.getType<_ijjp6588.CertificateFormat?>,
          _is.getType<_ib1q49f6.CertificateType?>,
          _is.getType<_id4nn3q6.DeviceAction?>,
          _is.getType<_ib1qc3xz.DeviceCommandStatus?>,
          _is.getType<_ibvghvux.DeviceReportType?>,
          _is.getType<_ialsmhvy.FileOperationType?>,
          _is.getType<_ismocxf7.LogLevel?>,
          _is.getType<_iddiyhy2.NotificationDeliveryStatus?>,
          _is.getType<_ij5x7qg1.NotificationType?>,
          _is.getType<_ivt7swit.PermissionPolicy?>,
          _is.getType<_immaegpe.PolicyApplicationAction?>,
          _is.getType<Map<String, String>>,
          _is.getType<List<_imtxgw4b.RestrictionCatalogEntry>>,
          _is.getType<List<_ixdbi6ns.DeviceActionInfo>>,
          _is.getType<Map<String, List<String>>>,
          _is.getType<List<String>>,
          _is.getType<List<_ity7ns8b.DeviceLogEntry>>,
        ],
        modules: const [_isp.Protocol.new],
        classNames: const [
          'DeviceActionInfo',
          'ProtocolCatalog',
          'RestrictionCatalogEntry',
          'DeviceConfigRequest',
          'DeviceConfigResponse',
          'DeviceEnrollmentRejectedException',
          'DeviceFileUploadRequest',
          'DeviceFileUploadResponse',
          'DeviceIdentityMismatchException',
          'DeviceLogEntry',
          'DeviceLogRequest',
          'DeviceNotificationAckRequest',
          'DevicePasswordCheckRequest',
          'DevicePolicyChangeRequest',
          'DeviceRegisterRequest',
          'DeviceRegisterResponse',
          'DeviceReportRequest',
          'DeviceRequestInvalidException',
          'DeviceStreamMessage',
          'DeviceSyncRequest',
          'DeviceSyncResponse',
          'DeviceUnauthenticatedException',
          'DeviceVersionInfo',
          'AppAutoUpdatePolicy',
          'CertificateAction',
          'CertificateFormat',
          'CertificateType',
          'DeviceAction',
          'DeviceCommandStatus',
          'DeviceReportType',
          'FileOperationType',
          'LogLevel',
          'NotificationDeliveryStatus',
          'NotificationType',
          'PermissionPolicy',
          'PolicyApplicationAction',
        ],
        classNamePrefix: 'wonkru_core.',
      );

  static List<_isp.TableDefinition> get targetTableDefinitions =>
      _ownTableDefinitions;

  static List<_isp.TableDefinition> get _ownTableDefinitions => [];

  void registerHostProtocol(
    String projectName,
    _is.SerializationManager protocol,
  ) {
    _hostProtocols.add(protocol);
  }

  static String? getClassNameFromObjectJson(dynamic data) =>
      _is.ProtocolDeserialization.normalizeClassName(
        _is.ProtocolDeserialization.readClassName(data),
        prefix: 'wonkru_core.',
      );

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    final rawDataClassName = _is.ProtocolDeserialization.readClassName(data);
    final dataClassName = _is.ProtocolDeserialization.normalizeClassName(
      rawDataClassName,
      prefix: 'wonkru_core.',
    );
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _is.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _ixdbi6ns.DeviceActionInfo) {
      return _ixdbi6ns.DeviceActionInfo.fromJson(data) as T;
    }
    if (t == _i1nmi3vv.ProtocolCatalog) {
      return _i1nmi3vv.ProtocolCatalog.fromJson(data) as T;
    }
    if (t == _imtxgw4b.RestrictionCatalogEntry) {
      return _imtxgw4b.RestrictionCatalogEntry.fromJson(data) as T;
    }
    if (t == _i6naazhz.DeviceConfigRequest) {
      return _i6naazhz.DeviceConfigRequest.fromJson(data) as T;
    }
    if (t == _iwis7jh8.DeviceConfigResponse) {
      return _iwis7jh8.DeviceConfigResponse.fromJson(data) as T;
    }
    if (t == _i4584h7a.DeviceEnrollmentRejectedException) {
      return _i4584h7a.DeviceEnrollmentRejectedException.fromJson(data) as T;
    }
    if (t == _iwvtvt2w.DeviceFileUploadRequest) {
      return _iwvtvt2w.DeviceFileUploadRequest.fromJson(data) as T;
    }
    if (t == _i8w1k6sf.DeviceFileUploadResponse) {
      return _i8w1k6sf.DeviceFileUploadResponse.fromJson(data) as T;
    }
    if (t == _i7fbuzd1.DeviceIdentityMismatchException) {
      return _i7fbuzd1.DeviceIdentityMismatchException.fromJson(data) as T;
    }
    if (t == _ity7ns8b.DeviceLogEntry) {
      return _ity7ns8b.DeviceLogEntry.fromJson(data) as T;
    }
    if (t == _iygkntpd.DeviceLogRequest) {
      return _iygkntpd.DeviceLogRequest.fromJson(data) as T;
    }
    if (t == _isnpoa55.DeviceNotificationAckRequest) {
      return _isnpoa55.DeviceNotificationAckRequest.fromJson(data) as T;
    }
    if (t == _i1d789es.DevicePasswordCheckRequest) {
      return _i1d789es.DevicePasswordCheckRequest.fromJson(data) as T;
    }
    if (t == _iatb2fxo.DevicePolicyChangeRequest) {
      return _iatb2fxo.DevicePolicyChangeRequest.fromJson(data) as T;
    }
    if (t == _isezr9ni.DeviceRegisterRequest) {
      return _isezr9ni.DeviceRegisterRequest.fromJson(data) as T;
    }
    if (t == _ighbnj3w.DeviceRegisterResponse) {
      return _ighbnj3w.DeviceRegisterResponse.fromJson(data) as T;
    }
    if (t == _i4958h6i.DeviceReportRequest) {
      return _i4958h6i.DeviceReportRequest.fromJson(data) as T;
    }
    if (t == _izd6hc1b.DeviceRequestInvalidException) {
      return _izd6hc1b.DeviceRequestInvalidException.fromJson(data) as T;
    }
    if (t == _ivtuvzpv.DeviceStreamMessage) {
      return _ivtuvzpv.DeviceStreamMessage.fromJson(data) as T;
    }
    if (t == _iz27z66x.DeviceSyncRequest) {
      return _iz27z66x.DeviceSyncRequest.fromJson(data) as T;
    }
    if (t == _irbo78yl.DeviceSyncResponse) {
      return _irbo78yl.DeviceSyncResponse.fromJson(data) as T;
    }
    if (t == _i2yac1rh.DeviceUnauthenticatedException) {
      return _i2yac1rh.DeviceUnauthenticatedException.fromJson(data) as T;
    }
    if (t == _i6ssk22y.DeviceVersionInfo) {
      return _i6ssk22y.DeviceVersionInfo.fromJson(data) as T;
    }
    if (t == _i55nrgys.AppAutoUpdatePolicy) {
      return _i55nrgys.AppAutoUpdatePolicy.fromJson(data) as T;
    }
    if (t == _id4i1lsk.CertificateAction) {
      return _id4i1lsk.CertificateAction.fromJson(data) as T;
    }
    if (t == _ijjp6588.CertificateFormat) {
      return _ijjp6588.CertificateFormat.fromJson(data) as T;
    }
    if (t == _ib1q49f6.CertificateType) {
      return _ib1q49f6.CertificateType.fromJson(data) as T;
    }
    if (t == _id4nn3q6.DeviceAction) {
      return _id4nn3q6.DeviceAction.fromJson(data) as T;
    }
    if (t == _ib1qc3xz.DeviceCommandStatus) {
      return _ib1qc3xz.DeviceCommandStatus.fromJson(data) as T;
    }
    if (t == _ibvghvux.DeviceReportType) {
      return _ibvghvux.DeviceReportType.fromJson(data) as T;
    }
    if (t == _ialsmhvy.FileOperationType) {
      return _ialsmhvy.FileOperationType.fromJson(data) as T;
    }
    if (t == _ismocxf7.LogLevel) {
      return _ismocxf7.LogLevel.fromJson(data) as T;
    }
    if (t == _iddiyhy2.NotificationDeliveryStatus) {
      return _iddiyhy2.NotificationDeliveryStatus.fromJson(data) as T;
    }
    if (t == _ij5x7qg1.NotificationType) {
      return _ij5x7qg1.NotificationType.fromJson(data) as T;
    }
    if (t == _ivt7swit.PermissionPolicy) {
      return _ivt7swit.PermissionPolicy.fromJson(data) as T;
    }
    if (t == _immaegpe.PolicyApplicationAction) {
      return _immaegpe.PolicyApplicationAction.fromJson(data) as T;
    }
    if (t == _is.getType<_ixdbi6ns.DeviceActionInfo?>()) {
      return (data != null ? _ixdbi6ns.DeviceActionInfo.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i1nmi3vv.ProtocolCatalog?>()) {
      return (data != null ? _i1nmi3vv.ProtocolCatalog.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_imtxgw4b.RestrictionCatalogEntry?>()) {
      return (data != null
              ? _imtxgw4b.RestrictionCatalogEntry.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i6naazhz.DeviceConfigRequest?>()) {
      return (data != null
              ? _i6naazhz.DeviceConfigRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iwis7jh8.DeviceConfigResponse?>()) {
      return (data != null
              ? _iwis7jh8.DeviceConfigResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i4584h7a.DeviceEnrollmentRejectedException?>()) {
      return (data != null
              ? _i4584h7a.DeviceEnrollmentRejectedException.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iwvtvt2w.DeviceFileUploadRequest?>()) {
      return (data != null
              ? _iwvtvt2w.DeviceFileUploadRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i8w1k6sf.DeviceFileUploadResponse?>()) {
      return (data != null
              ? _i8w1k6sf.DeviceFileUploadResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i7fbuzd1.DeviceIdentityMismatchException?>()) {
      return (data != null
              ? _i7fbuzd1.DeviceIdentityMismatchException.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ity7ns8b.DeviceLogEntry?>()) {
      return (data != null ? _ity7ns8b.DeviceLogEntry.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iygkntpd.DeviceLogRequest?>()) {
      return (data != null ? _iygkntpd.DeviceLogRequest.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_isnpoa55.DeviceNotificationAckRequest?>()) {
      return (data != null
              ? _isnpoa55.DeviceNotificationAckRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i1d789es.DevicePasswordCheckRequest?>()) {
      return (data != null
              ? _i1d789es.DevicePasswordCheckRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iatb2fxo.DevicePolicyChangeRequest?>()) {
      return (data != null
              ? _iatb2fxo.DevicePolicyChangeRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_isezr9ni.DeviceRegisterRequest?>()) {
      return (data != null
              ? _isezr9ni.DeviceRegisterRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ighbnj3w.DeviceRegisterResponse?>()) {
      return (data != null
              ? _ighbnj3w.DeviceRegisterResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i4958h6i.DeviceReportRequest?>()) {
      return (data != null
              ? _i4958h6i.DeviceReportRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_izd6hc1b.DeviceRequestInvalidException?>()) {
      return (data != null
              ? _izd6hc1b.DeviceRequestInvalidException.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ivtuvzpv.DeviceStreamMessage?>()) {
      return (data != null
              ? _ivtuvzpv.DeviceStreamMessage.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iz27z66x.DeviceSyncRequest?>()) {
      return (data != null ? _iz27z66x.DeviceSyncRequest.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_irbo78yl.DeviceSyncResponse?>()) {
      return (data != null ? _irbo78yl.DeviceSyncResponse.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i2yac1rh.DeviceUnauthenticatedException?>()) {
      return (data != null
              ? _i2yac1rh.DeviceUnauthenticatedException.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i6ssk22y.DeviceVersionInfo?>()) {
      return (data != null ? _i6ssk22y.DeviceVersionInfo.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i55nrgys.AppAutoUpdatePolicy?>()) {
      return (data != null
              ? _i55nrgys.AppAutoUpdatePolicy.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_id4i1lsk.CertificateAction?>()) {
      return (data != null ? _id4i1lsk.CertificateAction.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ijjp6588.CertificateFormat?>()) {
      return (data != null ? _ijjp6588.CertificateFormat.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ib1q49f6.CertificateType?>()) {
      return (data != null ? _ib1q49f6.CertificateType.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_id4nn3q6.DeviceAction?>()) {
      return (data != null ? _id4nn3q6.DeviceAction.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ib1qc3xz.DeviceCommandStatus?>()) {
      return (data != null
              ? _ib1qc3xz.DeviceCommandStatus.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ibvghvux.DeviceReportType?>()) {
      return (data != null ? _ibvghvux.DeviceReportType.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ialsmhvy.FileOperationType?>()) {
      return (data != null ? _ialsmhvy.FileOperationType.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ismocxf7.LogLevel?>()) {
      return (data != null ? _ismocxf7.LogLevel.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iddiyhy2.NotificationDeliveryStatus?>()) {
      return (data != null
              ? _iddiyhy2.NotificationDeliveryStatus.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ij5x7qg1.NotificationType?>()) {
      return (data != null ? _ij5x7qg1.NotificationType.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ivt7swit.PermissionPolicy?>()) {
      return (data != null ? _ivt7swit.PermissionPolicy.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_immaegpe.PolicyApplicationAction?>()) {
      return (data != null
              ? _immaegpe.PolicyApplicationAction.fromJson(data)
              : null)
          as T;
    }
    if (t == Map<String, String>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<String>(v)),
          )
          as T;
    }
    if (t == List<_imtxgw4b.RestrictionCatalogEntry>) {
      return (data as List)
              .map((e) => deserialize<_imtxgw4b.RestrictionCatalogEntry>(e))
              .toList()
          as T;
    }
    if (t == List<_ixdbi6ns.DeviceActionInfo>) {
      return (data as List)
              .map((e) => deserialize<_ixdbi6ns.DeviceActionInfo>(e))
              .toList()
          as T;
    }
    if (t == Map<String, List<String>>) {
      return (data as Map).map(
            (k, v) =>
                MapEntry(deserialize<String>(k), deserialize<List<String>>(v)),
          )
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_ity7ns8b.DeviceLogEntry>) {
      return (data as List)
              .map((e) => deserialize<_ity7ns8b.DeviceLogEntry>(e))
              .toList()
          as T;
    }
    final modules = deserializationMetadata.modulesForDeserialization(
      t,
      className: rawDataClassName,
    );
    for (final module in modules) {
      try {
        return module.deserialize<T>(data, t);
      } on _is.DeserializationTypeNotFoundException catch (_) {}
    }

    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _ixdbi6ns.DeviceActionInfo => 'DeviceActionInfo',
      _i1nmi3vv.ProtocolCatalog => 'ProtocolCatalog',
      _imtxgw4b.RestrictionCatalogEntry => 'RestrictionCatalogEntry',
      _i6naazhz.DeviceConfigRequest => 'DeviceConfigRequest',
      _iwis7jh8.DeviceConfigResponse => 'DeviceConfigResponse',
      _i4584h7a.DeviceEnrollmentRejectedException =>
        'DeviceEnrollmentRejectedException',
      _iwvtvt2w.DeviceFileUploadRequest => 'DeviceFileUploadRequest',
      _i8w1k6sf.DeviceFileUploadResponse => 'DeviceFileUploadResponse',
      _i7fbuzd1.DeviceIdentityMismatchException =>
        'DeviceIdentityMismatchException',
      _ity7ns8b.DeviceLogEntry => 'DeviceLogEntry',
      _iygkntpd.DeviceLogRequest => 'DeviceLogRequest',
      _isnpoa55.DeviceNotificationAckRequest => 'DeviceNotificationAckRequest',
      _i1d789es.DevicePasswordCheckRequest => 'DevicePasswordCheckRequest',
      _iatb2fxo.DevicePolicyChangeRequest => 'DevicePolicyChangeRequest',
      _isezr9ni.DeviceRegisterRequest => 'DeviceRegisterRequest',
      _ighbnj3w.DeviceRegisterResponse => 'DeviceRegisterResponse',
      _i4958h6i.DeviceReportRequest => 'DeviceReportRequest',
      _izd6hc1b.DeviceRequestInvalidException =>
        'DeviceRequestInvalidException',
      _ivtuvzpv.DeviceStreamMessage => 'DeviceStreamMessage',
      _iz27z66x.DeviceSyncRequest => 'DeviceSyncRequest',
      _irbo78yl.DeviceSyncResponse => 'DeviceSyncResponse',
      _i2yac1rh.DeviceUnauthenticatedException =>
        'DeviceUnauthenticatedException',
      _i6ssk22y.DeviceVersionInfo => 'DeviceVersionInfo',
      _i55nrgys.AppAutoUpdatePolicy => 'AppAutoUpdatePolicy',
      _id4i1lsk.CertificateAction => 'CertificateAction',
      _ijjp6588.CertificateFormat => 'CertificateFormat',
      _ib1q49f6.CertificateType => 'CertificateType',
      _id4nn3q6.DeviceAction => 'DeviceAction',
      _ib1qc3xz.DeviceCommandStatus => 'DeviceCommandStatus',
      _ibvghvux.DeviceReportType => 'DeviceReportType',
      _ialsmhvy.FileOperationType => 'FileOperationType',
      _ismocxf7.LogLevel => 'LogLevel',
      _iddiyhy2.NotificationDeliveryStatus => 'NotificationDeliveryStatus',
      _ij5x7qg1.NotificationType => 'NotificationType',
      _ivt7swit.PermissionPolicy => 'PermissionPolicy',
      _immaegpe.PolicyApplicationAction => 'PolicyApplicationAction',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('wonkru_core.', '');
    }

    switch (data) {
      case _ixdbi6ns.DeviceActionInfo():
        return 'DeviceActionInfo';
      case _i1nmi3vv.ProtocolCatalog():
        return 'ProtocolCatalog';
      case _imtxgw4b.RestrictionCatalogEntry():
        return 'RestrictionCatalogEntry';
      case _i6naazhz.DeviceConfigRequest():
        return 'DeviceConfigRequest';
      case _iwis7jh8.DeviceConfigResponse():
        return 'DeviceConfigResponse';
      case _i4584h7a.DeviceEnrollmentRejectedException():
        return 'DeviceEnrollmentRejectedException';
      case _iwvtvt2w.DeviceFileUploadRequest():
        return 'DeviceFileUploadRequest';
      case _i8w1k6sf.DeviceFileUploadResponse():
        return 'DeviceFileUploadResponse';
      case _i7fbuzd1.DeviceIdentityMismatchException():
        return 'DeviceIdentityMismatchException';
      case _ity7ns8b.DeviceLogEntry():
        return 'DeviceLogEntry';
      case _iygkntpd.DeviceLogRequest():
        return 'DeviceLogRequest';
      case _isnpoa55.DeviceNotificationAckRequest():
        return 'DeviceNotificationAckRequest';
      case _i1d789es.DevicePasswordCheckRequest():
        return 'DevicePasswordCheckRequest';
      case _iatb2fxo.DevicePolicyChangeRequest():
        return 'DevicePolicyChangeRequest';
      case _isezr9ni.DeviceRegisterRequest():
        return 'DeviceRegisterRequest';
      case _ighbnj3w.DeviceRegisterResponse():
        return 'DeviceRegisterResponse';
      case _i4958h6i.DeviceReportRequest():
        return 'DeviceReportRequest';
      case _izd6hc1b.DeviceRequestInvalidException():
        return 'DeviceRequestInvalidException';
      case _ivtuvzpv.DeviceStreamMessage():
        return 'DeviceStreamMessage';
      case _iz27z66x.DeviceSyncRequest():
        return 'DeviceSyncRequest';
      case _irbo78yl.DeviceSyncResponse():
        return 'DeviceSyncResponse';
      case _i2yac1rh.DeviceUnauthenticatedException():
        return 'DeviceUnauthenticatedException';
      case _i6ssk22y.DeviceVersionInfo():
        return 'DeviceVersionInfo';
      case _i55nrgys.AppAutoUpdatePolicy():
        return 'AppAutoUpdatePolicy';
      case _id4i1lsk.CertificateAction():
        return 'CertificateAction';
      case _ijjp6588.CertificateFormat():
        return 'CertificateFormat';
      case _ib1q49f6.CertificateType():
        return 'CertificateType';
      case _id4nn3q6.DeviceAction():
        return 'DeviceAction';
      case _ib1qc3xz.DeviceCommandStatus():
        return 'DeviceCommandStatus';
      case _ibvghvux.DeviceReportType():
        return 'DeviceReportType';
      case _ialsmhvy.FileOperationType():
        return 'FileOperationType';
      case _ismocxf7.LogLevel():
        return 'LogLevel';
      case _iddiyhy2.NotificationDeliveryStatus():
        return 'NotificationDeliveryStatus';
      case _ij5x7qg1.NotificationType():
        return 'NotificationType';
      case _ivt7swit.PermissionPolicy():
        return 'PermissionPolicy';
      case _immaegpe.PolicyApplicationAction():
        return 'PolicyApplicationAction';
    }
    className = _isp.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'serverpod.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'DeviceActionInfo') {
      return deserialize<_ixdbi6ns.DeviceActionInfo>(data['data']);
    }
    if (dataClassName == 'ProtocolCatalog') {
      return deserialize<_i1nmi3vv.ProtocolCatalog>(data['data']);
    }
    if (dataClassName == 'RestrictionCatalogEntry') {
      return deserialize<_imtxgw4b.RestrictionCatalogEntry>(data['data']);
    }
    if (dataClassName == 'DeviceConfigRequest') {
      return deserialize<_i6naazhz.DeviceConfigRequest>(data['data']);
    }
    if (dataClassName == 'DeviceConfigResponse') {
      return deserialize<_iwis7jh8.DeviceConfigResponse>(data['data']);
    }
    if (dataClassName == 'DeviceEnrollmentRejectedException') {
      return deserialize<_i4584h7a.DeviceEnrollmentRejectedException>(
        data['data'],
      );
    }
    if (dataClassName == 'DeviceFileUploadRequest') {
      return deserialize<_iwvtvt2w.DeviceFileUploadRequest>(data['data']);
    }
    if (dataClassName == 'DeviceFileUploadResponse') {
      return deserialize<_i8w1k6sf.DeviceFileUploadResponse>(data['data']);
    }
    if (dataClassName == 'DeviceIdentityMismatchException') {
      return deserialize<_i7fbuzd1.DeviceIdentityMismatchException>(
        data['data'],
      );
    }
    if (dataClassName == 'DeviceLogEntry') {
      return deserialize<_ity7ns8b.DeviceLogEntry>(data['data']);
    }
    if (dataClassName == 'DeviceLogRequest') {
      return deserialize<_iygkntpd.DeviceLogRequest>(data['data']);
    }
    if (dataClassName == 'DeviceNotificationAckRequest') {
      return deserialize<_isnpoa55.DeviceNotificationAckRequest>(data['data']);
    }
    if (dataClassName == 'DevicePasswordCheckRequest') {
      return deserialize<_i1d789es.DevicePasswordCheckRequest>(data['data']);
    }
    if (dataClassName == 'DevicePolicyChangeRequest') {
      return deserialize<_iatb2fxo.DevicePolicyChangeRequest>(data['data']);
    }
    if (dataClassName == 'DeviceRegisterRequest') {
      return deserialize<_isezr9ni.DeviceRegisterRequest>(data['data']);
    }
    if (dataClassName == 'DeviceRegisterResponse') {
      return deserialize<_ighbnj3w.DeviceRegisterResponse>(data['data']);
    }
    if (dataClassName == 'DeviceReportRequest') {
      return deserialize<_i4958h6i.DeviceReportRequest>(data['data']);
    }
    if (dataClassName == 'DeviceRequestInvalidException') {
      return deserialize<_izd6hc1b.DeviceRequestInvalidException>(data['data']);
    }
    if (dataClassName == 'DeviceStreamMessage') {
      return deserialize<_ivtuvzpv.DeviceStreamMessage>(data['data']);
    }
    if (dataClassName == 'DeviceSyncRequest') {
      return deserialize<_iz27z66x.DeviceSyncRequest>(data['data']);
    }
    if (dataClassName == 'DeviceSyncResponse') {
      return deserialize<_irbo78yl.DeviceSyncResponse>(data['data']);
    }
    if (dataClassName == 'DeviceUnauthenticatedException') {
      return deserialize<_i2yac1rh.DeviceUnauthenticatedException>(
        data['data'],
      );
    }
    if (dataClassName == 'DeviceVersionInfo') {
      return deserialize<_i6ssk22y.DeviceVersionInfo>(data['data']);
    }
    if (dataClassName == 'AppAutoUpdatePolicy') {
      return deserialize<_i55nrgys.AppAutoUpdatePolicy>(data['data']);
    }
    if (dataClassName == 'CertificateAction') {
      return deserialize<_id4i1lsk.CertificateAction>(data['data']);
    }
    if (dataClassName == 'CertificateFormat') {
      return deserialize<_ijjp6588.CertificateFormat>(data['data']);
    }
    if (dataClassName == 'CertificateType') {
      return deserialize<_ib1q49f6.CertificateType>(data['data']);
    }
    if (dataClassName == 'DeviceAction') {
      return deserialize<_id4nn3q6.DeviceAction>(data['data']);
    }
    if (dataClassName == 'DeviceCommandStatus') {
      return deserialize<_ib1qc3xz.DeviceCommandStatus>(data['data']);
    }
    if (dataClassName == 'DeviceReportType') {
      return deserialize<_ibvghvux.DeviceReportType>(data['data']);
    }
    if (dataClassName == 'FileOperationType') {
      return deserialize<_ialsmhvy.FileOperationType>(data['data']);
    }
    if (dataClassName == 'LogLevel') {
      return deserialize<_ismocxf7.LogLevel>(data['data']);
    }
    if (dataClassName == 'NotificationDeliveryStatus') {
      return deserialize<_iddiyhy2.NotificationDeliveryStatus>(data['data']);
    }
    if (dataClassName == 'NotificationType') {
      return deserialize<_ij5x7qg1.NotificationType>(data['data']);
    }
    if (dataClassName == 'PermissionPolicy') {
      return deserialize<_ivt7swit.PermissionPolicy>(data['data']);
    }
    if (dataClassName == 'PolicyApplicationAction') {
      return deserialize<_immaegpe.PolicyApplicationAction>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      return _isp.Protocol().deserializeByClassName({
        ...data,
        'className': dataClassName.substring(10),
      });
    }
    return super.deserializeByClassName(data);
  }

  @override
  Object? dynamicFieldToJson(
    Object? object, {
    bool forProtocol = false,
  }) {
    if ((object is List || object is Set || object is Map) ||
        getClassNameForObject(object) != null) {
      return super.dynamicFieldToJson(object, forProtocol: forProtocol);
    }
    for (final protocol in _hostProtocols) {
      final className = protocol.getClassNameForObject(object);
      if (className == null) continue;
      final host = protocol.getModuleName();
      final wrapped = {
        'className': className.contains('.') ? className : '$host.$className',
        'data': object,
      };
      return forProtocol
          ? _is.SerializationManager.toEncodableForProtocol(wrapped)
          : _is.SerializationManager.toEncodable(wrapped);
    }
    return super.dynamicFieldToJson(object, forProtocol: forProtocol);
  }

  @override
  dynamic deserializeDynamicFieldValue(Object? value) {
    if (value == null) return null;
    if (value is! Map<String, dynamic> || value['className'] is! String) {
      throw FormatException(
        'Dynamic fields are encoded as a Map with className and data, but got '
        '${value.runtimeType} instead.',
      );
    }
    final className = value['className'] as String;
    for (final protocol in _hostProtocols) {
      final host = protocol.getModuleName();
      final hostPrefix = '$host.';
      if (className.startsWith(hostPrefix)) {
        final strippedClassName = className.substring(hostPrefix.length);
        if (strippedClassName.contains('.')) {
          throw FormatException(
            'Dynamic field className must not use multiple prefixes: $className',
          );
        }
        final hostData = Map<String, dynamic>.from(value);
        hostData['className'] = strippedClassName;
        return protocol.deserializeByClassName(hostData);
      }
    }
    if (className.contains('.')) {
      for (final protocol in _hostProtocols) {
        try {
          return protocol.deserializeByClassName(value);
        } on _is.DeserializationClassNameNotFoundException catch (_) {}
      }
    }
    return deserializeByClassName(value);
  }

  @override
  _is.Table? getTableForType(Type t) {
    {
      var table = _isp.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    return null;
  }

  @override
  List<_isp.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  List<_isp.TableDefinition> getOwnTableDefinitions() => _ownTableDefinitions;

  @override
  String getModuleName() => 'wonkru_core';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _isp.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
