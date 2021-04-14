import 'package:flutter/material.dart';

import '../../pages.dart';

class PasswordInput extends StatelessWidget {
  const PasswordInput({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final LoginPage widget;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
        stream: widget.presenter.passwordErrorStream,
        builder: (context, snapshot) {
          return TextFormField(
            onChanged: widget.presenter.validatePassword,
            decoration: InputDecoration(
              labelText: 'Senha',
              errorText: snapshot.data?.isEmpty == true ? null : snapshot.data,
              icon: Icon(
                Icons.lock,
                color: Theme.of(context).primaryColorLight,
              ),
            ),
            obscureText: true,
          );
        });
  }
}
