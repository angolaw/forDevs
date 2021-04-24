import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/presentation/protocols/protocols.dart';
import 'package:fordev/validation/validators/validators.dart';

void main() {
  CompareFieldsValidation sut;
  setUp(() {
    sut = CompareFieldsValidation(
        field: 'any_field', valueToCompare: 'any_value');
  });

  test('should return error values are not the same', () {
    final error = sut.validate('wrong_value');
    expect(error, ValidationError.invalidField);
  });
  test('should return no error if the values are the same', () {
    final error = sut.validate('any_value');
    expect(error, null);
  });
}
