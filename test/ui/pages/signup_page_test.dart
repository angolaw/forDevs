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
  StreamController<UIError> nameErrorController;
  StreamController<UIError> emailErrorController;
  StreamController<UIError> passwordErrorController;
  StreamController<UIError> passwordConfirmationErrorController;
  StreamController<UIError> mainErrorController;
  StreamController<bool> isFormValidController;
  StreamController<bool> isLoadingController;
  StreamController<String> navigateToController;

  void initStreams() {
    nameErrorController = StreamController<UIError>();
    emailErrorController = StreamController<UIError>();
    passwordErrorController = StreamController<UIError>();
    passwordConfirmationErrorController = StreamController<UIError>();
    mainErrorController = StreamController<UIError>();
    isFormValidController = StreamController<bool>();
    isLoadingController = StreamController<bool>();
    navigateToController = StreamController<String>();
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
    when(presenter.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);
    when(presenter.isFormValidStream)
        .thenAnswer((_) => isFormValidController.stream);
    when(presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(presenter.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);
  }

  void closeStreams() {
    nameErrorController.close();
    emailErrorController.close();
    passwordErrorController.close();
    passwordConfirmationErrorController.close();
    isFormValidController.close();
    isLoadingController.close();
    mainErrorController.close();
    navigateToController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SignUpPresenterSpy();
    initStreams();
    mockStreams();
    final signUpPage = GetMaterialApp(
      initialRoute: '/signup',
      getPages: [
        GetPage(
            name: '/signup',
            page: () => SignUpPage(
                  presenter: presenter,
                )),
        GetPage(
            name: "/any_route",
            page: () => Scaffold(
                  body: Text("fake page"),
                )),
      ],
    );
    await tester.pumpWidget(signUpPage);
  }

  tearDown(() {
    closeStreams();
  });

  //error testing
  testWidgets('Should call validate with correct values',
      (WidgetTester tester) async {
    await loadPage(tester);

    final name = faker.person.name();
    await tester.enterText(find.bySemanticsLabel('Nome'), name);
    verify(presenter.validateName(name));

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('Email'), email);
    verify(presenter.validateEmail(email));

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Senha'), password);
    verify(presenter.validatePassword(password));

    final confirmationPassword = faker.internet.password();
    await tester.enterText(
        find.bySemanticsLabel('Confirmar senha'), confirmationPassword);

    verify(presenter.validatePasswordConfirmation(confirmationPassword));
  });
  group("email test", () {
    testWidgets("should present email error if email is invalid",
        (WidgetTester tester) async {
      await loadPage(tester);
      emailErrorController.add(UIError.invalidField);
      await tester.pump();
      expect(find.text('Campo inválido'), findsOneWidget);
      emailErrorController.add(UIError.requiredField);
      await tester.pump();
      expect(find.text('Campo obrigatório'), findsOneWidget);
      emailErrorController.add(null);
      await tester.pump();
      final emailTextChildren = find.descendant(
          of: find.bySemanticsLabel('Email'), matching: find.byType(Text));
      expect(emailTextChildren, findsOneWidget);
    });
  });

  group("password test", () {
    testWidgets("should present password error if email is invalid",
        (WidgetTester tester) async {
      await loadPage(tester);
      passwordErrorController.add(UIError.invalidField);
      await tester.pump();
      expect(find.text('Campo inválido'), findsOneWidget);
      passwordErrorController.add(UIError.requiredField);
      await tester.pump();
      expect(find.text('Campo obrigatório'), findsOneWidget);
      passwordErrorController.add(null);
      await tester.pump();
      final passwordTextChildren = find.descendant(
          of: find.bySemanticsLabel('Senha'), matching: find.byType(Text));
      expect(passwordTextChildren, findsOneWidget);
    });
  });
  group("password confirmation test", () {
    testWidgets("should present passwordConfirmation error if email is invalid",
        (WidgetTester tester) async {
      await loadPage(tester);
      passwordConfirmationErrorController.add(UIError.invalidField);
      await tester.pump();
      expect(find.text('Campo inválido'), findsOneWidget);
      passwordConfirmationErrorController.add(UIError.requiredField);
      await tester.pump();
      expect(find.text('Campo obrigatório'), findsOneWidget);
      passwordConfirmationErrorController.add(null);
      await tester.pump();
      final passwordConfirmationTextChildren = find.descendant(
          of: find.bySemanticsLabel('Confirmar senha'),
          matching: find.byType(Text));
      expect(passwordConfirmationTextChildren, findsOneWidget);
    });
  });
  group("name test", () {
    testWidgets("should present name error if email is invalid",
        (WidgetTester tester) async {
      await loadPage(tester);
      nameErrorController.add(UIError.invalidField);
      await tester.pump();
      expect(find.text('Campo inválido'), findsOneWidget);
      nameErrorController.add(UIError.requiredField);
      await tester.pump();
      expect(find.text('Campo obrigatório'), findsOneWidget);
      nameErrorController.add(null);
      await tester.pump();
      final nameTextChildren = find.descendant(
          of: find.bySemanticsLabel('Nome'), matching: find.byType(Text));
      expect(nameTextChildren, findsOneWidget);
    });
  });
  group("button test", () {
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
  group("sign up actions", () {
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
      isLoadingController.add(false);
      await tester.pump();
      await tester.tap(find.byType(RaisedButton));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
    testWidgets("should call signup on form submit",
        (WidgetTester tester) async {
      await loadPage(tester);
      isFormValidController.add(true);
      await tester.pump();
      final button = find.byType(RaisedButton);
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pump();

      verify(presenter.signUp()).called(1);
    });

    testWidgets("should present error on signUp failure",
        (WidgetTester tester) async {
      await loadPage(tester);
      mainErrorController.add(UIError.emailInUse);
      await tester.pump();
      expect(find.text("O email já está em uso"), findsOneWidget);
    });

    testWidgets("should present error on signUp throws",
        (WidgetTester tester) async {
      await loadPage(tester);
      mainErrorController.add(UIError.unexpected);
      await tester.pump();
      expect(
          find.text("Algo errado aconteceu. Tente novamente"), findsOneWidget);
    });

    testWidgets("should not present error on signUp success",
        (WidgetTester tester) async {
      await loadPage(tester);
      mainErrorController.add(null);
      await tester.pump();

      expect(find.text('main error'), findsNothing);
    });
    testWidgets("should change page on signUp success",
        (WidgetTester tester) async {
      await loadPage(tester);
      navigateToController.add('/any_route');
      await tester.pumpAndSettle();

      expect(Get.currentRoute, '/any_route');

      expect(find.text('fake page'), findsOneWidget);
    });
    testWidgets("should not load page on invalid parameters",
        (WidgetTester tester) async {
      await loadPage(tester);
      navigateToController.add('');
      await tester.pump();
      expect(Get.currentRoute, '/signup');

      navigateToController.add(null);
      await tester.pump();
      expect(Get.currentRoute, '/signup');
    });
    testWidgets("should call goToLogin on link click",
        (WidgetTester tester) async {
      await loadPage(tester);
      final button = find.text('Login');
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pump();

      verify(presenter.goToLogin()).called(1);
    });
  });
}
