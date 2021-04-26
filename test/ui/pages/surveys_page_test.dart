import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/ui/helpers/errors/errors.dart';
import 'package:fordev/ui/pages/pages.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

class SurveysPresenterSpy extends Mock implements SurveysPresenter {}

void main() {
  SurveysPresenter presenter;
  StreamController<bool> isLoadingController;
  StreamController<List<SurveyViewModel>> loadSurveysController;

  void initStreams() {
    isLoadingController = StreamController<bool>();
    loadSurveysController = StreamController<List<SurveyViewModel>>();
  }

  void mockStreams() {
    when(presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(presenter.loadSurveysStream)
        .thenAnswer((_) => loadSurveysController.stream);
  }

  void closeStreams() {
    isLoadingController.close();
    loadSurveysController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveysPresenterSpy();
    initStreams();
    mockStreams();
    final surveysPage = GetMaterialApp(initialRoute: '/surveys', getPages: [
      GetPage(
        name: '/surveys',
        page: () => SurveysPage(presenter: presenter),
      ),
    ]);
    await tester.pumpWidget(surveysPage);
  }

  List<SurveyViewModel> makeSurveys() {
    return [
      SurveyViewModel(
        id: "1",
        date: "20/01/2020",
        didAnswer: true,
        question: "Question 1",
      ),
      SurveyViewModel(
        id: "2",
        date: "20/01/2020",
        didAnswer: false,
        question: "Question 2",
      ),
      SurveyViewModel(
        id: "3",
        date: "20/01/2020",
        didAnswer: true,
        question: "Qual a melhor IDE para desenvolvimento Python",
      ),
      SurveyViewModel(
        id: "4",
        date: "20/01/2020",
        didAnswer: true,
        question: "Qual a melhor IDE para desenvolvimento Embarcado",
      ),
      SurveyViewModel(
        id: "5",
        date: "20/01/2020",
        didAnswer: false,
        question: "Qual a melhor IDE para desenvolvimento back-end",
      ),
    ];
  }

  tearDown(() {
    closeStreams();
  });

  testWidgets('should call LoadSurveys on page load',
      (WidgetTester tester) async {
    await loadPage(tester);
    verify(presenter.loadData()).called(1);
  });

  testWidgets('should present error if loadSurveysStreams fails ',
      (WidgetTester tester) async {
    await loadPage(tester);
    loadSurveysController.addError(UIError.unexpected.description);
    await tester.pump();
    expect(find.text('Algo errado aconteceu. Tente novamente'), findsOneWidget);
    expect(find.text('Recarregar'), findsOneWidget);
    expect(find.text('Question 1'), findsNothing);
  });
  testWidgets('should present list if loadSurveysStreams succeeds ',
      (WidgetTester tester) async {
    await loadPage(tester);
    loadSurveysController.add(makeSurveys());
    await tester.pump();
    expect(find.text('Algo errado aconteceu. Tente novamente'), findsNothing);
    expect(find.text('Recarregar'), findsNothing);
    expect(find.text('Question 1'), findsOneWidget);
    expect(find.text('Question 2'), findsOneWidget);
  });
}
