import 'package:equatable/equatable.dart';
import 'package:fordev/presentation/protocols/protocols.dart';
import 'package:fordev/validation/protocols/protocols.dart';
import 'package:meta/meta.dart';

class MinLengthValidation extends Equatable implements FieldValidation {
  final String field;
  final int size;
  MinLengthValidation({
    @required this.field,
    @required this.size,
  });
  ValidationError validate(Map input) {
    return input[field] != null && input[field].length >= size
        ? null
        : ValidationError.invalidField;
  }

  @override
  // TODO: implement props
  List<Object> get props => [field, size];
}
