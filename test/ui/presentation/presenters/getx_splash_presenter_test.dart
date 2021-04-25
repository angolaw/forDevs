import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/usecases/load_current_account.dart';
import 'package:fordev/presentation/presenter/presenter.dart';
import 'package:mockito/mockito.dart';

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {}

void main() {
  LoadCurrentAccount loadCurrentAccount;
  GetxSplashPresenter sut;
  String token;
  PostExpectation mockLoadCurrentAccountCall() =>
      when(loadCurrentAccount.load());
  void mockLoadCurrentAccount({AccountEntity account}) {
    mockLoadCurrentAccountCall().thenAnswer((_) async => account);
  }

  void mockLoadCurrentAccountError() {
    mockLoadCurrentAccountCall().thenThrow(Exception());
  }

  setUp(() {
    token = faker.guid.guid();
    loadCurrentAccount = LoadCurrentAccountSpy();
    sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccount);
    mockLoadCurrentAccount(account: AccountEntity(token: token));
  });
  test('should call LoadCurrentAccount ', () async {
    //quando eu chamar o metodo checkAccount
    await sut.checkAccount();
    //faca com que ele chame o loadCurrentAccount.load()
    verify(loadCurrentAccount.load()).called(1);
  });
  test('should go to surveys page on success', () async {
    sut.navigateToStream
        .listen(expectAsync1((page) => expect(page, '/surveys')));
    await sut.checkAccount();
  });
  test('should go to login if cache data is null', () async {
    mockLoadCurrentAccount(account: null);
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/login')));
    await sut.checkAccount();
  });
  test('should go to login if account entity is null ', () async {
    mockLoadCurrentAccount(account: AccountEntity(token: null));
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/login')));
    await sut.checkAccount();
  });
  test('should go to login if loadCurrentAccount.load() throws exception',
      () async {
    mockLoadCurrentAccountError();
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/login')));
    await sut.checkAccount();
  });
}
