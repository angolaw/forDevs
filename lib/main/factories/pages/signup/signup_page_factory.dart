import 'package:flutter/material.dart';
import 'package:fordev/ui/pages/signup/signup.dart';

import 'signup_presenter_factory.dart';

Widget makeSignupPage() {
  return SignUpPage(
    presenter: makeGetxSignUpPresenter(),
  );
}
