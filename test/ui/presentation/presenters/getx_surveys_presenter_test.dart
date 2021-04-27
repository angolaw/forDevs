import 'package:faker/faker.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/usecases/load_surveys.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class GextSurveysPresenter {
  final LoadSurveys loadSurveys;
  final _isLoading = true.obs;
  Stream<bool> get isLoadingStream => _isLoading.stream;

  GextSurveysPresenter({@required this.loadSurveys});

  Future<void> loadData() async {
    _isLoading.value = true;
    await loadSurveys.load();
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
    await sut.loadData();
    verify(loadSurveys.load()).called(1);
  });
}
