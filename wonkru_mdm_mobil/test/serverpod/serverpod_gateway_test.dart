import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wonkrumdm/Core/Utils/basic_storage.dart';
import 'package:wonkrumdm/Data/DataSources/Remote/serverpod_gateway.dart';

void main() {
  setUp(() async {
    // init reads the bootstrap CA key from BasicStorage, so an empty mock store
    // keeps setup off the network.
    SharedPreferences.setMockInitialValues({});
    await BasicStorage.instance.init();
    ServerpodGateway.instance.reset();
  });

  tearDown(() {
    ServerpodGateway.instance.reset();
  });

  test('before init isInitialized is false and client throws StateError', () {
    expect(ServerpodGateway.instance.isInitialized, isFalse);
    expect(() => ServerpodGateway.instance.client, throwsStateError);
  });

  test(
    'init sets isInitialized true; a repeat call with the same base URL returns the same client',
    () {
      final gateway = ServerpodGateway.instance;

      final first = gateway.init(baseUrl: 'http://10.0.2.2:8080');

      expect(gateway.isInitialized, isTrue);
      expect(identical(gateway.client, first), isTrue);

      final second = gateway.init(baseUrl: 'http://10.0.2.2:8080');

      expect(identical(first, second), isTrue);
      expect(identical(gateway.client, second), isTrue);
    },
  );

  test('a trailing slash difference is normalized and the same client is returned', () {
    final gateway = ServerpodGateway.instance;

    final withoutSlash = gateway.init(baseUrl: 'http://10.0.2.2:8080');
    final withSlash = gateway.init(baseUrl: 'http://10.0.2.2:8080/');

    expect(identical(withoutSlash, withSlash), isTrue);
  });

  test(
    'reset clears state: isInitialized false, client throws StateError',
    () {
      final gateway = ServerpodGateway.instance;
      gateway.init(baseUrl: 'http://10.0.2.2:8080');
      expect(gateway.isInitialized, isTrue);

      gateway.reset();

      expect(gateway.isInitialized, isFalse);
      expect(() => gateway.client, throwsStateError);
    },
  );
}
