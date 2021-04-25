import 'package:faker/faker.dart';
import 'package:fordev/data/http/http.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class RemoteLoadSurveys {
  final HttpClient client;
  final String url;

  RemoteLoadSurveys({@required this.client, @required this.url});
  Future<void> load() async {
    await client.request(url: url, method: 'get');
  }
}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  test('should call httpClient with correct values', () async {
    final httpUrl = faker.internet.httpUrl();
    final httpClient = HttpClientSpy();
    final sut = RemoteLoadSurveys(client: httpClient, url: httpUrl);

    await sut.load();
    verify(httpClient.request(url: httpUrl, method: 'get'));
  });
}
