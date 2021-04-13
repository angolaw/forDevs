import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:fordev/data/http/http.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

class ClientSpy extends Mock implements Client {}

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter({this.client});
  Future<Map> request(
      {@required String url, @required String method, Map body}) async {
    final headers = {
      "content-type": "application/json",
      "accept": "application/json"
    };
    final jsonBody = body != null ? jsonEncode(body) : null;
    final response =
        await client.post(Uri.parse(url), headers: headers, body: jsonBody);
    return jsonDecode(response.body);
  }
}

void main() {
  Client client;
  HttpAdapter sut;
  String url;
  void setUpBody() => when(client.post(any,
          body: anyNamed("body"), headers: anyNamed("headers")))
      .thenAnswer((_) async => Response('{"any_key":"any_value"}', 200));
  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client: client);
    url = faker.internet.httpUrl();
  });

  group("post", () {
    test("should call post with the correct values", () async {
      setUpBody();
      await sut.request(url: url, method: 'post');
      verify(client.post(Uri.parse(url), headers: {
        "content-type": "application/json",
        "accept": "application/json"
      }));
    });
    test("should have correct JSON headers", () async {
      setUpBody();
      await sut.request(url: url, method: 'post');
      verify(client.post(Uri.parse(url), headers: {
        "content-type": "application/json",
        "accept": "application/json"
      }));
    });
    test("should have correct body", () async {
      setUpBody();
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
      setUpBody();
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
      setUpBody();
      final response = await sut.request(url: url, method: 'post');
      expect(response, {'any_key': 'any_value'});
    });
  });
}
