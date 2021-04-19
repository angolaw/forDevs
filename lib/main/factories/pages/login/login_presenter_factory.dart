import 'package:fordev/main/factories/factories.dart';
import 'package:fordev/main/factories/pages/login/login_validation_factory.dart';
import 'package:fordev/main/factories/usecases/save_current_account_factory.dart';
import 'package:fordev/presentation/presenter/presenter.dart';

StreamLoginPresenter makeStreamLoginPresenter() {
  return StreamLoginPresenter(
      authentication: makeRemoteAuthentication(),
      validation: makeLoginValidation());
}

GetXLoginPresenter makeGetxLoginPresenter() {
  return GetXLoginPresenter(
      authentication: makeRemoteAuthentication(),
      validation: makeLoginValidation(),
      saveCurrentAccount: makeLocalSaveCurrentAccount());
}
