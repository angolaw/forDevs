import 'package:flutter/material.dart';
import 'package:fordev/utils/i18n/resources.dart';

class CreateAccountButton extends StatelessWidget {
  const CreateAccountButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton.icon(
        onPressed: () {},
        icon: Icon(Icons.person),
        label: Text(R.strings.addAccount));
  }
}
