import 'package:flutter/material.dart';
import 'package:fordev/ui/helpers/helpers.dart';

import '../signup_presenter.dart';

class BackToLoginButton extends StatelessWidget {
  final SignUpPresenter presenter;
  const BackToLoginButton({
    Key key,
    @required this.presenter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton.icon(
        onPressed: () {
          presenter.goToLogin();
        },
        icon: Icon(Icons.exit_to_app),
        label: Text(R.strings.login));
  }
}
