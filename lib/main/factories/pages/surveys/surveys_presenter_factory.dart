import 'package:fordev/main/factories/factories.dart';
import 'package:fordev/presentation/presenter/presenter.dart';
import 'package:fordev/ui/pages/pages.dart';

SurveysPresenter makeGetxSurveysPresenter() =>
    GextSurveysPresenter(loadSurveys: makeRemoteLoadSurveys());
