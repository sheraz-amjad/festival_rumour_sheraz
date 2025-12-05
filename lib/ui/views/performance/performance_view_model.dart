import 'package:flutter/material.dart';
import '../../../core/viewmodels/base_view_model.dart';
import '../../../core/constants/app_strings.dart';
import 'performance_view.dart';

class PerformanceViewModel extends BaseViewModel {
  List<PerformanceCategory> _performanceCategories = [];
  bool _showPerformancePreview = false;

  List<PerformanceCategory> get performanceCategories => _performanceCategories;
  bool get showPerformancePreview => _showPerformancePreview;

  @override
  void init() {
    super.init();
    _loadPerformanceCategories();
  }

  void _loadPerformanceCategories() {
    _performanceCategories = [
      PerformanceCategory(
        name: AppStrings.music,
        description: AppStrings.liveMusicPerformances,
        icon: Icons.music_note,
      ),
      PerformanceCategory(
        name: AppStrings.sportsAndGames,
        description: AppStrings.sportsActivitiesAndGames,
        icon: Icons.sports_soccer,
      ),
      PerformanceCategory(
        name: AppStrings.exhibitionsAndArtDisplays,
        description: AppStrings.artExhibitionsAndDisplays,
        icon: Icons.palette,
      ),
      PerformanceCategory(
        name: AppStrings.culturalPerformances,
        description: AppStrings.traditionalCulturalPerformances,
        icon: Icons.theater_comedy,
      ),
    ];
    notifyListeners();
  }

  void addPerformanceCategory(PerformanceCategory category) {
    _performanceCategories.add(category);
    notifyListeners();
  }

  void removePerformanceCategory(int index) {
    if (index >= 0 && index < _performanceCategories.length) {
      _performanceCategories.removeAt(index);
      notifyListeners();
    }
  }

  void set showPerformancePreview(bool value) {
    _showPerformancePreview = value;
    notifyListeners();
  }
}
