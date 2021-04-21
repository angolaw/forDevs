import 'package:flutter/material.dart';
import 'package:fordev/ui/helpers/helpers.dart';

class BackToLoginButton extends StatelessWidget {
  const BackToLoginButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton.icon(
        onPressed: () {},
        icon: Icon(Icons.exit_to_app),
        label: Text(R.strings.login));
  }
}
