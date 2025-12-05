import 'package:festival_rumour/ui/views/homeview/widgets/post_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/utils/backbutton.dart';
import '../../../core/utils/base_view.dart';
import '../../../core/router/app_router.dart';
import '../../../shared/widgets/responsive_widget.dart';
import '../../../shared/widgets/responsive_text_widget.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/extensions/context_extensions.dart';
import 'rumors_viewmodel.dart';

class RumorsView extends BaseView<RumorsViewModel> {
  const RumorsView({super.key, this.onBack});
  final VoidCallback? onBack;

  @override
  RumorsViewModel createViewModel() => RumorsViewModel();

  @override
  void onViewModelReady(RumorsViewModel viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.loadRumors();
  }

  @override
  Widget buildView(BuildContext context, RumorsViewModel viewModel) {
    return WillPopScope(
      onWillPop: () async {
        if (onBack != null) {
          onBack!();
          return false;
        }
        return true;
      },

      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            // Background Image - Full screen coverage
            Positioned.fill(
              child: Image.asset(AppAssets.bottomsheet, fit: BoxFit.cover),
            ),

            // Main Content
            SafeArea(
              child: Column(
                children: [
                  _buildAppBar(context, viewModel),
                  Expanded(child: _buildRumorsList(context, viewModel)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, RumorsViewModel viewModel) {
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
          CustomBackButton(
            onTap:
                onBack ??
                () {
                  // Navigate back to discover screen
                  Navigator.pop(context);
                },
          ),
          // Logo with responsive sizing
          const SizedBox(width: AppDimensions.spaceM),
          // Title - Flexible to prevent overflow
          Expanded(
            child: ResponsiveTextWidget(
              AppStrings.rumors,
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
        ],
      ),
    );
  }

  Widget _buildRumorsList(BuildContext context, RumorsViewModel viewModel) {
    if (viewModel.isLoading && viewModel.rumors.isEmpty) {
      return const LoadingWidget(message: AppStrings.loadingPosts);
    }

    if (viewModel.rumors.isEmpty) {
      return Center(
        child: ResponsiveTextWidget(
          AppStrings.noPostsAvailable,
          textType: TextType.body,
          color: AppColors.onPrimary,
          fontSize: AppDimensions.textM,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceS),
      itemCount: viewModel.rumors.length,
      itemBuilder: (context, index) {
        final rumor = viewModel.rumors[index];
        return Column(
          children: [
            PostWidget(post: rumor),
            // Add spacing except after the last post
            if (index != viewModel.rumors.length - 1)
              const SizedBox(height: AppDimensions.spaceM),
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
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: ResponsiveTextWidget(
                    AppStrings.postJob,
                    textType: TextType.title,
                    color: AppColors.yellow,
                    fontSize: AppDimensions.textL,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildJobTile(
                image: AppAssets.job1,
                title: AppStrings.festivalGizzaJob,
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.festivalsJob);
                },
              ),
              const Divider(color: AppColors.yellow, thickness: 1),
              const SizedBox(height: AppDimensions.spaceS),
              _buildJobTile(
                image: AppAssets.job2,
                title: AppStrings.festieHerosJob,
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.festivalsJob);
                },
              ),
              const SizedBox(height: AppDimensions.paddingS),
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
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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

                  const SizedBox(width: AppDimensions.paddingS),

                  /// Text — flexible and ellipsis
                  Expanded(
                    child: ResponsiveTextWidget(
                      title,
                      textType: TextType.body,
                      color: AppColors.white,
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
            const Icon(Icons.chevron_right, color: AppColors.yellow),
          ],
        ),
      ),
    );
  }
}
