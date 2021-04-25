import 'dart:async';

import 'package:fordev/domain/helpers/domain_error.dart';
import 'package:fordev/domain/usecases/authentication.dart';
import 'package:fordev/domain/usecases/save_current_account.dart';
import 'package:fordev/ui/helpers/helpers.dart';
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

  var _emailError = Rx<UIError>(UIError.unexpected);
  var _passwordError = Rx<UIError>(UIError.unexpected);
  var _mainError = Rx<UIError>(UIError.unexpected);
  var _isFormValid = false.obs;
  var _isLoading = false.obs;
  var _navigateTo = RxString('');

  Stream<UIError> get emailErrorStream => _emailError?.stream;
  Stream<UIError> get passwordErrorStream => _passwordError?.stream;
  Stream<bool> get isFormValidStream => _isFormValid?.stream;
  Stream<bool> get isLoadingStream => _isLoading?.stream;
  Stream<UIError> get mainErrorStream => _mainError?.stream;
  Stream<String> get navigateToStream => _navigateTo?.stream;

  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validateField(field: 'email');
    _validateForm();
  }

  void validatePassword(String password) {
    _password = password;
    _passwordError.value = _validateField(field: 'password');
    _validateForm();
  }

  UIError _validateField({String field}) {
    final formData = {'email': _email, 'password': _password};
    final error = validation.validate(field: field, input: formData);
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
    try {
      _isLoading.value = true;
      _mainError = null;
      final account = await authentication
          .auth(AuthenticationParams(email: _email, secret: _password));
      await saveCurrentAccount.save(account);
      _navigateTo.value = '/surveys';
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.invalidCredentials:
          _mainError.value = UIError.invalidCredentials;
          break;

        default:
          _mainError?.value = UIError.unexpected;
      }
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

  void goToSignup() {
    _navigateTo.value = '/signup';
  }
}
