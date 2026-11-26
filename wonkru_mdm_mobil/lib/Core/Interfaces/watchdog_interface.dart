abstract class IWatchdog {
  void startWatchdog();
  void stopWatchdog();
  bool get isWatchdogRunning;
  Duration get initialDelay;
  Future<void> checkNow();
}