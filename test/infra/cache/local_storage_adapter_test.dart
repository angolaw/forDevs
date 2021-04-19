import 'package:faker/faker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fordev/infra/cache/cache.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {}

void main() {
  FlutterSecureStorageSpy secureStorage;
  LocalStorageAdapter sut;
  String key;
  String value;

  void mockSaveSecureError() {
    when(secureStorage.write(key: anyNamed('key'), value: anyNamed('value')))
        .thenThrow(Exception());
  }

  setUp(() {
    secureStorage = FlutterSecureStorageSpy();
    sut = LocalStorageAdapter(secureStorage: secureStorage);
    key = faker.lorem.word();
    value = faker.guid.guid();
  });

  group("save secure ", () {
    test('should call save secure with correct values', () async {
      await sut.saveSecure(key: key, value: value);

      verify(secureStorage.write(key: key, value: value));
    });
    test('should throw if save secure throws', () async {
      mockSaveSecureError();

      final future = sut.saveSecure(key: key, value: value);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });
  group("fetchSecure", () {
    test('should call fetch secure correct values', () async {
      await sut.fetchSecure(key);
      verify(secureStorage.read(key: key));
    });
  });
}
