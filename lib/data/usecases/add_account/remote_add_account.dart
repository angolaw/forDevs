import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/models/models.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/usecases.dart';
import 'package:meta/meta.dart';

class RemoteAddAccount implements AddAccount {
  final HttpClient httpClient;
  final String url;

  RemoteAddAccount({@required this.httpClient, @required this.url});

  @override
  Future<AccountEntity> add(AddAccountParams params) async {
    final body = RemoteAddAccountParams.fromDomain(params).toJson();

    try {
      final httpResponse =
          await httpClient.request(url: url, method: 'post', body: body);
      return RemoteAccountModel.fromJson(httpResponse).toEntity();
    } on HttpError catch (e) {
      switch (e) {
        case HttpError.forbidden:
          throw DomainError.emailInUse;
        case HttpError.unauthorized:
          throw DomainError.invalidCredentials;
        default:
          throw DomainError.unexpected;
      }
    }
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
