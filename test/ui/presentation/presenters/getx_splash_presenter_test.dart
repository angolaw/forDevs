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
    await loadCurrentAccount.load();
  }
}

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {}

void main() {
  test('should call LoadCurrentAccount ', () async {
    final loadCurrentAccount = LoadCurrentAccountSpy();
    final sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccount);
    //quando eu chamar o metodo checkAccount
    await sut.checkAccount();
    //faca com que ele chame o loadCurrentAccount.load()
    verify(loadCurrentAccount.load()).called(1);
  });
}
