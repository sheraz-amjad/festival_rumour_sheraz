import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/viewmodels/base_view_model.dart';
import '../../../core/di/locator.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/router/app_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_durations.dart';
import 'festival_model.dart';

class FestivalViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();

  final List<FestivalModel> festivals = [];
  final List<FestivalModel> allFestivals = []; // Store all festivals
  List<FestivalModel> filteredFestivals = []; // Filtered festivals for search
  int currentPage = 0;
  String searchQuery = ''; // Search query
  String currentFilter = 'live'; // Current filter (default to live)
  late FocusNode searchFocusNode; // Search field focus node
  TextEditingController searchController = TextEditingController(); // Search field controller

  final PageController pageController = PageController(viewportFraction: AppDimensions.pageViewportFraction);
  Timer? _autoSlideTimer;

  FestivalViewModel() {
    searchFocusNode = FocusNode();
  }

  Future<void> loadFestivals() async {
    await handleAsync(() async {
      await Future.delayed(AppDurations.loadFestivalDelay);

      allFestivals.addAll([
        FestivalModel(
          title: AppStrings.mockFestival1,
          location: AppStrings.mockLocation1,
          date: AppStrings.mockDate1,
          imagepath: AppAssets.festivalimage,
          isLive: true,
        ),
        FestivalModel(
          title: AppStrings.mockFestival2,
          location: AppStrings.mockLocation2,
          date: AppStrings.mockDate2,
          imagepath: AppAssets.festivalimage,
          isLive: false,
        ),
        FestivalModel(
          title: AppStrings.mockFestival3,
          location: AppStrings.mockLocation3,
          date: AppStrings.mockDate3,
          imagepath: AppAssets.festivalimage,
          isLive: false,
        ),
        FestivalModel(
          title: AppStrings.mockFestival4,
          location: AppStrings.mockLocation4,
          date: AppStrings.mockDate4,
          imagepath: AppAssets.festivalimage,
          isLive: false,
        ),
        FestivalModel(
          title: AppStrings.mockFestival5,
          location: AppStrings.mockLocation1,
          date: AppStrings.mockDate5,
          imagepath: AppAssets.festivalimage,
          isLive: true,
        ),
        FestivalModel(
          title: AppStrings.mockFestival6,
          location: AppStrings.mockLocation5,
          date: AppStrings.mockDate6,
          imagepath: AppAssets.festivalimage,
          isLive: false,
        ),
      ]);
      
      // Apply default filter (live festivals)
      _applyFilter();
    }, 
    errorMessage: AppStrings.failedToLoadFestivals,
    minimumLoadingDuration: AppDurations.minimumLoadingDuration);

    if (festivals.isNotEmpty) {
      final int base = (festivals.length * AppDimensions.pageBaseMultiplier) + 1;
      currentPage = base;
      _jumpToInitialWhenReady(base);
      _startAutoSlide();
    }
  }

  void setPage(int index) {
    currentPage = index;
    notifyListeners();
  }

  void _startAutoSlide() {
    _autoSlideTimer?.cancel();
    if (festivals.isEmpty || isDisposed) {
      return;
    }

    _autoSlideTimer = Timer.periodic(AppDurations.autoSlideInterval, (_) {
      if (isDisposed || pageController.positions.isEmpty || !pageController.hasClients) {
        _autoSlideTimer?.cancel();
        return;
      }
      
      try {
        final int nextPage = currentPage + 1;
        pageController.animateToPage(
          nextPage,
          duration: AppDurations.slideAnimationDuration,
          curve: Curves.easeInOut,
        );
        currentPage = nextPage;
        if (!isDisposed) {
          notifyListeners();
        }
      } catch (e) {
        if (kDebugMode) print('Error in auto slide: $e');
        _autoSlideTimer?.cancel();
      }
    });
  }

  void navigateToHome() {
    _navigationService.navigateTo(AppRoutes.navbaar);
  }

  void goBack() {
    _navigationService.pop();
  }

  void goToNextSlide() {
    if (isDisposed || pageController.positions.isEmpty || !pageController.hasClients) return;
    
    try {
      final int nextPage = currentPage + 1;
      pageController.animateToPage(
        nextPage,
        duration: AppDurations.slideAnimationDuration,
        curve: Curves.easeInOut,
      );
      currentPage = nextPage;
      if (!isDisposed) {
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) print('Error in goToNextSlide: $e');
    }
  }

  void _jumpToInitialWhenReady(int page) {
    if (isDisposed) return;
    
    if (pageController.hasClients) {
      try {
        pageController.jumpToPage(page);
      } catch (e) {
        if (kDebugMode) print('Error jumping to page: $e');
      }
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!isDisposed) {
          _jumpToInitialWhenReady(page);
        }
      });
    }
  }

  // Search methods
  void setSearchQuery(String query) {
    searchQuery = query;
    _applySearchFilter();
    notifyListeners();
  }

  void clearSearch() {
    searchQuery = '';
    searchController.clear();
    _applySearchFilter();
    notifyListeners();
  }

  void setFilter(String filter) {
    currentFilter = filter;
    _applyFilter();
    notifyListeners();
  }

  void unfocusSearch() {
    if (isDisposed) return;
    
    try {
      searchFocusNode.unfocus();
    } catch (e) {
      if (kDebugMode) print('Error unfocusing search: $e');
    }
  }

  void _applySearchFilter() {
    if (searchQuery.isEmpty) {
      filteredFestivals = List.from(festivals);
    } else {
      filteredFestivals = festivals.where((festival) {
        return festival.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
               festival.location.toLowerCase().contains(searchQuery.toLowerCase()) ||
               festival.date.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }
  }

  void _applyFilter() {
    switch (currentFilter) {
      case 'live':
        festivals.clear();
        festivals.addAll(allFestivals.where((festival) => festival.isLive).toList());
        break;
      case 'upcoming':
        festivals.clear();
        festivals.addAll(allFestivals.where((festival) => !festival.isLive).toList());
        break;
      case 'past':
        festivals.clear();
        festivals.addAll(allFestivals.where((festival) => !festival.isLive).toList());
        break;
      default:
        festivals.clear();
        festivals.addAll(allFestivals);
    }
    _applySearchFilter();
  }

  String get currentSearchQuery => searchQuery;

  @override
  void onDispose() {
    _autoSlideTimer?.cancel();
    pageController.dispose();
    searchFocusNode.dispose();
    searchController.dispose();
    super.onDispose();
  }
}
