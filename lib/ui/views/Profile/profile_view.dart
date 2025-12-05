import 'package:festival_rumour/core/constants/app_strings.dart';
import 'package:festival_rumour/shared/extensions/context_extensions.dart';
import 'package:festival_rumour/shared/widgets/responsive_widget.dart';
import 'package:festival_rumour/shared/widgets/responsive_text_widget.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/router/app_router.dart';
import '../../../core/utils/backbutton.dart';
import '../../../core/services/auth_service.dart';

class ProfileView extends StatefulWidget {
  final VoidCallback? onBack;
  final Function(String)? onNavigateToSub;
  const ProfileView({super.key, this.onBack, this.onNavigateToSub});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  int selectedTab = 0; // 0 = Posts, 1 = Reels, 2 = Reposts
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print("🔙 Profile screen back button pressed");
        if (widget.onBack != null) {
          widget.onBack!(); // Navigate to home tab
          return false; // Prevent default back behavior
        }
        return true;
      },
      child: Scaffold(
        // floatingActionButton: _buildFloatingButton(context), // ✅ Add FAB here
        // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: Stack(

          children: [

            /// 🔹 Fullscreen background image
            Positioned.fill(
              child: Image.asset(
                AppAssets.bottomsheet,
                fit: BoxFit.cover,
              ),
            ),

            /// 🔹 Dark overlay for readability
            Positioned.fill(
              child: Container(color: AppColors.overlayBlack45),
            ),

            /// 🔹 Apply SafeArea to the WHOLE scrollable content
            SafeArea(
              child: CustomScrollView(
                slivers: [

                  /// 🔹 Top Bar as Sliver
                  SliverToBoxAdapter(
                    child: _profileTopBarWidget(),
                  ),
                  
                  /// 🔹 Divider after app bar
                  SliverToBoxAdapter(
                      child: _divider(),
                  ),
                  
                 // SizedBox(height: AppDimensions.spaceXS),

                  /// 🔹 Profile Header (Collapsible)
                  SliverAppBar(

                    expandedHeight: context.isSmallScreen
                        ? context.screenHeight * 0.25
                        : context.isMediumScreen
                        ? context.screenHeight * 0.24
                        : context.screenHeight * 0.24,
                    floating: false,
                    pinned: false,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    automaticallyImplyLeading: false,
                    flexibleSpace: FlexibleSpaceBar(
                      background: _buildProfileHeader(),
                    ),
                  ),


                  /// 🔹 Profile Tabs (Pinned)
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _ProfileTabsDelegate(
                      child: Container(
                        height: AppDimensions.buttonHeightXL,
                        color: AppColors.black.withOpacity(0.8),
                        child: _profileTabs(),
                      ),
                    ),
                  ),

                  /// 🔹 Dynamic Content
                  SliverToBoxAdapter(
                    child: Container(
                      color: AppColors.black.withOpacity(0.8),
                      child: _buildDynamicContent(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  // Widget _buildFloatingButton(BuildContext context) {
  //   return Container(
  //     margin: const EdgeInsets.only(bottom: 10, right: 5), // Fine-tuned position
  //     child: FloatingActionButton(
  //       onPressed: () {
  //         _showPostBottomSheet(context);
  //       },
  //       backgroundColor: AppColors.onPrimary,
  //       child: const Icon(Icons.add, color: Colors.white, size: 30),
  //       elevation: 8,
  //       shape: const CircleBorder(),
  //     ),
  //   );
  // }


        /// ---------------- INSTAGRAM-LIKE PROFILE HEADER ----------------
  Widget _buildProfileHeader() {
    //final mediaQuery = MediaQuery.maybeOf(context);
   // final topPadding = mediaQuery?.padding.top ?? 0.0;

    return Container(
      padding: context.responsivePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          /// Profile info (Username & followers left — Picture right)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
               radius: context.isLargeScreen ? 55 : context.isMediumScreen ? 50 : 50,
                backgroundImage: _authService.userPhotoUrl != null
                    ? NetworkImage(_authService.userPhotoUrl!)
                    : const AssetImage(AppAssets.profile),
                onBackgroundImageError: (exception, stackTrace) {
                  // Fallback to default image if network image fails
                  print('Error loading profile image: $exception');
                },
              ),
              SizedBox(width: context.getConditionalSpacing()),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Username
                    ResponsiveTextWidget(
                      _authService.userDisplayName ?? AppStrings.name,
                    //  textType: TextType.title,
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: AppDimensions.textL,
                    ),
                    SizedBox(height: AppDimensions.spaceS),
                    // Stats aligned with profile picture width
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildClickableStat("120", AppStrings.posts, () {
                          if (widget.onNavigateToSub != null) {
                            widget.onNavigateToSub!('posts');
                          } else {
                            Navigator.pushNamed(context, AppRoutes.posts);
                          }
                        }),
                        SizedBox(width: context.getConditionalSpacing()),
                        _buildClickableStat("5.4K", AppStrings.followers, () {
                          if (widget.onNavigateToSub != null) {
                            widget.onNavigateToSub!('followers');
                          } else {
                            Navigator.pushNamed(context, AppRoutes.profileList,
                                arguments: 0);
                          }
                        }),
                        SizedBox(width: context.getConditionalSpacing()),
                        _buildClickableStat("340", AppStrings.following, () {
                          if (widget.onNavigateToSub != null) {
                            widget.onNavigateToSub!('following');
                          } else {
                            Navigator.pushNamed(context, AppRoutes.profileList,
                                arguments: 1);
                          }
                        }),
                        SizedBox(width: context.getConditionalSpacing()),
                        _buildClickableStat("3", AppStrings.festivals, () {
                          if (widget.onNavigateToSub != null) {
                            widget.onNavigateToSub!('festivals');
                          } else {
                            Navigator.pushNamed(context, AppRoutes.profileList,
                                arguments: 2);
                          }
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: context.getConditionalSpacing()),

          /// Bio / Description below profile picture
          ResponsiveTextWidget(
            AppStrings.bioDescription,
            color: AppColors.white,
           // textType: TextType.heading,
            fontSize: context.getConditionalFont(),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }

  /// ---------------- DYNAMIC CONTENT ----------------
  Widget _buildDynamicContent() {
    return Column(
      children: [
       // SizedBox(height: context.isLargeScreen ? 20 : context.isMediumScreen ? 16 : 12),
        if (selectedTab == 0) _profileGridWidget(),
        if (selectedTab == 1) _profileReelsWidget(),
        if (selectedTab == 2) _profileRepostsWidget(),
      ],
    );
  }
  /// ---------------- TOP BAR ----------------
  Widget _profileTopBarWidget() {
    return Padding(
      padding: context.responsivePadding,
      child: Row(
        children: [
          /// Back button
          CustomBackButton(
            onTap: widget.onBack ?? () {},
          ),

          SizedBox(width: AppDimensions.spaceM),

          /// Profile title
          ResponsiveTextWidget(
            AppStrings.profile,
            textType: TextType.title,
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: context.getConditionalMainFont(),
          ),

          /// Spacer to push icons to the right
          const Spacer(),

          /// Right-side icons
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              IconButton(
                onPressed: () => _showPostBottomSheet(context),
                icon: Icon(Icons.add_box_outlined,
                    color: AppColors.white, 
                    size: AppDimensions.iconL),
                padding: context.responsivePadding,
                constraints: BoxConstraints(
                  minWidth: context.getConditionalIconSize(),
                  minHeight: context.getConditionalIconSize(),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.notification);
                },
                icon: Icon(Icons.notifications_none,
                    color: AppColors.white, 
                    size: AppDimensions.iconL),
                padding: context.responsivePadding,
                constraints: BoxConstraints(
                  minWidth: context.getConditionalIconSize(),
                  minHeight: context.getConditionalIconSize(),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.settings);
                },
                icon: Icon(Icons.settings,
                    color: AppColors.white, 
                    size: AppDimensions.iconL),
                padding: context.responsivePadding,
                constraints: BoxConstraints(
                  minWidth: context.getConditionalIconSize(),
                  minHeight: context.getConditionalIconSize(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _divider(){
    return  Container(
      width: double.infinity,
      // Remove any outer spacing
      child: const Divider(
        color: AppColors.primary,
        thickness: 1,
        height: 1,// end at very right
      ),
    );
  }
  /// ---------------- GRID / REELS / REPOSTS ----------------
  Widget _profileGridWidget() {
    final List<String> images = AppAssets.profilePosts;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.isLargeScreen ? 4 : context.isMediumScreen ? 3 : 3,
        mainAxisSpacing: context.isLargeScreen ? 4 : 2,
        crossAxisSpacing: context.isLargeScreen ? 4 : 2,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            if (widget.onNavigateToSub != null) {
              widget.onNavigateToSub!('posts');
            } else {
              Navigator.pushNamed(context, AppRoutes.posts);
            }
          },
          child: Image.asset(images[index], fit: BoxFit.cover),
        );
      },
    );
  }


  Widget _profileReelsWidget() {
    return Padding(
      padding: EdgeInsets.all(
        context.isSmallScreen 
            ? AppDimensions.paddingM
            : context.isMediumScreen 
                ? AppDimensions.paddingL
                : AppDimensions.paddingXL
      ),
      child: Center(
      ),
    );
  }

  Widget _profileRepostsWidget() {
    return Padding(
      padding: EdgeInsets.all(
        context.isSmallScreen 
            ? AppDimensions.paddingM
            : context.isMediumScreen 
                ? AppDimensions.paddingL
                : AppDimensions.paddingXL
      ),
      child: Center(
      ),
    );
  }

  /// ---------------- HELPERS ----------------
  Widget _buildStat(String count, String label) {
    return Column(
     // mainAxisSize: MainAxisSize.max,
      children: [
        ResponsiveTextWidget(
          count,
          textType: TextType.title,
          color: AppColors.white,
          fontWeight: FontWeight.bold,
         // fontSize: AppDimensions.textM,
          fontSize: context.isHighResolutionPhone ? 16 : 12,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        ResponsiveTextWidget(
          label,
          textType: TextType.caption,
          color: AppColors.white,
        //fontSize: AppDimensions.textXS,
          fontSize: context.isHighResolutionPhone ? 10 : 8,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildClickableStat(String count, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
        child: _buildStat(count, label),
    );
  }


  // Widget _buildMiniStat(String count, String label) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(count,
  //           style: TextStyle(
  //               color: AppColors.white,
  //               fontWeight: FontWeight.bold,
  //               fontSize: context.isSmallScreen
  //                   ? AppDimensions.textS
  //                   : context.isMediumScreen
  //                       ? AppDimensions.textM
  //                       : AppDimensions.textL)),
  //       Text(label,
  //           style: TextStyle(
  //               color: AppColors.white,
  //               fontSize: context.isSmallScreen
  //                   ? AppDimensions.textXS
  //                   : context.isMediumScreen
  //                       ? AppDimensions.textS
  //                       : AppDimensions.textM)),
  //     ],
  //   );
  // }

  Widget _profileTabs() {
    return Container(
      height: AppDimensions.buttonHeightXL,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: _tabIcon(Icons.grid_on, 0),
          ),
          Expanded(
            child: _tabIcon(Icons.video_collection_outlined, 1),
          ),
          Expanded(
            child: _tabIcon(Icons.repeat, 2),
          ),
        ],
      ),
    );
  }

  Widget _tabIcon(IconData icon, int index) {
    return IconButton(
      icon: Icon(
        icon,
        color: selectedTab == index ? AppColors.primary : AppColors.white,
        size: context.responsiveIconM,
      ),
      onPressed: () => setState(() => selectedTab = index),
      padding: EdgeInsets.all(context.responsivePadding.left),
      constraints: BoxConstraints(
        minWidth: context.responsiveIconXL,
        minHeight: context.responsiveIconXL,
      ),
    );
  }

  void _openFullScreenImage(BuildContext context, String imagePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            Scaffold(
              backgroundColor: AppColors.black,
              body: Stack(
                children: [
                  Center(
                    child: InteractiveViewer(
                      child: Image.asset(imagePath, fit: BoxFit.contain),
                    ),
                  ),
                  Positioned(
                    top: context.isSmallScreen 
                        ? AppDimensions.paddingL
                        : context.isMediumScreen 
                            ? AppDimensions.paddingXL
                            : AppDimensions.paddingXXL,
                    left: context.isSmallScreen 
                        ? AppDimensions.paddingM
                        : context.isMediumScreen 
                            ? AppDimensions.paddingL
                            : AppDimensions.paddingXL,
                    child: IconButton(
                      icon: Icon(
                        Icons.close, 
                        color: AppColors.white, 
                        size: context.responsiveIconL,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),
      ),
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
                  child: Text(
                    AppStrings.postJob,
                    style: TextStyle(
                      color: AppColors.yellow,
                      fontSize: AppDimensions.textL,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              _buildJobTile(
                image: AppAssets.job1,
                title: AppStrings.festivalGizzaJob,
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.jobpost);
                  // Navigate to add job screen if needed
                },
              ),
              const Divider(color: AppColors.yellow, thickness: 1),
              const SizedBox(height: AppDimensions.spaceS),
              _buildJobTile(
                image: AppAssets.job2,
                title: AppStrings.festieHerosJob,
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.jobpost);
                  //d post screen if needed
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
                    borderRadius: BorderRadius.circular(8),
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
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: AppDimensions.textL,
                      ),
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

/// ---------------- SLIVER PERSISTENT HEADER DELEGATE ----------------
class _ProfileTabsDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _ProfileTabsDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 56.0;

  @override
  double get minExtent => 56.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
