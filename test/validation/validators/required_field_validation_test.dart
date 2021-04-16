import 'package:test/test.dart';

abstract class FieldValidation {
  String get field;
  String validate(String value);
}

class RequiredFieldValidation implements FieldValidation {
  final String field;

  RequiredFieldValidation(this.field);

  String validate(String value) {
    if (value?.isNotEmpty == true) {
      return null;
    } else {
      return "Campo obrigatorio";
    }
  }
}

void main() {
  RequiredFieldValidation sut;
  setUp(() {
    sut = RequiredFieldValidation('any_field');
  });

  test("should return null if value is not empty", () {
    final error = sut.validate('any_value');

    expect(error, null);
  });
  test("should return error if value is empty", () {
    final error = sut.validate('');
    expect(error, "Campo obrigatorio");
  });
  test("should return error if value is null", () {
    final error = sut.validate(null);
    expect(error, "Campo obrigatorio");
  });
}
