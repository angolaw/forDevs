import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/domain/entities/account_entity.dart';
import 'package:fordev/domain/usecases/save_current_account.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';

class LocalSaveCurrentAccount implements SaveCurrentAccount {
  final SaveSecureCacheStorage saveSecureCacheStorage;

  LocalSaveCurrentAccount({@required this.saveSecureCacheStorage});
  @override
  Future<void> save(AccountEntity account) async {
    await saveSecureCacheStorage.save(key: 'token', value: account.token);
  }
}

abstract class SaveSecureCacheStorage {
  Future<void> save({@required String key, @required String value});
}

class SaveCacheStorageSpy extends Mock implements SaveSecureCacheStorage {}

void main() {
  test('should call SaveCacheStorage with correct values', () async {
    final cacheStorage = SaveCacheStorageSpy();
    final sut = LocalSaveCurrentAccount(saveSecureCacheStorage: cacheStorage);
    final account = AccountEntity(token: faker.guid.guid());
    await sut.save(account);
    verify(cacheStorage.save(key: 'token', value: account.token));
  });
}
