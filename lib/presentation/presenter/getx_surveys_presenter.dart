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
          .map((e) => SurveyViewModel(
                id: e.id,
                question: e.question,
                didAnswer: e.didAnswer,
                date: DateFormat('dd MMM yyyy').format(e.dateTime),
              ))
          .toList();
    } on DomainError catch (error) {
      //TODO FIX THIS
      print("Domain Error: " + error.toString());
      _surveys.subject
          .addError(UIError.unexpected.description, StackTrace.empty);
    }
  }
}
