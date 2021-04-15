import 'package:equatable/equatable.dart';
import 'package:fordev/domain/entities/account_entity.dart';
import 'package:meta/meta.dart';

import '../entities/entities.dart';

abstract class Authentication {
  Future<AccountEntity> auth(AuthenticationParams params);
}

class AuthenticationParams extends Equatable {
  final String email;
  final String secret;

  AuthenticationParams({@required this.email, @required this.secret});

  @override
  // TODO: implement props
  List<Object> get props => [email, secret];
}
