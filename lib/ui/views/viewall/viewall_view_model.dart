import 'package:flutter/material.dart';
import '../../../core/viewmodels/base_view_model.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_assets.dart';
import '../event/event_view.dart';
import '../performance/performance_view.dart';
import '../news/news_view_model.dart';


class ViewAllViewModel extends BaseViewModel {
  final int? _initialTab;
  int _selectedTab = 0;
  List<EventCategory> _events = [];
  List<PerformanceCategory> _performances = [];
  List<FestivalItem> _news = [];

  ViewAllViewModel({int? initialTab}) : _initialTab = initialTab;

  int get selectedTab => _selectedTab;
  List<EventCategory> get events => _events;
  List<PerformanceCategory> get performances => _performances;
  List<FestivalItem> get news => _news;
  bool get showTabSelector => _initialTab == null;

  @override
  void init() {
    super.init();
    if (_initialTab != null && _initialTab! >= 0 && _initialTab! <= 2) {
      _selectedTab = _initialTab!;
    }
    _loadAllData();
  }

  void _loadAllData() {
    // Load Events
    _events = [
      EventCategory(
        name: AppStrings.workshopsAndTalks,
        description: AppStrings.educationalWorkshopsAndSpeakerSessions,
      ),
      EventCategory(
        name: AppStrings.filmScreenings,
        description: AppStrings.movieAndDocumentaryScreenings,
      ),
      EventCategory(
        name: AppStrings.artInstallations,
        description: AppStrings.interactiveArtDisplaysAndExhibitions,
      ),
      EventCategory(
        name: AppStrings.charityAndCommunityEvents,
        description: AppStrings.communityServiceAndCharityActivities,
      ),
      EventCategory(
        name: AppStrings.musicPerformances,
        description: AppStrings.liveMusicAndEntertainmentShows,
      ),
    ];

    // Load Performances
    _performances = [
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

    // Load News
    _news = [
      FestivalItem(
        name: AppStrings.glastonburyFestival,
        description: AppStrings.musicAndArtsFestival,
      ),
      FestivalItem(
        name: AppStrings.readingAndLeedsFestival,
        description: AppStrings.rockAndAlternativeMusicFestival,
      ),
      FestivalItem(
        name: AppStrings.downloadFestival,
        description: AppStrings.rockAndMetalMusicFestival,
      ),
      FestivalItem(
        name: AppStrings.newBulletin,
        description: AppStrings.latestFestivalUpdates,
      ),
    ];

    notifyListeners();
  }

  void setSelectedTab(int index) {
    _selectedTab = index;
    notifyListeners();
  }

  void navigateToEventDetail(EventCategory event) {
    // Handle navigation to event detail
  }

  void navigateToPerformanceDetail(PerformanceCategory performance) {
    // Handle navigation to performance detail
  }

  void navigateToNewsDetail(FestivalItem newsItem) {
    // Handle navigation to news detail
  }
}

