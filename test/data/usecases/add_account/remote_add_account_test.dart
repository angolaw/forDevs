import 'package:faker/faker.dart';
import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/usecases/usecases.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/add_account.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  HttpClientSpy httpClient;
  String url;
  RemoteAddAccount sut;
  AddAccountParams params;
  String samePassword;
  Map mockValidData() =>
      {'accessToken': faker.guid.guid(), 'name': faker.person.name()};
  PostExpectation mockRequest() => when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body')));
  void mockHttpData(Map data) {
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    samePassword = faker.internet.password();
    sut = RemoteAddAccount(httpClient: httpClient, url: url);
    params = AddAccountParams(
        email: faker.internet.email(),
        password: samePassword,
        name: faker.person.firstName(),
        passwordConfirmation: samePassword);
  });

  group("httpClient", () {
    test("Should call httpClient with correct url", () async {
      await sut.add(params);
      verify(httpClient.request(url: url, method: 'post', body: {
        'email': params.email,
        'password': params.password,
        'passwordConfirmation': params.passwordConfirmation,
        'name': params.name
      }));
    });
    group("API test on HttpClient errors", () {
      test("Should throw UnexpectedError if HttpClient returns 400", () async {
        mockHttpError(HttpError.badRequest);
        final future = sut.add(params);
        expect(future, throwsA(DomainError.unexpected));
      });
      test("Should throw UnexpectedError if HttpClient returns 404", () async {
        mockHttpError(HttpError.notFound);
        final future = sut.add(params);
        expect(future, throwsA(DomainError.unexpected));
      });
      test("Should throw UnexpectedError if HttpClient returns 500", () async {
        mockHttpError(HttpError.serverError);
        final future = sut.add(params);
        expect(future, throwsA(DomainError.unexpected));
      });
      test("Should throw UnexpectedError if HttpClient returns 401", () async {
        mockHttpError(HttpError.unauthorized);
        final future = sut.add(params);
        expect(future, throwsA(DomainError.invalidCredentials));
      });
    });
  });
}
