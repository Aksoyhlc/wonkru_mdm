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
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:wonkru_core_client/wonkru_core_client.dart' as _inc4d0tr;
import 'package:wonkru_mdm_client/src/protocol/admin_api/device_log_level_slice.dart'
    as _ijgatwl3;
import 'package:wonkru_mdm_client/src/protocol/admin_api/device_notification_delivery_row.dart'
    as _igielq3j;
import 'package:wonkru_mdm_client/src/protocol/admin_api/smtp_test_notice.dart'
    as _ibzn59jo;
import 'package:wonkru_mdm_client/src/protocol/device_application.dart'
    as _i1ww50jj;
import 'package:wonkru_mdm_client/src/protocol/device_command.dart'
    as _i001a4i1;
import 'package:wonkru_mdm_client/src/protocol/device_report.dart' as _i9f6b1zs;
import 'package:wonkru_mdm_client/src/protocol/file_group_member.dart'
    as _ivpkm2mv;
import 'package:wonkru_mdm_client/src/protocol/policy_application.dart'
    as _ixu9efec;
import 'package:wonkru_mdm_client/src/protocol/policy_certificate.dart'
    as _i5kzc7q6;
import 'package:wonkru_mdm_client/src/protocol/policy_file.dart' as _if9818ly;
import 'admin_activity.dart' as _ilkbs9no;
import 'admin_api/admin_activity_list_request.dart' as _il40jveh;
import 'admin_api/admin_activity_page.dart' as _i2ogfkrt;
import 'admin_api/admin_application_version_upload_request.dart' as _ibnx3x34;
import 'admin_api/admin_certificate_upload_request.dart' as _i2i7gcy9;
import 'admin_api/admin_certificate_upload_response.dart' as _ibeavedp;
import 'admin_api/admin_device_log_list_request.dart' as _ibsxjx9g;
import 'admin_api/admin_device_notification_create_request.dart' as _i0uygnfl;
import 'admin_api/admin_device_notification_create_response.dart' as _ienp2sf2;
import 'admin_api/admin_device_sync_list_request.dart' as _it8bci40;
import 'admin_api/admin_device_update_request.dart' as _i5ssq7r3;
import 'admin_api/admin_file_upload_request.dart' as _ixipoy2h;
import 'admin_api/admin_file_upload_response.dart' as _isey13n8;
import 'admin_api/admin_list_request.dart' as _iapm86nx;
import 'admin_api/admin_notification_page.dart' as _icd53qe5;
import 'admin_api/admin_policy_validation_exception.dart' as _ixlhoaw3;
import 'admin_api/admin_session_info.dart' as _i80g53mf;
import 'admin_api/admin_settings_exception.dart' as _iu59x7nk;
import 'admin_api/admin_totp_exception.dart' as _i2utvefi;
import 'admin_api/admin_totp_setup.dart' as _i3nz7csi;
import 'admin_api/admin_upload_description.dart' as _iu3n1chj;
import 'admin_api/admin_upload_exception.dart' as _ia71vnyv;
import 'admin_api/admin_user_create_request.dart' as _ildmigsf;
import 'admin_api/admin_user_page.dart' as _i9rk252w;
import 'admin_api/admin_user_row.dart' as _ims49ql6;
import 'admin_api/admin_user_update_request.dart' as _i2h83yw3;
import 'admin_api/alert_type_channels.dart' as _i9zel9cc;
import 'admin_api/application_conflict_exception.dart' as _ixd9vqh5;
import 'admin_api/application_list_request.dart' as _iywpcgnp;
import 'admin_api/application_page.dart' as _inkse08r;
import 'admin_api/application_version_page.dart' as _i06gp40p;
import 'admin_api/certificate_info.dart' as _it9fk888;
import 'admin_api/certificate_page.dart' as _i069i7yr;
import 'admin_api/certificate_parse_exception.dart' as _idvvgfnd;
import 'admin_api/dashboard_alert_stats.dart' as _iwx6j1kn;
import 'admin_api/dashboard_chart.dart' as _iwum617n;
import 'admin_api/dashboard_device_stats.dart' as _i7zpqs0q;
import 'admin_api/device_application_page.dart' as _ims4wz7a;
import 'admin_api/device_command_bulk_status.dart' as _iwuzuhja;
import 'admin_api/device_command_page.dart' as _ifucos3a;
import 'admin_api/device_command_validation_exception.dart' as _ijjx2bbv;
import 'admin_api/device_group_page.dart' as _ighwyejk;
import 'admin_api/device_group_row.dart' as _i2z5ovpr;
import 'admin_api/device_list_request.dart' as _insko4or;
import 'admin_api/device_log_level_slice.dart' as _iy9vw0x0;
import 'admin_api/device_log_page.dart' as _ivl2ayfg;
import 'admin_api/device_log_row.dart' as _itdkq1k6;
import 'admin_api/device_log_stats.dart' as _ijqjfjf1;
import 'admin_api/device_log_trend.dart' as _iich49oa;
import 'admin_api/device_notification_delivery_row.dart' as _iseucvsp;
import 'admin_api/device_notification_page.dart' as _i2ax1xec;
import 'admin_api/device_notification_row.dart' as _i3iq80ms;
import 'admin_api/device_page.dart' as _i6l9f5ia;
import 'admin_api/device_sync_detail.dart' as _if85a0yt;
import 'admin_api/device_sync_page.dart' as _ivhik0oc;
import 'admin_api/device_sync_row.dart' as _ikh1hh2e;
import 'admin_api/file_group_page.dart' as _i6uvduqy;
import 'admin_api/file_group_row.dart' as _ixb986ds;
import 'admin_api/file_list_request.dart' as _izdib2p9;
import 'admin_api/file_page.dart' as _ihf99xfg;
import 'admin_api/policy_list_request.dart' as _i3l7vagh;
import 'admin_api/policy_page.dart' as _ihzti4x0;
import 'admin_api/provisioning_profile_page.dart' as _infi0uz9;
import 'admin_api/settings_form_state.dart' as _ia6p5hq7;
import 'admin_api/smtp_test_notice.dart' as _iiakujjl;
import 'admin_notification.dart' as _ijjkm6ii;
import 'admin_profile.dart' as _iatoqpz1;
import 'admin_totp_session.dart' as _i8418qom;
import 'application.dart' as _ice4s91e;
import 'application_version.dart' as _il9v10p8;
import 'certificate.dart' as _i0cezxmz;
import 'common/rate_limit_exceeded_exception.dart' as _ipzap20l;
import 'device.dart' as _ilo09f9g;
import 'device_application.dart' as _iowtu5tn;
import 'device_command.dart' as _i7oasmb9;
import 'device_device_group.dart' as _iaeyllp0;
import 'device_group.dart' as _i94jjjz5;
import 'device_log.dart' as _iw5fr9ey;
import 'device_notification.dart' as _ixgsn4mm;
import 'device_notification_device.dart' as _i5gkie1y;
import 'device_report.dart' as _ionnmq05;
import 'device_state_cache.dart' as _iedh5c79;
import 'device_sync.dart' as _ijb003y9;
import 'enums/admin_account_status.dart' as _iejobxhm;
import 'enums/app_source_type.dart' as _iroy7u8c;
import 'enums/panel_theme.dart' as _ilbmz5lz;
import 'enums/smtp_encryption.dart' as _isv41lzz;
import 'enums/storage_disk.dart' as _ixm72k6o;
import 'enums/system_alert_type.dart' as _iwraq6dd;
import 'file_asset.dart' as _i44ond0u;
import 'file_group.dart' as _i8zsj03n;
import 'file_group_member.dart' as _iqgn8zc1;
import 'future_calls/check_policy_devices_call.dart' as _incjgs37;
import 'future_calls/send_policy_call.dart' as _in35oqp4;
import 'policy.dart' as _if7d246m;
import 'policy_application.dart' as _ifuhrcyn;
import 'policy_certificate.dart' as _i867w0wl;
import 'policy_file.dart' as _ircfqpf1;
import 'provisioning_profile.dart' as _i6rve9c0;
import 'setting.dart' as _inngxkda;
export 'admin_activity.dart';
export 'admin_api/admin_activity_list_request.dart';
export 'admin_api/admin_activity_page.dart';
export 'admin_api/admin_application_version_upload_request.dart';
export 'admin_api/admin_certificate_upload_request.dart';
export 'admin_api/admin_certificate_upload_response.dart';
export 'admin_api/admin_device_log_list_request.dart';
export 'admin_api/admin_device_notification_create_request.dart';
export 'admin_api/admin_device_notification_create_response.dart';
export 'admin_api/admin_device_sync_list_request.dart';
export 'admin_api/admin_device_update_request.dart';
export 'admin_api/admin_file_upload_request.dart';
export 'admin_api/admin_file_upload_response.dart';
export 'admin_api/admin_list_request.dart';
export 'admin_api/admin_notification_page.dart';
export 'admin_api/admin_policy_validation_exception.dart';
export 'admin_api/admin_session_info.dart';
export 'admin_api/admin_settings_exception.dart';
export 'admin_api/admin_totp_exception.dart';
export 'admin_api/admin_totp_setup.dart';
export 'admin_api/admin_upload_description.dart';
export 'admin_api/admin_upload_exception.dart';
export 'admin_api/admin_user_create_request.dart';
export 'admin_api/admin_user_page.dart';
export 'admin_api/admin_user_row.dart';
export 'admin_api/admin_user_update_request.dart';
export 'admin_api/alert_type_channels.dart';
export 'admin_api/application_conflict_exception.dart';
export 'admin_api/application_list_request.dart';
export 'admin_api/application_page.dart';
export 'admin_api/application_version_page.dart';
export 'admin_api/certificate_info.dart';
export 'admin_api/certificate_page.dart';
export 'admin_api/certificate_parse_exception.dart';
export 'admin_api/dashboard_alert_stats.dart';
export 'admin_api/dashboard_chart.dart';
export 'admin_api/dashboard_device_stats.dart';
export 'admin_api/device_application_page.dart';
export 'admin_api/device_command_bulk_status.dart';
export 'admin_api/device_command_page.dart';
export 'admin_api/device_command_validation_exception.dart';
export 'admin_api/device_group_page.dart';
export 'admin_api/device_group_row.dart';
export 'admin_api/device_list_request.dart';
export 'admin_api/device_log_level_slice.dart';
export 'admin_api/device_log_page.dart';
export 'admin_api/device_log_row.dart';
export 'admin_api/device_log_stats.dart';
export 'admin_api/device_log_trend.dart';
export 'admin_api/device_notification_delivery_row.dart';
export 'admin_api/device_notification_page.dart';
export 'admin_api/device_notification_row.dart';
export 'admin_api/device_page.dart';
export 'admin_api/device_sync_detail.dart';
export 'admin_api/device_sync_page.dart';
export 'admin_api/device_sync_row.dart';
export 'admin_api/file_group_page.dart';
export 'admin_api/file_group_row.dart';
export 'admin_api/file_list_request.dart';
export 'admin_api/file_page.dart';
export 'admin_api/policy_list_request.dart';
export 'admin_api/policy_page.dart';
export 'admin_api/provisioning_profile_page.dart';
export 'admin_api/settings_form_state.dart';
export 'admin_api/smtp_test_notice.dart';
export 'admin_notification.dart';
export 'admin_profile.dart';
export 'admin_totp_session.dart';
export 'application.dart';
export 'application_version.dart';
export 'certificate.dart';
export 'common/rate_limit_exceeded_exception.dart';
export 'device.dart';
export 'device_application.dart';
export 'device_command.dart';
export 'device_device_group.dart';
export 'device_group.dart';
export 'device_log.dart';
export 'device_notification.dart';
export 'device_notification_device.dart';
export 'device_report.dart';
export 'device_state_cache.dart';
export 'device_sync.dart';
export 'enums/admin_account_status.dart';
export 'enums/app_source_type.dart';
export 'enums/panel_theme.dart';
export 'enums/smtp_encryption.dart';
export 'enums/storage_disk.dart';
export 'enums/system_alert_type.dart';
export 'file_asset.dart';
export 'file_group.dart';
export 'file_group_member.dart';
export 'future_calls/check_policy_devices_call.dart';
export 'future_calls/send_policy_call.dart';
export 'policy.dart';
export 'policy_application.dart';
export 'policy_certificate.dart';
export 'policy_file.dart';
export 'provisioning_profile.dart';
export 'setting.dart';
export 'client.dart';

