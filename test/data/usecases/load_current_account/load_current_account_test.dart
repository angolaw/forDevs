import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/domain/entities/account_entity.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';

class LocalLoadCurrentAccount {
  final FetchSecureCacheStorage fetchSecureCacheStorage;

  LocalLoadCurrentAccount({@required this.fetchSecureCacheStorage});

  Future<void> load() async {
    await fetchSecureCacheStorage.fetchSecure('token');
  }
}

abstract class FetchSecureCacheStorage {
  Future<void> fetchSecure(String key);
}

class FetchSecureCacheStorageSpy extends Mock
    implements FetchSecureCacheStorage {}

void main() {
  AccountEntity account;
  FetchSecureCacheStorage fetchSecureCacheStorage;
  LocalLoadCurrentAccount sut;
  setUp(() {
    account = AccountEntity(token: faker.guid.guid());
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    sut = LocalLoadCurrentAccount(
        fetchSecureCacheStorage: fetchSecureCacheStorage);
  });

  test('should call FetchSecureCacheStorage with correct value', () async {
    await sut.load();
    verify(fetchSecureCacheStorage.fetchSecure('token'));
  });

  test('should retrieve account data of given token', () async {
    await sut.load();
    verify(fetchSecureCacheStorage.fetchSecure('token'));
  });
}
