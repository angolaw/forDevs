import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/ui/pages/pages.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

class SurveysPresenterSpy extends Mock implements SurveysPresenter {}

void main() {
  SurveysPresenter presenter;

  setUp(() {
    presenter = SurveysPresenterSpy();
  });

  testWidgets('should call LoadSurveys on page load',
      (WidgetTester tester) async {
    final surveysPage = GetMaterialApp(initialRoute: '/surveys', getPages: [
      GetPage(
        name: '/surveys',
        page: () => SurveysPage(presenter: presenter),
      ),
    ]);
    await tester.pumpWidget(surveysPage);

    verify(presenter.loadData()).called(1);
  });
}
