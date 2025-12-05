import 'package:festival_rumour/shared/extensions/context_extensions.dart';
import 'package:festival_rumour/ui/views/Profile/profilelist/widgets/festivals_tab.dart';
import 'package:festival_rumour/ui/views/Profile/profilelist/widgets/followers_tab.dart';
import 'package:festival_rumour/ui/views/Profile/profilelist/widgets/following_tab.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/backbutton.dart';
import '../../../../core/utils/base_view.dart';
import '../../../../shared/widgets/responsive_text_widget.dart';
import 'profile_list_view_model.dart';


class ProfileListView extends BaseView<ProfileListViewModel> {
  final int initialTab; // 0 = Followers, 1 = Following, 2 = Festivals
  final String Username;
  final VoidCallback? onBack;

  const ProfileListView({
    super.key,
    required this.initialTab,
    required this.Username,
    this.onBack,
  });

  @override
  ProfileListViewModel createViewModel() => ProfileListViewModel();

  @override
  void onViewModelReady(ProfileListViewModel viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.setTab(initialTab);
  }

  @override
  Widget buildView(BuildContext context, ProfileListViewModel viewModel) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          /// 🔹 Background
          Positioned.fill(
            child: Image.asset(
              AppAssets.bottomsheet,
              fit: BoxFit.cover,
            ),
          ),

          /// 🔹 Foreground UI
          SafeArea(
            child: Column(
              children: [
                /// 🔹 App Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM, vertical: AppDimensions.paddingM),
                  child: Row(
                    children: [
                      CustomBackButton(onTap: () {
                        if (onBack != null) {
                          onBack!();
                        } else {
                          Navigator.pop(context);
                        }
                      }),
                      SizedBox(width: context.isLargeScreen ? 16 : context.isMediumScreen ? 12 : 10),
                      ResponsiveTextWidget(
                        Username,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: AppDimensions.textXL,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.refresh, color: AppColors.white),
                        onPressed: viewModel.refreshList,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppDimensions.paddingS),

                /// 🔹 Tabs Row
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      _buildTabButton(
                        label: AppStrings.followers,
                        isActive: viewModel.currentTab == 0,
                        onTap: () => viewModel.setTab(0),
                      ),
                      _buildTabButton(
                        label: AppStrings.following,
                        isActive: viewModel.currentTab == 1,
                        onTap: () => viewModel.setTab(1),
                      ),
                      _buildTabButton(
                        label: AppStrings.festivals,
                        isActive: viewModel.currentTab == 2,
                        onTap: () => viewModel.setTab(2),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppDimensions.paddingS),

                /// 🔹 Tab View
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _buildTabView(viewModel),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabView(ProfileListViewModel viewModel) {
    switch (viewModel.currentTab) {
      case 0:
        return FollowersTab(viewModel: viewModel);
      case 1:
        return FollowingTab(viewModel: viewModel);
      case 2:
        return FestivalsTab(viewModel: viewModel);
      default:
        return FollowersTab(viewModel: viewModel);
    }
  }

  Widget _buildTabButton({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingXL, vertical: AppDimensions.paddingM),
          decoration: BoxDecoration(
            color: isActive ? AppColors.accent : AppColors.onPrimary,
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
          child: ResponsiveTextWidget(
            label,
            textType: TextType.body,
              color: isActive ? AppColors.onPrimary : AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
  }
}
