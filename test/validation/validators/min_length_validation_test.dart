import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/presentation/protocols/protocols.dart';
import 'package:fordev/validation/protocols/protocols.dart';
import 'package:meta/meta.dart';

class MinLengthValidation implements FieldValidation {
  final String field;
  final int size;
  MinLengthValidation({
    @required this.field,
    @required this.size,
  });
  ValidationError validate(String value) {
    return value?.length == size ? null : ValidationError.invalidField;
  }
}

void main() {
  MinLengthValidation sut;
  setUp(() {
    sut = MinLengthValidation(field: 'any_field', size: 5);
  });

  test('should return error if value is empty', () {
    final error = sut.validate('');
    expect(error, ValidationError.invalidField);
  });
  test('should return error if value is null', () {
    final error = sut.validate(null);
    expect(error, ValidationError.invalidField);
  });
  test('should return error if value is less than min size', () {
    final error = sut.validate(faker.randomGenerator.string(4, min: 1));
    expect(error, ValidationError.invalidField);
  });

  test('should return no error if value is equals to min size', () {
    final error = sut.validate(faker.randomGenerator.string(5, min: 5));
    expect(error, null);
  });
}
