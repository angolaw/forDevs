import 'package:faker/faker.dart';
import 'package:fordev/data/cache/cache.dart';
import 'package:fordev/data/http/http.dart';
import 'package:fordev/main/decorators/decorators.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class FetchSecureCacheStorageSpy extends Mock
    implements FetchSecureCacheStorage {}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  FetchSecureCacheStorage fetchSecureCacheStorage;
  AuthorizeHttpClientDecorator sut;
  HttpClient httpClient;
  String url;
  String method;
  Map body;
  String token;
  String httpResponse;
  PostExpectation mockTokenCall() =>
      when(fetchSecureCacheStorage.fetchSecure(any));
  PostExpectation mockHttpResponseCall() => when(httpClient.request(
        url: anyNamed('url'),
        method: anyNamed('method'),
        body: anyNamed('body'),
        headers: anyNamed('headers'),
      ));
  void mockToken() {
    token = faker.guid.guid();
    mockTokenCall().thenAnswer((_) async => token);
  }

  void mockSecureStorageError() {
    mockTokenCall().thenThrow(Exception());
  }

  void mockHttpResponseError(HttpError error) {
    mockHttpResponseCall().thenThrow(error);
  }

  void mockHttpResponse() {
    httpResponse = faker.randomGenerator.string(50);
    when(mockHttpResponseCall().thenAnswer((_) async => httpResponse));
  }

  setUp(() {
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    httpClient = HttpClientSpy();

    sut = AuthorizeHttpClientDecorator(
      fetchSecureCacheStorage: fetchSecureCacheStorage,
      decoratee: httpClient,
    );
    url = faker.internet.httpUrl();
    method = faker.randomGenerator.string(10);
    body = {'any_key': 'any_value'};
    mockToken();
    mockHttpResponse();
  });
  test('should call FetchSecureCacheStorage with correct key', () async {
    await sut.request(url: url, method: method, body: body);
    verify(fetchSecureCacheStorage.fetchSecure('token')).called(1);
  });
  test('should call decoratee with accessToken on header', () async {
    await sut.request(
      url: url,
      method: method,
      body: body,
    );
    verify(
      httpClient.request(
        url: url,
        method: method,
        body: body,
        headers: {'x-access-token': token},
      ),
    ).called(1);

    await sut.request(
      url: url,
      method: method,
      body: body,
      headers: {'any_header': 'any_value'},
    );
    verify(
      httpClient.request(
        url: url,
        method: method,
        body: body,
        headers: {'x-access-token': token, 'any_header': 'any_value'},
      ),
    ).called(1);
  });
  test('should return same result as decoratee', () async {
    final response = await sut.request(url: url, method: method, body: body);
    expect(response, httpResponse);
  });
  test('should throw forbidden error if fetchSecureCacheStorage throws',
      () async {
    mockSecureStorageError();
    final future = sut.request(url: url, method: method, body: body);
    expect(future, throwsA(HttpError.forbidden));
  });

  test('should rethrow if decoratee throws', () async {
    mockHttpResponseError(HttpError.badRequest);
    final future = sut.request(url: url, method: method, body: body);
    expect(future, throwsA(HttpError.badRequest));
  });
}
