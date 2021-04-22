import 'package:flutter/material.dart';
import 'package:fordev/ui/helpers/helpers.dart';
import 'package:provider/provider.dart';

import '../signup.dart';

class PasswordConfirmationInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignUpPresenter>(context);
    return StreamBuilder<UIError>(
        stream: presenter.passwordConfirmationErrorStream,
        builder: (context, snapshot) {
          return TextFormField(
            onChanged: presenter.validatePasswordConfirmation,
            decoration: InputDecoration(
              labelText: "Confirmar senha",
              errorText: snapshot.hasData ? snapshot.data.description : null,
              icon: Icon(
                Icons.lock,
                color: Theme.of(context).primaryColorLight,
              ),
            ),
            keyboardType: TextInputType.text,
          );
        });
  }
}
