import 'dart:async';

import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/usecases.dart';
import 'package:fordev/ui/helpers/helpers.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '../protocols/validation.dart';

class GetxSignupPresenter extends GetxController {
  final Validation validation;
  final AddAccount addAccount;
  final SaveCurrentAccount saveCurrentAccount;

  GetxSignupPresenter({
    @required this.validation,
    @required this.addAccount,
    @required this.saveCurrentAccount,
  });
  String _name;
  String _password;
  String _passwordConfirmation;
  String _email;

  final _emailError = Rx<UIError>(UIError.unexpected);
  final _nameError = Rx<UIError>(UIError.unexpected);
  final _passwordError = Rx<UIError>(UIError.unexpected);
  final _passwordConfirmationError = Rx<UIError>(UIError.unexpected);
  final _mainError = Rx<UIError>(UIError.unexpected);
  final _isFormValid = false.obs;
  final _isLoading = false.obs;

  Stream<UIError> get emailErrorStream => _emailError?.stream;
  Stream<UIError> get passwordErrorStream => _passwordError?.stream;
  Stream<UIError> get passwordConfirmationErrorStream =>
      _passwordConfirmationError?.stream;
  Stream<UIError> get mainErrorStream => _mainError?.stream;
  Stream<UIError> get nameErrorStream => _nameError?.stream;
  Stream<bool> get isFormValidStream => _isFormValid?.stream;
  Stream<bool> get isLoadingStream => _isLoading?.stream;

  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validateField(field: 'email', value: email);
    _validateForm();
  }

  void validatePassword(String password) {
    _password = password;
    _passwordError.value = _validateField(field: 'password', value: password);
    _validateForm();
  }

  void validateName(String name) {
    _name = name;
    _nameError.value = _validateField(field: 'name', value: name);
    _validateForm();
  }

  void validateConfirmationPassword(String passwordConfirmation) {
    _passwordConfirmation = passwordConfirmation;
    _passwordConfirmationError.value = _validateField(
        field: 'passwordConfirmation', value: passwordConfirmation);
    _validateForm();
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

  Future<void> signUp() async {
    try {
      _isLoading.value = true;
      final account = await addAccount.add(AddAccountParams(
          name: _name,
          email: _email,
          password: _password,
          passwordConfirmation: _passwordConfirmation));
      await saveCurrentAccount.save(account);
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.invalidCredentials:
          _mainError.value = UIError.invalidCredentials;
          break;
        case DomainError.emailInUse:
          _mainError.value = UIError.emailInUse;
          break;
        default:
          _mainError.value = UIError.unexpected;
          break;
      }
      _isLoading.value = false;
    }
  }

  void dispose() {}

  void _validateForm() {
    _isFormValid.value = _nameError.value == null &&
        _emailError.value == null &&
        _passwordConfirmationError.value == null &&
        _passwordError.value == null &&
        _name != null &&
        _password != null &&
        _passwordConfirmation != null &&
        _email != null;
  }
}
