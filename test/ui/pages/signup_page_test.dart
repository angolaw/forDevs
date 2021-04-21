import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/ui/pages/pages.dart';
import 'package:fordev/ui/pages/signup/signup.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

void main() {
  Future<void> loadPage(WidgetTester tester) async {
    final signUpPage = GetMaterialApp(
      initialRoute: '/signup',
      getPages: [
        GetPage(
          name: "/signup",
          page: () => SignUpPage(),
        ),
      ],
    );
    await tester.pumpWidget(signUpPage);
  }

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

  //
}
