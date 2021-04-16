import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/validation/protocols/protocols.dart';

class EmailValidation implements FieldValidation {
  final String field;
  EmailValidation(this.field);

  String validate(String value) {
    return null;
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
}
