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
  var _isFormValid = false.obs;

  Stream<UIError> get emailErrorStream => _emailError?.stream;

  void validateEmail(String email) {
    _emailError.value = _validateField(field: 'password', value: email);
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
