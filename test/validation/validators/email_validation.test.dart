import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/presentation/protocols/protocols.dart';
import 'package:fordev/validation/validators/validators.dart';

void main() {
  EmailValidation sut;
  setUp(() {
    sut = EmailValidation('any_field');
  });
  test('should return null if email is empty', () {
    final error = sut.validate({'any_field': ''});
    expect(error, null);
  });
  test('should return null if email is null', () {
    final error = sut.validate({'any_field': null});
    expect(error, null);
  });
  test('should return null if email is valid', () {
    final error = sut.validate({'any_field': 'wsadevv@gmail.com'});
    expect(error, null);
  });
  test('should return error if email is invalid', () {
    final error = sut.validate({'any_field': 'wsadevv.abc'});
    expect(error, ValidationError.invalidField);
  });
}
