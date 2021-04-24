import 'package:fordev/presentation/protocols/protocols.dart';
import 'package:fordev/validation/protocols/protocols.dart';
import 'package:meta/meta.dart';

class CompareFieldsValidation implements FieldValidation {
  final String field;
  final String fieldToCompare;

  CompareFieldsValidation(
      {@required this.field, @required this.fieldToCompare});
  ValidationError validate(Map input) {
    return input[fieldToCompare] == input[field]
        ? null
        : ValidationError.invalidField;
  }
}
