import 'package:faker/faker.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/save_current_account.dart';
import 'package:fordev/domain/usecases/usecases.dart';
import 'package:fordev/presentation/presenter/presenter.dart';
import 'package:fordev/presentation/protocols/protocols.dart';
import 'package:fordev/ui/helpers/errors/errors.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class ValidationSpy extends Mock implements Validation {}

class SaveCurrentAccountSpy extends Mock implements SaveCurrentAccount {}

class AddAccountSpy extends Mock implements AddAccount {}

void main() {
  GetxSignupPresenter sut;
  ValidationSpy validation;
  String email;
  String password;
  String name;
  String passwordConfirmation;
  String token;
  AddAccountSpy addAccount;
  SaveCurrentAccount saveCurrentAccount;

  PostExpectation mockValidationCall(String field) => when(validation.validate(
      field: field == null ? anyNamed('field') : field,
      value: anyNamed('value')));
  PostExpectation mockAddAccountCall() => when(addAccount.add(any));

  void mockAddAccountError(DomainError error) {
    mockAddAccountCall().thenThrow(error);
  }

  void mockValidation({String field, ValidationError value}) {
    mockValidationCall(field).thenReturn(value);
  }

  void mockAddAccount() {
    mockAddAccountCall().thenAnswer((_) => AccountEntity(token: token));
  }

  PostExpectation mockSaveCurrentAccountCall() =>
      when(saveCurrentAccount.save(any));

  void mockSaveCurrentAccountError() {
    mockSaveCurrentAccountCall().thenThrow(DomainError.unexpected);
  }

  setUp(() {
    validation = ValidationSpy();
    addAccount = AddAccountSpy();
    saveCurrentAccount = SaveCurrentAccountSpy();

    sut = GetxSignupPresenter(
        validation: validation,
        addAccount: addAccount,
        saveCurrentAccount: saveCurrentAccount);
    email = faker.internet.email();
    password = faker.internet.password();
    passwordConfirmation = faker.internet.password();
    token = faker.guid.guid();
    mockAddAccount();
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

  group("password validation", () {
    test("should call validation with correct password", () {
      sut.validatePassword(password);
      verify(validation.validate(field: "password", value: password)).called(1);
    });

    test("should emit invalidFieldError if password is not valid", () {
      mockValidation(value: ValidationError.invalidField);
      sut.passwordErrorStream
          .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
      sut.isFormValidStream
          .listen(expectAsync1((isValid) => expect(isValid, false)));
      sut.validatePassword(password);
      sut.validatePassword(password);
    });
    test("should emit requiredFieldError if password empty", () {
      mockValidation(value: ValidationError.requiredField);
      sut.passwordErrorStream.listen(
          expectAsync1((error) => expect(error, UIError.requiredField)));
      sut.isFormValidStream
          .listen(expectAsync1((isValid) => expect(isValid, false)));
      sut.validatePassword(password);
      sut.validatePassword(password);
    });
    test("should emit isFormValid if validation fails", () {
      //mockando error
      mockValidation(value: ValidationError.invalidField);
      sut.passwordErrorStream
          .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
      sut.isFormValidStream
          .listen(expectAsync1((isValid) => expect(isValid, false)));
      sut.validatePassword(password);
      sut.validatePassword(password);
    });
    test("should emit null if validation succeed", () {
      sut.passwordErrorStream
          .listen(expectAsync1((error) => expect(error, null)));
      sut.isFormValidStream
          .listen(expectAsync1((isValid) => expect(isValid, false)));
      sut.validatePassword(password);
      sut.validatePassword(password);
    });
  });
  group("passwordConfirmation validation", () {
    test("should call validation with correct password confirmation", () {
      sut.validateConfirmationPassword(passwordConfirmation);
      verify(validation.validate(
              field: "passwordConfirmation", value: passwordConfirmation))
          .called(1);
    });

    test("should emit invalidFieldError if passwordConfirmation is not valid",
        () {
      mockValidation(value: ValidationError.invalidField);
      sut.passwordConfirmationErrorStream
          .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
      sut.isFormValidStream
          .listen(expectAsync1((isValid) => expect(isValid, false)));
      sut.validateConfirmationPassword(passwordConfirmation);
      sut.validateConfirmationPassword(passwordConfirmation);
    });
    test("should emit requiredFieldError if password empty", () {
      mockValidation(value: ValidationError.requiredField);
      sut.passwordConfirmationErrorStream.listen(
          expectAsync1((error) => expect(error, UIError.requiredField)));
      sut.isFormValidStream
          .listen(expectAsync1((isValid) => expect(isValid, false)));
      sut.validateConfirmationPassword(passwordConfirmation);
      sut.validateConfirmationPassword(passwordConfirmation);
    });
    test("should emit isFormValid if validation fails", () {
      //mockando error
      mockValidation(value: ValidationError.invalidField);
      sut.passwordConfirmationErrorStream
          .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
      sut.isFormValidStream
          .listen(expectAsync1((isValid) => expect(isValid, false)));
      sut.validateConfirmationPassword(passwordConfirmation);
      sut.validateConfirmationPassword(passwordConfirmation);
    });
    test("should emit null if validation succeed", () {
      sut.passwordConfirmationErrorStream
          .listen(expectAsync1((error) => expect(error, null)));
      sut.isFormValidStream
          .listen(expectAsync1((isValid) => expect(isValid, false)));
      sut.validateConfirmationPassword(passwordConfirmation);
      sut.validateConfirmationPassword(passwordConfirmation);
    });
  });

  group("mame validation", () {
    test("should call validation with correct name", () {
      sut.validateName(name);
      verify(validation.validate(field: "name", value: name)).called(1);
    });

    test("should emit invalidFieldError if name is not valid", () {
      mockValidation(value: ValidationError.invalidField);
      sut.nameErrorStream
          .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
      sut.isFormValidStream
          .listen(expectAsync1((isValid) => expect(isValid, false)));
      sut.validateName(name);
      sut.validateName(name);
    });
    test("should emit requiredFieldError if name empty", () {
      mockValidation(value: ValidationError.requiredField);
      sut.nameErrorStream.listen(
          expectAsync1((error) => expect(error, UIError.requiredField)));
      sut.isFormValidStream
          .listen(expectAsync1((isValid) => expect(isValid, false)));
      sut.validateName(name);
      sut.validateName(name);
    });
    test("should emit isFormValid if validation fails", () {
      //mockando error
      mockValidation(value: ValidationError.invalidField);
      sut.nameErrorStream
          .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
      sut.isFormValidStream
          .listen(expectAsync1((isValid) => expect(isValid, false)));
      sut.validateName(name);
      sut.validateName(name);
    });
    test("should emit null if validation succeed", () {
      sut.nameErrorStream.listen(expectAsync1((error) => expect(error, null)));
      sut.isFormValidStream
          .listen(expectAsync1((isValid) => expect(isValid, false)));
      sut.validateName(name);
      sut.validateName(name);
    });
  });
  group("form Validation", () {
    test("should enable form button if all fields are valid", () async {
      expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

      sut.validateEmail(email);
      await Future.delayed(Duration.zero);

      sut.validatePassword(password);
      await Future.delayed(Duration.zero);

      sut.validateConfirmationPassword(passwordConfirmation);
      await Future.delayed(Duration.zero);

      sut.validateName(name);
      await Future.delayed(Duration.zero);
    });
  });
  group("Authentication validation", () {
    test('Should call AddAccount with correct values', () async {
      sut.validateName(name);
      sut.validateEmail(email);
      sut.validatePassword(password);
      sut.validateConfirmationPassword(passwordConfirmation);

      await sut.signUp();

      verify(addAccount.add(AddAccountParams(
              name: name,
              email: email,
              password: password,
              passwordConfirmation: passwordConfirmation)))
          .called(1);
    });
    test("should call SaveCurrentAccount with correct values", () async {
      sut.validateName(name);
      sut.validateEmail(email);
      sut.validatePassword(password);
      sut.validateConfirmationPassword(passwordConfirmation);

      await sut.signUp();
      verify(saveCurrentAccount.save(AccountEntity(token: token))).called(1);
    });
    test("should emit UnexpectedError if saveCurrentAccount fails", () async {
      mockSaveCurrentAccountError();
      sut.validateName(name);
      sut.validateEmail(email);
      sut.validatePassword(password);
      sut.validateConfirmationPassword(passwordConfirmation);

      await sut.signUp();
      verify(saveCurrentAccount.save(AccountEntity(token: token))).called(1);
    });
    test("should emit  UnexpectedError if emailInUse error fails", () async {
      mockSaveCurrentAccountError();
      sut.validateName(name);
      sut.validateEmail(email);
      sut.validatePassword(password);
      sut.validateConfirmationPassword(passwordConfirmation);

      expectLater(sut.isLoadingStream, emits(true));
      sut.mainErrorStream
          .listen(expectAsync1((error) => expect(error, UIError.unexpected)));

      await sut.signUp();
    });

    test("should emit correct events on addAccount success", () async {
      sut.validateName(name);
      sut.validateEmail(email);
      sut.validatePassword(password);
      sut.validateConfirmationPassword(passwordConfirmation);

      expectLater(sut.isLoadingStream, emits(true));

      await sut.signUp();
    });

    test("should emit correct events on emailInUseError", () async {
      mockAddAccountError(DomainError.emailInUse);
      sut.validateName(name);
      sut.validateEmail(email);
      sut.validatePassword(password);
      sut.validateConfirmationPassword(passwordConfirmation);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      sut.mainErrorStream
          .listen(expectAsync1((error) => expect(error, UIError.emailInUse)));

      await sut.signUp();
    });
    test("should emit correct events on UnexpectedError", () async {
      mockAddAccountError(DomainError.unexpected);
      sut.validateName(name);
      sut.validateEmail(email);
      sut.validatePassword(password);
      sut.validateConfirmationPassword(passwordConfirmation);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      sut.mainErrorStream
          .listen(expectAsync1((error) => expect(error, UIError.unexpected)));

      await sut.signUp();
    });
  });
}
