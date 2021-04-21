import 'package:fordev/ui/helpers/helpers.dart';

abstract class SignUpPresenter {
  void validateEmail(String email);
  void validatePassword(String password);
  Stream<UIError> get emailErrorStream;
  Stream<UIError> get passwordErrorStream;
  Stream<UIError> get mainErrorStream;
  Stream<bool> get isFormValidStream;
  Stream<bool> get isLoadingStream;
  Stream<String> get navigateToStream;
  Future<void> auth();
  void dispose();
}
