import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/models/models.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/usecases.dart';
import 'package:meta/meta.dart';

class RemoteLoadSurveys implements LoadSurveys {
  final HttpClient<List<Map>> client;
  final String url;

  RemoteLoadSurveys({@required this.client, @required this.url});
  Future<List<SurveyEntity>> load() async {
    try {
      final httpResponse = await client.request(url: url, method: 'get');
      return httpResponse
          .map((e) => RemoteSurveyModel.fromJson(e).toEntity())
          .toList();
    } on HttpError catch (e) {
      throw e == HttpError.forbidden
          ? DomainError.accessDenied
          : DomainError.unexpected;
    }
  }
}