class Protocol extends _isc.SerializationManager
    implements _isc.ProtocolDeserializationProvider {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  @override
  _isc.ProtocolDeserialization get deserializationMetadata =>
      _isc.ProtocolDeserialization.cached(
        this,
        types: const [
          _isc.getType<_ilkbs9no.AdminActivity>,
          _isc.getType<_il40jveh.AdminActivityListRequest>,
          _isc.getType<_i2ogfkrt.AdminActivityPage>,
          _isc.getType<_ibnx3x34.AdminApplicationVersionUploadRequest>,
          _isc.getType<_i2i7gcy9.AdminCertificateUploadRequest>,
          _isc.getType<_ibeavedp.AdminCertificateUploadResponse>,
          _isc.getType<_ibsxjx9g.AdminDeviceLogListRequest>,
          _isc.getType<_i0uygnfl.AdminDeviceNotificationCreateRequest>,
          _isc.getType<_ienp2sf2.AdminDeviceNotificationCreateResponse>,
          _isc.getType<_it8bci40.AdminDeviceSyncListRequest>,
          _isc.getType<_i5ssq7r3.AdminDeviceUpdateRequest>,
          _isc.getType<_ixipoy2h.AdminFileUploadRequest>,
          _isc.getType<_isey13n8.AdminFileUploadResponse>,
          _isc.getType<_iapm86nx.AdminListRequest>,
          _isc.getType<_icd53qe5.AdminNotificationPage>,
          _isc.getType<_ixlhoaw3.AdminPolicyValidationException>,
          _isc.getType<_i80g53mf.AdminSessionInfo>,
          _isc.getType<_iu59x7nk.AdminSettingsException>,
          _isc.getType<_i2utvefi.AdminTotpException>,
          _isc.getType<_i3nz7csi.AdminTotpSetup>,
          _isc.getType<_iu3n1chj.AdminUploadDescription>,
          _isc.getType<_ia71vnyv.AdminUploadException>,
          _isc.getType<_ildmigsf.AdminUserCreateRequest>,
          _isc.getType<_i9rk252w.AdminUserPage>,
          _isc.getType<_ims49ql6.AdminUserRow>,
          _isc.getType<_i2h83yw3.AdminUserUpdateRequest>,
          _isc.getType<_i9zel9cc.AlertTypeChannels>,
          _isc.getType<_ixd9vqh5.ApplicationConflictException>,
          _isc.getType<_iywpcgnp.ApplicationListRequest>,
          _isc.getType<_inkse08r.ApplicationPage>,
          _isc.getType<_i06gp40p.ApplicationVersionPage>,
          _isc.getType<_it9fk888.CertificateInfo>,
          _isc.getType<_i069i7yr.CertificatePage>,
          _isc.getType<_idvvgfnd.CertificateParseException>,
          _isc.getType<_iwx6j1kn.DashboardAlertStats>,
          _isc.getType<_iwum617n.DashboardChart>,
          _isc.getType<_i7zpqs0q.DashboardDeviceStats>,
          _isc.getType<_ims4wz7a.DeviceApplicationPage>,
          _isc.getType<_iwuzuhja.DeviceCommandBulkStatus>,
          _isc.getType<_ifucos3a.DeviceCommandPage>,
          _isc.getType<_ijjx2bbv.DeviceCommandValidationException>,
          _isc.getType<_ighwyejk.DeviceGroupPage>,
          _isc.getType<_i2z5ovpr.DeviceGroupRow>,
          _isc.getType<_insko4or.DeviceListRequest>,
          _isc.getType<_iy9vw0x0.DeviceLogLevelSlice>,
          _isc.getType<_ivl2ayfg.DeviceLogPage>,
          _isc.getType<_itdkq1k6.DeviceLogRow>,
          _isc.getType<_ijqjfjf1.DeviceLogStats>,
          _isc.getType<_iich49oa.DeviceLogTrend>,
          _isc.getType<_iseucvsp.DeviceNotificationDeliveryRow>,
          _isc.getType<_i2ax1xec.DeviceNotificationPage>,
          _isc.getType<_i3iq80ms.DeviceNotificationRow>,
          _isc.getType<_i6l9f5ia.DevicePage>,
          _isc.getType<_if85a0yt.DeviceSyncDetail>,
          _isc.getType<_ivhik0oc.DeviceSyncPage>,
          _isc.getType<_ikh1hh2e.DeviceSyncRow>,
          _isc.getType<_i6uvduqy.FileGroupPage>,
          _isc.getType<_ixb986ds.FileGroupRow>,
          _isc.getType<_izdib2p9.FileListRequest>,
          _isc.getType<_ihf99xfg.FilePage>,
          _isc.getType<_i3l7vagh.PolicyListRequest>,
          _isc.getType<_ihzti4x0.PolicyPage>,
          _isc.getType<_infi0uz9.ProvisioningProfilePage>,
          _isc.getType<_ia6p5hq7.SettingsFormState>,
          _isc.getType<_iiakujjl.SmtpTestNotice>,
          _isc.getType<_ijjkm6ii.AdminNotification>,
          _isc.getType<_iatoqpz1.AdminProfile>,
          _isc.getType<_i8418qom.AdminTotpSession>,
          _isc.getType<_ice4s91e.Application>,
          _isc.getType<_il9v10p8.ApplicationVersion>,
          _isc.getType<_i0cezxmz.Certificate>,
          _isc.getType<_ipzap20l.RateLimitExceededException>,
          _isc.getType<_ilo09f9g.Device>,
          _isc.getType<_iowtu5tn.DeviceApplication>,
          _isc.getType<_i7oasmb9.DeviceCommand>,
          _isc.getType<_iaeyllp0.DeviceDeviceGroup>,
          _isc.getType<_i94jjjz5.DeviceGroup>,
          _isc.getType<_iw5fr9ey.DeviceLog>,
          _isc.getType<_ixgsn4mm.DeviceNotification>,
          _isc.getType<_i5gkie1y.DeviceNotificationDevice>,
          _isc.getType<_ionnmq05.DeviceReport>,
          _isc.getType<_iedh5c79.DeviceStateCache>,
          _isc.getType<_ijb003y9.DeviceSync>,
          _isc.getType<_iejobxhm.AdminAccountStatus>,
          _isc.getType<_iroy7u8c.AppSourceType>,
          _isc.getType<_ilbmz5lz.PanelTheme>,
          _isc.getType<_isv41lzz.SmtpEncryption>,
          _isc.getType<_ixm72k6o.StorageDisk>,
          _isc.getType<_iwraq6dd.SystemAlertType>,
          _isc.getType<_i44ond0u.FileAsset>,
          _isc.getType<_i8zsj03n.FileGroup>,
          _isc.getType<_iqgn8zc1.FileGroupMember>,
          _isc.getType<_incjgs37.CheckPolicyDevicesCall>,
          _isc.getType<_in35oqp4.SendPolicyCall>,
          _isc.getType<_if7d246m.Policy>,
          _isc.getType<_ifuhrcyn.PolicyApplication>,
          _isc.getType<_i867w0wl.PolicyCertificate>,
          _isc.getType<_ircfqpf1.PolicyFile>,
          _isc.getType<_i6rve9c0.ProvisioningProfile>,
          _isc.getType<_inngxkda.Setting>,
          _isc.getType<_ilkbs9no.AdminActivity?>,
          _isc.getType<_il40jveh.AdminActivityListRequest?>,
          _isc.getType<_i2ogfkrt.AdminActivityPage?>,
          _isc.getType<_ibnx3x34.AdminApplicationVersionUploadRequest?>,
          _isc.getType<_i2i7gcy9.AdminCertificateUploadRequest?>,
          _isc.getType<_ibeavedp.AdminCertificateUploadResponse?>,
          _isc.getType<_ibsxjx9g.AdminDeviceLogListRequest?>,
          _isc.getType<_i0uygnfl.AdminDeviceNotificationCreateRequest?>,
          _isc.getType<_ienp2sf2.AdminDeviceNotificationCreateResponse?>,
          _isc.getType<_it8bci40.AdminDeviceSyncListRequest?>,
          _isc.getType<_i5ssq7r3.AdminDeviceUpdateRequest?>,
          _isc.getType<_ixipoy2h.AdminFileUploadRequest?>,
          _isc.getType<_isey13n8.AdminFileUploadResponse?>,
          _isc.getType<_iapm86nx.AdminListRequest?>,
          _isc.getType<_icd53qe5.AdminNotificationPage?>,
          _isc.getType<_ixlhoaw3.AdminPolicyValidationException?>,
          _isc.getType<_i80g53mf.AdminSessionInfo?>,
          _isc.getType<_iu59x7nk.AdminSettingsException?>,
          _isc.getType<_i2utvefi.AdminTotpException?>,
          _isc.getType<_i3nz7csi.AdminTotpSetup?>,
          _isc.getType<_iu3n1chj.AdminUploadDescription?>,
          _isc.getType<_ia71vnyv.AdminUploadException?>,
          _isc.getType<_ildmigsf.AdminUserCreateRequest?>,
          _isc.getType<_i9rk252w.AdminUserPage?>,
          _isc.getType<_ims49ql6.AdminUserRow?>,
          _isc.getType<_i2h83yw3.AdminUserUpdateRequest?>,
          _isc.getType<_i9zel9cc.AlertTypeChannels?>,
          _isc.getType<_ixd9vqh5.ApplicationConflictException?>,
          _isc.getType<_iywpcgnp.ApplicationListRequest?>,
          _isc.getType<_inkse08r.ApplicationPage?>,
          _isc.getType<_i06gp40p.ApplicationVersionPage?>,
          _isc.getType<_it9fk888.CertificateInfo?>,
          _isc.getType<_i069i7yr.CertificatePage?>,
          _isc.getType<_idvvgfnd.CertificateParseException?>,
          _isc.getType<_iwx6j1kn.DashboardAlertStats?>,
          _isc.getType<_iwum617n.DashboardChart?>,
          _isc.getType<_i7zpqs0q.DashboardDeviceStats?>,
          _isc.getType<_ims4wz7a.DeviceApplicationPage?>,
          _isc.getType<_iwuzuhja.DeviceCommandBulkStatus?>,
          _isc.getType<_ifucos3a.DeviceCommandPage?>,
          _isc.getType<_ijjx2bbv.DeviceCommandValidationException?>,
          _isc.getType<_ighwyejk.DeviceGroupPage?>,
          _isc.getType<_i2z5ovpr.DeviceGroupRow?>,
          _isc.getType<_insko4or.DeviceListRequest?>,
          _isc.getType<_iy9vw0x0.DeviceLogLevelSlice?>,
          _isc.getType<_ivl2ayfg.DeviceLogPage?>,
          _isc.getType<_itdkq1k6.DeviceLogRow?>,
          _isc.getType<_ijqjfjf1.DeviceLogStats?>,
          _isc.getType<_iich49oa.DeviceLogTrend?>,
          _isc.getType<_iseucvsp.DeviceNotificationDeliveryRow?>,
          _isc.getType<_i2ax1xec.DeviceNotificationPage?>,
          _isc.getType<_i3iq80ms.DeviceNotificationRow?>,
          _isc.getType<_i6l9f5ia.DevicePage?>,
          _isc.getType<_if85a0yt.DeviceSyncDetail?>,
          _isc.getType<_ivhik0oc.DeviceSyncPage?>,
          _isc.getType<_ikh1hh2e.DeviceSyncRow?>,
          _isc.getType<_i6uvduqy.FileGroupPage?>,
          _isc.getType<_ixb986ds.FileGroupRow?>,
          _isc.getType<_izdib2p9.FileListRequest?>,
          _isc.getType<_ihf99xfg.FilePage?>,
          _isc.getType<_i3l7vagh.PolicyListRequest?>,
          _isc.getType<_ihzti4x0.PolicyPage?>,
          _isc.getType<_infi0uz9.ProvisioningProfilePage?>,
          _isc.getType<_ia6p5hq7.SettingsFormState?>,
          _isc.getType<_iiakujjl.SmtpTestNotice?>,
          _isc.getType<_ijjkm6ii.AdminNotification?>,
          _isc.getType<_iatoqpz1.AdminProfile?>,
          _isc.getType<_i8418qom.AdminTotpSession?>,
          _isc.getType<_ice4s91e.Application?>,
          _isc.getType<_il9v10p8.ApplicationVersion?>,
          _isc.getType<_i0cezxmz.Certificate?>,
          _isc.getType<_ipzap20l.RateLimitExceededException?>,
          _isc.getType<_ilo09f9g.Device?>,
          _isc.getType<_iowtu5tn.DeviceApplication?>,
          _isc.getType<_i7oasmb9.DeviceCommand?>,
          _isc.getType<_iaeyllp0.DeviceDeviceGroup?>,
          _isc.getType<_i94jjjz5.DeviceGroup?>,
          _isc.getType<_iw5fr9ey.DeviceLog?>,
          _isc.getType<_ixgsn4mm.DeviceNotification?>,
          _isc.getType<_i5gkie1y.DeviceNotificationDevice?>,
          _isc.getType<_ionnmq05.DeviceReport?>,
          _isc.getType<_iedh5c79.DeviceStateCache?>,
          _isc.getType<_ijb003y9.DeviceSync?>,
          _isc.getType<_iejobxhm.AdminAccountStatus?>,
          _isc.getType<_iroy7u8c.AppSourceType?>,
          _isc.getType<_ilbmz5lz.PanelTheme?>,
          _isc.getType<_isv41lzz.SmtpEncryption?>,
          _isc.getType<_ixm72k6o.StorageDisk?>,
          _isc.getType<_iwraq6dd.SystemAlertType?>,
          _isc.getType<_i44ond0u.FileAsset?>,
          _isc.getType<_i8zsj03n.FileGroup?>,
          _isc.getType<_iqgn8zc1.FileGroupMember?>,
          _isc.getType<_incjgs37.CheckPolicyDevicesCall?>,
          _isc.getType<_in35oqp4.SendPolicyCall?>,
          _isc.getType<_if7d246m.Policy?>,
          _isc.getType<_ifuhrcyn.PolicyApplication?>,
          _isc.getType<_i867w0wl.PolicyCertificate?>,
          _isc.getType<_ircfqpf1.PolicyFile?>,
          _isc.getType<_i6rve9c0.ProvisioningProfile?>,
          _isc.getType<_inngxkda.Setting?>,
          _isc.getType<List<_ilkbs9no.AdminActivity>>,
          _isc.getType<Map<String, String>>,
          _isc.getType<Map<String, String>?>,
          _isc.getType<List<int>>,
          _isc.getType<List<int>?>,
          _isc.getType<List<_iseucvsp.DeviceNotificationDeliveryRow>>,
          _isc.getType<List<_ijjkm6ii.AdminNotification>>,
          _isc.getType<List<_ims49ql6.AdminUserRow>>,
          _isc.getType<List<String>>,
          _isc.getType<List<_ice4s91e.Application>>,
          _isc.getType<Map<int, int>>,
          _isc.getType<Map<int, int>?>,
          _isc.getType<List<_il9v10p8.ApplicationVersion>>,
          _isc.getType<List<_i0cezxmz.Certificate>>,
          _isc.getType<List<String>?>,
          _isc.getType<List<_iowtu5tn.DeviceApplication>>,
          _isc.getType<List<_i7oasmb9.DeviceCommand>>,
          _isc.getType<List<_i2z5ovpr.DeviceGroupRow>>,
          _isc.getType<List<_itdkq1k6.DeviceLogRow>>,
          _isc.getType<List<_i3iq80ms.DeviceNotificationRow>>,
          _isc.getType<List<_ilo09f9g.Device>>,
          _isc.getType<List<_ikh1hh2e.DeviceSyncRow>>,
          _isc.getType<List<_ixb986ds.FileGroupRow>>,
          _isc.getType<List<_i44ond0u.FileAsset>>,
          _isc.getType<List<_if7d246m.Policy>>,
          _isc.getType<List<_i6rve9c0.ProvisioningProfile>>,
          _isc.getType<List<_i9zel9cc.AlertTypeChannels>>,
          _isc.getType<List<String>>,
          _isc.getType<List<int>>,
          _isc.getType<List<_i1ww50jj.DeviceApplication>>,
          _isc.getType<List<_i9f6b1zs.DeviceReport>>,
          _isc.getType<List<_i001a4i1.DeviceCommand>>,
          _isc.getType<List<_ijgatwl3.DeviceLogLevelSlice>>,
          _isc.getType<List<_igielq3j.DeviceNotificationDeliveryRow>>,
          _isc.getType<List<_ivpkm2mv.FileGroupMember>>,
          _isc.getType<List<_ixu9efec.PolicyApplication>>,
          _isc.getType<List<_if9818ly.PolicyFile>>,
          _isc.getType<List<_i5kzc7q6.PolicyCertificate>>,
          _isc.getType<List<_ibzn59jo.SmtpTestNotice>>,
          _isc.getType<List<_isc.UuidValue>>,
        ],
        modules: const [
          _iacc.Protocol.new,
          _iaic.Protocol.new,
          _inc4d0tr.Protocol.new,
        ],
        classNames: const [
          'AdminActivity',
          'AdminActivityListRequest',
          'AdminActivityPage',
          'AdminApplicationVersionUploadRequest',
          'AdminCertificateUploadRequest',
          'AdminCertificateUploadResponse',
          'AdminDeviceLogListRequest',
          'AdminDeviceNotificationCreateRequest',
          'AdminDeviceNotificationCreateResponse',
          'AdminDeviceSyncListRequest',
          'AdminDeviceUpdateRequest',
          'AdminFileUploadRequest',
          'AdminFileUploadResponse',
          'AdminListRequest',
          'AdminNotificationPage',
          'AdminPolicyValidationException',
          'AdminSessionInfo',
          'AdminSettingsException',
          'AdminTotpException',
          'AdminTotpSetup',
          'AdminUploadDescription',
          'AdminUploadException',
          'AdminUserCreateRequest',
          'AdminUserPage',
          'AdminUserRow',
          'AdminUserUpdateRequest',
          'AlertTypeChannels',
          'ApplicationConflictException',
          'ApplicationListRequest',
          'ApplicationPage',
          'ApplicationVersionPage',
          'CertificateInfo',
          'CertificatePage',
          'CertificateParseException',
          'DashboardAlertStats',
          'DashboardChart',
          'DashboardDeviceStats',
          'DeviceApplicationPage',
          'DeviceCommandBulkStatus',
          'DeviceCommandPage',
          'DeviceCommandValidationException',
          'DeviceGroupPage',
          'DeviceGroupRow',
          'DeviceListRequest',
          'DeviceLogLevelSlice',
          'DeviceLogPage',
          'DeviceLogRow',
          'DeviceLogStats',
          'DeviceLogTrend',
          'DeviceNotificationDeliveryRow',
          'DeviceNotificationPage',
          'DeviceNotificationRow',
          'DevicePage',
          'DeviceSyncDetail',
          'DeviceSyncPage',
          'DeviceSyncRow',
          'FileGroupPage',
          'FileGroupRow',
          'FileListRequest',
          'FilePage',
          'PolicyListRequest',
          'PolicyPage',
          'ProvisioningProfilePage',
          'SettingsFormState',
          'SmtpTestNotice',
          'AdminNotification',
          'AdminProfile',
          'AdminTotpSession',
          'Application',
          'ApplicationVersion',
          'Certificate',
          'RateLimitExceededException',
          'Device',
          'DeviceApplication',
          'DeviceCommand',
          'DeviceDeviceGroup',
          'DeviceGroup',
          'DeviceLog',
          'DeviceNotification',
          'DeviceNotificationDevice',
          'DeviceReport',
          'DeviceStateCache',
          'DeviceSync',
          'AdminAccountStatus',
          'AppSourceType',
          'PanelTheme',
          'SmtpEncryption',
          'StorageDisk',
          'SystemAlertType',
          'FileAsset',
          'FileGroup',
          'FileGroupMember',
          'CheckPolicyDevicesCall',
          'SendPolicyCall',
          'Policy',
          'PolicyApplication',
          'PolicyCertificate',
          'PolicyFile',
          'ProvisioningProfile',
          'Setting',
        ],
      );

  static String? getClassNameFromObjectJson(dynamic data) =>
      _isc.ProtocolDeserialization.readClassName(data);

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    final rawDataClassName = _isc.ProtocolDeserialization.readClassName(data);
    final dataClassName = rawDataClassName;
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _isc.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _ilkbs9no.AdminActivity) {
      return _ilkbs9no.AdminActivity.fromJson(data) as T;
    }
    if (t == _il40jveh.AdminActivityListRequest) {
      return _il40jveh.AdminActivityListRequest.fromJson(data) as T;
    }
    if (t == _i2ogfkrt.AdminActivityPage) {
      return _i2ogfkrt.AdminActivityPage.fromJson(data) as T;
    }
    if (t == _ibnx3x34.AdminApplicationVersionUploadRequest) {
      return _ibnx3x34.AdminApplicationVersionUploadRequest.fromJson(data) as T;
    }
    if (t == _i2i7gcy9.AdminCertificateUploadRequest) {
      return _i2i7gcy9.AdminCertificateUploadRequest.fromJson(data) as T;
    }
    if (t == _ibeavedp.AdminCertificateUploadResponse) {
      return _ibeavedp.AdminCertificateUploadResponse.fromJson(data) as T;
    }
    if (t == _ibsxjx9g.AdminDeviceLogListRequest) {
      return _ibsxjx9g.AdminDeviceLogListRequest.fromJson(data) as T;
    }
    if (t == _i0uygnfl.AdminDeviceNotificationCreateRequest) {
      return _i0uygnfl.AdminDeviceNotificationCreateRequest.fromJson(data) as T;
    }
    if (t == _ienp2sf2.AdminDeviceNotificationCreateResponse) {
      return _ienp2sf2.AdminDeviceNotificationCreateResponse.fromJson(data)
          as T;
    }
    if (t == _it8bci40.AdminDeviceSyncListRequest) {
      return _it8bci40.AdminDeviceSyncListRequest.fromJson(data) as T;
    }
    if (t == _i5ssq7r3.AdminDeviceUpdateRequest) {
      return _i5ssq7r3.AdminDeviceUpdateRequest.fromJson(data) as T;
    }
    if (t == _ixipoy2h.AdminFileUploadRequest) {
      return _ixipoy2h.AdminFileUploadRequest.fromJson(data) as T;
    }
    if (t == _isey13n8.AdminFileUploadResponse) {
      return _isey13n8.AdminFileUploadResponse.fromJson(data) as T;
    }
    if (t == _iapm86nx.AdminListRequest) {
      return _iapm86nx.AdminListRequest.fromJson(data) as T;
    }
    if (t == _icd53qe5.AdminNotificationPage) {
      return _icd53qe5.AdminNotificationPage.fromJson(data) as T;
    }
    if (t == _ixlhoaw3.AdminPolicyValidationException) {
      return _ixlhoaw3.AdminPolicyValidationException.fromJson(data) as T;
    }
    if (t == _i80g53mf.AdminSessionInfo) {
      return _i80g53mf.AdminSessionInfo.fromJson(data) as T;
    }
    if (t == _iu59x7nk.AdminSettingsException) {
      return _iu59x7nk.AdminSettingsException.fromJson(data) as T;
    }
    if (t == _i2utvefi.AdminTotpException) {
      return _i2utvefi.AdminTotpException.fromJson(data) as T;
    }
    if (t == _i3nz7csi.AdminTotpSetup) {
      return _i3nz7csi.AdminTotpSetup.fromJson(data) as T;
    }
    if (t == _iu3n1chj.AdminUploadDescription) {
      return _iu3n1chj.AdminUploadDescription.fromJson(data) as T;
    }
    if (t == _ia71vnyv.AdminUploadException) {
      return _ia71vnyv.AdminUploadException.fromJson(data) as T;
    }
    if (t == _ildmigsf.AdminUserCreateRequest) {
      return _ildmigsf.AdminUserCreateRequest.fromJson(data) as T;
    }
    if (t == _i9rk252w.AdminUserPage) {
      return _i9rk252w.AdminUserPage.fromJson(data) as T;
    }
    if (t == _ims49ql6.AdminUserRow) {
      return _ims49ql6.AdminUserRow.fromJson(data) as T;
    }
    if (t == _i2h83yw3.AdminUserUpdateRequest) {
      return _i2h83yw3.AdminUserUpdateRequest.fromJson(data) as T;
    }
    if (t == _i9zel9cc.AlertTypeChannels) {
      return _i9zel9cc.AlertTypeChannels.fromJson(data) as T;
    }
    if (t == _ixd9vqh5.ApplicationConflictException) {
      return _ixd9vqh5.ApplicationConflictException.fromJson(data) as T;
    }
    if (t == _iywpcgnp.ApplicationListRequest) {
      return _iywpcgnp.ApplicationListRequest.fromJson(data) as T;
    }
    if (t == _inkse08r.ApplicationPage) {
      return _inkse08r.ApplicationPage.fromJson(data) as T;
    }
    if (t == _i06gp40p.ApplicationVersionPage) {
      return _i06gp40p.ApplicationVersionPage.fromJson(data) as T;
    }
    if (t == _it9fk888.CertificateInfo) {
      return _it9fk888.CertificateInfo.fromJson(data) as T;
    }
    if (t == _i069i7yr.CertificatePage) {
      return _i069i7yr.CertificatePage.fromJson(data) as T;
    }
    if (t == _idvvgfnd.CertificateParseException) {
      return _idvvgfnd.CertificateParseException.fromJson(data) as T;
    }
    if (t == _iwx6j1kn.DashboardAlertStats) {
      return _iwx6j1kn.DashboardAlertStats.fromJson(data) as T;
    }
    if (t == _iwum617n.DashboardChart) {
      return _iwum617n.DashboardChart.fromJson(data) as T;
    }
    if (t == _i7zpqs0q.DashboardDeviceStats) {
      return _i7zpqs0q.DashboardDeviceStats.fromJson(data) as T;
    }
    if (t == _ims4wz7a.DeviceApplicationPage) {
      return _ims4wz7a.DeviceApplicationPage.fromJson(data) as T;
    }
    if (t == _iwuzuhja.DeviceCommandBulkStatus) {
      return _iwuzuhja.DeviceCommandBulkStatus.fromJson(data) as T;
    }
    if (t == _ifucos3a.DeviceCommandPage) {
      return _ifucos3a.DeviceCommandPage.fromJson(data) as T;
    }
    if (t == _ijjx2bbv.DeviceCommandValidationException) {
      return _ijjx2bbv.DeviceCommandValidationException.fromJson(data) as T;
    }
    if (t == _ighwyejk.DeviceGroupPage) {
      return _ighwyejk.DeviceGroupPage.fromJson(data) as T;
    }
    if (t == _i2z5ovpr.DeviceGroupRow) {
      return _i2z5ovpr.DeviceGroupRow.fromJson(data) as T;
    }
    if (t == _insko4or.DeviceListRequest) {
      return _insko4or.DeviceListRequest.fromJson(data) as T;
    }
    if (t == _iy9vw0x0.DeviceLogLevelSlice) {
      return _iy9vw0x0.DeviceLogLevelSlice.fromJson(data) as T;
    }
    if (t == _ivl2ayfg.DeviceLogPage) {
      return _ivl2ayfg.DeviceLogPage.fromJson(data) as T;
    }
    if (t == _itdkq1k6.DeviceLogRow) {
      return _itdkq1k6.DeviceLogRow.fromJson(data) as T;
    }
    if (t == _ijqjfjf1.DeviceLogStats) {
      return _ijqjfjf1.DeviceLogStats.fromJson(data) as T;
    }
    if (t == _iich49oa.DeviceLogTrend) {
      return _iich49oa.DeviceLogTrend.fromJson(data) as T;
    }
    if (t == _iseucvsp.DeviceNotificationDeliveryRow) {
      return _iseucvsp.DeviceNotificationDeliveryRow.fromJson(data) as T;
    }
    if (t == _i2ax1xec.DeviceNotificationPage) {
      return _i2ax1xec.DeviceNotificationPage.fromJson(data) as T;
    }
    if (t == _i3iq80ms.DeviceNotificationRow) {
      return _i3iq80ms.DeviceNotificationRow.fromJson(data) as T;
    }
    if (t == _i6l9f5ia.DevicePage) {
      return _i6l9f5ia.DevicePage.fromJson(data) as T;
    }
    if (t == _if85a0yt.DeviceSyncDetail) {
      return _if85a0yt.DeviceSyncDetail.fromJson(data) as T;
    }
    if (t == _ivhik0oc.DeviceSyncPage) {
      return _ivhik0oc.DeviceSyncPage.fromJson(data) as T;
    }
    if (t == _ikh1hh2e.DeviceSyncRow) {
      return _ikh1hh2e.DeviceSyncRow.fromJson(data) as T;
    }
    if (t == _i6uvduqy.FileGroupPage) {
      return _i6uvduqy.FileGroupPage.fromJson(data) as T;
    }
    if (t == _ixb986ds.FileGroupRow) {
      return _ixb986ds.FileGroupRow.fromJson(data) as T;
    }
    if (t == _izdib2p9.FileListRequest) {
      return _izdib2p9.FileListRequest.fromJson(data) as T;
    }
    if (t == _ihf99xfg.FilePage) {
      return _ihf99xfg.FilePage.fromJson(data) as T;
    }
    if (t == _i3l7vagh.PolicyListRequest) {
      return _i3l7vagh.PolicyListRequest.fromJson(data) as T;
    }
    if (t == _ihzti4x0.PolicyPage) {
      return _ihzti4x0.PolicyPage.fromJson(data) as T;
    }
    if (t == _infi0uz9.ProvisioningProfilePage) {
      return _infi0uz9.ProvisioningProfilePage.fromJson(data) as T;
    }
    if (t == _ia6p5hq7.SettingsFormState) {
      return _ia6p5hq7.SettingsFormState.fromJson(data) as T;
    }
    if (t == _iiakujjl.SmtpTestNotice) {
      return _iiakujjl.SmtpTestNotice.fromJson(data) as T;
    }
    if (t == _ijjkm6ii.AdminNotification) {
      return _ijjkm6ii.AdminNotification.fromJson(data) as T;
    }
    if (t == _iatoqpz1.AdminProfile) {
      return _iatoqpz1.AdminProfile.fromJson(data) as T;
    }
    if (t == _i8418qom.AdminTotpSession) {
      return _i8418qom.AdminTotpSession.fromJson(data) as T;
    }
    if (t == _ice4s91e.Application) {
      return _ice4s91e.Application.fromJson(data) as T;
    }
    if (t == _il9v10p8.ApplicationVersion) {
      return _il9v10p8.ApplicationVersion.fromJson(data) as T;
    }
    if (t == _i0cezxmz.Certificate) {
      return _i0cezxmz.Certificate.fromJson(data) as T;
    }
    if (t == _ipzap20l.RateLimitExceededException) {
      return _ipzap20l.RateLimitExceededException.fromJson(data) as T;
    }
    if (t == _ilo09f9g.Device) {
      return _ilo09f9g.Device.fromJson(data) as T;
    }
    if (t == _iowtu5tn.DeviceApplication) {
      return _iowtu5tn.DeviceApplication.fromJson(data) as T;
    }
    if (t == _i7oasmb9.DeviceCommand) {
      return _i7oasmb9.DeviceCommand.fromJson(data) as T;
    }
    if (t == _iaeyllp0.DeviceDeviceGroup) {
      return _iaeyllp0.DeviceDeviceGroup.fromJson(data) as T;
    }
    if (t == _i94jjjz5.DeviceGroup) {
      return _i94jjjz5.DeviceGroup.fromJson(data) as T;
    }
    if (t == _iw5fr9ey.DeviceLog) {
      return _iw5fr9ey.DeviceLog.fromJson(data) as T;
    }
    if (t == _ixgsn4mm.DeviceNotification) {
      return _ixgsn4mm.DeviceNotification.fromJson(data) as T;
    }
    if (t == _i5gkie1y.DeviceNotificationDevice) {
      return _i5gkie1y.DeviceNotificationDevice.fromJson(data) as T;
    }
    if (t == _ionnmq05.DeviceReport) {
      return _ionnmq05.DeviceReport.fromJson(data) as T;
    }
    if (t == _iedh5c79.DeviceStateCache) {
      return _iedh5c79.DeviceStateCache.fromJson(data) as T;
    }
    if (t == _ijb003y9.DeviceSync) {
      return _ijb003y9.DeviceSync.fromJson(data) as T;
    }
    if (t == _iejobxhm.AdminAccountStatus) {
      return _iejobxhm.AdminAccountStatus.fromJson(data) as T;
    }
    if (t == _iroy7u8c.AppSourceType) {
      return _iroy7u8c.AppSourceType.fromJson(data) as T;
    }
    if (t == _ilbmz5lz.PanelTheme) {
      return _ilbmz5lz.PanelTheme.fromJson(data) as T;
    }
    if (t == _isv41lzz.SmtpEncryption) {
      return _isv41lzz.SmtpEncryption.fromJson(data) as T;
    }
    if (t == _ixm72k6o.StorageDisk) {
      return _ixm72k6o.StorageDisk.fromJson(data) as T;
    }
    if (t == _iwraq6dd.SystemAlertType) {
      return _iwraq6dd.SystemAlertType.fromJson(data) as T;
    }
    if (t == _i44ond0u.FileAsset) {
      return _i44ond0u.FileAsset.fromJson(data) as T;
    }
    if (t == _i8zsj03n.FileGroup) {
      return _i8zsj03n.FileGroup.fromJson(data) as T;
    }
    if (t == _iqgn8zc1.FileGroupMember) {
      return _iqgn8zc1.FileGroupMember.fromJson(data) as T;
    }
    if (t == _incjgs37.CheckPolicyDevicesCall) {
      return _incjgs37.CheckPolicyDevicesCall.fromJson(data) as T;
    }
    if (t == _in35oqp4.SendPolicyCall) {
      return _in35oqp4.SendPolicyCall.fromJson(data) as T;
    }
    if (t == _if7d246m.Policy) {
      return _if7d246m.Policy.fromJson(data) as T;
    }
    if (t == _ifuhrcyn.PolicyApplication) {
      return _ifuhrcyn.PolicyApplication.fromJson(data) as T;
    }
    if (t == _i867w0wl.PolicyCertificate) {
      return _i867w0wl.PolicyCertificate.fromJson(data) as T;
    }
    if (t == _ircfqpf1.PolicyFile) {
      return _ircfqpf1.PolicyFile.fromJson(data) as T;
    }
    if (t == _i6rve9c0.ProvisioningProfile) {
      return _i6rve9c0.ProvisioningProfile.fromJson(data) as T;
    }
    if (t == _inngxkda.Setting) {
      return _inngxkda.Setting.fromJson(data) as T;
    }
    if (t == _isc.getType<_ilkbs9no.AdminActivity?>()) {
      return (data != null ? _ilkbs9no.AdminActivity.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_il40jveh.AdminActivityListRequest?>()) {
      return (data != null
              ? _il40jveh.AdminActivityListRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i2ogfkrt.AdminActivityPage?>()) {
      return (data != null ? _i2ogfkrt.AdminActivityPage.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ibnx3x34.AdminApplicationVersionUploadRequest?>()) {
      return (data != null
              ? _ibnx3x34.AdminApplicationVersionUploadRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i2i7gcy9.AdminCertificateUploadRequest?>()) {
      return (data != null
              ? _i2i7gcy9.AdminCertificateUploadRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ibeavedp.AdminCertificateUploadResponse?>()) {
      return (data != null
              ? _ibeavedp.AdminCertificateUploadResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ibsxjx9g.AdminDeviceLogListRequest?>()) {
      return (data != null
              ? _ibsxjx9g.AdminDeviceLogListRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i0uygnfl.AdminDeviceNotificationCreateRequest?>()) {
      return (data != null
              ? _i0uygnfl.AdminDeviceNotificationCreateRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ienp2sf2.AdminDeviceNotificationCreateResponse?>()) {
      return (data != null
              ? _ienp2sf2.AdminDeviceNotificationCreateResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_it8bci40.AdminDeviceSyncListRequest?>()) {
      return (data != null
              ? _it8bci40.AdminDeviceSyncListRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i5ssq7r3.AdminDeviceUpdateRequest?>()) {
      return (data != null
              ? _i5ssq7r3.AdminDeviceUpdateRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ixipoy2h.AdminFileUploadRequest?>()) {
      return (data != null
              ? _ixipoy2h.AdminFileUploadRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_isey13n8.AdminFileUploadResponse?>()) {
      return (data != null
              ? _isey13n8.AdminFileUploadResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_iapm86nx.AdminListRequest?>()) {
      return (data != null ? _iapm86nx.AdminListRequest.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_icd53qe5.AdminNotificationPage?>()) {
      return (data != null
              ? _icd53qe5.AdminNotificationPage.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ixlhoaw3.AdminPolicyValidationException?>()) {
      return (data != null
              ? _ixlhoaw3.AdminPolicyValidationException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i80g53mf.AdminSessionInfo?>()) {
      return (data != null ? _i80g53mf.AdminSessionInfo.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iu59x7nk.AdminSettingsException?>()) {
      return (data != null
              ? _iu59x7nk.AdminSettingsException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i2utvefi.AdminTotpException?>()) {
      return (data != null ? _i2utvefi.AdminTotpException.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i3nz7csi.AdminTotpSetup?>()) {
      return (data != null ? _i3nz7csi.AdminTotpSetup.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iu3n1chj.AdminUploadDescription?>()) {
      return (data != null
              ? _iu3n1chj.AdminUploadDescription.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ia71vnyv.AdminUploadException?>()) {
      return (data != null
              ? _ia71vnyv.AdminUploadException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ildmigsf.AdminUserCreateRequest?>()) {
      return (data != null
              ? _ildmigsf.AdminUserCreateRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i9rk252w.AdminUserPage?>()) {
      return (data != null ? _i9rk252w.AdminUserPage.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ims49ql6.AdminUserRow?>()) {
      return (data != null ? _ims49ql6.AdminUserRow.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i2h83yw3.AdminUserUpdateRequest?>()) {
      return (data != null
              ? _i2h83yw3.AdminUserUpdateRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i9zel9cc.AlertTypeChannels?>()) {
      return (data != null ? _i9zel9cc.AlertTypeChannels.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ixd9vqh5.ApplicationConflictException?>()) {
      return (data != null
              ? _ixd9vqh5.ApplicationConflictException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_iywpcgnp.ApplicationListRequest?>()) {
      return (data != null
              ? _iywpcgnp.ApplicationListRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_inkse08r.ApplicationPage?>()) {
      return (data != null ? _inkse08r.ApplicationPage.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i06gp40p.ApplicationVersionPage?>()) {
      return (data != null
              ? _i06gp40p.ApplicationVersionPage.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_it9fk888.CertificateInfo?>()) {
      return (data != null ? _it9fk888.CertificateInfo.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i069i7yr.CertificatePage?>()) {
      return (data != null ? _i069i7yr.CertificatePage.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_idvvgfnd.CertificateParseException?>()) {
      return (data != null
              ? _idvvgfnd.CertificateParseException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_iwx6j1kn.DashboardAlertStats?>()) {
      return (data != null
              ? _iwx6j1kn.DashboardAlertStats.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_iwum617n.DashboardChart?>()) {
      return (data != null ? _iwum617n.DashboardChart.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i7zpqs0q.DashboardDeviceStats?>()) {
      return (data != null
              ? _i7zpqs0q.DashboardDeviceStats.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ims4wz7a.DeviceApplicationPage?>()) {
      return (data != null
              ? _ims4wz7a.DeviceApplicationPage.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_iwuzuhja.DeviceCommandBulkStatus?>()) {
      return (data != null
              ? _iwuzuhja.DeviceCommandBulkStatus.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ifucos3a.DeviceCommandPage?>()) {
      return (data != null ? _ifucos3a.DeviceCommandPage.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ijjx2bbv.DeviceCommandValidationException?>()) {
      return (data != null
              ? _ijjx2bbv.DeviceCommandValidationException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ighwyejk.DeviceGroupPage?>()) {
      return (data != null ? _ighwyejk.DeviceGroupPage.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i2z5ovpr.DeviceGroupRow?>()) {
      return (data != null ? _i2z5ovpr.DeviceGroupRow.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_insko4or.DeviceListRequest?>()) {
      return (data != null ? _insko4or.DeviceListRequest.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iy9vw0x0.DeviceLogLevelSlice?>()) {
      return (data != null
              ? _iy9vw0x0.DeviceLogLevelSlice.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ivl2ayfg.DeviceLogPage?>()) {
      return (data != null ? _ivl2ayfg.DeviceLogPage.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_itdkq1k6.DeviceLogRow?>()) {
      return (data != null ? _itdkq1k6.DeviceLogRow.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ijqjfjf1.DeviceLogStats?>()) {
      return (data != null ? _ijqjfjf1.DeviceLogStats.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iich49oa.DeviceLogTrend?>()) {
      return (data != null ? _iich49oa.DeviceLogTrend.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iseucvsp.DeviceNotificationDeliveryRow?>()) {
      return (data != null
              ? _iseucvsp.DeviceNotificationDeliveryRow.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i2ax1xec.DeviceNotificationPage?>()) {
      return (data != null
              ? _i2ax1xec.DeviceNotificationPage.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i3iq80ms.DeviceNotificationRow?>()) {
      return (data != null
              ? _i3iq80ms.DeviceNotificationRow.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i6l9f5ia.DevicePage?>()) {
      return (data != null ? _i6l9f5ia.DevicePage.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_if85a0yt.DeviceSyncDetail?>()) {
      return (data != null ? _if85a0yt.DeviceSyncDetail.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ivhik0oc.DeviceSyncPage?>()) {
      return (data != null ? _ivhik0oc.DeviceSyncPage.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ikh1hh2e.DeviceSyncRow?>()) {
      return (data != null ? _ikh1hh2e.DeviceSyncRow.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i6uvduqy.FileGroupPage?>()) {
      return (data != null ? _i6uvduqy.FileGroupPage.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ixb986ds.FileGroupRow?>()) {
      return (data != null ? _ixb986ds.FileGroupRow.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_izdib2p9.FileListRequest?>()) {
      return (data != null ? _izdib2p9.FileListRequest.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ihf99xfg.FilePage?>()) {
      return (data != null ? _ihf99xfg.FilePage.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i3l7vagh.PolicyListRequest?>()) {
      return (data != null ? _i3l7vagh.PolicyListRequest.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ihzti4x0.PolicyPage?>()) {
      return (data != null ? _ihzti4x0.PolicyPage.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_infi0uz9.ProvisioningProfilePage?>()) {
      return (data != null
              ? _infi0uz9.ProvisioningProfilePage.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ia6p5hq7.SettingsFormState?>()) {
      return (data != null ? _ia6p5hq7.SettingsFormState.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iiakujjl.SmtpTestNotice?>()) {
      return (data != null ? _iiakujjl.SmtpTestNotice.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ijjkm6ii.AdminNotification?>()) {
      return (data != null ? _ijjkm6ii.AdminNotification.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iatoqpz1.AdminProfile?>()) {
      return (data != null ? _iatoqpz1.AdminProfile.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i8418qom.AdminTotpSession?>()) {
      return (data != null ? _i8418qom.AdminTotpSession.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ice4s91e.Application?>()) {
      return (data != null ? _ice4s91e.Application.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_il9v10p8.ApplicationVersion?>()) {
      return (data != null ? _il9v10p8.ApplicationVersion.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i0cezxmz.Certificate?>()) {
      return (data != null ? _i0cezxmz.Certificate.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ipzap20l.RateLimitExceededException?>()) {
      return (data != null
              ? _ipzap20l.RateLimitExceededException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ilo09f9g.Device?>()) {
      return (data != null ? _ilo09f9g.Device.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iowtu5tn.DeviceApplication?>()) {
      return (data != null ? _iowtu5tn.DeviceApplication.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i7oasmb9.DeviceCommand?>()) {
      return (data != null ? _i7oasmb9.DeviceCommand.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iaeyllp0.DeviceDeviceGroup?>()) {
      return (data != null ? _iaeyllp0.DeviceDeviceGroup.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i94jjjz5.DeviceGroup?>()) {
      return (data != null ? _i94jjjz5.DeviceGroup.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iw5fr9ey.DeviceLog?>()) {
      return (data != null ? _iw5fr9ey.DeviceLog.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ixgsn4mm.DeviceNotification?>()) {
      return (data != null ? _ixgsn4mm.DeviceNotification.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i5gkie1y.DeviceNotificationDevice?>()) {
      return (data != null
              ? _i5gkie1y.DeviceNotificationDevice.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ionnmq05.DeviceReport?>()) {
      return (data != null ? _ionnmq05.DeviceReport.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iedh5c79.DeviceStateCache?>()) {
      return (data != null ? _iedh5c79.DeviceStateCache.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ijb003y9.DeviceSync?>()) {
      return (data != null ? _ijb003y9.DeviceSync.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iejobxhm.AdminAccountStatus?>()) {
      return (data != null ? _iejobxhm.AdminAccountStatus.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iroy7u8c.AppSourceType?>()) {
      return (data != null ? _iroy7u8c.AppSourceType.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ilbmz5lz.PanelTheme?>()) {
      return (data != null ? _ilbmz5lz.PanelTheme.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_isv41lzz.SmtpEncryption?>()) {
      return (data != null ? _isv41lzz.SmtpEncryption.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ixm72k6o.StorageDisk?>()) {
      return (data != null ? _ixm72k6o.StorageDisk.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iwraq6dd.SystemAlertType?>()) {
      return (data != null ? _iwraq6dd.SystemAlertType.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i44ond0u.FileAsset?>()) {
      return (data != null ? _i44ond0u.FileAsset.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i8zsj03n.FileGroup?>()) {
      return (data != null ? _i8zsj03n.FileGroup.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iqgn8zc1.FileGroupMember?>()) {
      return (data != null ? _iqgn8zc1.FileGroupMember.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_incjgs37.CheckPolicyDevicesCall?>()) {
      return (data != null
              ? _incjgs37.CheckPolicyDevicesCall.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_in35oqp4.SendPolicyCall?>()) {
      return (data != null ? _in35oqp4.SendPolicyCall.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_if7d246m.Policy?>()) {
      return (data != null ? _if7d246m.Policy.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ifuhrcyn.PolicyApplication?>()) {
      return (data != null ? _ifuhrcyn.PolicyApplication.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i867w0wl.PolicyCertificate?>()) {
      return (data != null ? _i867w0wl.PolicyCertificate.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ircfqpf1.PolicyFile?>()) {
      return (data != null ? _ircfqpf1.PolicyFile.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i6rve9c0.ProvisioningProfile?>()) {
      return (data != null
              ? _i6rve9c0.ProvisioningProfile.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_inngxkda.Setting?>()) {
      return (data != null ? _inngxkda.Setting.fromJson(data) : null) as T;
    }
    if (t == List<_ilkbs9no.AdminActivity>) {
      return (data as List)
              .map((e) => deserialize<_ilkbs9no.AdminActivity>(e))
              .toList()
          as T;
    }
    if (t == Map<String, String>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<String>(v)),
          )
          as T;
    }
    if (t == _isc.getType<Map<String, String>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) =>
                      MapEntry(deserialize<String>(k), deserialize<String>(v)),
                )
              : null)
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == _isc.getType<List<int>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<int>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_iseucvsp.DeviceNotificationDeliveryRow>) {
      return (data as List)
              .map(
                (e) => deserialize<_iseucvsp.DeviceNotificationDeliveryRow>(e),
              )
              .toList()
          as T;
    }
    if (t == List<_ijjkm6ii.AdminNotification>) {
      return (data as List)
              .map((e) => deserialize<_ijjkm6ii.AdminNotification>(e))
              .toList()
          as T;
    }
    if (t == List<_ims49ql6.AdminUserRow>) {
      return (data as List)
              .map((e) => deserialize<_ims49ql6.AdminUserRow>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_ice4s91e.Application>) {
      return (data as List)
              .map((e) => deserialize<_ice4s91e.Application>(e))
              .toList()
          as T;
    }
    if (t == Map<int, int>) {
      return Map.fromEntries(
            (data as List).map(
              (e) =>
                  MapEntry(deserialize<int>(e['k']), deserialize<int>(e['v'])),
            ),
          )
          as T;
    }
    if (t == _isc.getType<Map<int, int>?>()) {
      return (data != null
              ? Map.fromEntries(
                  (data as List).map(
                    (e) => MapEntry(
                      deserialize<int>(e['k']),
                      deserialize<int>(e['v']),
                    ),
                  ),
                )
              : null)
          as T;
    }
    if (t == List<_il9v10p8.ApplicationVersion>) {
      return (data as List)
              .map((e) => deserialize<_il9v10p8.ApplicationVersion>(e))
              .toList()
          as T;
    }
    if (t == List<_i0cezxmz.Certificate>) {
      return (data as List)
              .map((e) => deserialize<_i0cezxmz.Certificate>(e))
              .toList()
          as T;
    }
    if (t == _isc.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_iowtu5tn.DeviceApplication>) {
      return (data as List)
              .map((e) => deserialize<_iowtu5tn.DeviceApplication>(e))
              .toList()
          as T;
    }
    if (t == List<_i7oasmb9.DeviceCommand>) {
      return (data as List)
              .map((e) => deserialize<_i7oasmb9.DeviceCommand>(e))
              .toList()
          as T;
    }
    if (t == List<_i2z5ovpr.DeviceGroupRow>) {
      return (data as List)
              .map((e) => deserialize<_i2z5ovpr.DeviceGroupRow>(e))
              .toList()
          as T;
    }
    if (t == List<_itdkq1k6.DeviceLogRow>) {
      return (data as List)
              .map((e) => deserialize<_itdkq1k6.DeviceLogRow>(e))
              .toList()
          as T;
    }
    if (t == List<_i3iq80ms.DeviceNotificationRow>) {
      return (data as List)
              .map((e) => deserialize<_i3iq80ms.DeviceNotificationRow>(e))
              .toList()
          as T;
    }
    if (t == List<_ilo09f9g.Device>) {
      return (data as List)
              .map((e) => deserialize<_ilo09f9g.Device>(e))
              .toList()
          as T;
    }
    if (t == List<_ikh1hh2e.DeviceSyncRow>) {
      return (data as List)
              .map((e) => deserialize<_ikh1hh2e.DeviceSyncRow>(e))
              .toList()
          as T;
    }
    if (t == List<_ixb986ds.FileGroupRow>) {
      return (data as List)
              .map((e) => deserialize<_ixb986ds.FileGroupRow>(e))
              .toList()
          as T;
    }
    if (t == List<_i44ond0u.FileAsset>) {
      return (data as List)
              .map((e) => deserialize<_i44ond0u.FileAsset>(e))
              .toList()
          as T;
    }
    if (t == List<_if7d246m.Policy>) {
      return (data as List)
              .map((e) => deserialize<_if7d246m.Policy>(e))
              .toList()
          as T;
    }
    if (t == List<_i6rve9c0.ProvisioningProfile>) {
      return (data as List)
              .map((e) => deserialize<_i6rve9c0.ProvisioningProfile>(e))
              .toList()
          as T;
    }
    if (t == List<_i9zel9cc.AlertTypeChannels>) {
      return (data as List)
              .map((e) => deserialize<_i9zel9cc.AlertTypeChannels>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == List<_i1ww50jj.DeviceApplication>) {
      return (data as List)
              .map((e) => deserialize<_i1ww50jj.DeviceApplication>(e))
              .toList()
          as T;
    }
    if (t == List<_i9f6b1zs.DeviceReport>) {
      return (data as List)
              .map((e) => deserialize<_i9f6b1zs.DeviceReport>(e))
              .toList()
          as T;
    }
    if (t == List<_i001a4i1.DeviceCommand>) {
      return (data as List)
              .map((e) => deserialize<_i001a4i1.DeviceCommand>(e))
              .toList()
          as T;
    }
    if (t == List<_ijgatwl3.DeviceLogLevelSlice>) {
      return (data as List)
              .map((e) => deserialize<_ijgatwl3.DeviceLogLevelSlice>(e))
              .toList()
          as T;
    }
    if (t == List<_igielq3j.DeviceNotificationDeliveryRow>) {
      return (data as List)
              .map(
                (e) => deserialize<_igielq3j.DeviceNotificationDeliveryRow>(e),
              )
              .toList()
          as T;
    }
    if (t == List<_ivpkm2mv.FileGroupMember>) {
      return (data as List)
              .map((e) => deserialize<_ivpkm2mv.FileGroupMember>(e))
              .toList()
          as T;
    }
    if (t == List<_ixu9efec.PolicyApplication>) {
      return (data as List)
              .map((e) => deserialize<_ixu9efec.PolicyApplication>(e))
              .toList()
          as T;
    }
    if (t == List<_if9818ly.PolicyFile>) {
      return (data as List)
              .map((e) => deserialize<_if9818ly.PolicyFile>(e))
              .toList()
          as T;
    }
    if (t == List<_i5kzc7q6.PolicyCertificate>) {
      return (data as List)
              .map((e) => deserialize<_i5kzc7q6.PolicyCertificate>(e))
              .toList()
          as T;
    }
    if (t == List<_ibzn59jo.SmtpTestNotice>) {
      return (data as List)
              .map((e) => deserialize<_ibzn59jo.SmtpTestNotice>(e))
              .toList()
          as T;
    }
    if (t == List<_isc.UuidValue>) {
      return (data as List).map((e) => deserialize<_isc.UuidValue>(e)).toList()
          as T;
    }
    final modules = deserializationMetadata.modulesForDeserialization(
      t,
      className: rawDataClassName,
    );
    for (final module in modules) {
      try {
        return module.deserialize<T>(data, t);
      } on _isc.DeserializationTypeNotFoundException catch (_) {}
    }

    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _ilkbs9no.AdminActivity => 'AdminActivity',
      _il40jveh.AdminActivityListRequest => 'AdminActivityListRequest',
      _i2ogfkrt.AdminActivityPage => 'AdminActivityPage',
      _ibnx3x34.AdminApplicationVersionUploadRequest =>
        'AdminApplicationVersionUploadRequest',
      _i2i7gcy9.AdminCertificateUploadRequest =>
        'AdminCertificateUploadRequest',
      _ibeavedp.AdminCertificateUploadResponse =>
        'AdminCertificateUploadResponse',
      _ibsxjx9g.AdminDeviceLogListRequest => 'AdminDeviceLogListRequest',
      _i0uygnfl.AdminDeviceNotificationCreateRequest =>
        'AdminDeviceNotificationCreateRequest',
      _ienp2sf2.AdminDeviceNotificationCreateResponse =>
        'AdminDeviceNotificationCreateResponse',
      _it8bci40.AdminDeviceSyncListRequest => 'AdminDeviceSyncListRequest',
      _i5ssq7r3.AdminDeviceUpdateRequest => 'AdminDeviceUpdateRequest',
      _ixipoy2h.AdminFileUploadRequest => 'AdminFileUploadRequest',
      _isey13n8.AdminFileUploadResponse => 'AdminFileUploadResponse',
      _iapm86nx.AdminListRequest => 'AdminListRequest',
      _icd53qe5.AdminNotificationPage => 'AdminNotificationPage',
      _ixlhoaw3.AdminPolicyValidationException =>
        'AdminPolicyValidationException',
      _i80g53mf.AdminSessionInfo => 'AdminSessionInfo',
      _iu59x7nk.AdminSettingsException => 'AdminSettingsException',
      _i2utvefi.AdminTotpException => 'AdminTotpException',
      _i3nz7csi.AdminTotpSetup => 'AdminTotpSetup',
      _iu3n1chj.AdminUploadDescription => 'AdminUploadDescription',
      _ia71vnyv.AdminUploadException => 'AdminUploadException',
      _ildmigsf.AdminUserCreateRequest => 'AdminUserCreateRequest',
      _i9rk252w.AdminUserPage => 'AdminUserPage',
      _ims49ql6.AdminUserRow => 'AdminUserRow',
      _i2h83yw3.AdminUserUpdateRequest => 'AdminUserUpdateRequest',
      _i9zel9cc.AlertTypeChannels => 'AlertTypeChannels',
      _ixd9vqh5.ApplicationConflictException => 'ApplicationConflictException',
      _iywpcgnp.ApplicationListRequest => 'ApplicationListRequest',
      _inkse08r.ApplicationPage => 'ApplicationPage',
      _i06gp40p.ApplicationVersionPage => 'ApplicationVersionPage',
      _it9fk888.CertificateInfo => 'CertificateInfo',
      _i069i7yr.CertificatePage => 'CertificatePage',
      _idvvgfnd.CertificateParseException => 'CertificateParseException',
      _iwx6j1kn.DashboardAlertStats => 'DashboardAlertStats',
      _iwum617n.DashboardChart => 'DashboardChart',
      _i7zpqs0q.DashboardDeviceStats => 'DashboardDeviceStats',
      _ims4wz7a.DeviceApplicationPage => 'DeviceApplicationPage',
      _iwuzuhja.DeviceCommandBulkStatus => 'DeviceCommandBulkStatus',
      _ifucos3a.DeviceCommandPage => 'DeviceCommandPage',
      _ijjx2bbv.DeviceCommandValidationException =>
        'DeviceCommandValidationException',
      _ighwyejk.DeviceGroupPage => 'DeviceGroupPage',
      _i2z5ovpr.DeviceGroupRow => 'DeviceGroupRow',
      _insko4or.DeviceListRequest => 'DeviceListRequest',
      _iy9vw0x0.DeviceLogLevelSlice => 'DeviceLogLevelSlice',
      _ivl2ayfg.DeviceLogPage => 'DeviceLogPage',
      _itdkq1k6.DeviceLogRow => 'DeviceLogRow',
      _ijqjfjf1.DeviceLogStats => 'DeviceLogStats',
      _iich49oa.DeviceLogTrend => 'DeviceLogTrend',
      _iseucvsp.DeviceNotificationDeliveryRow =>
        'DeviceNotificationDeliveryRow',
      _i2ax1xec.DeviceNotificationPage => 'DeviceNotificationPage',
      _i3iq80ms.DeviceNotificationRow => 'DeviceNotificationRow',
      _i6l9f5ia.DevicePage => 'DevicePage',
      _if85a0yt.DeviceSyncDetail => 'DeviceSyncDetail',
      _ivhik0oc.DeviceSyncPage => 'DeviceSyncPage',
      _ikh1hh2e.DeviceSyncRow => 'DeviceSyncRow',
      _i6uvduqy.FileGroupPage => 'FileGroupPage',
      _ixb986ds.FileGroupRow => 'FileGroupRow',
      _izdib2p9.FileListRequest => 'FileListRequest',
      _ihf99xfg.FilePage => 'FilePage',
      _i3l7vagh.PolicyListRequest => 'PolicyListRequest',
      _ihzti4x0.PolicyPage => 'PolicyPage',
      _infi0uz9.ProvisioningProfilePage => 'ProvisioningProfilePage',
      _ia6p5hq7.SettingsFormState => 'SettingsFormState',
      _iiakujjl.SmtpTestNotice => 'SmtpTestNotice',
      _ijjkm6ii.AdminNotification => 'AdminNotification',
      _iatoqpz1.AdminProfile => 'AdminProfile',
      _i8418qom.AdminTotpSession => 'AdminTotpSession',
      _ice4s91e.Application => 'Application',
      _il9v10p8.ApplicationVersion => 'ApplicationVersion',
      _i0cezxmz.Certificate => 'Certificate',
      _ipzap20l.RateLimitExceededException => 'RateLimitExceededException',
      _ilo09f9g.Device => 'Device',
      _iowtu5tn.DeviceApplication => 'DeviceApplication',
      _i7oasmb9.DeviceCommand => 'DeviceCommand',
      _iaeyllp0.DeviceDeviceGroup => 'DeviceDeviceGroup',
      _i94jjjz5.DeviceGroup => 'DeviceGroup',
      _iw5fr9ey.DeviceLog => 'DeviceLog',
      _ixgsn4mm.DeviceNotification => 'DeviceNotification',
      _i5gkie1y.DeviceNotificationDevice => 'DeviceNotificationDevice',
      _ionnmq05.DeviceReport => 'DeviceReport',
      _iedh5c79.DeviceStateCache => 'DeviceStateCache',
      _ijb003y9.DeviceSync => 'DeviceSync',
      _iejobxhm.AdminAccountStatus => 'AdminAccountStatus',
      _iroy7u8c.AppSourceType => 'AppSourceType',
      _ilbmz5lz.PanelTheme => 'PanelTheme',
      _isv41lzz.SmtpEncryption => 'SmtpEncryption',
      _ixm72k6o.StorageDisk => 'StorageDisk',
      _iwraq6dd.SystemAlertType => 'SystemAlertType',
      _i44ond0u.FileAsset => 'FileAsset',
      _i8zsj03n.FileGroup => 'FileGroup',
      _iqgn8zc1.FileGroupMember => 'FileGroupMember',
      _incjgs37.CheckPolicyDevicesCall => 'CheckPolicyDevicesCall',
      _in35oqp4.SendPolicyCall => 'SendPolicyCall',
      _if7d246m.Policy => 'Policy',
      _ifuhrcyn.PolicyApplication => 'PolicyApplication',
      _i867w0wl.PolicyCertificate => 'PolicyCertificate',
      _ircfqpf1.PolicyFile => 'PolicyFile',
      _i6rve9c0.ProvisioningProfile => 'ProvisioningProfile',
      _inngxkda.Setting => 'Setting',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('wonkru_mdm.', '');
    }

    switch (data) {
      case _ilkbs9no.AdminActivity():
        return 'AdminActivity';
      case _il40jveh.AdminActivityListRequest():
        return 'AdminActivityListRequest';
      case _i2ogfkrt.AdminActivityPage():
        return 'AdminActivityPage';
      case _ibnx3x34.AdminApplicationVersionUploadRequest():
        return 'AdminApplicationVersionUploadRequest';
      case _i2i7gcy9.AdminCertificateUploadRequest():
        return 'AdminCertificateUploadRequest';
      case _ibeavedp.AdminCertificateUploadResponse():
        return 'AdminCertificateUploadResponse';
      case _ibsxjx9g.AdminDeviceLogListRequest():
        return 'AdminDeviceLogListRequest';
      case _i0uygnfl.AdminDeviceNotificationCreateRequest():
        return 'AdminDeviceNotificationCreateRequest';
      case _ienp2sf2.AdminDeviceNotificationCreateResponse():
        return 'AdminDeviceNotificationCreateResponse';
      case _it8bci40.AdminDeviceSyncListRequest():
        return 'AdminDeviceSyncListRequest';
      case _i5ssq7r3.AdminDeviceUpdateRequest():
        return 'AdminDeviceUpdateRequest';
      case _ixipoy2h.AdminFileUploadRequest():
        return 'AdminFileUploadRequest';
      case _isey13n8.AdminFileUploadResponse():
        return 'AdminFileUploadResponse';
      case _iapm86nx.AdminListRequest():
        return 'AdminListRequest';
      case _icd53qe5.AdminNotificationPage():
        return 'AdminNotificationPage';
      case _ixlhoaw3.AdminPolicyValidationException():
        return 'AdminPolicyValidationException';
      case _i80g53mf.AdminSessionInfo():
        return 'AdminSessionInfo';
      case _iu59x7nk.AdminSettingsException():
        return 'AdminSettingsException';
      case _i2utvefi.AdminTotpException():
        return 'AdminTotpException';
      case _i3nz7csi.AdminTotpSetup():
        return 'AdminTotpSetup';
      case _iu3n1chj.AdminUploadDescription():
        return 'AdminUploadDescription';
      case _ia71vnyv.AdminUploadException():
        return 'AdminUploadException';
      case _ildmigsf.AdminUserCreateRequest():
        return 'AdminUserCreateRequest';
      case _i9rk252w.AdminUserPage():
        return 'AdminUserPage';
      case _ims49ql6.AdminUserRow():
        return 'AdminUserRow';
      case _i2h83yw3.AdminUserUpdateRequest():
        return 'AdminUserUpdateRequest';
      case _i9zel9cc.AlertTypeChannels():
        return 'AlertTypeChannels';
      case _ixd9vqh5.ApplicationConflictException():
        return 'ApplicationConflictException';
      case _iywpcgnp.ApplicationListRequest():
        return 'ApplicationListRequest';
      case _inkse08r.ApplicationPage():
        return 'ApplicationPage';
      case _i06gp40p.ApplicationVersionPage():
        return 'ApplicationVersionPage';
      case _it9fk888.CertificateInfo():
        return 'CertificateInfo';
      case _i069i7yr.CertificatePage():
        return 'CertificatePage';
      case _idvvgfnd.CertificateParseException():
        return 'CertificateParseException';
      case _iwx6j1kn.DashboardAlertStats():
        return 'DashboardAlertStats';
      case _iwum617n.DashboardChart():
        return 'DashboardChart';
      case _i7zpqs0q.DashboardDeviceStats():
        return 'DashboardDeviceStats';
      case _ims4wz7a.DeviceApplicationPage():
        return 'DeviceApplicationPage';
      case _iwuzuhja.DeviceCommandBulkStatus():
        return 'DeviceCommandBulkStatus';
      case _ifucos3a.DeviceCommandPage():
        return 'DeviceCommandPage';
      case _ijjx2bbv.DeviceCommandValidationException():
        return 'DeviceCommandValidationException';
      case _ighwyejk.DeviceGroupPage():
        return 'DeviceGroupPage';
      case _i2z5ovpr.DeviceGroupRow():
        return 'DeviceGroupRow';
      case _insko4or.DeviceListRequest():
        return 'DeviceListRequest';
      case _iy9vw0x0.DeviceLogLevelSlice():
        return 'DeviceLogLevelSlice';
      case _ivl2ayfg.DeviceLogPage():
        return 'DeviceLogPage';
      case _itdkq1k6.DeviceLogRow():
        return 'DeviceLogRow';
      case _ijqjfjf1.DeviceLogStats():
        return 'DeviceLogStats';
      case _iich49oa.DeviceLogTrend():
        return 'DeviceLogTrend';
      case _iseucvsp.DeviceNotificationDeliveryRow():
        return 'DeviceNotificationDeliveryRow';
      case _i2ax1xec.DeviceNotificationPage():
        return 'DeviceNotificationPage';
      case _i3iq80ms.DeviceNotificationRow():
        return 'DeviceNotificationRow';
      case _i6l9f5ia.DevicePage():
        return 'DevicePage';
      case _if85a0yt.DeviceSyncDetail():
        return 'DeviceSyncDetail';
      case _ivhik0oc.DeviceSyncPage():
        return 'DeviceSyncPage';
      case _ikh1hh2e.DeviceSyncRow():
        return 'DeviceSyncRow';
      case _i6uvduqy.FileGroupPage():
        return 'FileGroupPage';
      case _ixb986ds.FileGroupRow():
        return 'FileGroupRow';
      case _izdib2p9.FileListRequest():
        return 'FileListRequest';
      case _ihf99xfg.FilePage():
        return 'FilePage';
      case _i3l7vagh.PolicyListRequest():
        return 'PolicyListRequest';
      case _ihzti4x0.PolicyPage():
        return 'PolicyPage';
      case _infi0uz9.ProvisioningProfilePage():
        return 'ProvisioningProfilePage';
      case _ia6p5hq7.SettingsFormState():
        return 'SettingsFormState';
      case _iiakujjl.SmtpTestNotice():
        return 'SmtpTestNotice';
      case _ijjkm6ii.AdminNotification():
        return 'AdminNotification';
      case _iatoqpz1.AdminProfile():
        return 'AdminProfile';
      case _i8418qom.AdminTotpSession():
        return 'AdminTotpSession';
      case _ice4s91e.Application():
        return 'Application';
      case _il9v10p8.ApplicationVersion():
        return 'ApplicationVersion';
      case _i0cezxmz.Certificate():
        return 'Certificate';
      case _ipzap20l.RateLimitExceededException():
        return 'RateLimitExceededException';
      case _ilo09f9g.Device():
        return 'Device';
      case _iowtu5tn.DeviceApplication():
        return 'DeviceApplication';
      case _i7oasmb9.DeviceCommand():
        return 'DeviceCommand';
      case _iaeyllp0.DeviceDeviceGroup():
        return 'DeviceDeviceGroup';
      case _i94jjjz5.DeviceGroup():
        return 'DeviceGroup';
      case _iw5fr9ey.DeviceLog():
        return 'DeviceLog';
      case _ixgsn4mm.DeviceNotification():
        return 'DeviceNotification';
      case _i5gkie1y.DeviceNotificationDevice():
        return 'DeviceNotificationDevice';
      case _ionnmq05.DeviceReport():
        return 'DeviceReport';
      case _iedh5c79.DeviceStateCache():
        return 'DeviceStateCache';
      case _ijb003y9.DeviceSync():
        return 'DeviceSync';
      case _iejobxhm.AdminAccountStatus():
        return 'AdminAccountStatus';
      case _iroy7u8c.AppSourceType():
        return 'AppSourceType';
      case _ilbmz5lz.PanelTheme():
        return 'PanelTheme';
      case _isv41lzz.SmtpEncryption():
        return 'SmtpEncryption';
      case _ixm72k6o.StorageDisk():
        return 'StorageDisk';
      case _iwraq6dd.SystemAlertType():
        return 'SystemAlertType';
      case _i44ond0u.FileAsset():
        return 'FileAsset';
      case _i8zsj03n.FileGroup():
        return 'FileGroup';
      case _iqgn8zc1.FileGroupMember():
        return 'FileGroupMember';
      case _incjgs37.CheckPolicyDevicesCall():
        return 'CheckPolicyDevicesCall';
      case _in35oqp4.SendPolicyCall():
        return 'SendPolicyCall';
      case _if7d246m.Policy():
        return 'Policy';
      case _ifuhrcyn.PolicyApplication():
        return 'PolicyApplication';
      case _i867w0wl.PolicyCertificate():
        return 'PolicyCertificate';
      case _ircfqpf1.PolicyFile():
        return 'PolicyFile';
      case _i6rve9c0.ProvisioningProfile():
        return 'ProvisioningProfile';
      case _inngxkda.Setting():
        return 'Setting';
    }
    className = _iacc.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    className = _iaic.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _inc4d0tr.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'wonkru_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AdminActivity') {
      return deserialize<_ilkbs9no.AdminActivity>(data['data']);
    }
    if (dataClassName == 'AdminActivityListRequest') {
      return deserialize<_il40jveh.AdminActivityListRequest>(data['data']);
    }
    if (dataClassName == 'AdminActivityPage') {
      return deserialize<_i2ogfkrt.AdminActivityPage>(data['data']);
    }
    if (dataClassName == 'AdminApplicationVersionUploadRequest') {
      return deserialize<_ibnx3x34.AdminApplicationVersionUploadRequest>(
        data['data'],
      );
    }
    if (dataClassName == 'AdminCertificateUploadRequest') {
      return deserialize<_i2i7gcy9.AdminCertificateUploadRequest>(data['data']);
    }
    if (dataClassName == 'AdminCertificateUploadResponse') {
      return deserialize<_ibeavedp.AdminCertificateUploadResponse>(
        data['data'],
      );
    }
    if (dataClassName == 'AdminDeviceLogListRequest') {
      return deserialize<_ibsxjx9g.AdminDeviceLogListRequest>(data['data']);
    }
    if (dataClassName == 'AdminDeviceNotificationCreateRequest') {
      return deserialize<_i0uygnfl.AdminDeviceNotificationCreateRequest>(
        data['data'],
      );
    }
    if (dataClassName == 'AdminDeviceNotificationCreateResponse') {
      return deserialize<_ienp2sf2.AdminDeviceNotificationCreateResponse>(
        data['data'],
      );
    }
    if (dataClassName == 'AdminDeviceSyncListRequest') {
      return deserialize<_it8bci40.AdminDeviceSyncListRequest>(data['data']);
    }
    if (dataClassName == 'AdminDeviceUpdateRequest') {
      return deserialize<_i5ssq7r3.AdminDeviceUpdateRequest>(data['data']);
    }
    if (dataClassName == 'AdminFileUploadRequest') {
      return deserialize<_ixipoy2h.AdminFileUploadRequest>(data['data']);
    }
    if (dataClassName == 'AdminFileUploadResponse') {
      return deserialize<_isey13n8.AdminFileUploadResponse>(data['data']);
    }
    if (dataClassName == 'AdminListRequest') {
      return deserialize<_iapm86nx.AdminListRequest>(data['data']);
    }
    if (dataClassName == 'AdminNotificationPage') {
      return deserialize<_icd53qe5.AdminNotificationPage>(data['data']);
    }
    if (dataClassName == 'AdminPolicyValidationException') {
      return deserialize<_ixlhoaw3.AdminPolicyValidationException>(
        data['data'],
      );
    }
    if (dataClassName == 'AdminSessionInfo') {
      return deserialize<_i80g53mf.AdminSessionInfo>(data['data']);
    }
    if (dataClassName == 'AdminSettingsException') {
      return deserialize<_iu59x7nk.AdminSettingsException>(data['data']);
    }
    if (dataClassName == 'AdminTotpException') {
      return deserialize<_i2utvefi.AdminTotpException>(data['data']);
    }
    if (dataClassName == 'AdminTotpSetup') {
      return deserialize<_i3nz7csi.AdminTotpSetup>(data['data']);
    }
    if (dataClassName == 'AdminUploadDescription') {
      return deserialize<_iu3n1chj.AdminUploadDescription>(data['data']);
    }
    if (dataClassName == 'AdminUploadException') {
      return deserialize<_ia71vnyv.AdminUploadException>(data['data']);
    }
    if (dataClassName == 'AdminUserCreateRequest') {
      return deserialize<_ildmigsf.AdminUserCreateRequest>(data['data']);
    }
    if (dataClassName == 'AdminUserPage') {
      return deserialize<_i9rk252w.AdminUserPage>(data['data']);
    }
    if (dataClassName == 'AdminUserRow') {
      return deserialize<_ims49ql6.AdminUserRow>(data['data']);
    }
    if (dataClassName == 'AdminUserUpdateRequest') {
      return deserialize<_i2h83yw3.AdminUserUpdateRequest>(data['data']);
    }
    if (dataClassName == 'AlertTypeChannels') {
      return deserialize<_i9zel9cc.AlertTypeChannels>(data['data']);
    }
    if (dataClassName == 'ApplicationConflictException') {
      return deserialize<_ixd9vqh5.ApplicationConflictException>(data['data']);
    }
    if (dataClassName == 'ApplicationListRequest') {
      return deserialize<_iywpcgnp.ApplicationListRequest>(data['data']);
    }
    if (dataClassName == 'ApplicationPage') {
      return deserialize<_inkse08r.ApplicationPage>(data['data']);
    }
    if (dataClassName == 'ApplicationVersionPage') {
      return deserialize<_i06gp40p.ApplicationVersionPage>(data['data']);
    }
    if (dataClassName == 'CertificateInfo') {
      return deserialize<_it9fk888.CertificateInfo>(data['data']);
    }
    if (dataClassName == 'CertificatePage') {
      return deserialize<_i069i7yr.CertificatePage>(data['data']);
    }
    if (dataClassName == 'CertificateParseException') {
      return deserialize<_idvvgfnd.CertificateParseException>(data['data']);
    }
    if (dataClassName == 'DashboardAlertStats') {
      return deserialize<_iwx6j1kn.DashboardAlertStats>(data['data']);
    }
    if (dataClassName == 'DashboardChart') {
      return deserialize<_iwum617n.DashboardChart>(data['data']);
    }
    if (dataClassName == 'DashboardDeviceStats') {
      return deserialize<_i7zpqs0q.DashboardDeviceStats>(data['data']);
    }
    if (dataClassName == 'DeviceApplicationPage') {
      return deserialize<_ims4wz7a.DeviceApplicationPage>(data['data']);
    }
    if (dataClassName == 'DeviceCommandBulkStatus') {
      return deserialize<_iwuzuhja.DeviceCommandBulkStatus>(data['data']);
    }
    if (dataClassName == 'DeviceCommandPage') {
      return deserialize<_ifucos3a.DeviceCommandPage>(data['data']);
    }
    if (dataClassName == 'DeviceCommandValidationException') {
      return deserialize<_ijjx2bbv.DeviceCommandValidationException>(
        data['data'],
      );
    }
    if (dataClassName == 'DeviceGroupPage') {
      return deserialize<_ighwyejk.DeviceGroupPage>(data['data']);
    }
    if (dataClassName == 'DeviceGroupRow') {
      return deserialize<_i2z5ovpr.DeviceGroupRow>(data['data']);
    }
    if (dataClassName == 'DeviceListRequest') {
      return deserialize<_insko4or.DeviceListRequest>(data['data']);
    }
    if (dataClassName == 'DeviceLogLevelSlice') {
      return deserialize<_iy9vw0x0.DeviceLogLevelSlice>(data['data']);
    }
    if (dataClassName == 'DeviceLogPage') {
      return deserialize<_ivl2ayfg.DeviceLogPage>(data['data']);
    }
    if (dataClassName == 'DeviceLogRow') {
      return deserialize<_itdkq1k6.DeviceLogRow>(data['data']);
    }
    if (dataClassName == 'DeviceLogStats') {
      return deserialize<_ijqjfjf1.DeviceLogStats>(data['data']);
    }
    if (dataClassName == 'DeviceLogTrend') {
      return deserialize<_iich49oa.DeviceLogTrend>(data['data']);
    }
    if (dataClassName == 'DeviceNotificationDeliveryRow') {
      return deserialize<_iseucvsp.DeviceNotificationDeliveryRow>(data['data']);
    }
    if (dataClassName == 'DeviceNotificationPage') {
      return deserialize<_i2ax1xec.DeviceNotificationPage>(data['data']);
    }
    if (dataClassName == 'DeviceNotificationRow') {
      return deserialize<_i3iq80ms.DeviceNotificationRow>(data['data']);
    }
    if (dataClassName == 'DevicePage') {
      return deserialize<_i6l9f5ia.DevicePage>(data['data']);
    }
    if (dataClassName == 'DeviceSyncDetail') {
      return deserialize<_if85a0yt.DeviceSyncDetail>(data['data']);
    }
    if (dataClassName == 'DeviceSyncPage') {
      return deserialize<_ivhik0oc.DeviceSyncPage>(data['data']);
    }
    if (dataClassName == 'DeviceSyncRow') {
      return deserialize<_ikh1hh2e.DeviceSyncRow>(data['data']);
    }
    if (dataClassName == 'FileGroupPage') {
      return deserialize<_i6uvduqy.FileGroupPage>(data['data']);
    }
    if (dataClassName == 'FileGroupRow') {
      return deserialize<_ixb986ds.FileGroupRow>(data['data']);
    }
    if (dataClassName == 'FileListRequest') {
      return deserialize<_izdib2p9.FileListRequest>(data['data']);
    }
    if (dataClassName == 'FilePage') {
      return deserialize<_ihf99xfg.FilePage>(data['data']);
    }
    if (dataClassName == 'PolicyListRequest') {
      return deserialize<_i3l7vagh.PolicyListRequest>(data['data']);
    }
    if (dataClassName == 'PolicyPage') {
      return deserialize<_ihzti4x0.PolicyPage>(data['data']);
    }
    if (dataClassName == 'ProvisioningProfilePage') {
      return deserialize<_infi0uz9.ProvisioningProfilePage>(data['data']);
    }
    if (dataClassName == 'SettingsFormState') {
      return deserialize<_ia6p5hq7.SettingsFormState>(data['data']);
    }
    if (dataClassName == 'SmtpTestNotice') {
      return deserialize<_iiakujjl.SmtpTestNotice>(data['data']);
    }
    if (dataClassName == 'AdminNotification') {
      return deserialize<_ijjkm6ii.AdminNotification>(data['data']);
    }
    if (dataClassName == 'AdminProfile') {
      return deserialize<_iatoqpz1.AdminProfile>(data['data']);
    }
    if (dataClassName == 'AdminTotpSession') {
      return deserialize<_i8418qom.AdminTotpSession>(data['data']);
    }
    if (dataClassName == 'Application') {
      return deserialize<_ice4s91e.Application>(data['data']);
    }
    if (dataClassName == 'ApplicationVersion') {
      return deserialize<_il9v10p8.ApplicationVersion>(data['data']);
    }
    if (dataClassName == 'Certificate') {
      return deserialize<_i0cezxmz.Certificate>(data['data']);
    }
    if (dataClassName == 'RateLimitExceededException') {
      return deserialize<_ipzap20l.RateLimitExceededException>(data['data']);
    }
    if (dataClassName == 'Device') {
      return deserialize<_ilo09f9g.Device>(data['data']);
    }
    if (dataClassName == 'DeviceApplication') {
      return deserialize<_iowtu5tn.DeviceApplication>(data['data']);
    }
    if (dataClassName == 'DeviceCommand') {
      return deserialize<_i7oasmb9.DeviceCommand>(data['data']);
    }
    if (dataClassName == 'DeviceDeviceGroup') {
      return deserialize<_iaeyllp0.DeviceDeviceGroup>(data['data']);
    }
    if (dataClassName == 'DeviceGroup') {
      return deserialize<_i94jjjz5.DeviceGroup>(data['data']);
    }
    if (dataClassName == 'DeviceLog') {
      return deserialize<_iw5fr9ey.DeviceLog>(data['data']);
    }
    if (dataClassName == 'DeviceNotification') {
      return deserialize<_ixgsn4mm.DeviceNotification>(data['data']);
    }
    if (dataClassName == 'DeviceNotificationDevice') {
      return deserialize<_i5gkie1y.DeviceNotificationDevice>(data['data']);
    }
    if (dataClassName == 'DeviceReport') {
      return deserialize<_ionnmq05.DeviceReport>(data['data']);
    }
    if (dataClassName == 'DeviceStateCache') {
      return deserialize<_iedh5c79.DeviceStateCache>(data['data']);
    }
    if (dataClassName == 'DeviceSync') {
      return deserialize<_ijb003y9.DeviceSync>(data['data']);
    }
    if (dataClassName == 'AdminAccountStatus') {
      return deserialize<_iejobxhm.AdminAccountStatus>(data['data']);
    }
    if (dataClassName == 'AppSourceType') {
      return deserialize<_iroy7u8c.AppSourceType>(data['data']);
    }
    if (dataClassName == 'PanelTheme') {
      return deserialize<_ilbmz5lz.PanelTheme>(data['data']);
    }
    if (dataClassName == 'SmtpEncryption') {
      return deserialize<_isv41lzz.SmtpEncryption>(data['data']);
    }
    if (dataClassName == 'StorageDisk') {
      return deserialize<_ixm72k6o.StorageDisk>(data['data']);
    }
    if (dataClassName == 'SystemAlertType') {
      return deserialize<_iwraq6dd.SystemAlertType>(data['data']);
    }
    if (dataClassName == 'FileAsset') {
      return deserialize<_i44ond0u.FileAsset>(data['data']);
    }
    if (dataClassName == 'FileGroup') {
      return deserialize<_i8zsj03n.FileGroup>(data['data']);
    }
    if (dataClassName == 'FileGroupMember') {
      return deserialize<_iqgn8zc1.FileGroupMember>(data['data']);
    }
    if (dataClassName == 'CheckPolicyDevicesCall') {
      return deserialize<_incjgs37.CheckPolicyDevicesCall>(data['data']);
    }
    if (dataClassName == 'SendPolicyCall') {
      return deserialize<_in35oqp4.SendPolicyCall>(data['data']);
    }
    if (dataClassName == 'Policy') {
      return deserialize<_if7d246m.Policy>(data['data']);
    }
    if (dataClassName == 'PolicyApplication') {
      return deserialize<_ifuhrcyn.PolicyApplication>(data['data']);
    }
    if (dataClassName == 'PolicyCertificate') {
      return deserialize<_i867w0wl.PolicyCertificate>(data['data']);
    }
    if (dataClassName == 'PolicyFile') {
      return deserialize<_ircfqpf1.PolicyFile>(data['data']);
    }
    if (dataClassName == 'ProvisioningProfile') {
      return deserialize<_i6rve9c0.ProvisioningProfile>(data['data']);
    }
    if (dataClassName == 'Setting') {
      return deserialize<_inngxkda.Setting>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      return _iacc.Protocol().deserializeByClassName({
        ...data,
        'className': dataClassName.substring(20),
      });
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      return _iaic.Protocol().deserializeByClassName({
        ...data,
        'className': dataClassName.substring(19),
      });
    }
    if (dataClassName.startsWith('wonkru_core.')) {
      return _inc4d0tr.Protocol().deserializeByClassName({
        ...data,
        'className': dataClassName.substring(12),
      });
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iacc.Protocol().registerHostProtocol('wonkru_mdm', this);
    _iaic.Protocol().registerHostProtocol('wonkru_mdm', this);
    _inc4d0tr.Protocol().registerHostProtocol('wonkru_mdm', this);
  }

  @override
  String getModuleName() => 'wonkru_mdm';

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
      return _iacc.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iaic.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _inc4d0tr.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
