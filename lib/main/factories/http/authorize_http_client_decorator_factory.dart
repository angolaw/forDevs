import 'package:fordev/data/http/http.dart';
import 'package:fordev/main/decorators/authorize_http_client_decorator.dart';
import 'package:fordev/main/factories/factories.dart';
import 'package:http/http.dart';

HttpClient makeAuthorizeHttpDecorator() {
  final client = Client();
  return AuthorizeHttpClientDecorator(
    decoratee: makeHttpAdapter(),
    fetchSecureCacheStorage: makeLocalStorageAdapter(),
  );
}
