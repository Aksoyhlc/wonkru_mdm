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
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import 'package:wonkru_core_server/wonkru_core_server.dart' as _i3xu12wm;
import 'package:wonkru_mdm_server/src/generated/admin_api/device_log_level_slice.dart'
    as _i6875t1w;
import 'package:wonkru_mdm_server/src/generated/admin_api/device_notification_delivery_row.dart'
    as _icmf6gak;
import 'package:wonkru_mdm_server/src/generated/admin_api/smtp_test_notice.dart'
    as _i9q7wk1a;
import 'package:wonkru_mdm_server/src/generated/device_application.dart'
    as _i90lkbcq;
import 'package:wonkru_mdm_server/src/generated/device_command.dart'
    as _i3i3u504;
import 'package:wonkru_mdm_server/src/generated/device_report.dart'
    as _i2dxxkku;
import 'package:wonkru_mdm_server/src/generated/file_group_member.dart'
    as _i55v167m;
import 'package:wonkru_mdm_server/src/generated/policy_application.dart'
    as _isdxdq62;
import 'package:wonkru_mdm_server/src/generated/policy_certificate.dart'
    as _if8k345z;
import 'package:wonkru_mdm_server/src/generated/policy_file.dart' as _icygockk;
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

class Protocol extends _is.DatabaseSerializationManager
    implements _is.DatabaseProtocolDeserializationProvider {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  @override
  _is.ProtocolDeserialization get deserializationMetadata =>
      _is.ProtocolDeserialization.cached(
        this,
        types: const [
          _is.getType<_ilkbs9no.AdminActivity>,
          _is.getType<_il40jveh.AdminActivityListRequest>,
          _is.getType<_i2ogfkrt.AdminActivityPage>,
          _is.getType<_ibnx3x34.AdminApplicationVersionUploadRequest>,
          _is.getType<_i2i7gcy9.AdminCertificateUploadRequest>,
          _is.getType<_ibeavedp.AdminCertificateUploadResponse>,
          _is.getType<_ibsxjx9g.AdminDeviceLogListRequest>,
          _is.getType<_i0uygnfl.AdminDeviceNotificationCreateRequest>,
          _is.getType<_ienp2sf2.AdminDeviceNotificationCreateResponse>,
          _is.getType<_it8bci40.AdminDeviceSyncListRequest>,
          _is.getType<_i5ssq7r3.AdminDeviceUpdateRequest>,
          _is.getType<_ixipoy2h.AdminFileUploadRequest>,
          _is.getType<_isey13n8.AdminFileUploadResponse>,
          _is.getType<_iapm86nx.AdminListRequest>,
          _is.getType<_icd53qe5.AdminNotificationPage>,
          _is.getType<_ixlhoaw3.AdminPolicyValidationException>,
          _is.getType<_i80g53mf.AdminSessionInfo>,
          _is.getType<_iu59x7nk.AdminSettingsException>,
          _is.getType<_i2utvefi.AdminTotpException>,
          _is.getType<_i3nz7csi.AdminTotpSetup>,
          _is.getType<_iu3n1chj.AdminUploadDescription>,
          _is.getType<_ia71vnyv.AdminUploadException>,
          _is.getType<_ildmigsf.AdminUserCreateRequest>,
          _is.getType<_i9rk252w.AdminUserPage>,
          _is.getType<_ims49ql6.AdminUserRow>,
          _is.getType<_i2h83yw3.AdminUserUpdateRequest>,
          _is.getType<_i9zel9cc.AlertTypeChannels>,
          _is.getType<_ixd9vqh5.ApplicationConflictException>,
          _is.getType<_iywpcgnp.ApplicationListRequest>,
          _is.getType<_inkse08r.ApplicationPage>,
          _is.getType<_i06gp40p.ApplicationVersionPage>,
          _is.getType<_it9fk888.CertificateInfo>,
          _is.getType<_i069i7yr.CertificatePage>,
          _is.getType<_idvvgfnd.CertificateParseException>,
          _is.getType<_iwx6j1kn.DashboardAlertStats>,
          _is.getType<_iwum617n.DashboardChart>,
          _is.getType<_i7zpqs0q.DashboardDeviceStats>,
          _is.getType<_ims4wz7a.DeviceApplicationPage>,
          _is.getType<_iwuzuhja.DeviceCommandBulkStatus>,
          _is.getType<_ifucos3a.DeviceCommandPage>,
          _is.getType<_ijjx2bbv.DeviceCommandValidationException>,
          _is.getType<_ighwyejk.DeviceGroupPage>,
          _is.getType<_i2z5ovpr.DeviceGroupRow>,
          _is.getType<_insko4or.DeviceListRequest>,
          _is.getType<_iy9vw0x0.DeviceLogLevelSlice>,
          _is.getType<_ivl2ayfg.DeviceLogPage>,
          _is.getType<_itdkq1k6.DeviceLogRow>,
          _is.getType<_ijqjfjf1.DeviceLogStats>,
          _is.getType<_iich49oa.DeviceLogTrend>,
          _is.getType<_iseucvsp.DeviceNotificationDeliveryRow>,
          _is.getType<_i2ax1xec.DeviceNotificationPage>,
          _is.getType<_i3iq80ms.DeviceNotificationRow>,
          _is.getType<_i6l9f5ia.DevicePage>,
          _is.getType<_if85a0yt.DeviceSyncDetail>,
          _is.getType<_ivhik0oc.DeviceSyncPage>,
          _is.getType<_ikh1hh2e.DeviceSyncRow>,
          _is.getType<_i6uvduqy.FileGroupPage>,
          _is.getType<_ixb986ds.FileGroupRow>,
          _is.getType<_izdib2p9.FileListRequest>,
          _is.getType<_ihf99xfg.FilePage>,
          _is.getType<_i3l7vagh.PolicyListRequest>,
          _is.getType<_ihzti4x0.PolicyPage>,
          _is.getType<_infi0uz9.ProvisioningProfilePage>,
          _is.getType<_ia6p5hq7.SettingsFormState>,
          _is.getType<_iiakujjl.SmtpTestNotice>,
          _is.getType<_ijjkm6ii.AdminNotification>,
          _is.getType<_iatoqpz1.AdminProfile>,
          _is.getType<_i8418qom.AdminTotpSession>,
          _is.getType<_ice4s91e.Application>,
          _is.getType<_il9v10p8.ApplicationVersion>,
          _is.getType<_i0cezxmz.Certificate>,
          _is.getType<_ipzap20l.RateLimitExceededException>,
          _is.getType<_ilo09f9g.Device>,
          _is.getType<_iowtu5tn.DeviceApplication>,
          _is.getType<_i7oasmb9.DeviceCommand>,
          _is.getType<_iaeyllp0.DeviceDeviceGroup>,
          _is.getType<_i94jjjz5.DeviceGroup>,
          _is.getType<_iw5fr9ey.DeviceLog>,
          _is.getType<_ixgsn4mm.DeviceNotification>,
          _is.getType<_i5gkie1y.DeviceNotificationDevice>,
          _is.getType<_ionnmq05.DeviceReport>,
          _is.getType<_iedh5c79.DeviceStateCache>,
          _is.getType<_ijb003y9.DeviceSync>,
          _is.getType<_iejobxhm.AdminAccountStatus>,
          _is.getType<_iroy7u8c.AppSourceType>,
          _is.getType<_ilbmz5lz.PanelTheme>,
          _is.getType<_isv41lzz.SmtpEncryption>,
          _is.getType<_ixm72k6o.StorageDisk>,
          _is.getType<_iwraq6dd.SystemAlertType>,
          _is.getType<_i44ond0u.FileAsset>,
          _is.getType<_i8zsj03n.FileGroup>,
          _is.getType<_iqgn8zc1.FileGroupMember>,
          _is.getType<_incjgs37.CheckPolicyDevicesCall>,
          _is.getType<_in35oqp4.SendPolicyCall>,
          _is.getType<_if7d246m.Policy>,
          _is.getType<_ifuhrcyn.PolicyApplication>,
          _is.getType<_i867w0wl.PolicyCertificate>,
          _is.getType<_ircfqpf1.PolicyFile>,
          _is.getType<_i6rve9c0.ProvisioningProfile>,
          _is.getType<_inngxkda.Setting>,
          _is.getType<_ilkbs9no.AdminActivity?>,
          _is.getType<_il40jveh.AdminActivityListRequest?>,
          _is.getType<_i2ogfkrt.AdminActivityPage?>,
          _is.getType<_ibnx3x34.AdminApplicationVersionUploadRequest?>,
          _is.getType<_i2i7gcy9.AdminCertificateUploadRequest?>,
          _is.getType<_ibeavedp.AdminCertificateUploadResponse?>,
          _is.getType<_ibsxjx9g.AdminDeviceLogListRequest?>,
          _is.getType<_i0uygnfl.AdminDeviceNotificationCreateRequest?>,
          _is.getType<_ienp2sf2.AdminDeviceNotificationCreateResponse?>,
          _is.getType<_it8bci40.AdminDeviceSyncListRequest?>,
          _is.getType<_i5ssq7r3.AdminDeviceUpdateRequest?>,
          _is.getType<_ixipoy2h.AdminFileUploadRequest?>,
          _is.getType<_isey13n8.AdminFileUploadResponse?>,
          _is.getType<_iapm86nx.AdminListRequest?>,
          _is.getType<_icd53qe5.AdminNotificationPage?>,
          _is.getType<_ixlhoaw3.AdminPolicyValidationException?>,
          _is.getType<_i80g53mf.AdminSessionInfo?>,
          _is.getType<_iu59x7nk.AdminSettingsException?>,
          _is.getType<_i2utvefi.AdminTotpException?>,
          _is.getType<_i3nz7csi.AdminTotpSetup?>,
          _is.getType<_iu3n1chj.AdminUploadDescription?>,
          _is.getType<_ia71vnyv.AdminUploadException?>,
          _is.getType<_ildmigsf.AdminUserCreateRequest?>,
          _is.getType<_i9rk252w.AdminUserPage?>,
          _is.getType<_ims49ql6.AdminUserRow?>,
          _is.getType<_i2h83yw3.AdminUserUpdateRequest?>,
          _is.getType<_i9zel9cc.AlertTypeChannels?>,
          _is.getType<_ixd9vqh5.ApplicationConflictException?>,
          _is.getType<_iywpcgnp.ApplicationListRequest?>,
          _is.getType<_inkse08r.ApplicationPage?>,
          _is.getType<_i06gp40p.ApplicationVersionPage?>,
          _is.getType<_it9fk888.CertificateInfo?>,
          _is.getType<_i069i7yr.CertificatePage?>,
          _is.getType<_idvvgfnd.CertificateParseException?>,
          _is.getType<_iwx6j1kn.DashboardAlertStats?>,
          _is.getType<_iwum617n.DashboardChart?>,
          _is.getType<_i7zpqs0q.DashboardDeviceStats?>,
          _is.getType<_ims4wz7a.DeviceApplicationPage?>,
          _is.getType<_iwuzuhja.DeviceCommandBulkStatus?>,
          _is.getType<_ifucos3a.DeviceCommandPage?>,
          _is.getType<_ijjx2bbv.DeviceCommandValidationException?>,
          _is.getType<_ighwyejk.DeviceGroupPage?>,
          _is.getType<_i2z5ovpr.DeviceGroupRow?>,
          _is.getType<_insko4or.DeviceListRequest?>,
          _is.getType<_iy9vw0x0.DeviceLogLevelSlice?>,
          _is.getType<_ivl2ayfg.DeviceLogPage?>,
          _is.getType<_itdkq1k6.DeviceLogRow?>,
          _is.getType<_ijqjfjf1.DeviceLogStats?>,
          _is.getType<_iich49oa.DeviceLogTrend?>,
          _is.getType<_iseucvsp.DeviceNotificationDeliveryRow?>,
          _is.getType<_i2ax1xec.DeviceNotificationPage?>,
          _is.getType<_i3iq80ms.DeviceNotificationRow?>,
          _is.getType<_i6l9f5ia.DevicePage?>,
          _is.getType<_if85a0yt.DeviceSyncDetail?>,
          _is.getType<_ivhik0oc.DeviceSyncPage?>,
          _is.getType<_ikh1hh2e.DeviceSyncRow?>,
          _is.getType<_i6uvduqy.FileGroupPage?>,
          _is.getType<_ixb986ds.FileGroupRow?>,
          _is.getType<_izdib2p9.FileListRequest?>,
          _is.getType<_ihf99xfg.FilePage?>,
          _is.getType<_i3l7vagh.PolicyListRequest?>,
          _is.getType<_ihzti4x0.PolicyPage?>,
          _is.getType<_infi0uz9.ProvisioningProfilePage?>,
          _is.getType<_ia6p5hq7.SettingsFormState?>,
          _is.getType<_iiakujjl.SmtpTestNotice?>,
          _is.getType<_ijjkm6ii.AdminNotification?>,
          _is.getType<_iatoqpz1.AdminProfile?>,
          _is.getType<_i8418qom.AdminTotpSession?>,
          _is.getType<_ice4s91e.Application?>,
          _is.getType<_il9v10p8.ApplicationVersion?>,
          _is.getType<_i0cezxmz.Certificate?>,
          _is.getType<_ipzap20l.RateLimitExceededException?>,
          _is.getType<_ilo09f9g.Device?>,
          _is.getType<_iowtu5tn.DeviceApplication?>,
          _is.getType<_i7oasmb9.DeviceCommand?>,
          _is.getType<_iaeyllp0.DeviceDeviceGroup?>,
          _is.getType<_i94jjjz5.DeviceGroup?>,
          _is.getType<_iw5fr9ey.DeviceLog?>,
          _is.getType<_ixgsn4mm.DeviceNotification?>,
          _is.getType<_i5gkie1y.DeviceNotificationDevice?>,
          _is.getType<_ionnmq05.DeviceReport?>,
          _is.getType<_iedh5c79.DeviceStateCache?>,
          _is.getType<_ijb003y9.DeviceSync?>,
          _is.getType<_iejobxhm.AdminAccountStatus?>,
          _is.getType<_iroy7u8c.AppSourceType?>,
          _is.getType<_ilbmz5lz.PanelTheme?>,
          _is.getType<_isv41lzz.SmtpEncryption?>,
          _is.getType<_ixm72k6o.StorageDisk?>,
          _is.getType<_iwraq6dd.SystemAlertType?>,
          _is.getType<_i44ond0u.FileAsset?>,
          _is.getType<_i8zsj03n.FileGroup?>,
          _is.getType<_iqgn8zc1.FileGroupMember?>,
          _is.getType<_incjgs37.CheckPolicyDevicesCall?>,
          _is.getType<_in35oqp4.SendPolicyCall?>,
          _is.getType<_if7d246m.Policy?>,
          _is.getType<_ifuhrcyn.PolicyApplication?>,
          _is.getType<_i867w0wl.PolicyCertificate?>,
          _is.getType<_ircfqpf1.PolicyFile?>,
          _is.getType<_i6rve9c0.ProvisioningProfile?>,
          _is.getType<_inngxkda.Setting?>,
          _is.getType<List<_ilkbs9no.AdminActivity>>,
          _is.getType<Map<String, String>>,
          _is.getType<Map<String, String>?>,
          _is.getType<List<int>>,
          _is.getType<List<int>?>,
          _is.getType<List<_iseucvsp.DeviceNotificationDeliveryRow>>,
          _is.getType<List<_ijjkm6ii.AdminNotification>>,
          _is.getType<List<_ims49ql6.AdminUserRow>>,
          _is.getType<List<String>>,
          _is.getType<List<_ice4s91e.Application>>,
          _is.getType<Map<int, int>>,
          _is.getType<Map<int, int>?>,
          _is.getType<List<_il9v10p8.ApplicationVersion>>,
          _is.getType<List<_i0cezxmz.Certificate>>,
          _is.getType<List<String>?>,
          _is.getType<List<_iowtu5tn.DeviceApplication>>,
          _is.getType<List<_i7oasmb9.DeviceCommand>>,
          _is.getType<List<_i2z5ovpr.DeviceGroupRow>>,
          _is.getType<List<_itdkq1k6.DeviceLogRow>>,
          _is.getType<List<_i3iq80ms.DeviceNotificationRow>>,
          _is.getType<List<_ilo09f9g.Device>>,
          _is.getType<List<_ikh1hh2e.DeviceSyncRow>>,
          _is.getType<List<_ixb986ds.FileGroupRow>>,
          _is.getType<List<_i44ond0u.FileAsset>>,
          _is.getType<List<_if7d246m.Policy>>,
          _is.getType<List<_i6rve9c0.ProvisioningProfile>>,
          _is.getType<List<_i9zel9cc.AlertTypeChannels>>,
          _is.getType<List<String>>,
          _is.getType<List<int>>,
          _is.getType<List<_i90lkbcq.DeviceApplication>>,
          _is.getType<List<_i2dxxkku.DeviceReport>>,
          _is.getType<List<_i3i3u504.DeviceCommand>>,
          _is.getType<List<_i6875t1w.DeviceLogLevelSlice>>,
          _is.getType<List<_icmf6gak.DeviceNotificationDeliveryRow>>,
          _is.getType<List<_i55v167m.FileGroupMember>>,
          _is.getType<List<_isdxdq62.PolicyApplication>>,
          _is.getType<List<_icygockk.PolicyFile>>,
          _is.getType<List<_if8k345z.PolicyCertificate>>,
          _is.getType<List<_i9q7wk1a.SmtpTestNotice>>,
          _is.getType<List<_is.UuidValue>>,
        ],
        modules: const [
          _iacs.Protocol.new,
          _iais.Protocol.new,
          _i3xu12wm.Protocol.new,
          _isp.Protocol.new,
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

  static List<_isp.TableDefinition> get targetTableDefinitions => [
    ..._ownTableDefinitions,
    ..._iacs.Protocol().getOwnTableDefinitions(),
    ..._iais.Protocol().getOwnTableDefinitions(),
    ..._i3xu12wm.Protocol().getOwnTableDefinitions(),
    ..._isp.Protocol.targetTableDefinitions,
  ];

  static List<_isp.TableDefinition> get _ownTableDefinitions => [
    _isp.TableDefinition(
      name: 'admin_activities',
      dartName: 'AdminActivity',
      schema: 'public',
      module: 'wonkru_mdm',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'actorUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'actorEmail',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'actorName',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'action',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'targetType',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'targetId',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'data',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'ipAddress',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'admin_activities_actor_user_id_index',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'actorUserId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'admin_activities_action_index',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'action',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'admin_activities_created_at_index',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'createdAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'admin_activities_target_index',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'targetType',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'targetId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'admin_notifications',
      dartName: 'AdminNotification',
      schema: 'public',
      module: 'wonkru_mdm',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'userId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'type',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'title',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'message',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'data',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'readAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'admin_notifications_user_id_index',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'admin_profiles',
      dartName: 'AdminProfile',
      schema: 'public',
      module: 'wonkru_mdm',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'userId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:AdminAccountStatus',
          columnDefault: '\'disabled\'',
        ),
        _isp.ColumnDefinition(
          name: 'totpSecret',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'recoveryCodes',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'totpLastUsedCounter',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'lastLoginAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'totpFailedAttempts',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'totpLockedUntil',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'admin_profiles_user_id_unique',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'admin_totp_sessions',
      dartName: 'AdminTotpSession',
      schema: 'public',
      module: 'wonkru_mdm',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'userId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'sessionId',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'verifiedUntil',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'admin_totp_sessions_session_id_unique',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'sessionId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'admin_totp_sessions_user_id_index',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'application_versions',
      dartName: 'ApplicationVersion',
      schema: 'public',
      module: 'wonkru_mdm',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'applicationId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'versionName',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'versionCode',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'filePath',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'fileSizeBytes',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'checksumSha256',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'minSdkVersion',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'targetSdkVersion',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'isActive',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'permissions',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'isDefault',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'application_versions_fk_0',
          columns: ['applicationId'],
          referenceTable: 'applications',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'application_versions_application_id_foreign',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'applicationId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'application_versions_application_id_version_code_unique',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'applicationId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'versionCode',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'applications',
      dartName: 'Application',
      schema: 'public',
      module: 'wonkru_mdm',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'packageName',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'appName',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'developerName',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'iconUrl',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'category',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'sourceType',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'protocol:AppSourceType?',
        ),
        _isp.ColumnDefinition(
          name: 'isSystemApp',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'deletedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'applications_package_name_unique',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'packageName',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'certificates',
      dartName: 'Certificate',
      schema: 'public',
      module: 'wonkru_mdm',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'description',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'certificateType',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'module:wonkru_core:CertificateType',
        ),
        _isp.ColumnDefinition(
          name: 'certificateData',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'privateKeyData',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'format',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'module:wonkru_core:CertificateFormat',
        ),
        _isp.ColumnDefinition(
          name: 'issuer',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'subject',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'serialNumber',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'fingerprintSha256',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'validFrom',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'validUntil',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'isActive',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'deletedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'filePath',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'fileHash',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'password',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'certificates_fingerprint_sha256_unique',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'fingerprintSha256',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'device_applications',
      dartName: 'DeviceApplication',
      schema: 'public',
      module: 'wonkru_mdm',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'deviceId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'packageName',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'appName',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'versionName',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'versionCode',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'isSystemApp',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'isUninstallBlocked',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'isPowerSaveWhitelisted',
          columnType: _isp.ColumnType.boolean,
          isNullable: true,
          dartType: 'bool?',
        ),
        _isp.ColumnDefinition(
          name: 'lastSeenAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'device_applications_fk_0',
          columns: ['deviceId'],
          referenceTable: 'devices',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'device_applications_device_id_package_name_unique',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'deviceId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'packageName',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'device_applications_package_name_index',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'packageName',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'device_commands',
      dartName: 'DeviceCommand',
      schema: 'public',
      module: 'wonkru_mdm',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'deviceId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'commandId',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'bulkId',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'action',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'module:wonkru_core:DeviceAction',
        ),
        _isp.ColumnDefinition(
          name: 'params',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'module:wonkru_core:DeviceCommandStatus',
        ),
        _isp.ColumnDefinition(
          name: 'attempts',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'response',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'sentAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'ackedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'device_commands_fk_0',
          columns: ['deviceId'],
          referenceTable: 'devices',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'device_commands_command_id_unique',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'commandId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'device_commands_device_id_index',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'deviceId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'device_commands_status_index',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'status',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'device_commands_bulk_id_index',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'bulkId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'idx_device_commands_device_status',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'deviceId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'status',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'device_device_group',
      dartName: 'DeviceDeviceGroup',
      schema: 'public',
      module: 'wonkru_mdm',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'deviceId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'deviceGroupId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'device_device_group_fk_0',
          columns: ['deviceId'],
          referenceTable: 'devices',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'device_device_group_fk_1',
          columns: ['deviceGroupId'],
          referenceTable: 'device_groups',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'device_device_group_device_id_device_group_id_unique',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'deviceId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'deviceGroupId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'device_device_group_device_group_id_foreign',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'deviceGroupId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'device_groups',
      dartName: 'DeviceGroup',
      schema: 'public',
      module: 'wonkru_mdm',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'description',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'deletedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'device_logs',
      dartName: 'DeviceLog',
      schema: 'public',
      module: 'wonkru_mdm',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'deviceId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'entryUuid',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'sessionId',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'loggedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'level',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'tag',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'message',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'stacktrace',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'device_logs_fk_0',
          columns: ['deviceId'],
          referenceTable: 'devices',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'device_logs_logged_at_index',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'loggedAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'device_logs_level_index',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'level',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'device_logs_tag_index',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'tag',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'device_logs_device_id_logged_at_index',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'deviceId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'loggedAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'device_logs_session_id_index',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'sessionId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'device_notification_devices',
      dartName: 'DeviceNotificationDevice',
      schema: 'public',
      module: 'wonkru_mdm',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'deviceNotificationId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'deviceId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'module:wonkru_core:NotificationDeliveryStatus',
        ),
        _isp.ColumnDefinition(
          name: 'sentAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'receivedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'device_notification_devices_fk_0',
          columns: ['deviceNotificationId'],
          referenceTable: 'device_notifications',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'device_notification_devices_fk_1',
          columns: ['deviceId'],
          referenceTable: 'devices',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'device_notification_device_unique',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'deviceNotificationId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'deviceId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'device_notification_devices_status_index',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'status',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'device_notification_devices_sent_at_index',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'sentAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'device_notification_devices_received_at_index',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'receivedAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'device_notifications',
      dartName: 'DeviceNotification',
      schema: 'public',
      module: 'wonkru_mdm',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'uuid',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'title',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'message',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'type',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'module:wonkru_core:NotificationType',
        ),
        _isp.ColumnDefinition(
          name: 'extra',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'sentAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'device_notifications_uuid_unique',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'uuid',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'device_notifications_sent_at_index',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'sentAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'device_notifications_type_index',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'type',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'device_reports',
      dartName: 'DeviceReport',
      schema: 'public',
      module: 'wonkru_mdm',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'deviceId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'type',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'payload',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'device_reports_fk_0',
          columns: ['deviceId'],
          referenceTable: 'devices',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'device_reports_type_index',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'type',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'device_reports_device_id_index',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'deviceId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'device_state_cache',
      dartName: 'DeviceStateCache',
      schema: 'public',
      module: 'wonkru_mdm',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'deviceId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'deviceSyncId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'collectedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'manufacturer',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'model',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'brand',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'androidVersion',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'sdkInt',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'securityPatch',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'buildFingerprint',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'isPhysicalDevice',
          columnType: _isp.ColumnType.boolean,
          isNullable: true,
          dartType: 'bool?',
        ),
        _isp.ColumnDefinition(
          name: 'isLowRamDevice',
          columnType: _isp.ColumnType.boolean,
          isNullable: true,
          dartType: 'bool?',
        ),
        _isp.ColumnDefinition(
          name: 'batteryLevel',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'batteryState',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'isPowerSaveMode',
          columnType: _isp.ColumnType.boolean,
          isNullable: true,
          dartType: 'bool?',
        ),
        _isp.ColumnDefinition(
          name: 'isOnline',
          columnType: _isp.ColumnType.boolean,
          isNullable: true,
          dartType: 'bool?',
        ),
        _isp.ColumnDefinition(
          name: 'currentSsid',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'currentBssid',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'wifiRssi',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'wifiLinkSpeed',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'wifiFrequency',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'ipv4',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'ipv6',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'gateway',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'subnetMask',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'networkLastSsid',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'isRooted',
          columnType: _isp.ColumnType.boolean,
          isNullable: true,
          dartType: 'bool?',
        ),
        _isp.ColumnDefinition(
          name: 'adbEnabled',
          columnType: _isp.ColumnType.boolean,
          isNullable: true,
          dartType: 'bool?',
        ),
        _isp.ColumnDefinition(
          name: 'developerOptionsEnabled',
          columnType: _isp.ColumnType.boolean,
          isNullable: true,
          dartType: 'bool?',
        ),
        _isp.ColumnDefinition(
          name: 'unknownSourcesAllowed',
          columnType: _isp.ColumnType.boolean,
          isNullable: true,
          dartType: 'bool?',
        ),
        _isp.ColumnDefinition(
          name: 'encryptionStatus',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'playProtectStatus',
          columnType: _isp.ColumnType.boolean,
          isNullable: true,
          dartType: 'bool?',
        ),
        _isp.ColumnDefinition(
          name: 'passwordIsSufficient',
          columnType: _isp.ColumnType.boolean,
          isNullable: true,
          dartType: 'bool?',
        ),
        _isp.ColumnDefinition(
          name: 'passwordQuality',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'passwordComplexityLevel',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'hasSecureLock',
          columnType: _isp.ColumnType.boolean,
          isNullable: true,
          dartType: 'bool?',
        ),
        _isp.ColumnDefinition(
          name: 'isLocked',
          columnType: _isp.ColumnType.boolean,
          isNullable: true,
          dartType: 'bool?',
        ),
        _isp.ColumnDefinition(
          name: 'isDeviceOwner',
          columnType: _isp.ColumnType.boolean,
          isNullable: true,
          dartType: 'bool?',
        ),
        _isp.ColumnDefinition(
          name: 'totalStorageBytes',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'freeStorageBytes',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'usedStorageBytes',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'storageUsagePct',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _isp.ColumnDefinition(
          name: 'storageFreePct',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _isp.ColumnDefinition(
          name: 'totalInstalledApps',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'systemAppsCount',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'userAppsCount',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'managedAppsCount',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'installedCaCertCount',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'hasWonkruMdmCa',
          columnType: _isp.ColumnType.boolean,
          isNullable: true,
          dartType: 'bool?',
        ),
        _isp.ColumnDefinition(
          name: 'hasWonkruLocalCa',
          columnType: _isp.ColumnType.boolean,
          isNullable: true,
          dartType: 'bool?',
        ),
        _isp.ColumnDefinition(
          name: 'brightness',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'screenTimeoutMs',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'screenWidthPx',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'screenHeightPx',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'launcherModeEnabled',
          columnType: _isp.ColumnType.boolean,
          isNullable: true,
          dartType: 'bool?',
        ),
        _isp.ColumnDefinition(
          name: 'watchdogServiceEnabled',
          columnType: _isp.ColumnType.boolean,
          isNullable: true,
          dartType: 'bool?',
        ),
        _isp.ColumnDefinition(
          name: 'flutterAliveAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'bsDeviceUuid',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'bsDeviceCode',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'serverUrl',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'stDeviceUuid',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'stDeviceCode',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'lastPolicyUpdateAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'lastConfigFetchTime',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'stLastSyncAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'restrictionCount',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'device_state_cache_fk_0',
          columns: ['deviceId'],
          referenceTable: 'devices',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'device_state_cache_fk_1',
          columns: ['deviceSyncId'],
          referenceTable: 'device_syncs',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'device_state_cache_device_id_unique',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'deviceId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'uq_dsc_sync',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'deviceSyncId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'idx_dsc_collected_at',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'collectedAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'idx_dsc_is_online',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'isOnline',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'idx_dsc_battery_level',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'batteryLevel',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'idx_dsc_storage_pct',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'storageUsagePct',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'device_syncs',
      dartName: 'DeviceSync',
      schema: 'public',
      module: 'wonkru_mdm',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'deviceId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'collectedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'syncType',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'deviceInfo',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'mdmAppInfo',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'appsInfo',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'audioInfo',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'batteryInfo',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'certificatesInfo',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'displayInfo',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'networkInfo',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'notificationInfo',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'restrictionsInfo',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'securityInfo',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'storageInfo',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'systemInfo',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'otherInfo',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'bsInfo',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'stInfo',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'device_syncs_fk_0',
          columns: ['deviceId'],
          referenceTable: 'devices',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'device_syncs_device_id_index',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'deviceId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'device_syncs_collected_at_index',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'collectedAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'device_syncs_device_id_collected_at_index',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'deviceId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'collectedAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'devices',
      dartName: 'Device',
      schema: 'public',
      module: 'wonkru_mdm',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'code',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'uuid',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'authToken',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'policyId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'policyVersion',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'lastPolicyUpdate',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'groupId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'userId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'manufacturer',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'model',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'brand',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'serialNo',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'androidVersion',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'sdkVersion',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'agentVersionName',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'agentVersionCode',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'batteryLevel',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'ipAddress',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'isRooted',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'isLauncherMode',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'totalStorageBytes',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'freeStorageBytes',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'collectedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'lastSeenAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'firstSeenAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'deletedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'mustUseApplications',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'devices_fk_0',
          columns: ['policyId'],
          referenceTable: 'policies',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.setNull,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'devices_fk_1',
          columns: ['groupId'],
          referenceTable: 'device_groups',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.setNull,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'devices_code_unique',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'code',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'devices_uuid_unique',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'uuid',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'devices_auth_token_unique',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'authToken',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'devices_policy_id_index',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'policyId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'devices_group_id_index',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'groupId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'devices_manufacturer_index',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'manufacturer',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'devices_model_index',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'model',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'devices_android_version_index',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'androidVersion',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'devices_is_rooted_index',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'isRooted',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'devices_collected_at_index',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'collectedAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'devices_last_seen_at_index',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'lastSeenAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'devices_name_index',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'name',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'devices_user_id_index',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'idx_devices_group_deleted',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'groupId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'deletedAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'file_group_members',
      dartName: 'FileGroupMember',
      schema: 'public',
      module: 'wonkru_mdm',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'fileId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'fileGroupId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'file_group_members_fk_0',
          columns: ['fileId'],
          referenceTable: 'files',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'file_group_members_fk_1',
          columns: ['fileGroupId'],
          referenceTable: 'file_groups',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'file_group_members_file_id_file_group_id_unique',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'fileId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'fileGroupId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'file_groups',
      dartName: 'FileGroup',
      schema: 'public',
      module: 'wonkru_mdm',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'description',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'color',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'isActive',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'files',
      dartName: 'FileAsset',
      schema: 'public',
      module: 'wonkru_mdm',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'customName',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'fileExtension',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'filePath',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'publicUrl',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'mimeType',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'sizeBytes',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'fileHashSha256',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'disk',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'protocol:StorageDisk?',
        ),
        _isp.ColumnDefinition(
          name: 'deviceId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'files_fk_0',
          columns: ['deviceId'],
          referenceTable: 'devices',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.setNull,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'policies',
      dartName: 'Policy',
      schema: 'public',
      module: 'wonkru_mdm',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'slug',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'description',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'activeTimeRanges',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'isActive',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'version',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'defaultPolicy',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'adminPassword',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'batterySettings',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'storageSettings',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'audioSettings',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'displaySettings',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'securitySettings',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'restrictionSettings',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'launcher',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'syncSettings',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'otherSettings',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'deletedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'policies_slug_unique',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'slug',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'policy_applications',
      dartName: 'PolicyApplication',
      schema: 'public',
      module: 'wonkru_mdm',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'policyId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'sort',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'applicationId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'targetVersionId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'action',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'module:wonkru_core:PolicyApplicationAction',
        ),
        _isp.ColumnDefinition(
          name: 'showLauncher',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'customAppName',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'runOnBoot',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'updatePolicy',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'module:wonkru_core:AppAutoUpdatePolicy?',
        ),
        _isp.ColumnDefinition(
          name: 'startAfterInstall',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'uninstallBlock',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'policy_applications_fk_0',
          columns: ['policyId'],
          referenceTable: 'policies',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'policy_applications_fk_1',
          columns: ['applicationId'],
          referenceTable: 'applications',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'policy_applications_fk_2',
          columns: ['targetVersionId'],
          referenceTable: 'application_versions',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.setNull,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'policy_applications_policy_id_application_id_unique',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'policyId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'applicationId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'policy_applications_target_version_id_foreign',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'targetVersionId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'policy_certificates',
      dartName: 'PolicyCertificate',
      schema: 'public',
      module: 'wonkru_mdm',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'policyId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'certificateId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'action',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'module:wonkru_core:CertificateAction?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'policy_certificates_fk_0',
          columns: ['policyId'],
          referenceTable: 'policies',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'policy_certificates_fk_1',
          columns: ['certificateId'],
          referenceTable: 'certificates',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'policy_certificates_policy_id_certificate_id_unique',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'policyId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'certificateId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'policy_files',
      dartName: 'PolicyFile',
      schema: 'public',
      module: 'wonkru_mdm',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'policyId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'fileId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'usageType',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'module:wonkru_core:FileOperationType',
        ),
        _isp.ColumnDefinition(
          name: 'destinationPath',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'replaceIfExists',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'openAfterDownload',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'policy_files_fk_0',
          columns: ['policyId'],
          referenceTable: 'policies',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'policy_files_fk_1',
          columns: ['fileId'],
          referenceTable: 'files',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'policy_files_policy_id_foreign',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'policyId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'policy_files_file_id_foreign',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'fileId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'policy_files_policy_id_file_id_unique',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'policyId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'fileId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'provisioning_profiles',
      dartName: 'ProvisioningProfile',
      schema: 'public',
      module: 'wonkru_mdm',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'description',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'config',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'isActive',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'createdById',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'provisioning_profiles_created_by_foreign',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'createdById',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'settings',
      dartName: 'Setting',
      schema: 'public',
      module: 'wonkru_mdm',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'value',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'settings_name_unique',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'name',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
  ];

  static String? getClassNameFromObjectJson(dynamic data) =>
      _is.ProtocolDeserialization.readClassName(data);

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    final rawDataClassName = _is.ProtocolDeserialization.readClassName(data);
    final dataClassName = rawDataClassName;
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
    if (t == _is.getType<_ilkbs9no.AdminActivity?>()) {
      return (data != null ? _ilkbs9no.AdminActivity.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_il40jveh.AdminActivityListRequest?>()) {
      return (data != null
              ? _il40jveh.AdminActivityListRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i2ogfkrt.AdminActivityPage?>()) {
      return (data != null ? _i2ogfkrt.AdminActivityPage.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ibnx3x34.AdminApplicationVersionUploadRequest?>()) {
      return (data != null
              ? _ibnx3x34.AdminApplicationVersionUploadRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i2i7gcy9.AdminCertificateUploadRequest?>()) {
      return (data != null
              ? _i2i7gcy9.AdminCertificateUploadRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ibeavedp.AdminCertificateUploadResponse?>()) {
      return (data != null
              ? _ibeavedp.AdminCertificateUploadResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ibsxjx9g.AdminDeviceLogListRequest?>()) {
      return (data != null
              ? _ibsxjx9g.AdminDeviceLogListRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i0uygnfl.AdminDeviceNotificationCreateRequest?>()) {
      return (data != null
              ? _i0uygnfl.AdminDeviceNotificationCreateRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ienp2sf2.AdminDeviceNotificationCreateResponse?>()) {
      return (data != null
              ? _ienp2sf2.AdminDeviceNotificationCreateResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_it8bci40.AdminDeviceSyncListRequest?>()) {
      return (data != null
              ? _it8bci40.AdminDeviceSyncListRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i5ssq7r3.AdminDeviceUpdateRequest?>()) {
      return (data != null
              ? _i5ssq7r3.AdminDeviceUpdateRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ixipoy2h.AdminFileUploadRequest?>()) {
      return (data != null
              ? _ixipoy2h.AdminFileUploadRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_isey13n8.AdminFileUploadResponse?>()) {
      return (data != null
              ? _isey13n8.AdminFileUploadResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iapm86nx.AdminListRequest?>()) {
      return (data != null ? _iapm86nx.AdminListRequest.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_icd53qe5.AdminNotificationPage?>()) {
      return (data != null
              ? _icd53qe5.AdminNotificationPage.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ixlhoaw3.AdminPolicyValidationException?>()) {
      return (data != null
              ? _ixlhoaw3.AdminPolicyValidationException.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i80g53mf.AdminSessionInfo?>()) {
      return (data != null ? _i80g53mf.AdminSessionInfo.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iu59x7nk.AdminSettingsException?>()) {
      return (data != null
              ? _iu59x7nk.AdminSettingsException.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i2utvefi.AdminTotpException?>()) {
      return (data != null ? _i2utvefi.AdminTotpException.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i3nz7csi.AdminTotpSetup?>()) {
      return (data != null ? _i3nz7csi.AdminTotpSetup.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iu3n1chj.AdminUploadDescription?>()) {
      return (data != null
              ? _iu3n1chj.AdminUploadDescription.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ia71vnyv.AdminUploadException?>()) {
      return (data != null
              ? _ia71vnyv.AdminUploadException.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ildmigsf.AdminUserCreateRequest?>()) {
      return (data != null
              ? _ildmigsf.AdminUserCreateRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i9rk252w.AdminUserPage?>()) {
      return (data != null ? _i9rk252w.AdminUserPage.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ims49ql6.AdminUserRow?>()) {
      return (data != null ? _ims49ql6.AdminUserRow.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i2h83yw3.AdminUserUpdateRequest?>()) {
      return (data != null
              ? _i2h83yw3.AdminUserUpdateRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i9zel9cc.AlertTypeChannels?>()) {
      return (data != null ? _i9zel9cc.AlertTypeChannels.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ixd9vqh5.ApplicationConflictException?>()) {
      return (data != null
              ? _ixd9vqh5.ApplicationConflictException.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iywpcgnp.ApplicationListRequest?>()) {
      return (data != null
              ? _iywpcgnp.ApplicationListRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_inkse08r.ApplicationPage?>()) {
      return (data != null ? _inkse08r.ApplicationPage.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i06gp40p.ApplicationVersionPage?>()) {
      return (data != null
              ? _i06gp40p.ApplicationVersionPage.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_it9fk888.CertificateInfo?>()) {
      return (data != null ? _it9fk888.CertificateInfo.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i069i7yr.CertificatePage?>()) {
      return (data != null ? _i069i7yr.CertificatePage.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_idvvgfnd.CertificateParseException?>()) {
      return (data != null
              ? _idvvgfnd.CertificateParseException.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iwx6j1kn.DashboardAlertStats?>()) {
      return (data != null
              ? _iwx6j1kn.DashboardAlertStats.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iwum617n.DashboardChart?>()) {
      return (data != null ? _iwum617n.DashboardChart.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i7zpqs0q.DashboardDeviceStats?>()) {
      return (data != null
              ? _i7zpqs0q.DashboardDeviceStats.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ims4wz7a.DeviceApplicationPage?>()) {
      return (data != null
              ? _ims4wz7a.DeviceApplicationPage.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iwuzuhja.DeviceCommandBulkStatus?>()) {
      return (data != null
              ? _iwuzuhja.DeviceCommandBulkStatus.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ifucos3a.DeviceCommandPage?>()) {
      return (data != null ? _ifucos3a.DeviceCommandPage.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ijjx2bbv.DeviceCommandValidationException?>()) {
      return (data != null
              ? _ijjx2bbv.DeviceCommandValidationException.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ighwyejk.DeviceGroupPage?>()) {
      return (data != null ? _ighwyejk.DeviceGroupPage.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i2z5ovpr.DeviceGroupRow?>()) {
      return (data != null ? _i2z5ovpr.DeviceGroupRow.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_insko4or.DeviceListRequest?>()) {
      return (data != null ? _insko4or.DeviceListRequest.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iy9vw0x0.DeviceLogLevelSlice?>()) {
      return (data != null
              ? _iy9vw0x0.DeviceLogLevelSlice.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ivl2ayfg.DeviceLogPage?>()) {
      return (data != null ? _ivl2ayfg.DeviceLogPage.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_itdkq1k6.DeviceLogRow?>()) {
      return (data != null ? _itdkq1k6.DeviceLogRow.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ijqjfjf1.DeviceLogStats?>()) {
      return (data != null ? _ijqjfjf1.DeviceLogStats.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iich49oa.DeviceLogTrend?>()) {
      return (data != null ? _iich49oa.DeviceLogTrend.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iseucvsp.DeviceNotificationDeliveryRow?>()) {
      return (data != null
              ? _iseucvsp.DeviceNotificationDeliveryRow.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i2ax1xec.DeviceNotificationPage?>()) {
      return (data != null
              ? _i2ax1xec.DeviceNotificationPage.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i3iq80ms.DeviceNotificationRow?>()) {
      return (data != null
              ? _i3iq80ms.DeviceNotificationRow.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i6l9f5ia.DevicePage?>()) {
      return (data != null ? _i6l9f5ia.DevicePage.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_if85a0yt.DeviceSyncDetail?>()) {
      return (data != null ? _if85a0yt.DeviceSyncDetail.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ivhik0oc.DeviceSyncPage?>()) {
      return (data != null ? _ivhik0oc.DeviceSyncPage.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ikh1hh2e.DeviceSyncRow?>()) {
      return (data != null ? _ikh1hh2e.DeviceSyncRow.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i6uvduqy.FileGroupPage?>()) {
      return (data != null ? _i6uvduqy.FileGroupPage.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ixb986ds.FileGroupRow?>()) {
      return (data != null ? _ixb986ds.FileGroupRow.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_izdib2p9.FileListRequest?>()) {
      return (data != null ? _izdib2p9.FileListRequest.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ihf99xfg.FilePage?>()) {
      return (data != null ? _ihf99xfg.FilePage.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i3l7vagh.PolicyListRequest?>()) {
      return (data != null ? _i3l7vagh.PolicyListRequest.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ihzti4x0.PolicyPage?>()) {
      return (data != null ? _ihzti4x0.PolicyPage.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_infi0uz9.ProvisioningProfilePage?>()) {
      return (data != null
              ? _infi0uz9.ProvisioningProfilePage.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ia6p5hq7.SettingsFormState?>()) {
      return (data != null ? _ia6p5hq7.SettingsFormState.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iiakujjl.SmtpTestNotice?>()) {
      return (data != null ? _iiakujjl.SmtpTestNotice.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ijjkm6ii.AdminNotification?>()) {
      return (data != null ? _ijjkm6ii.AdminNotification.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iatoqpz1.AdminProfile?>()) {
      return (data != null ? _iatoqpz1.AdminProfile.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i8418qom.AdminTotpSession?>()) {
      return (data != null ? _i8418qom.AdminTotpSession.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ice4s91e.Application?>()) {
      return (data != null ? _ice4s91e.Application.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_il9v10p8.ApplicationVersion?>()) {
      return (data != null ? _il9v10p8.ApplicationVersion.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i0cezxmz.Certificate?>()) {
      return (data != null ? _i0cezxmz.Certificate.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ipzap20l.RateLimitExceededException?>()) {
      return (data != null
              ? _ipzap20l.RateLimitExceededException.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ilo09f9g.Device?>()) {
      return (data != null ? _ilo09f9g.Device.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iowtu5tn.DeviceApplication?>()) {
      return (data != null ? _iowtu5tn.DeviceApplication.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i7oasmb9.DeviceCommand?>()) {
      return (data != null ? _i7oasmb9.DeviceCommand.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iaeyllp0.DeviceDeviceGroup?>()) {
      return (data != null ? _iaeyllp0.DeviceDeviceGroup.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i94jjjz5.DeviceGroup?>()) {
      return (data != null ? _i94jjjz5.DeviceGroup.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iw5fr9ey.DeviceLog?>()) {
      return (data != null ? _iw5fr9ey.DeviceLog.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ixgsn4mm.DeviceNotification?>()) {
      return (data != null ? _ixgsn4mm.DeviceNotification.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i5gkie1y.DeviceNotificationDevice?>()) {
      return (data != null
              ? _i5gkie1y.DeviceNotificationDevice.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ionnmq05.DeviceReport?>()) {
      return (data != null ? _ionnmq05.DeviceReport.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iedh5c79.DeviceStateCache?>()) {
      return (data != null ? _iedh5c79.DeviceStateCache.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ijb003y9.DeviceSync?>()) {
      return (data != null ? _ijb003y9.DeviceSync.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iejobxhm.AdminAccountStatus?>()) {
      return (data != null ? _iejobxhm.AdminAccountStatus.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iroy7u8c.AppSourceType?>()) {
      return (data != null ? _iroy7u8c.AppSourceType.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ilbmz5lz.PanelTheme?>()) {
      return (data != null ? _ilbmz5lz.PanelTheme.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_isv41lzz.SmtpEncryption?>()) {
      return (data != null ? _isv41lzz.SmtpEncryption.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ixm72k6o.StorageDisk?>()) {
      return (data != null ? _ixm72k6o.StorageDisk.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iwraq6dd.SystemAlertType?>()) {
      return (data != null ? _iwraq6dd.SystemAlertType.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i44ond0u.FileAsset?>()) {
      return (data != null ? _i44ond0u.FileAsset.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i8zsj03n.FileGroup?>()) {
      return (data != null ? _i8zsj03n.FileGroup.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iqgn8zc1.FileGroupMember?>()) {
      return (data != null ? _iqgn8zc1.FileGroupMember.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_incjgs37.CheckPolicyDevicesCall?>()) {
      return (data != null
              ? _incjgs37.CheckPolicyDevicesCall.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_in35oqp4.SendPolicyCall?>()) {
      return (data != null ? _in35oqp4.SendPolicyCall.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_if7d246m.Policy?>()) {
      return (data != null ? _if7d246m.Policy.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ifuhrcyn.PolicyApplication?>()) {
      return (data != null ? _ifuhrcyn.PolicyApplication.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i867w0wl.PolicyCertificate?>()) {
      return (data != null ? _i867w0wl.PolicyCertificate.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ircfqpf1.PolicyFile?>()) {
      return (data != null ? _ircfqpf1.PolicyFile.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i6rve9c0.ProvisioningProfile?>()) {
      return (data != null
              ? _i6rve9c0.ProvisioningProfile.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_inngxkda.Setting?>()) {
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
    if (t == _is.getType<Map<String, String>?>()) {
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
    if (t == _is.getType<List<int>?>()) {
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
    if (t == _is.getType<Map<int, int>?>()) {
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
    if (t == _is.getType<List<String>?>()) {
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
    if (t == List<_i90lkbcq.DeviceApplication>) {
      return (data as List)
              .map((e) => deserialize<_i90lkbcq.DeviceApplication>(e))
              .toList()
          as T;
    }
    if (t == List<_i2dxxkku.DeviceReport>) {
      return (data as List)
              .map((e) => deserialize<_i2dxxkku.DeviceReport>(e))
              .toList()
          as T;
    }
    if (t == List<_i3i3u504.DeviceCommand>) {
      return (data as List)
              .map((e) => deserialize<_i3i3u504.DeviceCommand>(e))
              .toList()
          as T;
    }
    if (t == List<_i6875t1w.DeviceLogLevelSlice>) {
      return (data as List)
              .map((e) => deserialize<_i6875t1w.DeviceLogLevelSlice>(e))
              .toList()
          as T;
    }
    if (t == List<_icmf6gak.DeviceNotificationDeliveryRow>) {
      return (data as List)
              .map(
                (e) => deserialize<_icmf6gak.DeviceNotificationDeliveryRow>(e),
              )
              .toList()
          as T;
    }
    if (t == List<_i55v167m.FileGroupMember>) {
      return (data as List)
              .map((e) => deserialize<_i55v167m.FileGroupMember>(e))
              .toList()
          as T;
    }
    if (t == List<_isdxdq62.PolicyApplication>) {
      return (data as List)
              .map((e) => deserialize<_isdxdq62.PolicyApplication>(e))
              .toList()
          as T;
    }
    if (t == List<_icygockk.PolicyFile>) {
      return (data as List)
              .map((e) => deserialize<_icygockk.PolicyFile>(e))
              .toList()
          as T;
    }
    if (t == List<_if8k345z.PolicyCertificate>) {
      return (data as List)
              .map((e) => deserialize<_if8k345z.PolicyCertificate>(e))
              .toList()
          as T;
    }
    if (t == List<_i9q7wk1a.SmtpTestNotice>) {
      return (data as List)
              .map((e) => deserialize<_i9q7wk1a.SmtpTestNotice>(e))
              .toList()
          as T;
    }
    if (t == List<_is.UuidValue>) {
      return (data as List).map((e) => deserialize<_is.UuidValue>(e)).toList()
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
    className = _iacs.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    className = _iais.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _i3xu12wm.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'wonkru_core.$className';
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
      return _iacs.Protocol().deserializeByClassName({
        ...data,
        'className': dataClassName.substring(20),
      });
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      return _iais.Protocol().deserializeByClassName({
        ...data,
        'className': dataClassName.substring(19),
      });
    }
    if (dataClassName.startsWith('wonkru_core.')) {
      return _i3xu12wm.Protocol().deserializeByClassName({
        ...data,
        'className': dataClassName.substring(12),
      });
    }
    if (dataClassName.startsWith('serverpod.')) {
      return _isp.Protocol().deserializeByClassName({
        ...data,
        'className': dataClassName.substring(10),
      });
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iacs.Protocol().registerHostProtocol('wonkru_mdm', this);
    _iais.Protocol().registerHostProtocol('wonkru_mdm', this);
    _i3xu12wm.Protocol().registerHostProtocol('wonkru_mdm', this);
  }

  @override
  _is.Table? getTableForType(Type t) {
    {
      var table = _iacs.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _iais.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i3xu12wm.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _isp.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _ilkbs9no.AdminActivity:
        return _ilkbs9no.AdminActivity.t;
      case _ijjkm6ii.AdminNotification:
        return _ijjkm6ii.AdminNotification.t;
      case _iatoqpz1.AdminProfile:
        return _iatoqpz1.AdminProfile.t;
      case _i8418qom.AdminTotpSession:
        return _i8418qom.AdminTotpSession.t;
      case _ice4s91e.Application:
        return _ice4s91e.Application.t;
      case _il9v10p8.ApplicationVersion:
        return _il9v10p8.ApplicationVersion.t;
      case _i0cezxmz.Certificate:
        return _i0cezxmz.Certificate.t;
      case _ilo09f9g.Device:
        return _ilo09f9g.Device.t;
      case _iowtu5tn.DeviceApplication:
        return _iowtu5tn.DeviceApplication.t;
      case _i7oasmb9.DeviceCommand:
        return _i7oasmb9.DeviceCommand.t;
      case _iaeyllp0.DeviceDeviceGroup:
        return _iaeyllp0.DeviceDeviceGroup.t;
      case _i94jjjz5.DeviceGroup:
        return _i94jjjz5.DeviceGroup.t;
      case _iw5fr9ey.DeviceLog:
        return _iw5fr9ey.DeviceLog.t;
      case _ixgsn4mm.DeviceNotification:
        return _ixgsn4mm.DeviceNotification.t;
      case _i5gkie1y.DeviceNotificationDevice:
        return _i5gkie1y.DeviceNotificationDevice.t;
      case _ionnmq05.DeviceReport:
        return _ionnmq05.DeviceReport.t;
      case _iedh5c79.DeviceStateCache:
        return _iedh5c79.DeviceStateCache.t;
      case _ijb003y9.DeviceSync:
        return _ijb003y9.DeviceSync.t;
      case _i44ond0u.FileAsset:
        return _i44ond0u.FileAsset.t;
      case _i8zsj03n.FileGroup:
        return _i8zsj03n.FileGroup.t;
      case _iqgn8zc1.FileGroupMember:
        return _iqgn8zc1.FileGroupMember.t;
      case _if7d246m.Policy:
        return _if7d246m.Policy.t;
      case _ifuhrcyn.PolicyApplication:
        return _ifuhrcyn.PolicyApplication.t;
      case _i867w0wl.PolicyCertificate:
        return _i867w0wl.PolicyCertificate.t;
      case _ircfqpf1.PolicyFile:
        return _ircfqpf1.PolicyFile.t;
      case _i6rve9c0.ProvisioningProfile:
        return _i6rve9c0.ProvisioningProfile.t;
      case _inngxkda.Setting:
        return _inngxkda.Setting.t;
    }
    return null;
  }

  @override
  List<_isp.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  List<_isp.TableDefinition> getOwnTableDefinitions() => _ownTableDefinitions;

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
      return _iacs.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iais.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i3xu12wm.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
