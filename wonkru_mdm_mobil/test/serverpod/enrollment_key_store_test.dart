import 'package:flutter_test/flutter_test.dart';
import 'package:wonkrumdm/Core/Constants/Enums/storage_keys.dart';
import 'package:wonkrumdm/Core/Services/enrollment_recovery.dart';
import 'package:wonkrumdm/Core/Utils/enrollment_key_store.dart';

void main() {
  late Map<String, String> secure;
  late Map<String, String> plain;

  EnrollmentKeyStore memoryStore() => EnrollmentKeyStore(
    readSecure: (key) => secure[key],
    writeSecure: (key, value) => secure[key] = value,
    removeSecure: secure.remove,
    readPlain: (key) => plain[key],
    removePlain: plain.remove,
  );

  setUp(() {
    secure = {};
    plain = {};
  });

  tearDown(() => EnrollmentKeyStore.instance = null);

  test('the QR extra is moved to secure storage and the plain copy is deleted', () {
    plain[EnrollmentKeyStore.provisioningExtra] = ' qr-key ';
    final store = memoryStore();

    expect(store.key, 'qr-key');
    expect(secure[Sk.enrollmentKey.name], 'qr-key');
    expect(plain.containsKey(EnrollmentKeyStore.provisioningExtra), isFalse);
  });

  test('the rejection flag applies only to the same key', () {
    final store = memoryStore()..save('old');
    expect(store.isRejected, isFalse);

    store.markRejected();
    expect(store.isRejected, isTrue);

    store.save('old');
    expect(store.isRejected, isTrue, reason: 'same key entered again');

    store.save('new');
    expect(store.isRejected, isFalse);
  });

  test('recovery with a rejected key stops before going to the network', () async {
    final store = memoryStore()
      ..save('old')
      ..markRejected();
    EnrollmentKeyStore.instance = store;

    // No token (StorageHelper empty): recovery enters its body and returns
    // before NetworkManager/register because the key is rejected.
    final outcome = await EnrollmentRecovery.recoverMissingEnrollment();

    expect(outcome, RecoveryOutcome.enrollmentRejected);
    expect(EnrollmentRecovery.isRunning, isFalse);
  });
}
