import 'package:flutter/cupertino.dart';

import '../../../core/viewmodels/base_view_model.dart';
import '../../../core/router/app_router.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/di/locator.dart';

class DetailViewModel extends BaseViewModel {
  // Navigation methods
  void navigateBack(BuildContext context) {
    Navigator.pop(context);
  }

  void navigateToNews(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.news);
  }

  void navigateToToilets(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.toilets);
  }

  void navigateToPerformance(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.performance);
  }

  void navigateToEvent(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.event);
  }
}
