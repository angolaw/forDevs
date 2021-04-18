import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/domain/entities/account_entity.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/save_current_account.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';

class LocalSaveCurrentAccount implements SaveCurrentAccount {
  final SaveSecureCacheStorage saveSecureCacheStorage;

  LocalSaveCurrentAccount({@required this.saveSecureCacheStorage});
  @override
  Future<void> save(AccountEntity account) async {
    try {
      await saveSecureCacheStorage.save(key: 'token', value: account.token);
    } catch (e) {
      throw DomainError.unexpected;
    }
  }
}

abstract class SaveSecureCacheStorage {
  Future<void> save({@required String key, @required String value});
}

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
  test('should call SaveSecureCacheStorage with correct values', () async {
    await sut.save(account);
    verify(saveSecureCacheStorage.save(key: 'token', value: account.token));
  });
  test('should throw UnexpectedError if SaveSecureCacheStorage throws',
      () async {
    when(saveSecureCacheStorage.save(
            key: anyNamed('key'), value: anyNamed('value')))
        .thenThrow(Exception());
    final future = sut.save(account);
    expect(future, throwsA(DomainError.unexpected));
  });
}
