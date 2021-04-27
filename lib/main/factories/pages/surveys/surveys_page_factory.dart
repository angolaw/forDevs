import 'package:flutter/material.dart';
import 'package:fordev/ui/pages/pages.dart';

import '../../../../ui/pages/pages.dart';
import 'surveys_presenter_factory.dart';

Widget makesSurveysPage() {
  return SurveysPage(
    presenter: makeGetxSurveysPresenter(),
  );
}
