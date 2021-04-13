import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/usecases/usecases.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/usecases.dart';
import 'package:mockito/mockito.dart';
import 'package:faker/faker.dart';

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
      verify(httpClient.request(
          url: url,
          method: 'post',
          body: {'email': params.email, 'password': params.secret}));
    });
    test("Should call httpClient with correct values", () async {
      await sut.auth(params: params);
      verify(httpClient.request(
          url: url,
          method: 'post',
          body: {'email': params.email, 'password': params.secret}));
    });
    test("should call httpClient with correct body", () async {
      await sut.auth(params: params);
      verify(httpClient.request(
          url: url,
          method: 'post',
          body: {'email': params.email, 'password': params.secret}));
    });
  });
  group("API call errors", () {
    test("Should throw UnexpectedError if HttpClient returns 400", () async {
      when(httpClient.request(
              url: anyNamed('url'),
              method: anyNamed('method'),
              body: anyNamed('body')))
          .thenThrow(HttpError.badRequest);
      final future = sut.auth(params: params);
      expect(future, throwsA(DomainError.unexpected));
    });
    test("Should throw UnexpectedError if HttpClient returns 404", () async {
      when(httpClient.request(
              url: anyNamed('url'),
              method: anyNamed('method'),
              body: anyNamed('body')))
          .thenThrow(HttpError.notFound);
      final future = sut.auth(params: params);
      expect(future, throwsA(DomainError.unexpected));
    });
    test("Should throw UnexpectedError if HttpClient returns 500", () async {
      when(httpClient.request(
              url: anyNamed('url'),
              method: anyNamed('method'),
              body: anyNamed('body')))
          .thenThrow(HttpError.serverError);
      final future = sut.auth(params: params);
      expect(future, throwsA(DomainError.unexpected));
    });
    test("Should throw InvalidCredentialsError if HttpClient returns 401",
        () async {
      when(httpClient.request(
              url: anyNamed('url'),
              method: anyNamed('method'),
              body: anyNamed('body')))
          .thenThrow(HttpError.unauthorized);
      final future = sut.auth(params: params);
      expect(future, throwsA(DomainError.invalidCredentials));
    });
  });
}
