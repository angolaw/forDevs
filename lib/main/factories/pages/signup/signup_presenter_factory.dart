

import 'package:fordev/presentation/presenter/presenter.dart';
import 'package:fordev/ui/pages/signup/signup.dart';

import '../../factories.dart';

SignUpPresenter makeGetxSignUpPresenter()  =>
   GetxSignUpPresenter(
    addAccount: makeRemoteAddAccount(),
    validation: makeSignUpValidation(),
    saveCurrentAccount: makeLocalSaveCurrentAccount();


