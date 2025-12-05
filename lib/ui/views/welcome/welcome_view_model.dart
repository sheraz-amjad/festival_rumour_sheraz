import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/di/locator.dart';
import '../../../core/router/app_router.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/viewmodels/base_view_model.dart';
import '../../../shared/extensions/context_extensions.dart';

class WelcomeViewModel extends BaseViewModel {
  bool _isLoading = false;
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authService = AuthService();

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> loginWithGoogle() async {
    setLoading(true);

    try {
      final userCredential = await _authService.signInWithGoogle();
      if (userCredential != null) {
        // User signed in successfully with Firebase
        print("Google Sign-In successful: ${userCredential.user?.email}");
        // Navigate to home or next screen
        _navigationService.navigateTo(AppRoutes.festivals);
      }
    } catch (error) {
      print("Google Sign-In Error: $error");
      // You can show error message to user here
    }

    setLoading(false);
  }

  Future<void> loginWithEmail() async {
    _navigationService.navigateTo(AppRoutes.username);
  }

  Future<void> loginWithApple() async {
    setLoading(true);

    try {
      final userCredential = await _authService.signInWithApple();
      if (userCredential != null) {
        // User signed in successfully with Firebase
        print("Apple Sign-In successful: ${userCredential.user?.email}");
        // Navigate to home or next screen
        _navigationService.navigateTo(AppRoutes.festivals);
      }
    } catch (error) {
      print("Apple Sign-In Error: $error");
      // You can show error message to user here
    }

    setLoading(false);
  }

  void goToSignup() {
    _navigationService.navigateTo(AppRoutes.signupEmail);
  }
}
