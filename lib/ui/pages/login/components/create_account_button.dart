import 'package:flutter/material.dart';
import 'package:fordev/ui/helpers/helpers.dart';

import '../login_presenter.dart';

class CreateAccountButton extends StatelessWidget {
  final LoginPresenter presenter;
  const CreateAccountButton({
    Key key,
    @required this.presenter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton.icon(
        onPressed: () {
          presenter.goToSignup();
        },
        icon: Icon(Icons.person),
        label: Text(R.strings.addAccount));
  }
}
