import 'package:festival_rumour/shared/extensions/context_extensions.dart';
import 'package:festival_rumour/ui/views/festival/widgets/festivalcard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/base_view.dart';
import '../../../shared/widgets/responsive_text_widget.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/responsive_widget.dart';
import 'festival_view_model.dart';

class FestivalView extends BaseView<FestivalViewModel> {
  const FestivalView({super.key});

  @override
  FestivalViewModel createViewModel() => FestivalViewModel();

  @override
  void onViewModelReady(FestivalViewModel viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.loadFestivals();
  }

  @override
  Widget buildView(BuildContext context, FestivalViewModel viewModel) {
    final pageController = viewModel.pageController;

    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping outside
        viewModel.unfocusSearch();
      },
      child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          /// 🖼 Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppAssets.bottomsheet),
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// 🎨 Overlay layer (white or black tint)
          Container(
            color: AppColors.primary.withOpacity(0.3), // You can tweak opacity (0.1–0.4)
          ),

          /// 🧱 Foreground content
          SafeArea(
            child: ResponsiveContainer(
              mobileMaxWidth: double.infinity,
              tabletMaxWidth: AppDimensions.tabletWidth,
              desktopMaxWidth: AppDimensions.desktopWidth,
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: AppDimensions.spaceS),
                _buildTopBarWithSearch(context, viewModel),
                SizedBox(height: AppDimensions.spaceS),
              //   SizedBox(height: context.getConditionalSpacing()),
                _titleHeadline(context),
                SizedBox(height: AppDimensions.spaceS),
                Expanded(
                    child: _buildFestivalsSlider(context, viewModel, pageController),
                ),
                SizedBox(height: AppDimensions.spaceS),
                _buildBottomIcon(context),
              ],
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  void _showFilterMenu(BuildContext context, FestivalViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.onPrimary.withOpacity(0.9),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Filter Festivals',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            _buildFilterOption(context, viewModel, AppStrings.live, Icons.live_tv),
            _buildFilterOption(context, viewModel, AppStrings.upcoming, Icons.schedule),
            _buildFilterOption(context, viewModel, AppStrings.past, Icons.history),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(BuildContext context, FestivalViewModel viewModel, String filter, IconData icon) {
    final isSelected = viewModel.currentFilter == filter;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.accent : AppColors.primary,
      ),
      title: Text(
        filter,
        style: TextStyle(
          color: isSelected ? AppColors.accent : AppColors.primary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () {
        viewModel.setFilter(filter);
        Navigator.pop(context);
      },
    );
  }


  Widget _buildTopBarWithSearch(BuildContext context, FestivalViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingS),
      child: Row(
      children: [
          // Logo
        Container(
          height: context.getConditionalLogoSize(),
          width: context.getConditionalLogoSize(),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
          ),
          child: SvgPicture.asset(
            AppAssets.logo,
            color: AppColors.primary,
          ),
        ),
         SizedBox(width: AppDimensions.spaceM ),
          
          // Search Bar (same design as home view)
        Expanded(
          child: Container(
            height: context.isSmallScreen 
                ? AppDimensions.searchBarHeight * 0.8
                : context.isMediumScreen 
                    ? AppDimensions.searchBarHeight * 0.9
                    : AppDimensions.searchBarHeight * 0.9,
            margin: context.responsiveMargin,
            padding: context.responsivePadding,
            decoration: BoxDecoration(
              color: AppColors.onPrimary,
              borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
            ),
            child: Row(
              children: [
                SizedBox(width: context.getConditionalSpacing()),
                Icon(
                  Icons.search, 
                  color: AppColors.onSurfaceVariant, 
                  size: context.getConditionalIconSize(),
                ),
                SizedBox(width: context.getConditionalSpacing()),

                /// 🔹 Search Field
                Expanded(
                  child: TextField(
                    controller: viewModel.searchController,
                        focusNode: viewModel.searchFocusNode,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText: AppStrings.searchFestivals,
                          hintStyle: const TextStyle(
                        color: AppColors.grey600,
                            fontWeight: FontWeight.w600,
                            fontSize: AppDimensions.textM,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          isDense: true,
                          filled: false,
                          fillColor: Colors.transparent,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: AppDimensions.textM,
                          height: AppDimensions.searchBarTextHeight,
                        ),
                    cursorColor: AppColors.primary,
                    onChanged: (value) {
                      viewModel.setSearchQuery(value);
                    },
                    onSubmitted: (value) {
                      viewModel.unfocusSearch();
                    },
                   textInputAction: TextInputAction.search,
                  ),
                ),

                /// 🔹 Search Clear Button - Always reserve space
                SizedBox(
                  width: AppDimensions.searchBarClearButtonWidth,
                  child: viewModel.currentSearchQuery.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear, color: AppColors.primary, size: AppDimensions.searchBarIconSize),
                    onPressed: () {
                      // ✅ Clear search and hide keyboard
                      viewModel.clearSearch();
                      FocusScope.of(context).unfocus();
                    },
                  )
                      : const SizedBox.shrink(),
                ),

                /// 🔹 Filter Dropdown Menu (No Text Display)
                SizedBox(
                  width: context.getConditionalIconSize(), // Fixed width to prevent layout issues
                  height: context.getConditionalIconSize(), // Fixed height to match search bar
                  child: DropdownMenu<String>(
                    initialSelection: viewModel.currentFilter,
                    onSelected: (value) {
                      if (value != null) {
                        viewModel.setFilter(value);
                        debugPrint("${AppDimensions.debugSelectedFilter}$value");
                      }
                    },
                    // Hide the text input completely
                    textStyle: const TextStyle(color: Colors.transparent, fontSize: 0),
                    inputDecorationTheme: InputDecorationTheme(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                    ),
                    // Make the dropdown invisible but functional
                    expandedInsets: EdgeInsets.zero,
                    width: double.infinity,
                  menuStyle: MenuStyle(
                    backgroundColor: WidgetStateProperty.all(AppColors.onPrimary),
                    elevation: WidgetStateProperty.all(8),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                      ),
                    ),
                    minimumSize: WidgetStateProperty.all(Size(double.infinity, 0)),
                    maximumSize: WidgetStateProperty.all(Size(double.infinity, double.infinity)),
                  ),
                  trailingIcon: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                    ),
                    child: const Icon(
                      Icons.arrow_drop_down_outlined,
                      color: AppColors.onPrimary,
                      size: AppDimensions.searchBarDropdownIconSize,
                    ),
                  ),
                  dropdownMenuEntries: [
                    DropdownMenuEntry<String>(
                      value: AppStrings.live,
                      label: AppStrings.live,
                      labelWidget: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.paddingM,
                            vertical: AppDimensions.paddingS,
                          ),
                          decoration: BoxDecoration(
                            color: viewModel.currentFilter == AppStrings.live
                                ? AppColors.primary.withOpacity(0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                width: AppDimensions.searchBarDropdownEntryIconContainerSize,
                                height: AppDimensions.searchBarDropdownEntryIconContainerHeight,
                                decoration: BoxDecoration(
                                  color: viewModel.currentFilter == AppStrings.live
                                      ? AppColors.accent
                                      : AppColors.primary,
                                  borderRadius: BorderRadius.circular(AppDimensions.radiusXS),
                                  boxShadow: viewModel.currentFilter == AppStrings.live
                                      ? [
                                          BoxShadow(
                                            color: AppColors.primary.withOpacity(0.3),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]
                                      : null,
                      ),
                      child: Icon(
                                  Icons.live_tv,
                        color: AppColors.onPrimary, 
                                  size: AppDimensions.searchBarDropdownEntryIconSize,
                                ),
                              ),
                              const SizedBox(width: AppDimensions.spaceM),
                              Text(
                          AppStrings.live,
                                style: TextStyle(
                                  color: viewModel.currentFilter == AppStrings.live
                                      ? AppColors.accent
                                      : AppColors.primary,
                                  fontSize: AppDimensions.textM,
                                  fontWeight: viewModel.currentFilter == AppStrings.live
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    DropdownMenuEntry<String>(
                      value: AppStrings.upcoming,
                      label: AppStrings.upcoming,
                      labelWidget: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.paddingM,
                            vertical: AppDimensions.paddingS,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                width: AppDimensions.searchBarDropdownEntryIconContainerSize,
                                height: AppDimensions.searchBarDropdownEntryIconContainerHeight,
                                decoration: BoxDecoration(
                                  color: viewModel.currentFilter == AppStrings.upcoming
                                      ? AppColors.accent
                                      : AppColors.primary,
                                  borderRadius: BorderRadius.circular(AppDimensions.radiusXS),
                                  boxShadow: viewModel.currentFilter == AppStrings.upcoming
                                      ? [
                                          BoxShadow(
                                            color: AppColors.primary.withOpacity(0.3),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Icon(
                                  Icons.schedule,
                                  color: AppColors.onPrimary,
                                  size: AppDimensions.searchBarDropdownEntryIconSize,
                                ),
                              ),
                              const SizedBox(width: AppDimensions.spaceM),
                              Text(
                          AppStrings.upcoming,
                                style: TextStyle(
                                  color: viewModel.currentFilter == AppStrings.upcoming
                                      ? AppColors.accent
                                      : AppColors.primary,
                                  fontSize: AppDimensions.textM,
                                  fontWeight: viewModel.currentFilter == AppStrings.upcoming
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    DropdownMenuEntry<String>(
                      value: AppStrings.past,
                      label: AppStrings.past,
                      labelWidget: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.paddingM,
                            vertical: AppDimensions.paddingS,
                          ),
                          decoration: BoxDecoration(
                            color: viewModel.currentFilter == AppStrings.past
                                ? AppColors.primary.withOpacity(0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                width: AppDimensions.searchBarDropdownEntryIconContainerSize,
                                height: AppDimensions.searchBarDropdownEntryIconContainerHeight,
                                decoration: BoxDecoration(
                                  color: viewModel.currentFilter == AppStrings.past
                                      ? AppColors.accent
                                      : AppColors.primary,
                                  borderRadius: BorderRadius.circular(AppDimensions.radiusXS),
                                  boxShadow: viewModel.currentFilter == AppStrings.past
                                      ? [
                                          BoxShadow(
                                            color: AppColors.primary.withOpacity(0.3),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Icon(
                                  Icons.history,
                                  color: AppColors.onPrimary,
                                  size: AppDimensions.searchBarDropdownEntryIconSize,
                                ),
                              ),
                              const SizedBox(width: AppDimensions.spaceM),
                              Text(
                          AppStrings.past,
                                style: TextStyle(
                                  color: viewModel.currentFilter == AppStrings.past
                                      ? AppColors.accent
                                      : AppColors.primary,
                                  fontSize: AppDimensions.textM,
                                  fontWeight: viewModel.currentFilter == AppStrings.past
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
      ),
    );
  }

  Widget _buildFestivalsSlider(BuildContext context, FestivalViewModel viewModel, PageController pageController) {
    if (viewModel.isLoading && viewModel.festivals.isEmpty) {
      return LoadingWidget(message: AppStrings.loadingfestivals);
    }

    // Show filtered festivals if there's a search query, otherwise show all festivals
    final festivalsToShow = viewModel.searchQuery.isNotEmpty ? viewModel.filteredFestivals : viewModel.festivals;

    if (festivalsToShow.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off,
              size: 64,
              color: AppColors.onSurfaceVariant,
            ),
            const SizedBox(height: AppDimensions.spaceM),
            ResponsiveTextWidget(
              viewModel.searchQuery.isNotEmpty 
                ? "${AppStrings.noFestivalsAvailable} for '${viewModel.searchQuery}'"
                : AppStrings.noFestivalsAvailable,
              textType: TextType.body,
              color: AppColors.onSurfaceVariant,
              textAlign: TextAlign.center,
            ),
            if (viewModel.searchQuery.isNotEmpty) ...[
              const SizedBox(height: AppDimensions.spaceS),
              TextButton(
                onPressed: () => viewModel.clearSearch(),
                child: const ResponsiveTextWidget(
                  AppStrings.clearSearch,
                  textType: TextType.body, color: AppColors.primary),
                ),
            ],
          ],
        ),
      );
    }

    return PageView.builder(
      controller: pageController,
      padEnds: true,
      onPageChanged: (page) {
        viewModel.setPage(page);
      },
      itemBuilder: (context, index) {
        final festival = festivalsToShow[index % festivalsToShow.length];
        return SizedBox(
          width: double.infinity,
          child: ResponsivePadding(
            mobilePadding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingS),
            tabletPadding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
            desktopPadding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
            child: FestivalCard(
              festival: festival,
              onBack: viewModel.goBack,
              onTap: viewModel.navigateToHome,
              onNext: viewModel.goToNextSlide,
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomIcon(BuildContext context) {
    return Center(
        child: Container(
          height: AppDimensions.buttonHeightXL,
          width: AppDimensions.buttonHeightXL,
          child: SvgPicture.asset(
            AppAssets.note,
            width: AppDimensions.iconM,
            height: AppDimensions.iconM,
            color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _titleHeadline(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.isSmallScreen 
            ? AppDimensions.paddingXS
            : context.isMediumScreen 
                ? AppDimensions.paddingS
                : AppDimensions.paddingS,
        vertical: context.isSmallScreen
            ? AppDimensions.paddingXS
            : context.isMediumScreen 
                ? AppDimensions.paddingS
                : AppDimensions.paddingS
      ),
      decoration: BoxDecoration(
        color: AppColors.headlineBackground,
      ),
      child: ResponsiveTextWidget(
        AppStrings.headlineText,
        textAlign: TextAlign.center,
        fontSize: AppDimensions.textL,
      //  fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
    );
  }
}
