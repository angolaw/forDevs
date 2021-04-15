import 'package:faker/faker.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/usecases/authentication.dart';
import 'package:fordev/presentation/presenter/presenter.dart';
import 'package:fordev/presentation/protocols/protocols.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class ValidationSpy extends Mock implements Validation {}

class AuthenticationSpy extends Mock implements Authentication {}

void main() {
  StreamLoginPresenter sut;
  AuthenticationSpy authentication;
  ValidationSpy validation;
  String email;
  String password;
  PostExpectation mockValidationCall(String field) => when(validation.validate(
      field: field == null ? anyNamed('field') : field,
      value: anyNamed('value')));
  void mockValidation({String field, String value}) {
    mockValidationCall(field).thenReturn(value);
  }

  PostExpectation mockAuthenticationCall() => when(authentication.auth(any));
  void mockAuthentication() {
    mockAuthenticationCall()
        .thenAnswer((_) async => AccountEntity(token: faker.guid.guid()));
  }

  setUp(() {
    validation = ValidationSpy();
    authentication = AuthenticationSpy();
    sut = StreamLoginPresenter(
        validation: validation, authentication: authentication);
    email = faker.internet.email();
    password = faker.internet.password();
    mockValidation();
    mockAuthentication();
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
  group("form validation", () {
    test("should emit false in isValidStream if both fields are not validated",
        () {
      //mocking email with error
      mockValidation(field: 'email', value: 'error');
      sut.emailErrorStream
          .listen(expectAsync1((error) => expect(error, 'error')));
      sut.passwordErrorStream
          .listen(expectAsync1((error) => expect(error, null)));

      sut.isFormValidStream
          .listen(expectAsync1((isValid) => expect(isValid, false)));
      sut.validateEmail(email);
      sut.validatePassword(password);
    });
    test("should emit true in isValidStream if both fields are validated",
        () async {
      sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
      sut.passwordErrorStream
          .listen(expectAsync1((error) => expect(error, null)));

      expectLater(sut.isFormValidStream, emitsInAnyOrder([false, true]));
      sut.validateEmail(email);
      await Future.delayed(Duration.zero);
      sut.validatePassword(password);
    });
  });
  group("Authentication validation", () {
    test("should call authentication with correct values", () async {
      sut.validateEmail(email);
      sut.validatePassword(password);
      await sut.auth();
      verify(authentication
              .auth(AuthenticationParams(email: email, secret: password)))
          .called(1);
    });
    test("should emit correct events on Authentication success", () async {
      sut.validateEmail(email);
      sut.validatePassword(password);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.auth();
    });
  });
}
