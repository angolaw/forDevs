import 'package:faker/faker.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/usecases/load_surveys.dart';
import 'package:fordev/ui/pages/surveys/survey_viewmodel.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class GextSurveysPresenter {
  final LoadSurveys loadSurveys;
  final _isLoading = true.obs;
  Stream<bool> get isLoadingStream => _isLoading.stream;
  final _surveys = Rx<List<SurveyViewModel>>([]);

  Stream<List<SurveyViewModel>> get surveysStream => _surveys.stream;

  GextSurveysPresenter({@required this.loadSurveys});

  Future<void> loadData() async {
    _isLoading.value = true;
    final surveys = await loadSurveys.load();
    _surveys.value = surveys
        .map((e) => SurveyViewModel(
              id: e.id,
              question: e.question,
              didAnswer: e.didAnswer,
              date: DateFormat('dd MMM yyyy').format(e.dateTime),
            ))
        .toList();
    _isLoading.value = false;
  }
}

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

  void mockLoadSurveys(List<SurveyEntity> data) {
    surveys = data;
    when(loadSurveys.load()).thenAnswer((_) async => data);
  }

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
}
