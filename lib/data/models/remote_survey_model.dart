import 'dart:convert';

import 'package:fordev/data/http/http.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:meta/meta.dart';

class RemoteSurveyModel {
  final String id;
  final String question;
  final String date;
  final bool didAnswer;

  RemoteSurveyModel(
      {@required this.id,
      @required this.question,
      @required this.date,
      @required this.didAnswer});

  SurveyEntity toEntity() => SurveyEntity(
        id: id,
        question: question,
        dateTime: DateTime.parse(date),
        didAnswer: didAnswer,
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'date': date,
      'didAnswer': didAnswer,
    };
  }

  factory RemoteSurveyModel.fromJson(Map json) {
    if (!json.keys
        .toSet()
        .containsAll(['id', 'question', 'date', 'didAnswer'])) {
      throw HttpError.invalidData;
    }
    return RemoteSurveyModel(
      id: json['id'],
      question: json['question'],
      date: json['date'],
      didAnswer: json['didAnswer'],
    );
  }

  String toJson() => json.encode(toMap());
}
