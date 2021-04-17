import 'package:fordev/data/http/http.dart';
import 'package:fordev/infra/http/http.dart';
import 'package:http/http.dart';

HttpClient makeHttpAdapter() {
  final client = Client();
  return HttpAdapter(client: client);
}
