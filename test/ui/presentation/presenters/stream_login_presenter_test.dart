import 'package:faker/faker.dart';
import 'package:fordev/presentation/presenter/presenter.dart';
import 'package:fordev/presentation/protocols/protocols.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class ValidationSpy extends Mock implements Validation {}

void main() {
  StreamLoginPresenter sut;
  ValidationSpy validation;
  String email;
  String password;
  PostExpectation mockValidationCall(String field) => when(validation.validate(
      field: field == null ? anyNamed('field') : field,
      value: anyNamed('value')));
  void mockValidation({String field, String value}) {
    mockValidationCall(field).thenReturn(value);
  }

  setUp(() {
    validation = ValidationSpy();
    sut = StreamLoginPresenter(validation: validation);
    email = faker.internet.email();
    password = faker.internet.password();
    mockValidation();
  });

  group("email validation", () {
    test("should call validation with correct email", () {
      sut.validateEmail(email);
      verify(validation.validate(field: "email", value: email)).called(1);
    });

    test("should emit email error if validation fails", () {
      mockValidation(value: 'error');
      sut.emailErrorStream
          .listen(expectAsync1((error) => expect(error, 'error')));
      sut.validateEmail(email);
      sut.validateEmail(email);
    });
    test("should emit isFormValid if validation fails", () {
      //mockando error
      mockValidation(value: 'error');
      sut.emailErrorStream
          .listen(expectAsync1((error) => expect(error, 'error')));
      sut.isFormValidStream
          .listen(expectAsync1((isValid) => expect(isValid, false)));
      sut.validateEmail(email);
      sut.validateEmail(email);
    });
    test("should emit null if validation succeed", () {
      sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
      sut.isFormValidStream
          .listen(expectAsync1((isValid) => expect(isValid, false)));
      sut.validateEmail(email);
      sut.validateEmail(email);
    });
  });
  group("password validation", () {
    test("should call validation with correct password", () {
      sut.validatePassword(password);
      verify(validation.validate(field: "password", value: password)).called(1);
    });
    test("should emit passwordError if validation fails", () {
      mockValidation(value: 'error');
      sut.passwordErrorStream
          .listen(expectAsync1((error) => expect(error, 'error')));

      sut.validatePassword(password);
      sut.validatePassword(password);
    });
    test("should emit passwordError as null if validation succeed", () {
      sut.passwordErrorStream
          .listen(expectAsync1((error) => expect(error, null)));
      sut.isFormValidStream
          .listen(expectAsync1((isValid) => expect(isValid, false)));

      sut.validatePassword(password);
      sut.validatePassword(password);
    });
  });
}
