import '../repositories/auth_repository.dart';

class SignInWithGoogle {
  final AuthRepository _repository;
  SignInWithGoogle(this._repository);

  Future<void> call() {
    return _repository.signInWithGoogle();
  }
}





