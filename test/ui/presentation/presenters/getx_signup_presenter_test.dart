import 'package:faker/faker.dart';
import 'package:fordev/domain/usecases/save_current_account.dart';
import 'package:fordev/presentation/presenter/presenter.dart';
import 'package:fordev/presentation/protocols/protocols.dart';
import 'package:fordev/ui/helpers/errors/errors.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class ValidationSpy extends Mock implements Validation {}

class SaveCurrentAccountSpy extends Mock implements SaveCurrentAccount {}

void main() {
  GetxSignupPresenter sut;
  ValidationSpy validation;
  String email;

  PostExpectation mockValidationCall(String field) => when(validation.validate(
      field: field == null ? anyNamed('field') : field,
      value: anyNamed('value')));

  void mockValidation({String field, ValidationError value}) {
    mockValidationCall(field).thenReturn(value);
  }

  setUp(() {
    validation = ValidationSpy();

    sut = GetxSignupPresenter(validation: validation);
    email = faker.internet.email();

    mockValidation();
  });

  group("email validation", () {
    test("should call validation with correct email", () {
      sut.validateEmail(email);
      verify(validation.validate(field: "email", value: email)).called(1);
    });

    test("should emit invalidFieldError if email is not valid", () {
      mockValidation(value: ValidationError.invalidField);
      sut.emailErrorStream
          .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
      sut.isFormValidStream
          .listen(expectAsync1((isValid) => expect(isValid, false)));
      sut.validateEmail(email);
      sut.validateEmail(email);
    });
    test("should emit requiredFieldError if email empty", () {
      mockValidation(value: ValidationError.requiredField);
      sut.emailErrorStream.listen(
          expectAsync1((error) => expect(error, UIError.requiredField)));
      sut.isFormValidStream
          .listen(expectAsync1((isValid) => expect(isValid, false)));
      sut.validateEmail(email);
      sut.validateEmail(email);
    });
    test("should emit isFormValid if validation fails", () {
      //mockando error
      mockValidation(value: ValidationError.invalidField);
      sut.emailErrorStream
          .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
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
}
