import 'package:flutter/material.dart';
import 'package:fordev/ui/helpers/helpers.dart';
import 'package:provider/provider.dart';

import '../signup_presenter.dart';

class NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignUpPresenter>(context);
    return StreamBuilder<UIError>(
        stream: presenter.nameErrorStream,
        builder: (context, snapshot) {
          return TextFormField(
            onChanged: presenter.validateName,
            decoration: InputDecoration(
              labelText: 'Nome',
              errorText: snapshot.hasData ? snapshot.data.description : null,
              icon: Icon(
                Icons.person_outline,
                color: Theme.of(context).primaryColorLight,
              ),
            ),
            keyboardType: TextInputType.name,
          );
        });
  }
}
