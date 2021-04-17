import 'package:equatable/equatable.dart';
import 'package:fordev/validation/protocols/protocols.dart';

class RequiredFieldValidation extends Equatable implements FieldValidation {
  final String field;

  RequiredFieldValidation(this.field);

  String validate(String value) {
    return value?.isNotEmpty == true ? null : "Campo obrigatorio";
  }

  @override
  // TODO: implement props
  List<Object> get props => [field];

  @override
  // TODO: implement stringify
  bool get stringify => true;
}
