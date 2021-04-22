import 'package:flutter/material.dart';
import 'package:fordev/ui/components/headline1.dart';
import 'package:fordev/ui/components/login_header.dart';
import 'package:fordev/ui/helpers/helpers.dart';
import 'package:fordev/ui/pages/signup/signup.dart';

import 'components/components.dart';

class SignUpPage extends StatelessWidget {
  final SignUpPresenter presenter;

  SignUpPage({
    Key key,
    this.presenter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void hideKeyboard() {
      final currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    }

    return Scaffold(
      body: Builder(
        builder: (context) {
          return GestureDetector(
            onTap: hideKeyboard,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LoginHeader(),
                  Headline1(text: R.strings.addAccount),
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Form(
                      child: Column(
                        children: [
                          NameInput(),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: EmailInput(),
                          ),
                          PasswordInput(),
                          Padding(
                            padding: EdgeInsets.only(top: 8.0, bottom: 32),
                            child: PasswordConfirmationInput(),
                          ),
                          SignUpButton(),
                          BackToLoginButton(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
