# Wonkru MDM Android Agent

The Android agent for [Wonkru MDM](../README.md), built with Flutter and native
Kotlin integrations. It runs as an Android Device Owner and communicates with the
Serverpod backend to apply policies, receive commands, and report device status.

- Managed launcher and device restrictions.
- Application installation, file delivery, and certificate management.
- Device inventory, telemetry, and real-time command acknowledgements.

## Build

Run from this directory:

```bash
flutter pub get
flutter build apk --debug --dart-define-from-file=config.json
```

The APK is written to `build/app/outputs/flutter-apk/app-debug.apk`.
`config.json` contains emulator development defaults. For a physical device,
configure an API address reachable from that device.

## Enrollment

Start the backend, create a default policy, and obtain an enrollment key from the
admin panel. Install the agent on an unprovisioned, account-free Android device,
assign Device Owner, then complete permissions and enrollment.

See the [project setup guide](../README.md#install-the-android-agent-on-an-emulator)
for ADB commands and the [agent documentation](https://docs.wonkrumdm.com/reference/mobile-agent/)
for provisioning and supported operations.

## File destinations

Policy `destination_path` values accept an absolute directory, a full file path,
or `custom://file?file_name=report.pdf&directory=_DOWNLOAD_`. Directory tokens are
`_DOCUMENT_` (app documents, the default), `_TEMP_` (app temporary storage), and
`_DOWNLOAD_` (system Downloads). App documents and temporary storage are private
to the agent.
