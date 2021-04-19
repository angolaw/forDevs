import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:fordev/domain/entities/account_entity.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/usecases.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class LocalLoadCurrentAccount implements LoadCurrentAccount {
  final FetchSecureCacheStorage fetchSecureCacheStorage;

  LocalLoadCurrentAccount({@required this.fetchSecureCacheStorage});

  Future<AccountEntity> load() async {
    String token;
    try {
      token = await fetchSecureCacheStorage.fetchSecure('token');
      return AccountEntity(token: token);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}

abstract class FetchSecureCacheStorage {
  Future<String> fetchSecure(String key);
}

class FetchSecureCacheStorageSpy extends Mock
    implements FetchSecureCacheStorage {}

void main() {
  AccountEntity userAccount;
  FetchSecureCacheStorage fetchSecureCacheStorage;
  LocalLoadCurrentAccount sut;
  String token;
  PostExpectation mockFetchSecureCall() =>
      when(fetchSecureCacheStorage.fetchSecure(any));

  void mockFetchSecure() {
    mockFetchSecureCall().thenAnswer((_) async => token);
  }

  void mockFetchSecureError() {
    mockFetchSecureCall().thenThrow(Exception());
  }

  setUp(() {
    token = faker.guid.guid();

    userAccount = AccountEntity(token: faker.guid.guid());
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    sut = LocalLoadCurrentAccount(
        fetchSecureCacheStorage: fetchSecureCacheStorage);
    mockFetchSecure();
  });

  test('should call FetchSecureCacheStorage with correct value', () async {
    await sut.load();
    verify(fetchSecureCacheStorage.fetchSecure('token'));
  });

  test('should return an AccountEntity of given token', () async {
    final account = await sut.load();
    expect(account, AccountEntity(token: token));
  });
  test('should throw DomainError on exception', () async {
    mockFetchSecureError();

    final future = sut.load();
    expect(future, throwsA(DomainError.unexpected));
  });
}
