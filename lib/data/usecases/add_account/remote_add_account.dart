import 'package:fordev/data/http/http.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/usecases/usecases.dart';
import 'package:meta/meta.dart';

class RemoteAddAccount implements AddAccount {
  final HttpClient httpClient;
  final String url;

  RemoteAddAccount({@required this.httpClient, @required this.url});

  @override
  Future<AccountEntity> add(AddAccountParams params) async {
    final body = RemoteAddAccountParams.fromDomain(params).toJson();
    await httpClient.request(url: url, method: 'post', body: body);
    return null;
  }
}

class RemoteAddAccountParams {
  final String email;
  final String password;
  final String passwordConfirmation;
  final String name;

  RemoteAddAccountParams(
      {@required this.passwordConfirmation,
      @required this.name,
      @required this.email,
      @required this.password});

  factory RemoteAddAccountParams.fromDomain(
          AddAccountParams addAccountParams) =>
      RemoteAddAccountParams(
          email: addAccountParams.email,
          password: addAccountParams.password,
          passwordConfirmation: addAccountParams.passwordConfirmation,
          name: addAccountParams.name);
  Map toJson() => {
        'email': email,
        'password': password,
        'passwordConfirmation': passwordConfirmation,
        'name': name
      };
}
