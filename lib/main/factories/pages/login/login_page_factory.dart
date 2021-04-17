import 'package:flutter/material.dart';
import 'package:fordev/data/usecases/usecases.dart';
import 'package:fordev/infra/http/http.dart';
import 'package:fordev/presentation/presenter/presenter.dart';
import 'package:fordev/ui/pages/pages.dart';
import 'package:fordev/validation/validators/validators.dart';
import 'package:http/http.dart';

Widget makeLoginPage() {
  final client = Client();
  final httpAdapter = HttpAdapter(client: client);
  final url = 'http://fordevs.herokuapp.com/api/login';
  final remoteAuthentication =
      RemoteAuthentication(httpClient: httpAdapter, url: url);
  final validationComposite = ValidationComposite(validations: [
    RequiredFieldValidation('email'),
    EmailValidation('email'),
    RequiredFieldValidation('password'),
  ]);
  final streamLoginPresenter = StreamLoginPresenter(
      authentication: remoteAuthentication, validation: validationComposite);
  return LoginPage(
    presenter: streamLoginPresenter,
  );
}
