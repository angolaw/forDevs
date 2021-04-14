import 'package:faker/faker.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class StreamLoginPresenter {
  final Validation validation;

  StreamLoginPresenter({@required this.validation});
  void validateEmail(String email) {
    validation.validate(field: 'email', value: email);
  }
}

abstract class Validation {
  validate({@required String field, @required String value});
}

class ValidationSpy extends Mock implements Validation {}

void main() {
  StreamLoginPresenter sut;
  ValidationSpy validation;
  String email;
  setUp(() {
    validation = ValidationSpy();
    sut = StreamLoginPresenter(validation: validation);
    email = faker.internet.email();
  });

  test("should call validation with correct email", () {
    sut.validateEmail(email);
    verify(validation.validate(field: "email", value: email)).called(1);
  });
}
