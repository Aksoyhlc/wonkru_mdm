import 'dart:async';
import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:wonkrumdm/Core/Logging/wlog.dart';
import 'package:wonkrumdm/Core/Utils/basic_storage.dart';

import '../Constants/Enums/storage_keys.dart';

const _tag = 'HeartbeatService';

class HeartbeatService {
  static Future<void> start() async {
    RootIsolateToken? rootToken = RootIsolateToken.instance;
    if (rootToken == null) {
      WLog.w(_tag, 'RootIsolateToken not available, Heartbeat cannot start');
      return;
    }

    await Isolate.spawn(_heartbeatEntryPoint, rootToken);
    WLog.i(_tag, 'Heartbeat isolate started');
  }

  @pragma('vm:entry-point')
  static void _heartbeatEntryPoint(RootIsolateToken rootToken) async {
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootToken);
    await BasicStorage.instance.init();
    final st = BasicStorage();

    st.setInt(Sk.flutter_alive_timestamp.name, DateTime.now().millisecondsSinceEpoch);

    Timer.periodic(const Duration(seconds: 2), (timer) {
      try {
        final now = DateTime.now().millisecondsSinceEpoch;

        st.setInt(Sk.flutter_alive_timestamp.name, now);

        WLog.v(_tag, 'Isolate heartbeat tick');
      } catch (e, st) {
        WLog.e(_tag, 'Heartbeat write error', error: e, stackTrace: st);
      }
    });
  }
}