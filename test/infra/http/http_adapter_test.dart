import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

class ClientSpy extends Mock implements Client {}

class HttpAdapter {
  final Client client;

  HttpAdapter({this.client});
  Future<void> request(
      {@required String url, @required String method, Map body}) async {
    final headers = {
      "content-type": "application/json",
      "accept": "application/json"
    };
    final jsonBody = body != null ? jsonEncode(body) : null;
    await client.post(Uri.parse(url), headers: headers, body: jsonBody);
  }
}

void main() {
  Client client;
  HttpAdapter sut;
  String url;
  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client: client);
    url = faker.internet.httpUrl();
  });

  group("post", () {
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
}
