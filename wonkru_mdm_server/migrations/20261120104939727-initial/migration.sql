BEGIN;

--
-- Function: gen_random_uuid_v7()
-- Source: https://gist.github.com/kjmph/5bd772b2c2df145aa645b837da7eca74
-- License: MIT (copyright notice included on the generator source code).
--
create or replace function gen_random_uuid_v7()
returns uuid
as $$
begin
  -- use random v4 uuid as starting point (which has the same variant we need)
  -- then overlay timestamp
  -- then set version 7 by flipping the 2 and 1 bit in the version 4 string
  return encode(
    set_bit(
      set_bit(
        overlay(uuid_send(gen_random_uuid())
                placing substring(int8send(floor(extract(epoch from clock_timestamp()) * 1000)::bigint) from 3)
                from 1 for 6
        ),
        52, 1
      ),
      53, 1
    ),
    'hex')::uuid;
end
$$
language plpgsql
volatile;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "admin_activities" (
    "id" bigserial PRIMARY KEY,
    "actorUserId" uuid,
    "actorEmail" text,
    "actorName" text,
    "action" text NOT NULL,
    "targetType" text,
    "targetId" text,
    "data" text,
    "ipAddress" text,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "admin_activities_actor_user_id_index" ON "admin_activities" USING btree ("actorUserId");
CREATE INDEX "admin_activities_action_index" ON "admin_activities" USING btree ("action");
CREATE INDEX "admin_activities_created_at_index" ON "admin_activities" USING btree ("createdAt");
CREATE INDEX "admin_activities_target_index" ON "admin_activities" USING btree ("targetType", "targetId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "admin_notifications" (
    "id" bigserial PRIMARY KEY,
    "userId" uuid NOT NULL,
    "type" text NOT NULL,
    "title" text NOT NULL,
    "message" text NOT NULL,
    "data" text,
    "readAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "admin_notifications_user_id_index" ON "admin_notifications" USING btree ("userId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "admin_profiles" (
    "id" bigserial PRIMARY KEY,
    "userId" uuid NOT NULL,
    "status" text NOT NULL DEFAULT 'disabled'::text,
    "totpSecret" text,
    "recoveryCodes" text,
    "totpLastUsedCounter" bigint,
    "lastLoginAt" timestamp without time zone,
    "totpFailedAttempts" bigint NOT NULL,
    "totpLockedUntil" timestamp without time zone,
    "createdAt" timestamp without time zone,
    "updatedAt" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "admin_profiles_user_id_unique" ON "admin_profiles" USING btree ("userId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "admin_totp_sessions" (
    "id" bigserial PRIMARY KEY,
    "userId" uuid NOT NULL,
    "sessionId" text NOT NULL,
    "verifiedUntil" timestamp without time zone NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "admin_totp_sessions_session_id_unique" ON "admin_totp_sessions" USING btree ("sessionId");
CREATE INDEX "admin_totp_sessions_user_id_index" ON "admin_totp_sessions" USING btree ("userId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "application_versions" (
    "id" bigserial PRIMARY KEY,
    "applicationId" bigint NOT NULL,
    "versionName" text NOT NULL,
    "versionCode" bigint NOT NULL,
    "filePath" text,
    "fileSizeBytes" bigint,
    "checksumSha256" text,
    "minSdkVersion" bigint,
    "targetSdkVersion" bigint,
    "isActive" boolean NOT NULL,
    "permissions" text,
    "isDefault" boolean NOT NULL,
    "createdAt" timestamp without time zone,
    "updatedAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "application_versions_application_id_foreign" ON "application_versions" USING btree ("applicationId");
CREATE UNIQUE INDEX "application_versions_application_id_version_code_unique" ON "application_versions" USING btree ("applicationId", "versionCode");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "applications" (
    "id" bigserial PRIMARY KEY,
    "packageName" text NOT NULL,
    "appName" text NOT NULL,
    "developerName" text,
    "iconUrl" text,
    "category" text,
    "sourceType" text,
    "isSystemApp" boolean NOT NULL,
    "createdAt" timestamp without time zone,
    "updatedAt" timestamp without time zone,
    "deletedAt" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "applications_package_name_unique" ON "applications" USING btree ("packageName");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "certificates" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "description" text,
    "certificateType" text NOT NULL,
    "certificateData" text NOT NULL,
    "privateKeyData" text,
    "format" text NOT NULL,
    "issuer" text,
    "subject" text,
    "serialNumber" text,
    "fingerprintSha256" text,
    "validFrom" timestamp without time zone,
    "validUntil" timestamp without time zone,
    "isActive" boolean NOT NULL,
    "createdAt" timestamp without time zone,
    "updatedAt" timestamp without time zone,
    "deletedAt" timestamp without time zone,
    "filePath" text,
    "fileHash" text,
    "password" text
);

-- Indexes
CREATE UNIQUE INDEX "certificates_fingerprint_sha256_unique" ON "certificates" USING btree ("fingerprintSha256");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "device_applications" (
    "id" bigserial PRIMARY KEY,
    "deviceId" bigint NOT NULL,
    "packageName" text NOT NULL,
    "appName" text NOT NULL,
    "versionName" text,
    "versionCode" bigint,
    "isSystemApp" boolean NOT NULL,
    "isUninstallBlocked" boolean NOT NULL,
    "isPowerSaveWhitelisted" boolean,
    "lastSeenAt" timestamp without time zone,
    "createdAt" timestamp without time zone,
    "updatedAt" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "device_applications_device_id_package_name_unique" ON "device_applications" USING btree ("deviceId", "packageName");
CREATE INDEX "device_applications_package_name_index" ON "device_applications" USING btree ("packageName");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "device_commands" (
    "id" bigserial PRIMARY KEY,
    "deviceId" bigint NOT NULL,
    "commandId" text NOT NULL,
    "bulkId" text,
    "action" text NOT NULL,
    "params" text,
    "status" text NOT NULL,
    "attempts" bigint NOT NULL,
    "response" text,
    "createdAt" timestamp without time zone,
    "sentAt" timestamp without time zone,
    "ackedAt" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "device_commands_command_id_unique" ON "device_commands" USING btree ("commandId");
CREATE INDEX "device_commands_device_id_index" ON "device_commands" USING btree ("deviceId");
CREATE INDEX "device_commands_status_index" ON "device_commands" USING btree ("status");
CREATE INDEX "device_commands_bulk_id_index" ON "device_commands" USING btree ("bulkId");
CREATE INDEX "idx_device_commands_device_status" ON "device_commands" USING btree ("deviceId", "status");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "device_device_group" (
    "id" bigserial PRIMARY KEY,
    "deviceId" bigint NOT NULL,
    "deviceGroupId" bigint NOT NULL,
    "createdAt" timestamp without time zone,
    "updatedAt" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "device_device_group_device_id_device_group_id_unique" ON "device_device_group" USING btree ("deviceId", "deviceGroupId");
CREATE INDEX "device_device_group_device_group_id_foreign" ON "device_device_group" USING btree ("deviceGroupId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "device_groups" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "description" text,
    "createdAt" timestamp without time zone,
    "updatedAt" timestamp without time zone,
    "deletedAt" timestamp without time zone
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "device_logs" (
    "id" bigserial PRIMARY KEY,
    "deviceId" bigint NOT NULL,
    "entryUuid" text,
    "sessionId" text,
    "loggedAt" timestamp without time zone,
    "level" bigint NOT NULL,
    "tag" text,
    "message" text NOT NULL,
    "stacktrace" text,
    "createdAt" timestamp without time zone,
    "updatedAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "device_logs_logged_at_index" ON "device_logs" USING btree ("loggedAt");
CREATE INDEX "device_logs_level_index" ON "device_logs" USING btree ("level");
CREATE INDEX "device_logs_tag_index" ON "device_logs" USING btree ("tag");
CREATE INDEX "device_logs_device_id_logged_at_index" ON "device_logs" USING btree ("deviceId", "loggedAt");
CREATE INDEX "device_logs_session_id_index" ON "device_logs" USING btree ("sessionId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "device_notification_devices" (
    "id" bigserial PRIMARY KEY,
    "deviceNotificationId" bigint NOT NULL,
    "deviceId" bigint NOT NULL,
    "status" text NOT NULL,
    "sentAt" timestamp without time zone,
    "receivedAt" timestamp without time zone,
    "createdAt" timestamp without time zone,
    "updatedAt" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "device_notification_device_unique" ON "device_notification_devices" USING btree ("deviceNotificationId", "deviceId");
CREATE INDEX "device_notification_devices_status_index" ON "device_notification_devices" USING btree ("status");
CREATE INDEX "device_notification_devices_sent_at_index" ON "device_notification_devices" USING btree ("sentAt");
CREATE INDEX "device_notification_devices_received_at_index" ON "device_notification_devices" USING btree ("receivedAt");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "device_notifications" (
    "id" bigserial PRIMARY KEY,
    "uuid" text,
    "title" text NOT NULL,
    "message" text NOT NULL,
    "type" text NOT NULL,
    "extra" text,
    "sentAt" timestamp without time zone,
    "createdAt" timestamp without time zone,
    "updatedAt" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "device_notifications_uuid_unique" ON "device_notifications" USING btree ("uuid");
CREATE INDEX "device_notifications_sent_at_index" ON "device_notifications" USING btree ("sentAt");
CREATE INDEX "device_notifications_type_index" ON "device_notifications" USING btree ("type");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "device_reports" (
    "id" bigserial PRIMARY KEY,
    "deviceId" bigint NOT NULL,
    "type" text NOT NULL,
    "payload" text NOT NULL,
    "createdAt" timestamp without time zone,
    "updatedAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "device_reports_type_index" ON "device_reports" USING btree ("type");
CREATE INDEX "device_reports_device_id_index" ON "device_reports" USING btree ("deviceId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "device_state_cache" (
    "id" bigserial PRIMARY KEY,
    "deviceId" bigint NOT NULL,
    "deviceSyncId" bigint NOT NULL,
    "collectedAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "manufacturer" text,
    "model" text,
    "brand" text,
    "androidVersion" text,
    "sdkInt" bigint,
    "securityPatch" text,
    "buildFingerprint" text,
    "isPhysicalDevice" boolean,
    "isLowRamDevice" boolean,
    "batteryLevel" bigint,
    "batteryState" text,
    "isPowerSaveMode" boolean,
    "isOnline" boolean,
    "currentSsid" text,
    "currentBssid" text,
    "wifiRssi" bigint,
    "wifiLinkSpeed" bigint,
    "wifiFrequency" bigint,
    "ipv4" text,
    "ipv6" text,
    "gateway" text,
    "subnetMask" text,
    "networkLastSsid" text,
    "isRooted" boolean,
    "adbEnabled" boolean,
    "developerOptionsEnabled" boolean,
    "unknownSourcesAllowed" boolean,
    "encryptionStatus" text,
    "playProtectStatus" boolean,
    "passwordIsSufficient" boolean,
    "passwordQuality" bigint,
    "passwordComplexityLevel" bigint,
    "hasSecureLock" boolean,
    "isLocked" boolean,
    "isDeviceOwner" boolean,
    "totalStorageBytes" bigint,
    "freeStorageBytes" bigint,
    "usedStorageBytes" bigint,
    "storageUsagePct" double precision,
    "storageFreePct" double precision,
    "totalInstalledApps" bigint,
    "systemAppsCount" bigint,
    "userAppsCount" bigint,
    "managedAppsCount" bigint,
    "installedCaCertCount" bigint,
    "hasWonkruMdmCa" boolean,
    "hasWonkruLocalCa" boolean,
    "brightness" bigint,
    "screenTimeoutMs" bigint,
    "screenWidthPx" bigint,
    "screenHeightPx" bigint,
    "launcherModeEnabled" boolean,
    "watchdogServiceEnabled" boolean,
    "flutterAliveAt" timestamp without time zone,
    "bsDeviceUuid" text,
    "bsDeviceCode" text,
    "serverUrl" text,
    "stDeviceUuid" text,
    "stDeviceCode" text,
    "lastPolicyUpdateAt" timestamp without time zone,
    "lastConfigFetchTime" text,
    "stLastSyncAt" timestamp without time zone,
    "restrictionCount" bigint
);

-- Indexes
CREATE UNIQUE INDEX "device_state_cache_device_id_unique" ON "device_state_cache" USING btree ("deviceId");
CREATE UNIQUE INDEX "uq_dsc_sync" ON "device_state_cache" USING btree ("deviceSyncId");
CREATE INDEX "idx_dsc_collected_at" ON "device_state_cache" USING btree ("collectedAt");
CREATE INDEX "idx_dsc_is_online" ON "device_state_cache" USING btree ("isOnline");
CREATE INDEX "idx_dsc_battery_level" ON "device_state_cache" USING btree ("batteryLevel");
CREATE INDEX "idx_dsc_storage_pct" ON "device_state_cache" USING btree ("storageUsagePct");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "device_syncs" (
    "id" bigserial PRIMARY KEY,
    "deviceId" bigint NOT NULL,
    "collectedAt" timestamp without time zone NOT NULL,
    "syncType" text,
    "deviceInfo" text,
    "mdmAppInfo" text,
    "appsInfo" text,
    "audioInfo" text,
    "batteryInfo" text,
    "certificatesInfo" text,
    "displayInfo" text,
    "networkInfo" text,
    "notificationInfo" text,
    "restrictionsInfo" text,
    "securityInfo" text,
    "storageInfo" text,
    "systemInfo" text,
    "otherInfo" text,
    "bsInfo" text,
    "stInfo" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "device_syncs_device_id_index" ON "device_syncs" USING btree ("deviceId");
CREATE INDEX "device_syncs_collected_at_index" ON "device_syncs" USING btree ("collectedAt");
CREATE INDEX "device_syncs_device_id_collected_at_index" ON "device_syncs" USING btree ("deviceId", "collectedAt");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "devices" (
    "id" bigserial PRIMARY KEY,
    "code" text NOT NULL,
    "uuid" text,
    "name" text,
    "authToken" text,
    "policyId" bigint,
    "policyVersion" bigint,
    "lastPolicyUpdate" timestamp without time zone,
    "groupId" bigint,
    "userId" uuid,
    "manufacturer" text,
    "model" text,
    "brand" text,
    "serialNo" text,
    "androidVersion" text,
    "sdkVersion" bigint,
    "agentVersionName" text,
    "agentVersionCode" bigint,
    "batteryLevel" bigint,
    "ipAddress" text,
    "isRooted" boolean NOT NULL,
    "isLauncherMode" boolean NOT NULL,
    "totalStorageBytes" bigint,
    "freeStorageBytes" bigint,
    "collectedAt" timestamp without time zone,
    "lastSeenAt" timestamp without time zone,
    "firstSeenAt" timestamp without time zone,
    "createdAt" timestamp without time zone,
    "updatedAt" timestamp without time zone,
    "deletedAt" timestamp without time zone,
    "mustUseApplications" text
);

-- Indexes
CREATE UNIQUE INDEX "devices_code_unique" ON "devices" USING btree ("code");
CREATE UNIQUE INDEX "devices_uuid_unique" ON "devices" USING btree ("uuid");
CREATE UNIQUE INDEX "devices_auth_token_unique" ON "devices" USING btree ("authToken");
CREATE INDEX "devices_policy_id_index" ON "devices" USING btree ("policyId");
CREATE INDEX "devices_group_id_index" ON "devices" USING btree ("groupId");
CREATE INDEX "devices_manufacturer_index" ON "devices" USING btree ("manufacturer");
CREATE INDEX "devices_model_index" ON "devices" USING btree ("model");
CREATE INDEX "devices_android_version_index" ON "devices" USING btree ("androidVersion");
CREATE INDEX "devices_is_rooted_index" ON "devices" USING btree ("isRooted");
CREATE INDEX "devices_collected_at_index" ON "devices" USING btree ("collectedAt");
CREATE INDEX "devices_last_seen_at_index" ON "devices" USING btree ("lastSeenAt");
CREATE INDEX "devices_name_index" ON "devices" USING btree ("name");
CREATE INDEX "devices_user_id_index" ON "devices" USING btree ("userId");
CREATE INDEX "idx_devices_group_deleted" ON "devices" USING btree ("groupId", "deletedAt");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "file_group_members" (
    "id" bigserial PRIMARY KEY,
    "fileId" bigint NOT NULL,
    "fileGroupId" bigint NOT NULL,
    "createdAt" timestamp without time zone,
    "updatedAt" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "file_group_members_file_id_file_group_id_unique" ON "file_group_members" USING btree ("fileId", "fileGroupId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "file_groups" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "description" text,
    "color" text,
    "isActive" boolean NOT NULL,
    "createdAt" timestamp without time zone,
    "updatedAt" timestamp without time zone
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "files" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "customName" text,
    "fileExtension" text,
    "filePath" text NOT NULL,
    "publicUrl" text,
    "mimeType" text,
    "sizeBytes" bigint NOT NULL,
    "fileHashSha256" text,
    "disk" text,
    "deviceId" bigint,
    "createdAt" timestamp without time zone,
    "updatedAt" timestamp without time zone
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "policies" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "slug" text,
    "description" text,
    "activeTimeRanges" text,
    "isActive" boolean NOT NULL,
    "version" bigint NOT NULL,
    "defaultPolicy" boolean NOT NULL,
    "adminPassword" text,
    "batterySettings" text,
    "storageSettings" text,
    "audioSettings" text,
    "displaySettings" text,
    "securitySettings" text,
    "restrictionSettings" text,
    "launcher" text,
    "syncSettings" text,
    "otherSettings" text,
    "createdAt" timestamp without time zone,
    "updatedAt" timestamp without time zone,
    "deletedAt" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "policies_slug_unique" ON "policies" USING btree ("slug");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "policy_applications" (
    "id" bigserial PRIMARY KEY,
    "policyId" bigint NOT NULL,
    "sort" bigint NOT NULL,
    "applicationId" bigint NOT NULL,
    "targetVersionId" bigint,
    "action" text NOT NULL,
    "showLauncher" boolean NOT NULL,
    "customAppName" text,
    "runOnBoot" boolean NOT NULL,
    "updatePolicy" text,
    "startAfterInstall" boolean NOT NULL,
    "uninstallBlock" boolean NOT NULL,
    "createdAt" timestamp without time zone,
    "updatedAt" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "policy_applications_policy_id_application_id_unique" ON "policy_applications" USING btree ("policyId", "applicationId");
CREATE INDEX "policy_applications_target_version_id_foreign" ON "policy_applications" USING btree ("targetVersionId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "policy_certificates" (
    "id" bigserial PRIMARY KEY,
    "policyId" bigint NOT NULL,
    "certificateId" bigint NOT NULL,
    "action" text,
    "createdAt" timestamp without time zone,
    "updatedAt" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "policy_certificates_policy_id_certificate_id_unique" ON "policy_certificates" USING btree ("policyId", "certificateId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "policy_files" (
    "id" bigserial PRIMARY KEY,
    "policyId" bigint NOT NULL,
    "fileId" bigint,
    "usageType" text NOT NULL,
    "destinationPath" text,
    "replaceIfExists" boolean NOT NULL,
    "openAfterDownload" boolean NOT NULL,
    "createdAt" timestamp without time zone,
    "updatedAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "policy_files_policy_id_foreign" ON "policy_files" USING btree ("policyId");
CREATE INDEX "policy_files_file_id_foreign" ON "policy_files" USING btree ("fileId");
CREATE UNIQUE INDEX "policy_files_policy_id_file_id_unique" ON "policy_files" USING btree ("policyId", "fileId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "provisioning_profiles" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "description" text,
    "config" text NOT NULL,
    "isActive" boolean NOT NULL,
    "createdById" uuid,
    "createdAt" timestamp without time zone,
    "updatedAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "provisioning_profiles_created_by_foreign" ON "provisioning_profiles" USING btree ("createdById");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "settings" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "value" text,
    "createdAt" timestamp without time zone,
    "updatedAt" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "settings_name_unique" ON "settings" USING btree ("name");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_cloud_storage" (
    "id" bigserial PRIMARY KEY,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "addedTime" timestamp without time zone NOT NULL,
    "expiration" timestamp without time zone,
    "byteData" bytea NOT NULL,
    "verified" boolean NOT NULL,
    "contentType" text,
    "cacheControl" text,
    "contentDisposition" text,
    "contentEncoding" text,
    "customMetadata" text
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_path_idx" ON "serverpod_cloud_storage" USING btree ("storageId", "path");
CREATE INDEX "serverpod_cloud_storage_expiration" ON "serverpod_cloud_storage" USING btree ("expiration");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_cloud_storage_direct_download" (
    "id" bigserial PRIMARY KEY,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "expiration" timestamp without time zone NOT NULL,
    "authKey" text NOT NULL,
    "downloadFileName" text,
    "contentType" text
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_direct_download_auth_key" ON "serverpod_cloud_storage_direct_download" USING btree ("authKey");
CREATE INDEX "serverpod_cloud_storage_direct_download_expiration" ON "serverpod_cloud_storage_direct_download" USING btree ("expiration");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_cloud_storage_direct_upload" (
    "id" bigserial PRIMARY KEY,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "expiration" timestamp without time zone NOT NULL,
    "authKey" text NOT NULL,
    "maxFileSize" bigint NOT NULL DEFAULT 10485760,
    "contentLength" bigint,
    "preventOverwrite" boolean NOT NULL DEFAULT false,
    "contentType" text,
    "cacheControl" text,
    "contentDisposition" text,
    "contentEncoding" text,
    "customMetadata" text
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_direct_upload_storage_path" ON "serverpod_cloud_storage_direct_upload" USING btree ("storageId", "path");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_future_call" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "serializedObject" text,
    "serverId" text NOT NULL,
    "identifier" text,
    "scheduling" json
);

-- Indexes
CREATE INDEX "serverpod_future_call_time_idx" ON "serverpod_future_call" USING btree ("time");
CREATE INDEX "serverpod_future_call_serverId_idx" ON "serverpod_future_call" USING btree ("serverId");
CREATE INDEX "serverpod_future_call_identifier_idx" ON "serverpod_future_call" USING btree ("identifier");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_future_call_claim" (
    "id" bigserial PRIMARY KEY,
    "futureCallId" bigint,
    "lastHeartbeatTime" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "future_call_unique_idx" ON "serverpod_future_call_claim" USING btree ("futureCallId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_health_connection_info" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "active" bigint NOT NULL,
    "closing" bigint NOT NULL,
    "idle" bigint NOT NULL,
    "granularity" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_health_connection_info_timestamp_idx" ON "serverpod_health_connection_info" USING btree ("timestamp", "serverId", "granularity");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_health_metric" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "serverId" text NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "isHealthy" boolean NOT NULL,
    "value" double precision NOT NULL,
    "granularity" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_health_metric_timestamp_idx" ON "serverpod_health_metric" USING btree ("timestamp", "serverId", "name", "granularity");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_log" (
    "id" bigserial PRIMARY KEY,
    "sessionLogId" bigint NOT NULL,
    "messageId" bigint,
    "reference" text,
    "serverId" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "logLevel" bigint NOT NULL,
    "message" text NOT NULL,
    "error" text,
    "stackTrace" text,
    "order" bigint NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_log_sessionLogId_idx" ON "serverpod_log" USING btree ("sessionLogId", "order");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_message_log" (
    "id" bigserial PRIMARY KEY,
    "sessionLogId" bigint NOT NULL,
    "serverId" text NOT NULL,
    "messageId" bigint NOT NULL,
    "endpoint" text NOT NULL,
    "messageName" text NOT NULL,
    "duration" double precision NOT NULL,
    "error" text,
    "stackTrace" text,
    "slow" boolean NOT NULL,
    "order" bigint NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_message_log_sessionLogId_idx" ON "serverpod_message_log" USING btree ("sessionLogId", "order");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_method" (
    "id" bigserial PRIMARY KEY,
    "endpoint" text NOT NULL,
    "method" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_method_endpoint_method_idx" ON "serverpod_method" USING btree ("endpoint", "method");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_migrations" (
    "id" bigserial PRIMARY KEY,
    "module" text NOT NULL,
    "version" text NOT NULL,
    "timestamp" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_migrations_ids" ON "serverpod_migrations" USING btree ("module");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_query_log" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "sessionLogId" bigint NOT NULL,
    "messageId" bigint,
    "query" text NOT NULL,
    "duration" double precision NOT NULL,
    "numRows" bigint,
    "error" text,
    "stackTrace" text,
    "slow" boolean NOT NULL,
    "order" bigint NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_query_log_sessionLogId_idx" ON "serverpod_query_log" USING btree ("sessionLogId", "order");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_readwrite_test" (
    "id" bigserial PRIMARY KEY,
    "number" bigint NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_runtime_settings" (
    "id" bigserial PRIMARY KEY,
    "logSettings" json NOT NULL,
    "logSettingsOverrides" json NOT NULL,
    "logServiceCalls" boolean NOT NULL,
    "logMalformedCalls" boolean NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_session_log" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "module" text,
    "endpoint" text,
    "method" text,
    "duration" double precision,
    "numQueries" bigint,
    "slow" boolean,
    "error" text,
    "stackTrace" text,
    "authenticatedUserId" bigint,
    "userId" text,
    "isOpen" boolean,
    "touched" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_session_log_serverid_idx" ON "serverpod_session_log" USING btree ("serverId");
CREATE INDEX "serverpod_session_log_time_idx" ON "serverpod_session_log" USING btree ("time");
CREATE INDEX "serverpod_session_log_touched_idx" ON "serverpod_session_log" USING btree ("touched");
CREATE INDEX "serverpod_session_log_isopen_idx" ON "serverpod_session_log" USING btree ("isOpen");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_core_jwt_refresh_token" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "scopeNames" json NOT NULL,
    "extraClaims" text,
    "method" text NOT NULL,
    "fixedSecret" bytea NOT NULL,
    "rotatingSecretHash" text NOT NULL,
    "lastUpdatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "serverpod_auth_core_jwt_refresh_token_last_updated_at" ON "serverpod_auth_core_jwt_refresh_token" USING btree ("lastUpdatedAt");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_core_profile" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "userName" text,
    "fullName" text,
    "email" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "imageId" uuid
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_profile_user_profile_email_auth_user_id" ON "serverpod_auth_core_profile" USING btree ("authUserId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_core_profile_image" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "userProfileId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "url" text NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_core_session" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "scopeNames" json NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lastUsedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expiresAt" timestamp without time zone,
    "expireAfterUnusedFor" bigint,
    "sessionKeyHash" bytea NOT NULL,
    "sessionKeySalt" bytea NOT NULL,
    "method" text NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_core_user" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "createdAt" timestamp without time zone NOT NULL,
    "scopeNames" json NOT NULL,
    "blocked" boolean NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_idp_anonymous_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_idp_apple_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "userIdentifier" text NOT NULL,
    "refreshToken" text NOT NULL,
    "refreshTokenRequestedWithBundleIdentifier" boolean NOT NULL,
    "lastRefreshedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "email" text,
    "isEmailVerified" boolean,
    "isPrivateEmail" boolean,
    "firstName" text,
    "lastName" text
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_apple_account_identifier" ON "serverpod_auth_idp_apple_account" USING btree ("userIdentifier");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_idp_email_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "email" text NOT NULL,
    "passwordHash" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_idp_email_account_email" ON "serverpod_auth_idp_email_account" USING btree ("email");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_idp_email_account_otp_login_request" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "email" text NOT NULL,
    "challengeId" uuid NOT NULL,
    "completeChallengeId" uuid
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_idp_email_account_otp_login_request_email" ON "serverpod_auth_idp_email_account_otp_login_request" USING btree ("email");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_idp_email_account_password_reset_request" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "emailAccountId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "challengeId" uuid NOT NULL,
    "setPasswordChallengeId" uuid
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_idp_email_account_request" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "email" text NOT NULL,
    "challengeId" uuid NOT NULL,
    "createAccountChallengeId" uuid
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_idp_email_account_request_email" ON "serverpod_auth_idp_email_account_request" USING btree ("email");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_idp_facebook_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "userIdentifier" text NOT NULL,
    "email" text,
    "fullName" text,
    "firstName" text,
    "lastName" text
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_facebook_account_user_identifier" ON "serverpod_auth_idp_facebook_account" USING btree ("userIdentifier");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_idp_firebase_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "created" timestamp without time zone NOT NULL,
    "email" text,
    "phone" text,
    "userIdentifier" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_firebase_account_user_identifier" ON "serverpod_auth_idp_firebase_account" USING btree ("userIdentifier");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_idp_github_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "userIdentifier" text NOT NULL,
    "email" text,
    "created" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_github_account_user_identifier" ON "serverpod_auth_idp_github_account" USING btree ("userIdentifier");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_idp_google_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "created" timestamp without time zone NOT NULL,
    "email" text NOT NULL,
    "userIdentifier" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_google_account_user_identifier" ON "serverpod_auth_idp_google_account" USING btree ("userIdentifier");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_idp_microsoft_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "userIdentifier" text NOT NULL,
    "email" text,
    "created" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_microsoft_account_user_identifier" ON "serverpod_auth_idp_microsoft_account" USING btree ("userIdentifier");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_idp_passkey_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "keyId" bytea NOT NULL,
    "keyIdBase64" text NOT NULL,
    "clientDataJSON" bytea NOT NULL,
    "attestationObject" bytea NOT NULL,
    "originalChallenge" bytea NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_idp_passkey_account_key_id_base64" ON "serverpod_auth_idp_passkey_account" USING btree ("keyIdBase64");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_idp_passkey_challenge" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "createdAt" timestamp without time zone NOT NULL,
    "challenge" bytea NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_idp_rate_limited_request_attempt" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "domain" text NOT NULL,
    "source" text NOT NULL,
    "key" text NOT NULL,
    "ipAddress" text,
    "attemptedAt" timestamp without time zone NOT NULL,
    "extraData" json
);

-- Indexes
CREATE INDEX "serverpod_auth_idp_rate_limited_request_attempt_composite" ON "serverpod_auth_idp_rate_limited_request_attempt" USING btree ("domain", "source", "key", "attemptedAt");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_idp_secret_challenge" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "challengeCodeHash" text NOT NULL
);

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "application_versions"
    ADD CONSTRAINT "application_versions_fk_0"
    FOREIGN KEY("applicationId")
    REFERENCES "applications"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "device_applications"
    ADD CONSTRAINT "device_applications_fk_0"
    FOREIGN KEY("deviceId")
    REFERENCES "devices"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "device_commands"
    ADD CONSTRAINT "device_commands_fk_0"
    FOREIGN KEY("deviceId")
    REFERENCES "devices"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "device_device_group"
    ADD CONSTRAINT "device_device_group_fk_0"
    FOREIGN KEY("deviceId")
    REFERENCES "devices"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "device_device_group"
    ADD CONSTRAINT "device_device_group_fk_1"
    FOREIGN KEY("deviceGroupId")
    REFERENCES "device_groups"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "device_logs"
    ADD CONSTRAINT "device_logs_fk_0"
    FOREIGN KEY("deviceId")
    REFERENCES "devices"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "device_notification_devices"
    ADD CONSTRAINT "device_notification_devices_fk_0"
    FOREIGN KEY("deviceNotificationId")
    REFERENCES "device_notifications"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "device_notification_devices"
    ADD CONSTRAINT "device_notification_devices_fk_1"
    FOREIGN KEY("deviceId")
    REFERENCES "devices"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "device_reports"
    ADD CONSTRAINT "device_reports_fk_0"
    FOREIGN KEY("deviceId")
    REFERENCES "devices"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "device_state_cache"
    ADD CONSTRAINT "device_state_cache_fk_0"
    FOREIGN KEY("deviceId")
    REFERENCES "devices"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "device_state_cache"
    ADD CONSTRAINT "device_state_cache_fk_1"
    FOREIGN KEY("deviceSyncId")
    REFERENCES "device_syncs"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "device_syncs"
    ADD CONSTRAINT "device_syncs_fk_0"
    FOREIGN KEY("deviceId")
    REFERENCES "devices"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "devices"
    ADD CONSTRAINT "devices_fk_0"
    FOREIGN KEY("policyId")
    REFERENCES "policies"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "devices"
    ADD CONSTRAINT "devices_fk_1"
    FOREIGN KEY("groupId")
    REFERENCES "device_groups"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "file_group_members"
    ADD CONSTRAINT "file_group_members_fk_0"
    FOREIGN KEY("fileId")
    REFERENCES "files"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "file_group_members"
    ADD CONSTRAINT "file_group_members_fk_1"
    FOREIGN KEY("fileGroupId")
    REFERENCES "file_groups"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "files"
    ADD CONSTRAINT "files_fk_0"
    FOREIGN KEY("deviceId")
    REFERENCES "devices"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "policy_applications"
    ADD CONSTRAINT "policy_applications_fk_0"
    FOREIGN KEY("policyId")
    REFERENCES "policies"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "policy_applications"
    ADD CONSTRAINT "policy_applications_fk_1"
    FOREIGN KEY("applicationId")
    REFERENCES "applications"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "policy_applications"
    ADD CONSTRAINT "policy_applications_fk_2"
    FOREIGN KEY("targetVersionId")
    REFERENCES "application_versions"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "policy_certificates"
    ADD CONSTRAINT "policy_certificates_fk_0"
    FOREIGN KEY("policyId")
    REFERENCES "policies"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "policy_certificates"
    ADD CONSTRAINT "policy_certificates_fk_1"
    FOREIGN KEY("certificateId")
    REFERENCES "certificates"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "policy_files"
    ADD CONSTRAINT "policy_files_fk_0"
    FOREIGN KEY("policyId")
    REFERENCES "policies"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "policy_files"
    ADD CONSTRAINT "policy_files_fk_1"
    FOREIGN KEY("fileId")
    REFERENCES "files"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_future_call_claim"
    ADD CONSTRAINT "serverpod_future_call_claim_fk_0"
    FOREIGN KEY("futureCallId")
    REFERENCES "serverpod_future_call"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_log"
    ADD CONSTRAINT "serverpod_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_message_log"
    ADD CONSTRAINT "serverpod_message_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_query_log"
    ADD CONSTRAINT "serverpod_query_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_auth_core_jwt_refresh_token"
    ADD CONSTRAINT "serverpod_auth_core_jwt_refresh_token_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_auth_core_profile"
    ADD CONSTRAINT "serverpod_auth_core_profile_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "serverpod_auth_core_profile"
    ADD CONSTRAINT "serverpod_auth_core_profile_fk_1"
    FOREIGN KEY("imageId")
    REFERENCES "serverpod_auth_core_profile_image"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    DEFERRABLE INITIALLY DEFERRED;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_auth_core_profile_image"
    ADD CONSTRAINT "serverpod_auth_core_profile_image_fk_0"
    FOREIGN KEY("userProfileId")
    REFERENCES "serverpod_auth_core_profile"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_auth_core_session"
    ADD CONSTRAINT "serverpod_auth_core_session_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_auth_idp_anonymous_account"
    ADD CONSTRAINT "serverpod_auth_idp_anonymous_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_auth_idp_apple_account"
    ADD CONSTRAINT "serverpod_auth_idp_apple_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_auth_idp_email_account"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_auth_idp_email_account_otp_login_request"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_otp_login_request_fk_0"
    FOREIGN KEY("challengeId")
    REFERENCES "serverpod_auth_idp_secret_challenge"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "serverpod_auth_idp_email_account_otp_login_request"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_otp_login_request_fk_1"
    FOREIGN KEY("completeChallengeId")
    REFERENCES "serverpod_auth_idp_secret_challenge"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_auth_idp_email_account_password_reset_request"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_password_reset_request_fk_0"
    FOREIGN KEY("emailAccountId")
    REFERENCES "serverpod_auth_idp_email_account"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "serverpod_auth_idp_email_account_password_reset_request"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_password_reset_request_fk_1"
    FOREIGN KEY("challengeId")
    REFERENCES "serverpod_auth_idp_secret_challenge"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "serverpod_auth_idp_email_account_password_reset_request"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_password_reset_request_fk_2"
    FOREIGN KEY("setPasswordChallengeId")
    REFERENCES "serverpod_auth_idp_secret_challenge"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_auth_idp_email_account_request"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_request_fk_0"
    FOREIGN KEY("challengeId")
    REFERENCES "serverpod_auth_idp_secret_challenge"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "serverpod_auth_idp_email_account_request"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_request_fk_1"
    FOREIGN KEY("createAccountChallengeId")
    REFERENCES "serverpod_auth_idp_secret_challenge"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_auth_idp_facebook_account"
    ADD CONSTRAINT "serverpod_auth_idp_facebook_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_auth_idp_firebase_account"
    ADD CONSTRAINT "serverpod_auth_idp_firebase_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_auth_idp_github_account"
    ADD CONSTRAINT "serverpod_auth_idp_github_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_auth_idp_google_account"
    ADD CONSTRAINT "serverpod_auth_idp_google_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_auth_idp_microsoft_account"
    ADD CONSTRAINT "serverpod_auth_idp_microsoft_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_auth_idp_passkey_account"
    ADD CONSTRAINT "serverpod_auth_idp_passkey_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR wonkru_mdm
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('wonkru_mdm', '20261120104939727-initial', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261120104939727-initial', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260924105232991', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105232991', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20261015164015382', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261015164015382', "timestamp" = now();


COMMIT;
