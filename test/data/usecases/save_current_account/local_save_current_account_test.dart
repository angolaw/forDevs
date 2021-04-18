import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/data/cache/save_secure_cache_storage.dart';
import 'package:fordev/data/usecases/save_current_account/local_save_current_account.dart';
import 'package:fordev/domain/entities/account_entity.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:mockito/mockito.dart';

class SaveCacheStorageSpy extends Mock implements SaveSecureCacheStorage {}

void main() {
  AccountEntity account;
  LocalSaveCurrentAccount sut;
  SaveCacheStorageSpy saveSecureCacheStorage;

  setUp(() {
    saveSecureCacheStorage = SaveCacheStorageSpy();
    sut =
        LocalSaveCurrentAccount(saveSecureCacheStorage: saveSecureCacheStorage);
    account = AccountEntity(token: faker.guid.guid());
  });
  void mockError() {
    when(saveSecureCacheStorage.save(
            key: anyNamed('key'), value: anyNamed('value')))
        .thenThrow(Exception());
  }

  test('should call SaveSecureCacheStorage with correct values', () async {
    await sut.save(account);
    verify(saveSecureCacheStorage.save(key: 'token', value: account.token));
  });
  test('should throw UnexpectedError if SaveSecureCacheStorage throws',
      () async {
    mockError();
    final future = sut.save(account);
    expect(future, throwsA(DomainError.unexpected));
  });
}
