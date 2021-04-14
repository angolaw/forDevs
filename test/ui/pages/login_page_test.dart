import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/ui/pages/pages.dart';
import 'package:mockito/mockito.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

void main() {
  LoginPresenter presenter;
  StreamController<String> emailErrorController;
  StreamController<String> passwordErrorController;
  StreamController<bool> isFormValidController;
  StreamController<bool> isLoadingController;
  StreamController<String> mainErrorController;

  void initStreams() {
    emailErrorController = StreamController<String>();
    passwordErrorController = StreamController<String>();
    isFormValidController = StreamController<bool>();
    isLoadingController = StreamController<bool>();
    mainErrorController = StreamController<String>();
  }

  void mockStreams() {
    when(presenter.emailErrorStream)
        .thenAnswer((_) => emailErrorController.stream);
    when(presenter.passwordErrorStream)
        .thenAnswer((_) => passwordErrorController.stream);
    when(presenter.isFormValidStream)
        .thenAnswer((_) => isFormValidController.stream);
    when(presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(presenter.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);
  }

  void closeStreams() {
    emailErrorController.close();
    passwordErrorController.close();
    isFormValidController.close();
    isLoadingController.close();
    mainErrorController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = LoginPresenterSpy();
    initStreams();
    mockStreams();

    final loginPage = MaterialApp(
      home: LoginPage(
        presenter: presenter,
      ),
    );
    await tester.pumpWidget(loginPage);
  }

  tearDown(() {
    closeStreams();
  });

  group("loginPage", () {
    testWidgets("Should load with initial state correct",
        (WidgetTester tester) async {
      //arrange
      await loadPage(tester);

      final emailTextChildren = find.descendant(
          of: find.bySemanticsLabel("Email"), matching: find.byType(Text));

      expect(emailTextChildren, findsOneWidget,
          reason:
              'when a textformfield has only one child, means it has no error, since this child is the hint text');

      final passwordTextChildren = find.descendant(
          of: find.bySemanticsLabel("Senha"), matching: find.byType(Text));

      expect(passwordTextChildren, findsOneWidget,
          reason:
              'when a textformfield has only one child, means it has no error, since this child is the hint text');

      final button = tester.widget<RaisedButton>(find.byType(RaisedButton));

      expect(button.onPressed, null);
    });

    //validate form
    testWidgets("should call validate with correct values",
        (WidgetTester tester) async {
      //arrange
      await loadPage(tester);

      final email = faker.internet.email();
      await tester.enterText(find.bySemanticsLabel("Email"), email);
      verify(presenter.validateEmail(email));

      final password = faker.internet.password();
      await tester.enterText(find.bySemanticsLabel("Senha"), password);
      verify(presenter.validatePassword(password));
    });
  });

  //

  group("email test", () {
    testWidgets("should present error if email is invalid",
        (WidgetTester tester) async {
      await loadPage(tester);
      emailErrorController.add('any error');
      await tester.pump();
      expect(find.text('any error'), findsOneWidget);
    });
    testWidgets("should present no error if email is valid",
        (WidgetTester tester) async {
      await loadPage(tester);
      emailErrorController.add(null);
      await tester.pump();
      final emailTextChildren = find.descendant(
          of: find.bySemanticsLabel('Email'), matching: find.byType(Text));
      expect(emailTextChildren, findsOneWidget);
    });
    testWidgets("should present no error if email is valid with empty string",
        (WidgetTester tester) async {
      await loadPage(tester);
      emailErrorController.add('');
      await tester.pump();
      final emailTextChildren = find.descendant(
          of: find.bySemanticsLabel('Email'), matching: find.byType(Text));
      expect(emailTextChildren, findsOneWidget);
    });
  });
  group("password test", () {
    testWidgets("should present error if password is invalid",
        (WidgetTester tester) async {
      await loadPage(tester);
      passwordErrorController.add('any error');
      await tester.pump();
      expect(find.text('any error'), findsOneWidget);
    });
    testWidgets("should present no error if password is valid",
        (WidgetTester tester) async {
      await loadPage(tester);
      passwordErrorController.add(null);
      await tester.pump();
      final passwordTextChildren = find.descendant(
          of: find.bySemanticsLabel('Senha'), matching: find.byType(Text));
      expect(passwordTextChildren, findsOneWidget);
    });
    testWidgets("should present no error if email is valid with empty string",
        (WidgetTester tester) async {
      await loadPage(tester);
      passwordErrorController.add('');
      await tester.pump();
      final passwordTextChildren = find.descendant(
          of: find.bySemanticsLabel('Email'), matching: find.byType(Text));
      expect(passwordTextChildren, findsOneWidget);
    });
  });
  group("button", () {
    testWidgets("should enable button if form is valid",
        (WidgetTester tester) async {
      await loadPage(tester);
      isFormValidController.add(true);
      await tester.pump();
      final button = tester.widget<RaisedButton>(find.byType(RaisedButton));
      expect(button.onPressed, isNotNull);
    });
    testWidgets("should disable button if form is invalid",
        (WidgetTester tester) async {
      await loadPage(tester);
      isFormValidController.add(false);
      await tester.pump();
      final button = tester.widget<RaisedButton>(find.byType(RaisedButton));
      expect(button.onPressed, isNull);
    });
  });
  group("login", () {
    testWidgets("should call authentication on form submit",
        (WidgetTester tester) async {
      await loadPage(tester);
      isFormValidController.add(true);
      await tester.pump();
      await tester.tap(find.byType(RaisedButton));
      await tester.pump();

      verify(presenter.auth()).called(1);
    });
    testWidgets("should show loading on form submit",
        (WidgetTester tester) async {
      await loadPage(tester);
      isLoadingController.add(true);
      await tester.pump();
      await tester.tap(find.byType(RaisedButton));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
    testWidgets("should hide loading on form submit",
        (WidgetTester tester) async {
      await loadPage(tester);
      isLoadingController.add(true);
      await tester.pump();
      isLoadingController.add(false);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
    testWidgets("should present error on authentication failure",
        (WidgetTester tester) async {
      await loadPage(tester);
      mainErrorController.add('main error');
      await tester.pump();
      expect(find.text('main error'), findsOneWidget);
    });
    testWidgets("should not present error on authentication success",
        (WidgetTester tester) async {
      await loadPage(tester);
      mainErrorController.add(null);
      await tester.pump();

      expect(find.text('main error'), findsNothing);
    });
    testWidgets("should close streams on dispose", (WidgetTester tester) async {
      await loadPage(tester);
      addTearDown(() {
        verify(presenter.dispose()).called(1);
      });
    });
  });
}
