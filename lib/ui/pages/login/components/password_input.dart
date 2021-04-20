import 'package:flutter/material.dart';
import 'package:fordev/ui/helpers/errors/errors.dart';
import 'package:provider/provider.dart';

import '../../pages.dart';

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);
    return StreamBuilder<UIError>(
        stream: presenter.passwordErrorStream,
        builder: (context, snapshot) {
          return TextFormField(
            onChanged: presenter.validatePassword,
            decoration: InputDecoration(
              labelText: 'Senha',
              errorText: snapshot.hasData ? snapshot.data.description : null,
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
