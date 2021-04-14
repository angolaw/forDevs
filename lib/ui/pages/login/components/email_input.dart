import 'package:flutter/material.dart';

import '../login_page.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final LoginPage widget;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
        stream: widget.presenter.emailErrorStream,
        builder: (context, snapshot) {
          return TextFormField(
            onChanged: widget.presenter.validateEmail,
            decoration: InputDecoration(
              labelText: 'Email',
              errorText: snapshot.data?.isEmpty == true ? null : snapshot.data,
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
