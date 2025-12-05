import 'package:festival_rumour/shared/widgets/responsive_widget.dart';
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/router/app_router.dart';
import '../profile_list_view_model.dart';

class FollowersTab extends StatelessWidget {
  final ProfileListViewModel viewModel;
  const FollowersTab({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// 🔹 Search Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM, vertical: AppDimensions.paddingS),
          child: TextField(
            style: const TextStyle(color: AppColors.primary),
            cursorColor: AppColors.primary,
            decoration: InputDecoration(
              hintText: AppStrings.searchFollowers,
              hintStyle: const TextStyle(color: AppColors.primary),
              prefixIcon: const Icon(Icons.search, color: AppColors.primary),
              filled: true,
              fillColor: AppColors.onPrimary.withOpacity(0.3),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
                borderSide: const BorderSide(color: AppColors.onPrimary, width: 2), // ✅ White border when active
              ),
            ),
            onChanged: viewModel.searchFollowers,
          ),
        ),

        /// 🔹 List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
            itemCount: viewModel.followers.length,
            itemBuilder: (context, index) {
              final follower = viewModel.followers[index];
              return Container(
                margin: const EdgeInsets.only(bottom: AppDimensions.paddingS),
                padding: const EdgeInsets.all(AppDimensions.paddingM),
                decoration: BoxDecoration(
                  color: AppColors.black,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  border: Border.all(
                    color: AppColors.white,
                    width: AppDimensions.dividerThickness,
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: AppDimensions.avatarS,
                      backgroundImage: AssetImage(follower['image'] ?? ''),
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                    ),
                    const SizedBox(width: AppDimensions.paddingXS),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ResponsiveText(
                            follower['name'] ?? 'Unknown User',
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: AppDimensions.textL,
                            //  fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.spaceXS),
                          ResponsiveText(
                            follower['username'] ?? '',
                            style: const TextStyle(
                              color: AppColors.grey600,
                              fontSize: AppDimensions.textM,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: AppDimensions.buttonHeightM,
                      margin: const EdgeInsets.only(right: AppDimensions.spaceS),
                      child: ElevatedButton(
                        onPressed: () {
                          // Remove user from followers list
                          viewModel.removeFollower(follower);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: AppColors.onPrimary,
                          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                          ),
                        ),
                        child: const ResponsiveText(
                          'Unfollow',
                          style: TextStyle(
                            fontSize: AppDimensions.textM,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                PopupMenuButton<String>(
                  color: AppColors.primary,
                  icon: const Icon(
                    Icons.more_vert,
                    color: AppColors.white,
                  ),
                  itemBuilder: (BuildContext context) => [
                     PopupMenuItem<String>(
                      value: 'Message',
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to chat view
                          Navigator.pushNamed(context, AppRoutes.chat);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: AppColors.onPrimary,
                          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                          ),
                        ),

                        child: const ResponsiveText(
                          'Message',
                          style: TextStyle(
                            fontSize: AppDimensions.textM,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                    ),
                  ],
                ),
                ]
              ),
              );
            },
          ),
        ),
      ],
    );
  }
}
