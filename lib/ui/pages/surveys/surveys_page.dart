import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fordev/ui/components/components.dart';
import 'package:fordev/ui/helpers/helpers.dart';
import 'package:fordev/ui/pages/pages.dart';

import 'components/surveys_components.dart';

class SurveysPage extends StatelessWidget {
  final SurveysPresenter presenter;

  SurveysPage({Key key, this.presenter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    presenter?.loadData();
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(R.strings.surveys),
        ),
        body: Builder(
          builder: (context) {
            presenter?.isLoadingStream?.listen((isLoading) {
              if (isLoading == true) {
                showLoading(context, "Aguarde");
              } else {
                hideLoading(context);
              }
            });
            return StreamBuilder<List<SurveyViewModel>>(
                stream: presenter?.loadSurveysStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Column(
                      children: [
                        Text(snapshot.error),
                        RaisedButton(
                          onPressed: null,
                          child: Text(R.strings.reload),
                        )
                      ],
                    );
                  }
                  if (snapshot.hasData) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: CarouselSlider(
                          options: CarouselOptions(
                            enlargeCenterPage: true,
                            aspectRatio: 1,
                          ),
                          items: snapshot?.data
                              .map((survey) => SurveyItem(
                                    viewModel: survey,
                                  ))
                              .toList()),
                    );
                  }
                  return SizedBox.shrink();
                });
          },
        ));
  }
}
