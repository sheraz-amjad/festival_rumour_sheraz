import '../../domain/repositories/auth_repository.dart';
import '../../core/services/auth_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;

  AuthRepositoryImpl(this._authService);

  @override
  Future<void> signInWithApple() async {
    await _authService.signInWithApple();
  }

  @override
  Future<void> signInWithGoogle() async {
    await _authService.signInWithGoogle();
  }
}



