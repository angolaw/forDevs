import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/ui/helpers/errors/errors.dart';
import 'package:fordev/ui/pages/pages.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

class SurveysPresenterSpy extends Mock implements SurveysPresenter {}

void main() {
  SurveysPresenter presenter;
  StreamController<List<SurveyViewModel>> loadSurveysController;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveysPresenterSpy();
    loadSurveysController = StreamController<List<SurveyViewModel>>();
    when(presenter.surveysStream)
        .thenAnswer((_) => loadSurveysController.stream);
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
        date: "Date 1",
        didAnswer: true,
        question: "Question 1",
      ),
      SurveyViewModel(
        id: "2",
        date: "Date 2",
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
    loadSurveysController.close();
  });

  testWidgets('should call LoadSurveys on page load',
      (WidgetTester tester) async {
    await loadPage(tester);
    verify(presenter.loadData()).called(1);
  });

  testWidgets('should present error if surveysStreams fails ',
      (WidgetTester tester) async {
    await loadPage(tester);
    loadSurveysController.addError(UIError.unexpected.description);
    await tester.pump();
    expect(find.text('Algo errado aconteceu. Tente novamente'), findsOneWidget);
    expect(find.text('Recarregar'), findsOneWidget);
    expect(find.text('Question 1'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
  testWidgets('should present list if surveysStreams succeeds ',
      (WidgetTester tester) async {
    await loadPage(tester);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    loadSurveysController.add(makeSurveys());
    await tester.pump();
    expect(find.text('Algo errado aconteceu. Tente novamente'), findsNothing);
    expect(find.text('Recarregar'), findsNothing);
    expect(find.text('Question 1'), findsOneWidget);
    expect(find.text('Question 2'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
  testWidgets(
      'should present viewModel data in SurveyItem if surveysStream succeeds ',
      (WidgetTester tester) async {
    await loadPage(tester);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    loadSurveysController.add(makeSurveys());
    await tester.pump();
    expect(find.text('Algo errado aconteceu. Tente novamente'), findsNothing);
    expect(find.text('Recarregar'), findsNothing);
    expect(find.text('Question 1'), findsOneWidget);
    expect(find.text('Question 2'), findsOneWidget);
    expect(find.text('Date 1'), findsOneWidget);
    expect(find.text('Date 2'), findsOneWidget);
  });

  testWidgets('should call LoadSurveys on reload button click',
      (WidgetTester tester) async {
    await loadPage(tester);
    loadSurveysController.addError(UIError.unexpected.description);
    await tester.pump();
    await tester.tap(find.text("Recarregar"));

    verify(presenter.loadData()).called(2);
  });

  // testWidgets('should present green if user did answer the survey',
  //     (WidgetTester tester) async {
  //   await loadPage(tester);
  //   final targetColor = Color.fromRGBO(0, 37, 26, 1);
  //   WidgetPredicate widgetSelectedPredicate =
  //       (Widget widget) => widget is Container && widget.color == targetColor;
  //   loadSurveysController.add(makeSurveys());
  //   await tester.pump();
  //   expect(find.text('Algo errado aconteceu. Tente novamente'), findsNothing);
  //   expect(find.text('Recarregar'), findsNothing);
  //   expect(find.text('Question 1'), findsOneWidget);
  //   expect(find.text('Question 2'), findsOneWidget);
  //   expect(find.text('Date 1'), findsOneWidget);
  //   expect(find.text('Date 2'), findsOneWidget);
  //
  //   //expect(find.byWidgetPredicate(widgetSelectedPredicate), findsOneWidget);
  // });
}
