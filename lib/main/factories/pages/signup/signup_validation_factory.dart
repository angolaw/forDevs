import 'package:fordev/main/builders/builders.dart';
import 'package:fordev/presentation/protocols/protocols.dart';
import 'package:fordev/validation/protocols/protocols.dart';
import 'package:fordev/validation/validators/validators.dart';

Validation makeSignUpValidation() {
  return ValidationComposite(validations: makeSignUpValidations());
}

List<FieldValidation> makeSignUpValidations() {
  return [
    ...ValidationBuilder.field('email').required().email().build(),
    ...ValidationBuilder.field('password').required().min(3).build(),
    ...ValidationBuilder.field('name').required().min(2).build(),
    ...ValidationBuilder.field('passwordConfirmation')
        .required()
        .min(3)
        .sameAs('password')
        .build(),
  ];
}
