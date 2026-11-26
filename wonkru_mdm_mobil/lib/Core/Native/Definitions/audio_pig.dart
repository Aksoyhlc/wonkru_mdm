import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/Core/Native/Generated/audio_api.g.dart',
    dartOptions: DartOptions(),
    kotlinOut: 'android/app/src/main/kotlin/com/wonkrumdm/api/AudioPig.g.kt',
    kotlinOptions: KotlinOptions(package: 'com.wonkrumdm.api.audio'),
  ),
)
class NativeVolumeEvent {
  int? streamType;

  int? volumePercent;

  int? ringerMode;
}

@HostApi()
abstract class AudioPig {
  @async
  Map<String, Object?> setMusicVolume(int volumePercent);

  @async
  int getMusicVolume();

  @async
  bool hasNotificationPolicyAccess();

  @async
  void requestNotificationPolicyAccess();

}

@FlutterApi()
abstract class AudioEventAPI {
  void onVolumeChanged(NativeVolumeEvent event);
}