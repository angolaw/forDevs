import 'package:flutter/material.dart';
import 'package:fordev/ui/pages/pages.dart';
import 'package:fordev/ui/pages/signup/signup.dart';

import '../../factories.dart';

Widget makeSignupPage() {
  return SignUpPage(
    presenter: makeGetxSignupPresenter(),
  );
}
