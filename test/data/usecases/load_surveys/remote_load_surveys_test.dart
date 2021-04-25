import 'package:faker/faker.dart';
import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/models/models.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class RemoteLoadSurveys {
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
      switch (e) {
        case HttpError.forbidden:
          throw DomainError.accessDenied;
          break;
        default:
          throw DomainError.unexpected;
          break;
      }
    }
  }
}

class HttpClientSpy extends Mock implements HttpClient<List<Map>> {}

void main() {
  String httpUrl;
  HttpClientSpy httpClient;
  RemoteLoadSurveys sut;
  List<Map> list;
  List<Map> mockValidData() => [
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(50),
          'didAnswer': faker.randomGenerator.boolean(),
          'date': faker.date.dateTime().toIso8601String()
        },
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(50),
          'didAnswer': faker.randomGenerator.boolean(),
          'date': faker.date.dateTime().toIso8601String()
        }
      ];
  PostExpectation mockRequest() => when(
      httpClient.request(url: anyNamed('url'), method: anyNamed('method')));
  void mockHttpData(List<Map> data) {
    list = data;
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  setUp(() {
    httpUrl = faker.internet.httpUrl();
    httpClient = HttpClientSpy();
    sut = RemoteLoadSurveys(client: httpClient, url: httpUrl);
    mockHttpData(mockValidData());
  });

  test('should call httpClient with correct values', () async {
    await sut.load();
    verify(httpClient.request(url: httpUrl, method: 'get'));
  });
  test('should return surveys on 200', () async {
    final surveys = await sut.load();
    expect(surveys, [
      SurveyEntity(
          id: list[0]['id'],
          question: list[0]['question'],
          dateTime: DateTime.parse(list[0]['date']),
          didAnswer: list[0]['didAnswer']),
      SurveyEntity(
          id: list[1]['id'],
          question: list[1]['question'],
          dateTime: DateTime.parse(list[1]['date']),
          didAnswer: list[1]['didAnswer']),
    ]);
  });
  test(
      'should throw UnexpectedError if HttpClient returns 200 with invalid data',
      () async {
    mockHttpData([
      {'invalid_key': 'invalid_value'}
    ]);
    final future = sut.load();
    expect(future, throwsA(DomainError.unexpected));
  });
  test("should throw UnexpectedError if HttpClient returns 400", () async {
    mockHttpError(HttpError.notFound);
    final future = sut.load();
    expect(future, throwsA(DomainError.unexpected));
  });
  test("should throw UnexpectedError if HttpClient returns 500", () async {
    mockHttpError(HttpError.serverError);
    final future = sut.load();
    expect(future, throwsA(DomainError.unexpected));
  });
  test("should throw AccessDenied if HttpClient returns 403", () async {
    mockHttpError(HttpError.forbidden);
    final future = sut.load();
    expect(future, throwsA(DomainError.accessDenied));
  });
}
