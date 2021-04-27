import 'package:meta/meta.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../..//models/models.dart';
import '../../http/http.dart';

class RemoteLoadSurveys implements LoadSurveys {
  final HttpClient client;
  final String url;

  RemoteLoadSurveys({@required this.client, @required this.url});
  Future<List<SurveyEntity>> load() async {
    try {
      final httpResponse = await client.request(url: url, method: 'get');
      return httpResponse
          .map<SurveyEntity>((e) => RemoteSurveyModel.fromJson(e).toEntity())
          .toList();
    } on HttpError catch (e) {
      throw e == HttpError.forbidden
          ? DomainError.accessDenied
          : DomainError.unexpected;
    }
  }
}
