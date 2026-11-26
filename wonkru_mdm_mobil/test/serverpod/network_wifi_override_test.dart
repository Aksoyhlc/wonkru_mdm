import 'package:flutter_test/flutter_test.dart';
import 'package:wonkrumdm/Core/Managers/network_manager.dart';

/// The operator command is persistent (an override): a later watchdog round
/// does not re-enable Wi-Fi. Only an explicit "enable" clears the override.
void main() {
  group('Wi-Fi watchdog decision', () {
    test('required + off + no override → re-enables', () {
      expect(
        NetworkManager.shouldReEnableWifi(
          requiredWifi: true,
          isWifiEnabled: false,
          operatorOverride: false,
        ),
        isTrue,
      );
    });

    test('does not re-enable while the operator override is active', () {
      expect(
        NetworkManager.shouldReEnableWifi(
          requiredWifi: true,
          isWifiEnabled: false,
          operatorOverride: true,
        ),
        isFalse,
      );
    });

    test('does not re-enable when requiredWifi is false', () {
      expect(
        NetworkManager.shouldReEnableWifi(
          requiredWifi: false,
          isWifiEnabled: false,
          operatorOverride: false,
        ),
        isFalse,
      );
    });

    test('does not re-enable when Wi-Fi is already on', () {
      expect(
        NetworkManager.shouldReEnableWifi(
          requiredWifi: true,
          isWifiEnabled: true,
          operatorOverride: false,
        ),
        isFalse,
      );
    });
  });

  group('operator override flag', () {
    tearDown(() {
      NetworkManager().wifiToggleOverride = null;
      NetworkManager().operatorWifiOverride = false;
    });

    test('disable_wifi sets the override, enable clears it', () async {
      NetworkManager().wifiToggleOverride = (_) async => true;

      await NetworkManager().toggleWifi(false);
      expect(NetworkManager().operatorWifiOverride, isTrue);

      await NetworkManager().toggleWifi(true);
      expect(NetworkManager().operatorWifiOverride, isFalse);
    });

    test('the override is unchanged when the native toggle fails', () async {
      NetworkManager().wifiToggleOverride = (_) async => false;

      await NetworkManager().toggleWifi(false);
      expect(NetworkManager().operatorWifiOverride, isFalse);
    });
  });
}
