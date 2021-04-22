import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/ui/helpers/helpers.dart';
import 'package:fordev/ui/pages/signup/signup.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

class SignUpPresenterSpy extends Mock implements SignUpPresenter {}

void main() {
  SignUpPresenter presenter;
  StreamController<UIError> emailErrorController;
  StreamController<UIError> nameErrorController;
  StreamController<UIError> passwordErrorController;
  StreamController<UIError> passwordConfirmationErrorController;

  void initStreams() {
    emailErrorController = StreamController<UIError>();
    passwordErrorController = StreamController<UIError>();
    nameErrorController = StreamController<UIError>();
    passwordErrorController = StreamController<UIError>();
  }

  void mockStreams() {
    when(presenter.nameErrorStream)
        .thenAnswer((_) => nameErrorController.stream);
    when(presenter.emailErrorStream)
        .thenAnswer((_) => emailErrorController.stream);
    when(presenter.passwordErrorStream)
        .thenAnswer((_) => passwordErrorController.stream);
    when(presenter.passwordConfirmationErrorStream)
        .thenAnswer((_) => passwordConfirmationErrorController.stream);
  }

  void closeStreams() {
    emailErrorController.close();
    passwordErrorController.close();
    nameErrorController.close();
    passwordConfirmationErrorController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SignUpPresenterSpy();
    initStreams();
    mockStreams();
    final signUpPage = GetMaterialApp(
      initialRoute: '/signup',
      getPages: [
        GetPage(
          name: "/signup",
          page: () => SignUpPage(
            presenter: presenter,
          ),
        ),
      ],
    );
    await tester.pumpWidget(signUpPage);
  }

  tearDown(() {
    closeStreams();
  });

  group("Sign Up page", () {
    testWidgets("Should load with initial state correct",
        (WidgetTester tester) async {
      //arrange
      await loadPage(tester);

      final emailTextChildren = find.descendant(
          of: find.bySemanticsLabel("Email"), matching: find.byType(Text));
      expect(emailTextChildren, findsOneWidget,
          reason:
              'when a textformfield has only one child, means it has no error, since this child is the hint text');
      final nameTextChildren = find.descendant(
          of: find.bySemanticsLabel("Nome"), matching: find.byType(Text));
      expect(nameTextChildren, findsOneWidget,
          reason:
              'when a textformfield has only one child, means it has no error, since this child is the hint text');

      final passwordTextChildren = find.descendant(
          of: find.bySemanticsLabel("Senha"), matching: find.byType(Text));
      expect(passwordTextChildren, findsOneWidget,
          reason:
              'when a textformfield has only one child, means it has no error, since this child is the hint text');

      final passwordConfirmationTextChildren = find.descendant(
          of: find.bySemanticsLabel("Confirmar senha"),
          matching: find.byType(Text));
      expect(passwordConfirmationTextChildren, findsOneWidget,
          reason:
              'when a textformfield has only one child, means it has no error, since this child is the hint text');

      final button = tester.widget<RaisedButton>(find.byType(RaisedButton));

      expect(button.onPressed, null);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    //validate form
  });
  group("validate fields", () {
    testWidgets("should call validate with correct values",
        (WidgetTester tester) async {
      //arrange
      await loadPage(tester);

      final email = faker.internet.email();
      await tester.enterText(find.bySemanticsLabel("Email"), email);
      verify(presenter.validateEmail(email));
      final name = faker.person.name();
      await tester.enterText(find.bySemanticsLabel("Nome"), name);
      verify(presenter.validateName(name));

      final password = faker.internet.password();
      await tester.enterText(find.bySemanticsLabel("Senha"), password);
      //verify if validatePassword is called
      verify(presenter.validatePassword(password));

      await tester.enterText(
          find.bySemanticsLabel("Confirmar senha"), password);
      //verify if validatePassword is called
      verify(presenter.validatePasswordConfirmation(password));
    });
  });

  //
}
