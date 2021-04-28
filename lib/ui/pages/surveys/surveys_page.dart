import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fordev/ui/helpers/helpers.dart';
import 'package:fordev/ui/pages/pages.dart';

import 'components/surveys_components.dart';

class SurveysPage extends StatelessWidget {
  final SurveysPresenter presenter;

  SurveysPage({this.presenter});

  @override
  Widget build(BuildContext context) {
    presenter.loadData();

    return Scaffold(
      appBar: AppBar(title: Text(R.strings.surveys)),
      body: StreamBuilder<List<SurveyViewModel>>(
          stream: presenter.surveysStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Padding(
                padding: EdgeInsets.all(40),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(snapshot.error,
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center),
                      SizedBox(height: 10),
                      RaisedButton(
                        onPressed: presenter.loadData,
                        child: Text(R.strings.reload),
                      )
                    ],
                  ),
                ),
              );
            }
            if (snapshot.hasData) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: CarouselSlider(
                  options:
                      CarouselOptions(enlargeCenterPage: true, aspectRatio: 1),
                  items: snapshot.data
                      .map((viewModel) => SurveyItem(
                            viewModel: viewModel,
                          ))
                      .toList(),
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
