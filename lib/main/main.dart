import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fordev/main/factories/factories.dart';
import 'package:fordev/ui/components/app_theme.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'factories/pages/pages.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;

  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return GetMaterialApp(
      title: "4Dev",
      debugShowCheckedModeBanner: false,
      theme: makeAppTheme(),
      initialRoute: "/login",
      getPages: [
        GetPage(name: "/", page: makeSplashPage, transition: Transition.fade),
        GetPage(
            name: "/login", page: makeLoginPage, transition: Transition.fadeIn),
        GetPage(
          name: "/signup",
          page: makeSignupPage,
        ),
        GetPage(
            name: "/surveys",
            transition: Transition.fadeIn,
            page: makesSurveysPage),
      ],
    );
  }
}
