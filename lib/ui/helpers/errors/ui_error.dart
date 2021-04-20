enum UIError { unexpected, invalidCredentials, requiredField, invalidField }

extension UIErrorExtension on UIError {
  String get description {
    switch (this) {
      case UIError.invalidCredentials:
        return "Credenciais inválidas";
      case UIError.unexpected:
        return 'Algo errado aconteceu. Tente novamente';
      case UIError.requiredField:
        return 'Campo obrigatorio';
      case UIError.invalidField:
        return 'Campo invalido';
      default:
        return '';
    }
  }
}
