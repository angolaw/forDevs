import 'package:fordev/data/cache/cache.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class AuthorizeHttpClientDecorator {
  final FetchSecureCacheStorage fetchSecureCacheStorage;

  AuthorizeHttpClientDecorator({@required this.fetchSecureCacheStorage});

  Future<void> request() async {
    await fetchSecureCacheStorage.fetchSecure('token');
  }
}

class FetchSecureCacheStorageSpy extends Mock
    implements FetchSecureCacheStorage {}

void main() {
  FetchSecureCacheStorageSpy fetchSecureCacheStorage;
  AuthorizeHttpClientDecorator sut;
  setUp(() {
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    sut = AuthorizeHttpClientDecorator(
        fetchSecureCacheStorage: fetchSecureCacheStorage);
  });
  test('should call FetchSecureCacheStorage with correct key', () async {
    await sut.request();
    verify(fetchSecureCacheStorage.fetchSecure('token')).called(1);
  });
}
