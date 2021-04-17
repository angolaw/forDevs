import 'package:fordev/presentation/protocols/protocols.dart';
import 'package:fordev/validation/validators/validators.dart';

Validation makeLoginValidation() {
  return ValidationComposite(validations: [
    RequiredFieldValidation('email'),
    EmailValidation('email'),
    RequiredFieldValidation('password'),
  ]);
}
