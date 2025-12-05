import 'package:flutter/material.dart';
import '../../../core/viewmodels/base_view_model.dart';
import '../../../core/di/locator.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/router/app_router.dart';

class SplashViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();

  SplashViewModel() {
    _init();
  }

  Future<void> _init() async {
    setLoading(true);
    await Future.delayed(const Duration(seconds: 3));
    // Navigate to Welcome screen via NavigationService and clear stack
    await _navigationService.pushNamedAndRemoveUntil(
      AppRoutes.welcome,
      (route) => false,
    );
  }
}
