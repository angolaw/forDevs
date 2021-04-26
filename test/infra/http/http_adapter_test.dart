import 'package:faker/faker.dart';
import 'package:fordev/data/http/http.dart';
import 'package:fordev/infra/http/http.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class ClientSpy extends Mock implements Client {}

void main() {
  Client client;
  HttpAdapter sut;
  String url;

  PostExpectation mockRequest() => when(
      client.post(any, body: anyNamed("body"), headers: anyNamed("headers")));
  void mockResponse(int statusCode, {String body = '{"any_key":"any_value"}'}) {
    mockRequest().thenAnswer((_) async => Response(body, statusCode));
  }

  void mockError() {
    mockRequest().thenThrow(Exception());
  }

  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client: client);
    url = faker.internet.httpUrl();
  });
  group("shared", () {
    test("should throw ServerError when an invalid http verb is provided",
        () async {
      final future = sut.request(url: url, method: 'away');
      expect(future, throwsA(HttpError.serverError));
    });
  });
  group("post", () {
    setUp(() {
      mockResponse(200);
    });
    test("should call post with the correct values", () async {
      await sut.request(url: url, method: 'post');
      verify(client.post(Uri.parse(url), headers: {
        "content-type": "application/json",
        "accept": "application/json"
      }));
    });
    test("should have correct JSON headers", () async {
      await sut.request(url: url, method: 'post');
      verify(client.post(Uri.parse(url), headers: {
        "content-type": "application/json",
        "accept": "application/json"
      }));
    });
    test("should have correct body", () async {
      await sut
          .request(url: url, method: 'post', body: {'any_key': 'any_value'});
      verify(
        client.post(
          Uri.parse(url),
          headers: {
            "content-type": "application/json",
            "accept": "application/json"
          },
          body: '{"any_key":"any_value"}',
        ),
      );
    });
    test("should call post without body", () async {
      await sut.request(
        url: url,
        method: 'post',
      );
      verify(
        client.post(
          any,
          headers: anyNamed("headers"),
        ),
      );
    });
  });
  group("success cases ", () {
    test("should return data if post returns 200", () async {
      mockResponse(200);
      final response = await sut.request(url: url, method: 'post');
      expect(response, {'any_key': 'any_value'});
    });
    test("should return null if post returns 200 with no data", () async {
      mockResponse(200, body: '');
      final response = await sut.request(url: url, method: 'post');
      expect(response, null);
    });
    test("should return null if post returns 204", () async {
      mockResponse(204, body: '');
      final response = await sut.request(url: url, method: 'post');
      expect(response, null);
    });
    test("should return null if post returns 204 with data", () async {
      mockResponse(204);
      final response = await sut.request(url: url, method: 'post');
      expect(response, null);
    });
  });
  group("Error status codes", () {
    test("should return BadRequest if post returns 400", () async {
      mockResponse(400);
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.badRequest));
    });
    test("should return BadRequest if post returns 400 with data", () async {
      mockResponse(400, body: '');
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.badRequest));
    });
    test("should return Unauthorized if post returns 401", () async {
      mockResponse(401);
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.unauthorized));
    });
    test("should return Forbidden if post returns 403", () async {
      mockResponse(403);
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.forbidden));
    });
    test("should return Not Found if post returns 404", () async {
      mockResponse(404);
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.notFound));
    });
    test("should return Server Error if post returns 500", () async {
      mockResponse(500);
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.serverError));
    });
    test("should return Server Error if post throws", () async {
      mockError();
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.serverError));
    });
  });

  group("GET", () {
    PostExpectation mockRequest() =>
        when(client.get(any, headers: anyNamed("headers")));

    void mockResponse(int statusCode,
        {String body = '{"any_key":"any_value"}'}) {
      mockRequest().thenAnswer((_) async => Response(body, statusCode));
    }

    setUp(() {
      mockResponse(200);
    });

    test("should call GET method with the correct values", () async {
      await sut.request(url: url, method: 'get');
      verify(client.get(Uri.parse(url), headers: {
        "content-type": "application/json",
        "accept": "application/json"
      }));
    });
    test("should return data if GET returns 200", () async {
      mockResponse(200);
      final response = await sut.request(url: url, method: 'get');
      expect(response, {'any_key': 'any_value'});
    });
    test("should return null if GET returns 200 with no data", () async {
      mockResponse(200, body: '');
      final response = await sut.request(url: url, method: 'get');
      expect(response, null);
    });
  });
}
