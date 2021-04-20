import 'dart:async';

import 'package:fordev/domain/helpers/domain_error.dart';
import 'package:fordev/domain/usecases/authentication.dart';
import 'package:fordev/ui/helpers/errors/errors.dart';
import 'package:fordev/ui/pages/pages.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '../protocols/validation.dart';

class LoginState {
  String email;
  String password;
  var emailError = Rx<UIError>(UIError.unexpected);
  var passwordError = Rx<UIError>(UIError.unexpected);
  var mainError = Rx<UIError>(UIError.unexpected);
  String navigateTo;
  bool get isFormValid =>
      emailError == null &&
      passwordError == null &&
      email != null &&
      password != null;
  bool isLoading = false;
}

class StreamLoginPresenter implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;
  StreamLoginPresenter(
      {@required this.validation, @required this.authentication});

  var _controller = StreamController<LoginState>.broadcast();
  var _state = LoginState();
  Stream<UIError> get emailErrorStream =>
      _controller?.stream?.map((state) => state.emailError)?.distinct();
  Stream<UIError> get passwordErrorStream =>
      _controller?.stream?.map((state) => state.passwordError)?.distinct();
  Stream<bool> get isFormValidStream =>
      _controller?.stream?.map((state) => state.isFormValid)?.distinct();
  Stream<bool> get isLoadingStream =>
      _controller?.stream?.map((state) => state.isLoading)?.distinct();
  Stream<UIError> get mainErrorStream =>
      _controller?.stream?.map((state) => state.mainError)?.distinct();
  Stream<String> get navigateToStream =>
      _controller?.stream?.map((state) => state.navigateTo)?.distinct();

  void _update() => _controller?.add(_state);

  void validateEmail(String email) {
    _state.email = email;
    _state.emailError = _validateField(field: "email", value: email);
    _update();
  }

  void validatePassword(String password) {
    _state.password = password;
    _state.passwordError =
        validation.validate(field: 'password', value: password);
    _update();
  }

  UIError _validateField({String field, String value}) {
    final error = validation.validate(field: field, value: value);
    switch (error) {
      case ValidationError.invalidField:
        return UIError.invalidField;
      case ValidationError.requiredField:
        return UIError.requiredField;
      default:
        return null;
    }
  }

  Future<void> auth() async {
    _state.isLoading = true;
    _update();
    try {
      await authentication.auth(
          AuthenticationParams(email: _state.email, secret: _state.password));
    } on DomainError catch (error) {
      _state.mainError = error.description;
    }

    _state.isLoading = false;
    _update();
  }

  void dispose() {
    _controller.close();
    _controller = null;
  }
}
