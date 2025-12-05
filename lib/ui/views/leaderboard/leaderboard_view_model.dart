

import '../../../core/viewmodels/base_view_model.dart';

class LeaderboardViewModel extends BaseViewModel {
  final List<Map<String, dynamic>> leaders = [
    {"rank": 1, "name": "Patrick", "badge": "Top Rumour Spotter"},
    {"rank": 2, "name": "James", "badge": "Media Master"},
    {"rank": 3, "name": "Micheal", "badge": "Crowd Favourite"},
  ];
}
