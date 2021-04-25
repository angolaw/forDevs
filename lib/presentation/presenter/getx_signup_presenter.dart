import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/usecases.dart';
import 'package:fordev/presentation/protocols/protocols.dart';
import 'package:fordev/ui/helpers/helpers.dart';
import 'package:fordev/ui/pages/signup/signup.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';

class GetxSignUpPresenter extends GetxController implements SignUpPresenter {
  final Validation validation;
  final AddAccount addAccount;
  final SaveCurrentAccount saveCurrentAccount;

  final _emailError = Rx<UIError>(UIError.unexpected);
  final _nameError = Rx<UIError>(UIError.unexpected);
  final _passwordError = Rx<UIError>(UIError.unexpected);
  final _passwordConfirmationError = Rx<UIError>(UIError.unexpected);
  final _mainError = Rx<UIError>(UIError.unexpected);
  final _navigateTo = Rx<String>('');
  final _isFormValid = false.obs;
  final _isLoading = false.obs;

  String _name;
  String _email;
  String _password;
  String _passwordConfirmation;

  Stream<UIError> get emailErrorStream => _emailError.stream;
  Stream<UIError> get nameErrorStream => _nameError.stream;
  Stream<UIError> get passwordErrorStream => _passwordError.stream;
  Stream<UIError> get passwordConfirmationErrorStream =>
      _passwordConfirmationError.stream;
  Stream<UIError> get mainErrorStream => _mainError.stream;
  Stream<bool> get isFormValidStream => _isFormValid.stream;
  Stream<bool> get isLoadingStream => _isLoading.stream;
  Stream<String> get navigateToStream => _navigateTo.stream;

  GetxSignUpPresenter(
      {@required this.validation,
      @required this.addAccount,
      @required this.saveCurrentAccount});

  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validateField(field: 'email');
    _validateForm();
  }

  void validateName(String name) {
    _name = name;
    _nameError.value = _validateField(field: 'name');
    _validateForm();
  }

  void validatePassword(String password) {
    _password = password;
    _passwordError.value = _validateField(field: 'password');
    _validateForm();
  }

  void validatePasswordConfirmation(String passwordConfirmation) {
    _passwordConfirmation = passwordConfirmation;
    _passwordConfirmationError.value =
        _validateField(field: 'passwordConfirmation');
    _validateForm();
  }

  UIError _validateField({String field}) {
    final formData = {
      'email': _email,
      'password': _password,
      'name': _name,
      'passwordConfirmation': _passwordConfirmation,
    };
    final error = validation.validate(field: field, input: formData);
    switch (error) {
      case ValidationError.invalidField:
        return UIError.invalidField;
      case ValidationError.requiredField:
        return UIError.requiredField;
      default:
        return null;
    }
  }

  void _validateForm() {
    _isFormValid.value = _emailError.value == null &&
        _nameError.value == null &&
        _passwordError.value == null &&
        _passwordConfirmationError.value == null &&
        _name != null &&
        _email != null &&
        _password != null &&
        _passwordConfirmation != null;
  }

  Future<void> signUp() async {
    try {
      _isLoading.value = true;
      final account = await addAccount.add(AddAccountParams(
          name: _name,
          email: _email,
          password: _password,
          passwordConfirmation: _passwordConfirmation));
      await saveCurrentAccount.save(account);
      _navigateTo.value = '/surveys';
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.emailInUse:
          _mainError.value = UIError.emailInUse;
          break;
        default:
          _mainError.value = UIError.unexpected;
          break;
      }
      _isLoading.value = false;
    }
  }

  void goToLogin() {
    _navigateTo.value = '/login';
  }
}
