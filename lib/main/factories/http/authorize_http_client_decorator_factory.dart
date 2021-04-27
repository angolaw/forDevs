import 'package:fordev/data/http/http.dart';
import 'package:fordev/main/decorators/authorize_http_client_decorator.dart';
import 'package:fordev/main/factories/factories.dart';

HttpClient makeAuthorizeHttpDecorator() => AuthorizeHttpClientDecorator(
      decoratee: makeHttpAdapter(),
      fetchSecureCacheStorage: makeLocalStorageAdapter(),
    );
