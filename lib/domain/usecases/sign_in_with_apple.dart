import '../repositories/auth_repository.dart';

class SignInWithApple {
  final AuthRepository _repository;
  SignInWithApple(this._repository);

  Future<void> call() {
    return _repository.signInWithApple();
  }
}





