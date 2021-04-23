import 'dart:async';

import 'package:fordev/ui/helpers/helpers.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '../protocols/validation.dart';

class GetxSignupPresenter extends GetxController {
  final Validation validation;

  GetxSignupPresenter({
    @required this.validation,
  });

  var _emailError = Rx<UIError>(UIError.unexpected);
  var _nameError = Rx<UIError>(UIError.unexpected);
  var _passwordError = Rx<UIError>(UIError.unexpected);
  var _isFormValid = false.obs;

  Stream<UIError> get emailErrorStream => _emailError?.stream;
  Stream<UIError> get passwordErrorStream => _passwordError?.stream;
  Stream<UIError> get nameErrorStream => _nameError?.stream;
  Stream<bool> get isFormValidStream => _isFormValid?.stream;

  void validateEmail(String email) {
    _emailError.value = _validateField(field: 'email', value: email);
    _validateForm();
  }

  void validatePassword(String password) {
    _passwordError.value = _validateField(field: 'password', value: password);
    _validateForm();
  }

  void validateName(String name) {
    _nameError.value = _validateField(field: 'name', value: name);
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

  void dispose() {}

  void _validateForm() {
    _isFormValid.value = false;
  }
}
