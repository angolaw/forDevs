import 'package:fordev/ui/helpers/helpers.dart';

abstract class SignUpPresenter {
  void validateEmail(String email);
  void validatePassword(String password);
  void validateName(String name);
  void validatePasswordConfirmation(String confirmationPassword);

  Stream<UIError> get emailErrorStream;
  Stream<UIError> get passwordErrorStream;
  Stream<UIError> get nameErrorStream;
  Stream<UIError> get passwordConfirmationErrorStream;

  void dispose();
}
