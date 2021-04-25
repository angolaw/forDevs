import 'package:fordev/main/builders/builders.dart';
import 'package:fordev/presentation/protocols/protocols.dart';
import 'package:fordev/validation/protocols/protocols.dart';
import 'package:fordev/validation/validators/validators.dart';

Validation makeLoginValidation() {
  return ValidationComposite(validations: makeSignUpnValidations());
}

List<FieldValidation> makeSignUpnValidations() {
  return [
    ...ValidationBuilder.field('email').required().email().build(),
    ...ValidationBuilder.field('password').required().min(3).build()
  ];
}
