import 'dart:async';

import 'package:faker/faker.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class LoginState {
  String emailError;
}

class StreamLoginPresenter {
  final Validation validation;
  StreamLoginPresenter({@required this.validation});

  final _controller = StreamController<LoginState>.broadcast();
  var _state = LoginState();
  Stream<String> get emailErrorStream =>
      _controller.stream.map((state) => state.emailError);

  void validateEmail(String email) {
    _state.emailError = validation.validate(field: 'email', value: email);
    _controller.add(_state);
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
    mockValidation();
  });

  test("should call validation with correct email", () {
    sut.validateEmail(email);
    verify(validation.validate(field: "email", value: email)).called(1);
  });

  test("should emit email error if validation fails", () {
    mockValidation(value: 'error');
    expectLater(sut.emailErrorStream, emits('error'));
    sut.validateEmail(email);
  });
}
