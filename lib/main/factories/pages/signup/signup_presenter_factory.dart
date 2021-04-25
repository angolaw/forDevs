import 'package:fordev/main/factories/factories.dart';
import 'package:fordev/presentation/presenter/presenter.dart';

GetXLoginPresenter makeGetxSignUpPresenter() {
  return GetxSignUpPresenter(
    authentication: makeRemoteAuthentication(),
    addAccount: null,
    validation: null,
  );
}
