import 'package:flutter/material.dart';

ThemeData makeAppTheme() {
  final primaryColor = Color.fromRGBO(136, 14, 79, 1);
  final primaryColorDark = Color.fromRGBO(96, 0, 39, 1);
  final primaryColorLight = Color.fromRGBO(188, 71, 123, 1);

  InputDecorationTheme inputDecorationTheme() {
    return InputDecorationTheme(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: primaryColorDark),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: primaryColorLight),
        ),
        alignLabelWithHint: true);
  }

  ButtonThemeData buttonTheme() {
    return ButtonThemeData(
      colorScheme: ColorScheme.light(primary: primaryColor),
      buttonColor: primaryColor,
      splashColor: primaryColorLight,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  return ThemeData(
      primaryColor: primaryColor,
      primaryColorDark: primaryColorDark,
      primaryColorLight: primaryColorLight,
      accentColor: primaryColor,
      textTheme: TextTheme(
          headline1: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: primaryColorDark)),
      inputDecorationTheme: inputDecorationTheme(),
      buttonTheme: buttonTheme(),
      backgroundColor: Colors.white);
}
