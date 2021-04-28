import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/usecases.dart';
import 'package:fordev/ui/helpers/helpers.dart';
import 'package:fordev/ui/pages/pages.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

class GextSurveysPresenter implements SurveysPresenter {
  final LoadSurveys loadSurveys;
  final _surveys = Rx<List<SurveyViewModel>>([]);

  Stream<List<SurveyViewModel>> get surveysStream => _surveys.stream;

  GextSurveysPresenter({@required this.loadSurveys});

  Future<void> loadData() async {
    try {
      final surveys = await loadSurveys.load();
      _surveys.value = surveys
          .map((survey) => SurveyViewModel(
              id: survey.id,
              question: survey.question,
              date: DateFormat('dd MMM yyyy').format(survey.dateTime),
              didAnswer: survey.didAnswer))
          .toList();
    } on DomainError catch (e) {
      print("DomainError ocurred ${e.toString()} ");
      _surveys.subject
          .addError(UIError.unexpected.description, StackTrace.empty);
    }
  }
}
