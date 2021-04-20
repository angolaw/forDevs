import 'package:flutter/material.dart';
import 'package:fordev/ui/helpers/errors/errors.dart';
import 'package:provider/provider.dart';

import '../login_presenter.dart';

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);
    return StreamBuilder<UIError>(
        stream: presenter.emailErrorStream,
        builder: (context, snapshot) {
          return TextFormField(
            onChanged: presenter.validateEmail,
            decoration: InputDecoration(
              labelText: 'Email',
              errorText: snapshot.hasData ? snapshot.data.description : null,
              icon: Icon(
                Icons.email,
                color: Theme.of(context).primaryColorLight,
              ),
            ),
            keyboardType: TextInputType.emailAddress,
          );
        });
  }
}
