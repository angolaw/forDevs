import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/domain/usecases/load_current_account.dart';
import 'package:fordev/ui/pages/pages.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';

class GetxSplashPresenter implements SplashPresenter {
  final LoadCurrentAccount loadCurrentAccount;

  var _navigateTo = RxString('');

  GetxSplashPresenter({@required this.loadCurrentAccount});
  Stream<String> get navigateToStream => _navigateTo.stream;

  @override
  Future<void> checkAccount() async {
    _navigateTo.value = '/surveys';
    await loadCurrentAccount.load();
  }
}

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {}

void main() {
  LoadCurrentAccount loadCurrentAccount;
  GetxSplashPresenter sut;
  setUp(() {
    loadCurrentAccount = LoadCurrentAccountSpy();
    sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccount);
  });
  test('should call LoadCurrentAccount ', () async {
    //quando eu chamar o metodo checkAccount
    await sut.checkAccount();
    //faca com que ele chame o loadCurrentAccount.load()
    verify(loadCurrentAccount.load()).called(1);
  });
  test('should go to surveys page in success', () async {
    sut.navigateToStream
        .listen(expectAsync1((page) => expect(page, '/surveys')));
    await sut.checkAccount();
  });
}
