import '../../../core/viewmodels/base_view_model.dart';
import '../../../core/router/app_router.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/di/locator.dart';

class SettingsViewModel extends BaseViewModel {
  /// 🔹 Switch states
  bool notifications = true;
  bool privacy = false;

  /// 🔹 Navigation service
  final NavigationService _navigationService = locator<NavigationService>();

  /// 🔹 Toggle methods
  void toggleNotifications(bool value) {
    notifications = value;
    notifyListeners();
  }

  void togglePrivacy(bool value) {
    privacy = value;
    notifyListeners();
  }

  /// 🔹 Navigation / Actions (stub methods for now)
  void editAccount() {
    _navigationService.navigateTo(AppRoutes.editAccount);
  }

  void openBadges() {
    // TODO: Navigate to Badges screen
  }

  void openLeaderboard() {
    // TODO: Navigate to Leaderboard screen
    _navigationService.navigateTo(AppRoutes.leaderboard);
  }

  void openHelp() {
    // TODO: Open How to Use section
  }

  void rateApp() {
    // TODO: Launch app store for rating
  }

  void shareApp() {
    // TODO: Implement app sharing logic
  }

  void openPrivacyPolicy() {
    // TODO: Navigate to Privacy Policy page
  }

  void openTerms() {
    // TODO: Navigate to Terms & Conditions page
  }

  void logout() {
    _navigationService.navigateTo(
      AppRoutes.welcome,
      arguments: null,
      // Replace all routes before navigating
    );

    // Ensure all previous routes are removed
    _navigationService.popUntil((route) => route.isFirst);
  }

  void goToSubscription() {
    _navigationService.navigateTo(AppRoutes.subscription);
  }
}
