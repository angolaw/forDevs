import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/presentation/protocols/protocols.dart';
import 'package:fordev/validation/validators/validators.dart';

void main() {
  CompareFieldsValidation sut;
  setUp(() {
    sut = CompareFieldsValidation(
        field: 'any_field', fieldToCompare: 'other_field');
  });

  test('should return error values are not the same', () {
    final formData = {'any_field': 'any_value', 'other_field': 'other_value'};
    final error = sut.validate(formData);
    expect(error, ValidationError.invalidField);
  });
  test('should return null on invalid cases', () {
    expect(sut.validate({'any_field': 'any_value'}), null);
    expect(sut.validate({'other_field': 'any_value'}), null);
    expect(sut.validate({}), null);
  });
  test('should return no error if the values are the same', () {
    final formData = {'any_field': 'any_value', 'other_field': 'any_value'};
    final error = sut.validate(formData);
    expect(error, null);
  });
}
