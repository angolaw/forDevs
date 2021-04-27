import 'package:faker/faker.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/load_surveys.dart';
import 'package:fordev/presentation/presenter/getx_surveys_presenter.dart';
import 'package:fordev/ui/helpers/helpers.dart';
import 'package:fordev/ui/pages/surveys/survey_viewmodel.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class LoadSurveysSpy extends Mock implements LoadSurveys {}

void main() {
  LoadSurveys loadSurveys;
  GextSurveysPresenter sut;
  List<SurveyEntity> surveys;

  List<SurveyEntity> mockValidData() => [
        SurveyEntity(
            id: faker.guid.guid(),
            question: faker.lorem.sentence(),
            dateTime: DateTime(2020, 1, 2),
            didAnswer: faker.randomGenerator.boolean()),
        SurveyEntity(
            id: faker.guid.guid(),
            question: faker.lorem.sentence(),
            dateTime: DateTime(2021, 7, 2),
            didAnswer: faker.randomGenerator.boolean()),
      ];
  PostExpectation mockLoadSurveysCall() => when(loadSurveys.load());
  void mockLoadSurveys(List<SurveyEntity> data) {
    surveys = data;
    mockLoadSurveysCall().thenAnswer((_) async => data);
  }

  void mockLoadSurveysError() =>
      mockLoadSurveysCall().thenThrow(DomainError.unexpected);

  setUp(() {
    loadSurveys = LoadSurveysSpy();
    sut = GextSurveysPresenter(loadSurveys: loadSurveys);
    mockLoadSurveys(mockValidData());
  });
  test('should call loadSurveys on loadData', () async {
    await sut.loadData();
    verify(loadSurveys.load()).called(1);
  });
  test('should emit correct events on success', () async {
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    sut.surveysStream.listen(expectAsync1((surveys) => expect(surveys, [
          SurveyViewModel(
              id: surveys[0].id,
              question: surveys[0].question,
              date: '02 Jan 2020',
              didAnswer: surveys[0].didAnswer),
          SurveyViewModel(
              id: surveys[1].id,
              question: surveys[1].question,
              date: '02 Jul 2021',
              didAnswer: surveys[1].didAnswer)
        ])));

    await sut.loadData();
  });
  test('should emit correct events on failure', () async {
    mockLoadSurveysError();
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    sut.surveysStream.listen(null,
        onError: expectAsync1(
            (error) => expect(error, UIError.unexpected.description)));

    await sut.loadData();
  });
}
