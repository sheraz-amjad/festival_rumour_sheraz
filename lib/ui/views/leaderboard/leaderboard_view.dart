import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/base_view.dart';
import '../../../shared/widgets/responsive_text_widget.dart';
import 'leaderboard_view_model.dart';

class LeaderboardView extends BaseView<LeaderboardViewModel> {
  const LeaderboardView({super.key});

  @override
  LeaderboardViewModel createViewModel() => LeaderboardViewModel();

  @override
  Widget buildView(BuildContext context, LeaderboardViewModel viewModel) {
    return Scaffold(
      body: Stack(
        children: [
          LeaderboardWidgets.buildBackground(),
          SafeArea(
            child: Column(
              children: [
                LeaderboardWidgets.buildAppBar(context),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingM),
                    child: Column(
                      children: [
                        const SizedBox(height: AppDimensions.paddingS),
                        LeaderboardWidgets.buildTitle(),
                        const SizedBox(height: AppDimensions.paddingL),
                        // Top 3 podium section
                        if (viewModel.leaders.length >= 3)
                          LeaderboardWidgets.buildPodiumSection(
                            first: viewModel.leaders[0],
                            second: viewModel.leaders[1],
                            third: viewModel.leaders[2],
                          ),
                        const SizedBox(height: AppDimensions.paddingL),
                        // Leaderboard list
                        ...viewModel.leaders.asMap().entries.map((entry) {
                          final index = entry.key;
                          final leader = entry.value;
                          return LeaderboardWidgets.buildLeaderCard(
                            rank: leader['rank'],
                            name: leader['name'],
                            badge: leader['badge'],
                            isTopThree: index < 3,
                          );
                        }),
                        const SizedBox(height: AppDimensions.paddingXL),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class LeaderboardWidgets {
  /// 🔹 AppBar Section
  static Widget buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingS,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button with glassmorphism
          Material(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.all(10),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
              ),
            ),
          ),

          const ResponsiveTextWidget(
            AppStrings.leaderBoard,
            textType: TextType.title,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: AppDimensions.textXL,
          ),

          // PRO badge with glow effect
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.accent, AppColors.accent.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withOpacity(0.5),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.workspace_premium, color: Colors.white, size: 20),
                SizedBox(width: 6),
                ResponsiveTextWidget(
                  AppStrings.pro,
                  textType: TextType.body,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: AppDimensions.textS,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Background Image with Overlay
  static Widget buildBackground() {
    return Stack(
      children: [
        Image.asset(
          AppAssets.leaderboard,
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        ),
        Container(
          color: Colors.black.withOpacity(0.4), // overlay for readability
        ),
      ],
    );
  }

  /// 🔹 Title Section with Enhanced Glass Effect
  static Widget buildTitle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingL,
        vertical: AppDimensions.paddingM,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 6),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
            spreadRadius: -5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_events,
            color: Colors.amber.shade300,
            size: 32,
          ),
          const SizedBox(width: AppDimensions.paddingS),
          Flexible(
            child: ResponsiveTextWidget(
              AppStrings.lunaFest2025,
              textType: TextType.heading,
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: AppDimensions.textXXL,
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Podium Section for Top 3
  static Widget buildPodiumSection({
    required Map<String, dynamic> first,
    required Map<String, dynamic> second,
    required Map<String, dynamic> third,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.12),
            Colors.white.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Second Place
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.grey.shade400, Colors.blueGrey.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.workspace_premium,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingS),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingS,
                    vertical: AppDimensions.paddingXS,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      ResponsiveTextWidget(
                        second['name'] ?? '',
                        textType: TextType.body,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: AppDimensions.textS,
                      ),
                      const SizedBox(height: 2),
                      ResponsiveTextWidget(
                        '2nd',
                        textType: TextType.caption,
                        color: Colors.white70,
                        fontSize: AppDimensions.textXS,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // First Place (Taller)
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.amber.shade400, Colors.orange.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber.withOpacity(0.6),
                        blurRadius: 20,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.emoji_events,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingS),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingM,
                    vertical: AppDimensions.paddingS,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.amber.withOpacity(0.3),
                        Colors.orange.withOpacity(0.2),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.amber.withOpacity(0.5),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      ResponsiveTextWidget(
                        first['name'] ?? '',
                        textType: TextType.body,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: AppDimensions.textM,
                      ),
                      const SizedBox(height: 2),
                      ResponsiveTextWidget(
                        '1st',
                        textType: TextType.caption,
                        color: Colors.amber.shade100,
                        fontSize: AppDimensions.textS,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Third Place
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.brown.shade400, Colors.orange.shade700],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.brown.withOpacity(0.5),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.military_tech,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingS),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingS,
                    vertical: AppDimensions.paddingXS,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      ResponsiveTextWidget(
                        third['name'] ?? '',
                        textType: TextType.body,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: AppDimensions.textS,
                      ),
                      const SizedBox(height: 2),
                      ResponsiveTextWidget(
                        '3rd',
                        textType: TextType.caption,
                        color: Colors.white70,
                        fontSize: AppDimensions.textXS,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Leaderboard Card with Enhanced Design
  static Widget buildLeaderCard({
    required int rank,
    required String name,
    required String badge,
    bool isTopThree = false,
  }) {
    // Skip rendering if already shown in podium
    if (isTopThree && rank <= 3) {
      return const SizedBox.shrink();
    }

    final rankColor = rank <= 3
        ? (rank == 1
            ? Colors.amber
            : rank == 2
                ? Colors.grey.shade400
                : Colors.brown.shade400)
        : Colors.white.withOpacity(0.7);

    final rankGradient = rank == 1
        ? LinearGradient(
            colors: [Colors.amber.shade400, Colors.orange.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : rank == 2
            ? LinearGradient(
                colors: [Colors.grey.shade400, Colors.blueGrey.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : rank == 3
                ? LinearGradient(
                    colors: [Colors.brown.shade400, Colors.orange.shade700],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null;

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: AppDimensions.paddingXS,
        horizontal: AppDimensions.paddingM,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingS,
      ),
      decoration: BoxDecoration(
        gradient: rankGradient != null
            ? rankGradient
            : LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.5),
                  Colors.black.withOpacity(0.3),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: rank <= 3
              ? Colors.white.withOpacity(0.5)
              : Colors.white.withOpacity(0.1),
          width: rank <= 3 ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: rank <= 3
                ? rankColor.withOpacity(0.4)
                : Colors.black.withOpacity(0.3),
            blurRadius: rank <= 3 ? 12 : 6,
            offset: Offset(0, rank <= 3 ? 4 : 2),
            spreadRadius: rank <= 3 ? 1 : 0,
          ),
        ],
      ),
      child: Row(
        children: [
          // Rank number with background
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: rank <= 3
                  ? Colors.white.withOpacity(0.25)
                  : Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Center(
              child: ResponsiveTextWidget(
                '#$rank',
                textType: TextType.body,
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: rank <= 3 ? AppDimensions.textM : AppDimensions.textS,
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.paddingM),
          // Avatar with icon
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              gradient: rank <= 3
                  ? rankGradient
                  : LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.2),
                        Colors.white.withOpacity(0.1),
                      ],
                    ),
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: AppDimensions.avatarM,
              backgroundColor: Colors.white.withOpacity(0.2),
              child: Icon(
                rank == 1
                    ? Icons.emoji_events
                    : rank == 2
                        ? Icons.workspace_premium
                        : rank == 3
                            ? Icons.military_tech
                            : Icons.person,
                color: rank <= 3 ? Colors.white : Colors.white70,
                size: rank <= 3 ? 28 : 24,
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.paddingM),
          // Name and badge
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ResponsiveTextWidget(
                  name,
                  textType: TextType.body,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: AppDimensions.textM,
                ),
                const SizedBox(height: 2),
                ResponsiveTextWidget(
                  badge,
                  textType: TextType.caption,
                  color: Colors.white.withOpacity(0.8),
                  fontSize: AppDimensions.textXS,
                ),
              ],
            ),
          ),
          // Trophy icon for top 3
          if (rank <= 3)
            Icon(
              Icons.workspace_premium,
              color: rankColor,
              size: 24,
            ),
        ],
      ),
    );
  }
}
