

import '../../../core/viewmodels/base_view_model.dart';

enum SubscriptionPlan { monthly, yearly, lifetime }

class SubscriptionViewModel extends BaseViewModel {
  SubscriptionPlan _selectedPlan = SubscriptionPlan.monthly;

  SubscriptionPlan get selectedPlan => _selectedPlan;

  void selectPlan(SubscriptionPlan plan) {
    _selectedPlan = plan;
    notifyListeners();
  }

  String getPrice(SubscriptionPlan plan) {
    switch (plan) {
      case SubscriptionPlan.monthly:
        return "RS 0000";
      case SubscriptionPlan.yearly:
        return "RS 0000";
      case SubscriptionPlan.lifetime:
        return "RS 0000";
    }
  }

  void subscribe() {
    // TODO: integrate with payment / API
    // Handle subscription logic here
  }
}
