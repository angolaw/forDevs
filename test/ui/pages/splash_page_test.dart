import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';

class SplashPage extends StatelessWidget {
  final SplashPresenter presenter;

  const SplashPage({Key key, @required this.presenter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    presenter.loadCurrentAccount();
    return Scaffold(
        appBar: AppBar(title: Text("4Dev")),
        body: Builder(
          builder: (context) {
            presenter.navigateToStream.listen((page) {
              if (page?.isNotEmpty == true) {
                Get.offAllNamed(page);
              }
            });
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}

abstract class SplashPresenter {
  Stream<String> get navigateToStream;
  Future<void> loadCurrentAccount();
}

class SplashPresenterSpy extends Mock implements SplashPresenter {}

void main() {
  SplashPresenterSpy presenter;
  StreamController<String> navigateToController;
  tearDown(() {
    navigateToController.close();
  });
  Future<void> loadPage(WidgetTester tester) async {
    presenter = SplashPresenterSpy();
    navigateToController = StreamController<String>();
    when(presenter.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);
    await tester.pumpWidget(GetMaterialApp(
      initialRoute: '/',
      getPages: [
        GetPage(
          name: "/",
          page: () => SplashPage(presenter: presenter),
        ),
        GetPage(
          name: "/any_route",
          page: () => Scaffold(
            body: Text("fake page"),
          ),
        )
      ],
    ));
  }

  testWidgets("should present loading on page load",
      (WidgetTester tester) async {
    await loadPage(tester);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
  testWidgets("should call loadCurrentAccount on page load",
      (WidgetTester tester) async {
    await loadPage(tester);
    verify(presenter.loadCurrentAccount()).called(1);
  });
  testWidgets("should load page", (WidgetTester tester) async {
    await loadPage(tester);
    navigateToController.add('/any_route');
    await tester.pumpAndSettle();
    expect(Get.currentRoute, '/any_route');
    expect(find.text('fake page'), findsOneWidget);
  });
  testWidgets("should not load page on invalid parameters",
      (WidgetTester tester) async {
    await loadPage(tester);
    navigateToController.add('');
    await tester.pump();
    expect(Get.currentRoute, '/');

    navigateToController.add(null);
    await tester.pump();
    expect(Get.currentRoute, '/');
  });
}
