import 'dart:async';

import 'package:fordev/domain/helpers/domain_error.dart';
import 'package:fordev/domain/usecases/authentication.dart';
import 'package:fordev/domain/usecases/save_current_account.dart';
import 'package:fordev/ui/pages/pages.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '../protocols/validation.dart';

class GetXLoginPresenter extends GetxController implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;
  final SaveCurrentAccount saveCurrentAccount;

  String _email;
  String _password;

  GetXLoginPresenter(
      {@required this.validation,
      @required this.authentication,
      @required this.saveCurrentAccount});

  var _emailError = RxString('');
  var _passwordError = RxString('');
  var _mainError = RxString('');
  var _isFormValid = false.obs;
  var _isLoading = false.obs;
  var _navigateTo = RxString('');

  Stream<String> get emailErrorStream => _emailError?.stream;
  Stream<String> get passwordErrorStream => _passwordError?.stream;
  Stream<bool> get isFormValidStream => _isFormValid?.stream;
  Stream<bool> get isLoadingStream => _isLoading?.stream;
  Stream<String> get mainErrorStream => _mainError?.stream;
  Stream<String> get navigateToStream => _navigateTo?.stream;

  void validateEmail(String email) {
    _email = email;
    _emailError.value = validation.validate(field: 'email', value: email);
    _validateForm();
  }

  void validatePassword(String password) {
    _password = password;
    _passwordError.value =
        validation.validate(field: 'password', value: password);
    _validateForm();
  }

  UIError _validateField({String field, String value}) {
    final error = validation.validate(field: field, value: value);
    return error;
  }

  Future<void> auth() async {
    try {
      _isLoading.value = true;

      final account = await authentication
          .auth(AuthenticationParams(email: _email, secret: _password));
      await saveCurrentAccount.save(account);
      _navigateTo.value = '/surveys';
    } on DomainError catch (error) {
      _mainError.value = error.description;
      _isLoading.value = false;
    }
  }

  void dispose() {}

  void _validateForm() {
    _isFormValid.value = _emailError.value == null &&
        _passwordError.value == null &&
        _email != null &&
        _password != null;
  }
}
