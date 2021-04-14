import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './components/components.dart';
import '../../components/components.dart';
import '../pages.dart';
import 'components/login_button.dart';

class LoginPage extends StatefulWidget {
  final LoginPresenter presenter;

  LoginPage({Key key, this.presenter}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.presenter.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          widget.presenter.isLoadingStream.listen((isLoading) {
            if (isLoading) {
              showLoading(context, "Aguarde");
            } else {
              hideLoading(context);
            }
          });
          widget.presenter.mainErrorStream.listen((hasMainError) {
            if (hasMainError != null) {
              showSnackBar(context, hasMainError);
            } else {
              hideLoading(context);
            }
          });
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LoginHeader(),
                Headline1(text: "Login"),
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Provider<LoginPresenter>(
                    create: (_) => widget.presenter,
                    child: Form(
                      child: Column(
                        children: [
                          EmailInput(),
                          Padding(
                            padding: EdgeInsets.only(top: 8.0, bottom: 32),
                            child: PasswordInput(),
                          ),
                          LoginButton(),
                          CreateAccountButton(),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
