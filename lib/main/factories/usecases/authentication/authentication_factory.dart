import 'package:fordev/data/usecases/usecases.dart';
import 'package:fordev/domain/usecases/usecases.dart';
import 'package:fordev/main/factories/http/http.dart';

Authentication makeRemoteAuthentication() {
  return RemoteAuthentication(
      httpClient: makeHttpAdapter(), url: makeApiUrl('login'));
}
