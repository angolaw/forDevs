import 'package:equatable/equatable.dart';
import 'package:fordev/validation/protocols/protocols.dart';

class EmailValidation extends Equatable implements FieldValidation {
  final String field;
  EmailValidation(this.field);

  String validate(String value) {
    final regex = RegExp(r"^[a-zA-Z0-9_.-]+@[a-zA-Z0-9-]+.[a-zA-Z0-9-.]+$");

    final isValid = value?.isNotEmpty != true || regex.hasMatch(value);
    return isValid ? null : "Campo invalido";
  }

  @override
  // TODO: implement props
  List<Object> get props => [field];

  @override
  // TODO: implement stringify
  bool get stringify => true;
}
