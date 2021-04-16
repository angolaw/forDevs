import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/presentation/protocols/protocols.dart';
import 'package:fordev/validation/protocols/protocols.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite({this.validations});
  @override
  String validate({@required String field, @required String value}) {
    return null;
  }
}

class FieldValidationSpy extends Mock implements FieldValidation {}

void main() {
  ValidationComposite sut;
  setUp(() {
    sut = ValidationComposite(validations: []);
  });
  test('should return null if all validations return null or empty', () {
    final validation1 = FieldValidationSpy();
    when((validation1.field)).thenReturn('any_field');
    when((validation1.validate(any))).thenReturn(null);

    final validation2 = FieldValidationSpy();
    when((validation2.field)).thenReturn('any_field');
    when((validation2.validate(any))).thenReturn('');
    sut.validations.add(validation1);
    sut.validations.add(validation2);

    final error = sut.validate(field: 'any_field', value: 'any_value');
    expect(error, null);
  });
}
