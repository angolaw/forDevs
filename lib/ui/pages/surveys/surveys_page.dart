import 'package:flutter/material.dart';
import 'package:fordev/ui/helpers/helpers.dart';

class SurveysPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(R.strings.surveys),
      ),
      body: Center(
        child: Text(R.strings.surveys),
      ),
    );
  }
}
