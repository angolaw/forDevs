import 'package:fordev/domain/entities/account_entity.dart';
import 'package:meta/meta.dart';
import '../entities/entities.dart';

abstract class Authentication {
  Future<AccountEntity> auth(
      {@required String email, @required String password});
}
