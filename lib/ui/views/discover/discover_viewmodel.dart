import 'package:flutter/cupertino.dart';

import '../../../core/router/app_router.dart';
import '../../../core/viewmodels/base_view_model.dart';
import '../../../core/constants/app_strings.dart';

class DiscoverViewModel extends BaseViewModel {
  String selected = AppStrings.live;
  bool _isFavorited = false;
  //List<Map<String, String>> festivals = AppFestivals.festivals;

  bool get isFavorited => _isFavorited;

  void select(String category) {
    selected = category;
    notifyListeners();
  }

  void toggleFavorite() {
    _isFavorited = !_isFavorited;
    notifyListeners();
  }

  void goToRumors(BuildContext context) {
    Navigator.pushNamed(
      context,
      AppRoutes.rumors,
    );
  }

  void onBottomNavTap(int index) {
    // Navigate between tabs
  }
}
