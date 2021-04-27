import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fordev/ui/components/components.dart';
import 'package:fordev/ui/helpers/helpers.dart';
import 'package:fordev/ui/pages/pages.dart';

import 'components/surveys_components.dart';

class SurveysPage extends StatefulWidget {
  final SurveysPresenter presenter;

  SurveysPage({this.presenter});

  @override
  _SurveysPageState createState() => _SurveysPageState();
}

class _SurveysPageState extends State<SurveysPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(R.strings.surveys)),
      body: Builder(
        builder: (context) {
          widget.presenter.isLoadingStream.listen((isLoading) {
            if (isLoading == true) {
              showLoading(context, "Aguarde");
            } else {
              //navigator debug locked
              //! BUG
              hideLoading(context);
            }
          });
          widget.presenter.loadData();

          return StreamBuilder<List<SurveyViewModel>>(
              stream: widget.presenter.surveysStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Padding(
                    padding: EdgeInsets.all(40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(snapshot.error,
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center),
                        SizedBox(height: 10),
                        RaisedButton(
                          onPressed: widget.presenter.loadData,
                          child: Text(R.strings.reload),
                        )
                      ],
                    ),
                  );
                }
                if (snapshot.hasData) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: CarouselSlider(
                      options: CarouselOptions(
                          enlargeCenterPage: true, aspectRatio: 1),
                      items: snapshot.data
                          .map((viewModel) => SurveyItem(
                                viewModel: viewModel,
                              ))
                          .toList(),
                    ),
                  );
                }
                return SizedBox(height: 0);
              });
        },
      ),
    );
  }
}
