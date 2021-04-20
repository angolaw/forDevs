import 'package:fordev/main/factories/factories.dart';
import 'package:fordev/presentation/presenter/presenter.dart';

GetxSplashPresenter makeGetxSplashPresenter() {
  return GetxSplashPresenter(loadCurrentAccount: makeLocalLoadCurrentAccount());
}
