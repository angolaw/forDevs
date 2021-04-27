import '../pages.dart';

abstract class SurveysPresenter {
  Stream<List<SurveyViewModel>> get surveysStream;
  Future<void> loadData();
}
