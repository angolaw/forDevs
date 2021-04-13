import 'package:faker/faker.dart';
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

  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client: client);
    url = faker.internet.httpUrl();
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
}
