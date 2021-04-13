import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/domain/usecases/usecases.dart';
import 'package:mockito/mockito.dart';
import 'package:faker/faker.dart';
import 'package:meta/meta.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({@required this.httpClient, @required this.url});
  Future<void> auth({AuthenticationParams params}) async {
    final body = {'email': params.email, 'password': params.secret};
    await httpClient.request(url: url, method: 'post', body: body);
  }
}

abstract class HttpClient {
  Future<void> request(
      {@required String url, @required String method, Map body});
}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  HttpClientSpy httpClient;
  String url;
  RemoteAuthentication sut;
  AuthenticationParams params;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    params = AuthenticationParams(
        email: faker.internet.email(), secret: faker.internet.password());
  });

  group("HttpClient", () {
    test("Should call httpClient with correct url", () async {
      await sut.auth(params: params);
      verify(httpClient.request(url: url, method: 'post'));
    });
    test("Should call httpClient with correct values", () async {
      await sut.auth(params: params);
      verify(httpClient.request(url: url, method: 'post'));
    });
    test("should call httpClient with correct body", () async {
      await sut.auth(params: params);
      verify(httpClient.request(
          url: url,
          method: 'post',
          body: {'email': params.email, 'password': params.secret}));
    });
  });
}
