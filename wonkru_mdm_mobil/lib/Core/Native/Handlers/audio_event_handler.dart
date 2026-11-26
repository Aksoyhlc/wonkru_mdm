import 'dart:async';

import 'package:wonkrumdm/Core/Native/Generated/audio_api.g.dart';

class AudioEventHandler extends AudioEventAPI {
  final _volumeController = StreamController<NativeVolumeEvent>.broadcast();

  Stream<NativeVolumeEvent> get volumeStream => _volumeController.stream;

  @override
  void onVolumeChanged(NativeVolumeEvent event) {
    _volumeController.add(event);
  }

  void dispose() {
    _volumeController.close();
  }
}