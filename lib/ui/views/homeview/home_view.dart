import 'package:festival_rumour/ui/views/homeview/widgets/post_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/utils/base_view.dart';
import '../../../core/router/app_router.dart';
import '../../../shared/widgets/responsive_widget.dart';
import '../../../shared/widgets/responsive_text_widget.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/extensions/context_extensions.dart';
import 'home_viewmodel.dart';

class HomeView extends BaseView<HomeViewModel> {
  const HomeView({super.key});

  @override
  HomeViewModel createViewModel() => HomeViewModel();

  @override
  void onViewModelReady(HomeViewModel viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.loadPosts();
  }

  @override
  Widget buildView(BuildContext context, HomeViewModel viewModel) {
    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping outside
        viewModel.unfocusSearch();
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        body: Stack(
        children: [
          // Background Image - Full screen coverage
          Positioned.fill(
            child: Image.asset(
              AppAssets.bottomsheet,
              fit: BoxFit.cover,
            ),
          ),

          // Main Content
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(context, viewModel),
                _buildSearchBar(context, viewModel),
                // Conditional spacing based on screen size

                Expanded(
                  child: _buildFeedList(context, viewModel),
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
  Widget _buildFloatingButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, right: 5), // Fine-tuned position
      child: FloatingActionButton(
        onPressed: () {
          //   _showPostBottomSheet(context);
        },
        backgroundColor: AppColors.onPrimary,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
        elevation: 8,
        shape: const CircleBorder(),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, HomeViewModel viewModel) {
    return ResponsivePadding(
      mobilePadding: EdgeInsets.symmetric(
        horizontal: AppDimensions.appBarHorizontalMobile,
        vertical: AppDimensions.appBarVerticalMobile,
      ),
      tabletPadding: EdgeInsets.symmetric(
        horizontal: AppDimensions.appBarHorizontalTablet,
        vertical: AppDimensions.appBarVerticalTablet,
      ),
      desktopPadding: EdgeInsets.symmetric(
        horizontal: AppDimensions.appBarHorizontalDesktop,
        vertical: AppDimensions.appBarVerticalDesktop,
      ),
      child: Row(
        children: [
          // Logo with responsive sizing
          SvgPicture.asset(
            AppAssets.logo,
            color: AppColors.primary,
            width: context.getConditionalLogoSize(),
           // The getter 'responsivePaddingL' isn't defined for the type 'BuildContext'.
            
            height: context.getConditionalLogoSize(),
          ),
          
          // Title - Flexible to prevent overflow
          Expanded(
            child: ResponsiveTextWidget(
              AppStrings.lunaFest2025,
              fontSize: context.getConditionalMainFont(),
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Create Post Icon Button with responsive sizing
          IconButton(
            icon: Icon(
              Icons.add_circle_outline,
              color: AppColors.primary,
              size: AppDimensions.iconXL,
            ),
            onPressed: () => viewModel.goToCreatePost(),
          ),

          // Job Icon Button with responsive sizing
          IconButton(
            icon: SvgPicture.asset(
              AppAssets.jobicon,
             width: AppDimensions.iconXL,
              height: AppDimensions.iconXL,
            ),
            onPressed: () => _showPostBottomSheet(context),
          ),
          
          // Conditional spacing before Pro label
          
          // Pro Label - Aligned with search bar dropdown position
          GestureDetector(
            onTap: viewModel.goToSubscription,
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.paddingS),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
              child: ResponsiveTextWidget(
                AppStrings.proLabel,
                textType: TextType.label,
                fontSize: AppDimensions.textS,
                color: AppColors.proLabelText,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildSearchBar(BuildContext context, HomeViewModel viewModel) {
    return ResponsiveContainer(
      mobileMaxWidth: double.infinity,
      tabletMaxWidth: double.infinity,
      desktopMaxWidth: double.infinity,
      child: Container(
        margin:  context.responsiveMargin,
        padding:  context.responsivePadding,
        height: context.getConditionalButtonSize(),
        decoration: BoxDecoration(
          color: AppColors.onPrimary,
          borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
        ),
        child: Row(
          children: [
            SizedBox(width: context.getConditionalSpacing()),
            // Conditional spacing for search icon - smaller on small screens
            Icon(
              Icons.search, 
              color: AppColors.onSurfaceVariant, 
              size: context.getConditionalIconSize(),
            ),
            // Conditional spacing after search icon - adaptive sizing
            SizedBox(width: context.getConditionalSpacing()),
            /// 🔹 Search Field
            Expanded(
              child: TextField(
                controller: viewModel.searchController,
                focusNode: viewModel.searchFocusNode,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: AppStrings.searchHint,
                  hintStyle: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: context.getConditionalFont(),
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
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: context.getConditionalFont(),
                //  height: context.getConditionalButtonSize(),
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
              width: context.getConditionalIconSize(),
              child: viewModel.currentSearchQuery.isNotEmpty
                  ? IconButton(
                icon:  Icon(Icons.clear, color: AppColors.primary, size: context.getConditionalIconSize()),
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
              width: AppDimensions.iconL, // Fixed width to prevent layout issues
              height: AppDimensions.iconL, // Fixed height to match search bar
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
                      width: double.infinity,
                      padding: context.responsivePadding,
                     margin: context.responsiveMargin,  // vertical: context.responsivePadding,

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
                          SizedBox(width: context.responsiveSpaceM),
                          ResponsiveTextWidget(
                            AppStrings.live,
                            textType: TextType.body,
                            color: viewModel.currentFilter == AppStrings.live
                                ? AppColors.accent
                                : AppColors.primary,
                            fontSize: context.responsiveTextM,
                            fontWeight: viewModel.currentFilter == AppStrings.live
                                ? FontWeight.w600
                                : FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                  ),
                DropdownMenuEntry<String>(
                  value: AppStrings.upcoming,
                  label: AppStrings.upcoming,
                  labelWidget: Container(
                      width: double.infinity,
                    padding: context.responsivePadding,
                    margin: context.responsiveMargin,
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
                          SizedBox(width: context.responsiveSpaceM),
                          ResponsiveTextWidget(
                            AppStrings.upcoming,
                            textType: TextType.body,
                            color: viewModel.currentFilter == AppStrings.upcoming
                                ? AppColors.accent
                                : AppColors.primary,
                            fontSize: context.responsiveTextM,
                            fontWeight: viewModel.currentFilter == AppStrings.upcoming
                                ? FontWeight.w600
                                : FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                  ),
                DropdownMenuEntry<String>(
                  value: AppStrings.past,
                  label: AppStrings.past,
                  labelWidget: Container(
                      width: double.infinity,
                    padding: context.responsivePadding,
                    margin: context.responsiveMargin,
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
                          SizedBox(width: context.responsiveSpaceM),
                          ResponsiveTextWidget(
                            AppStrings.past,
                            textType: TextType.body,
                            color: viewModel.currentFilter == AppStrings.past
                                ? AppColors.accent
                                : AppColors.primary,
                            fontSize: context.responsiveTextM,
                            fontWeight: viewModel.currentFilter == AppStrings.past
                                ? FontWeight.w600
                                : FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
              ),
            ),
            // Conditional spacing at end of search bar

          ],
        ),
      ),
    );
  }

  Widget _buildFeedList(BuildContext context, HomeViewModel viewModel) {
    if (viewModel.isLoading && viewModel.posts.isEmpty) {
      return const LoadingWidget(message: AppStrings.loadingPosts);
    }

    if (viewModel.posts.isEmpty) {
      return Center(
        child: ResponsiveTextWidget(
          AppStrings.noPostsAvailable,
          textType: TextType.body,
          color: AppColors.primary,
          fontSize: AppDimensions.textM,
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingXS),
      itemCount: viewModel.posts.length,
      itemBuilder: (context, index) {
        final post = viewModel.posts[index];
        return Column(
          children: [
            PostWidget(post: post),
            // Conditional spacing between posts
            if (index != viewModel.posts.length - 1)
              SizedBox(height: context.responsiveSpaceS),
          ],
        );
      },
    );
  }


  void _showPostBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.onPrimary.withOpacity(0.4),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: context.getConditionalPadding(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
           // crossAxisAlignment: CrossAxisAlignment.,
            children: [
               Center(
                child: Padding(
                  padding: context.getConditionalPadding(),
                  child: ResponsiveTextWidget(
                    AppStrings.jobDetails,
                  //  textType: TextType.title,
                    color: AppColors.yellow,
                    fontSize: context.getConditionalFont(),
                  //  fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildJobTile(
                image: AppAssets.job1,
                title: AppStrings.festivalGizzaJob,
                context: context,
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.festivalsJob);
                  // Navigate to add job screen if needed
                },
              ),
              const Divider(color: Colors.yellow, thickness: 1),
              // Conditional spacing between job tiles

              _buildJobTile(
                image: AppAssets.job2,
                title: AppStrings.festieHerosJob,
                context: context,
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.festivalsJob);
                  // Navigate to another add post screen if needed
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildJobTile({
    required String image,
    required String title,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: context.responsiveSpaceXS),
        padding: EdgeInsets.symmetric(horizontal: context.responsivePaddingS.left, vertical: context.responsivePaddingS.top),
        decoration: BoxDecoration(
          // color: Colors.white.withOpacity(0.1),
          // borderRadius: BorderRadius.circular(10),
          // border: Border.all(color: Colors.yellow, width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            /// Left side (Image + Text)
            Expanded(
              child: Row(
                children: [

                  /// Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                    child: Image.asset(
                      image,
                      width: AppDimensions.imageM,
                      height: AppDimensions.imageM,
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Conditional spacing between image and text

                  /// Text — flexible and ellipsis
                  Expanded(
                    child: ResponsiveTextWidget(
                      title,
                      textType: TextType.body,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: AppDimensions.textL,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            /// Chevron icon (outside Expanded)
            const Icon(Icons.chevron_right, color: Colors.yellow),
          ],
        ),
      ),
    );
  }
}
