import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/validation/protocols/protocols.dart';

class EmailValidation implements FieldValidation {
  final String field;
  EmailValidation(this.field);

  String validate(String value) {
    final regex = RegExp(r"^[a-zA-Z0-9_.-]+@[a-zA-Z0-9-]+.[a-zA-Z0-9-.]+$");

    final isValid = value?.isNotEmpty != true || regex.hasMatch(value);
    return isValid ? null : "Campo invalido";
  }
}

void main() {
  EmailValidation sut;
  setUp(() {
    sut = EmailValidation('any_field');
  });
  test('should return null if email is empty', () {
    final error = sut.validate('');
    expect(error, null);
  });
  test('should return null if email is null', () {
    final error = sut.validate(null);
    expect(error, null);
  });
  test('should return null if email is valid', () {
    final error = sut.validate('wsadevv@gmail.com');
    expect(error, null);
  });
  test('should return error if email is invalid', () {
    final error = sut.validate('wsadevv.abc');
    expect(error, "Campo invalido");
  });
}
