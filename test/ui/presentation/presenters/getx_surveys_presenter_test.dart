import 'package:fordev/domain/usecases/load_surveys.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class GextSurveysPresenter {
  final LoadSurveys loadSurveys;

  GextSurveysPresenter({@required this.loadSurveys});

  Future<void> loadData() async {
    return loadSurveys.load();
  }
}

class LoadSurveysSpy extends Mock implements LoadSurveys {}

void main() {
  LoadSurveys loadSurveys;
  GextSurveysPresenter sut;
  setUp(() {
    loadSurveys = LoadSurveysSpy();
    sut = GextSurveysPresenter(loadSurveys: loadSurveys);
  });
  test('should call loadSurveys on loadData', () async {
    await sut.loadData();
    verify(loadSurveys.load()).called(1);
  });
}
