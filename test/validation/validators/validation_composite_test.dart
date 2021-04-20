import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/presentation/protocols/protocols.dart';
import 'package:fordev/validation/protocols/protocols.dart';
import 'package:fordev/validation/validators/validation_composite.dart';
import 'package:mockito/mockito.dart';

class FieldValidationSpy extends Mock implements FieldValidation {}

void main() {
  ValidationComposite sut;
  FieldValidationSpy validation1;
  FieldValidationSpy validation2;
  FieldValidationSpy validation3;
  void mockValidation1(ValidationError error) {
    when(validation1.validate(any)).thenReturn(error);
  }

  void mockValidation2(ValidationError error) {
    when(validation2.validate(any)).thenReturn(error);
  }

  void mockValidation3(ValidationError error) {
    when(validation3.validate(any)).thenReturn(error);
  }

  setUp(() {
    validation1 = FieldValidationSpy();
    when((validation1.field)).thenReturn('any_field');
    mockValidation1(null);
    validation2 = FieldValidationSpy();
    when((validation2.field)).thenReturn('any_field');
    mockValidation2(null);
    validation3 = FieldValidationSpy();
    when((validation2.field)).thenReturn('other_field');
    mockValidation3(null);
    sut = ValidationComposite(
        validations: [validation1, validation2, validation3]);
  });
  test('should return null if all validations return null or empty', () {
    final error = sut.validate(field: 'any_field', value: 'any_value');
    expect(error, null);
  });
  test('should the first error of the field', () {
    mockValidation1(ValidationError.requiredField);
    mockValidation2(ValidationError.requiredField);
    mockValidation3(ValidationError.invalidField);
    final error = sut.validate(field: 'any_field', value: 'any_value');
    print("Error $error");
    expect(error, ValidationError.requiredField);
  });
}
