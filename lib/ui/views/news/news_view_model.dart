import 'package:flutter/cupertino.dart';

import '../../../core/viewmodels/base_view_model.dart';

class NewsViewModel extends BaseViewModel {
  List<FestivalItem> _festivals = [];
  bool _showBulletinPreview = false;
  bool _showPerformancePreview = false;

  List<FestivalItem> get festivals => _festivals;
  bool get showBulletinPreview => _showBulletinPreview;
  bool get showPerformancePreview => _showPerformancePreview;

  @override
  void init() {
    super.init();
    _loadFestivals();
  }

  void _loadFestivals() {
    _festivals = [
      FestivalItem(
        name: 'Glastonbury Festival',
        description: 'Music and Arts Festival',
      ),
      FestivalItem(
        name: 'Reading And Leeds Festival',
        description: 'Rock and Alternative Music Festival',
      ),
      FestivalItem(
        name: 'Download Festival',
        description: 'Rock and Metal Music Festival',
      ),
      FestivalItem(
        name: 'New Bulletin',
        description: 'Latest Festival Updates',
      ),
    ];
    notifyListeners();
  }

  void addFestival(FestivalItem festival) {
    _festivals.add(festival);
    notifyListeners();
  }

  void removeFestival(int index) {
    if (index >= 0 && index < _festivals.length) {
      _festivals.removeAt(index);
      notifyListeners();
    }
  }

  void set showBulletinPreview(bool value) {
    _showBulletinPreview = value;
    notifyListeners();
  }

  void set showPerformancePreview(bool value) {
    _showPerformancePreview = value;
    notifyListeners();
  }

  // Navigation methods
  // void navigateBack(BuildContext context) {
  //   Navigator.pop(context);
  // }

  void navigateToBulletinPreview() {
    _showBulletinPreview = true;
    notifyListeners();
  }

  void navigateBackFromBulletinPreview() {
    _showBulletinPreview = false;
    notifyListeners();
  }

  void navigateToPerformancePreview() {
    _showPerformancePreview = true;
    notifyListeners();
  }

  void navigateBackFromPerformancePreview() {
    _showPerformancePreview = false;
    notifyListeners();
  }
}

class FestivalItem {
  final String name;
  final String description;

  FestivalItem({
    required this.name,
    required this.description,
  });
}
