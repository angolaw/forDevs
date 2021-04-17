import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fordev/ui/components/app_theme.dart';
import 'package:fordev/ui/pages/pages.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return MaterialApp(
      title: "4Dev",
      debugShowCheckedModeBanner: false,
      theme: makeAppTheme(),
      home: LoginPage(),
    );
  }
}
