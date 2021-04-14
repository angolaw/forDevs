abstract class LoginPresenter {
  void validateEmail(String email);
  void validatePassword(String password);
  Stream<String> get emailErrorStream;
  Stream<String> get passwordErrorStream;
  Stream<String> get mainErrorStream;
  Stream<bool> get isFormValidStream;
  Stream<bool> get isLoadingStream;
  Future<void> auth();
  void dispose();
}
