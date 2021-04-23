import 'package:equatable/equatable.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:meta/meta.dart';

abstract class AddAccount {
  Future<AccountEntity> add(AddAccountParams params);
}

class AddAccountParams extends Equatable {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;

  AddAccountParams(
      {@required this.name,
      @required this.email,
      @required this.password,
      @required this.passwordConfirmation});

  @override
  // TODO: implement props
  List<Object> get props => [name, email, password, passwordConfirmation];
}
