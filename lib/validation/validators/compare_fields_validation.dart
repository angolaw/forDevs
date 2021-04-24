import 'package:fordev/presentation/protocols/protocols.dart';
import 'package:fordev/validation/protocols/protocols.dart';
import 'package:meta/meta.dart';

class CompareFieldsValidation implements FieldValidation {
  final String field;
  final String valueToCompare;

  CompareFieldsValidation(
      {@required this.field, @required this.valueToCompare});
  ValidationError validate(String value) {
    return valueToCompare == value ? null : ValidationError.invalidField;
  }
}
