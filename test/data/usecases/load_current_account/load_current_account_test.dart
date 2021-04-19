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

  setUp(() {
    account = AccountEntity(token: faker.guid.guid());
  });
  test('should call FetchSecureCacheStorage with correct value', () async {
    final fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    final sut = LocalLoadCurrentAccount(
        fetchSecureCacheStorage: fetchSecureCacheStorage);
    await sut.load();
    verify(fetchSecureCacheStorage.fetchSecure('token'));
  });

  test('should retrieve account data of given token', () async {
    final fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    final sut = LocalLoadCurrentAccount(
        fetchSecureCacheStorage: fetchSecureCacheStorage);
    await sut.load();
    verify(fetchSecureCacheStorage.fetchSecure('token'));
  });
}
