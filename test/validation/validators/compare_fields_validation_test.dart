import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/presentation/protocols/protocols.dart';
import 'package:fordev/validation/protocols/protocols.dart';
import 'package:meta/meta.dart';

class CompareFieldsValidation implements FieldValidation {
  final String field;
  final String valueToCompare;

  CompareFieldsValidation(
      {@required this.field, @required this.valueToCompare});
  ValidationError validate(String value) {
    return ValidationError.invalidField;
  }
}

void main() {
  CompareFieldsValidation sut;
  setUp(() {
    sut = CompareFieldsValidation(
        field: 'any_field', valueToCompare: 'any_value');
  });

  test('should return error values are note the same', () {
    final error = sut.validate('wrong_value');
    expect(error, ValidationError.invalidField);
  });
}
