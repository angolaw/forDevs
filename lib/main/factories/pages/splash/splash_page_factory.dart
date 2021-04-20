import 'package:flutter/material.dart';
import 'package:fordev/ui/pages/pages.dart';

import 'splash.dart';

Widget makeSplashPage() {
  return SplashPage(presenter: makeGetxSplashPresenter());
}
