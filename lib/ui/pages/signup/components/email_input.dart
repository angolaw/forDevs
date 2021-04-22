import 'package:flutter/material.dart';
import 'package:fordev/ui/helpers/helpers.dart';
import 'package:fordev/ui/pages/signup/signup.dart';
import 'package:provider/provider.dart';

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignUpPresenter>(context);
    return StreamBuilder<UIError>(
        stream: presenter.emailErrorStream,
        builder: (context, snapshot) {
          return TextFormField(
            onChanged: presenter.validatePassword,
            decoration: InputDecoration(
              labelText: 'Email',
              errorText: snapshot.hasData ? snapshot.data.description : null,
              icon: Icon(
                Icons.email,
                color: Theme.of(context).primaryColorLight,
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            obscureText: true,
          );
        });
  }
}
