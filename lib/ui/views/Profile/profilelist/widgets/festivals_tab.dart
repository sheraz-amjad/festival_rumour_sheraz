import 'package:festival_rumour/shared/widgets/responsive_widget.dart';
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_strings.dart';
import '../profile_list_view_model.dart';

class FestivalsTab extends StatefulWidget {
  final ProfileListViewModel viewModel;
  const FestivalsTab({super.key, required this.viewModel});

  @override
  State<FestivalsTab> createState() => _FestivalsTabState();
}

class _FestivalsTabState extends State<FestivalsTab> {
  final Set<int> _favoriteFestivals = {};

  void _toggleFavorite(int index) {
    setState(() {
      if (_favoriteFestivals.contains(index)) {
        _favoriteFestivals.remove(index);
      } else {
        _favoriteFestivals.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM, vertical: AppDimensions.paddingS),
          child: TextField(
            style: const TextStyle(color: AppColors.primary),
            cursorColor: AppColors.primary,
            decoration: InputDecoration(
              hintText: AppStrings.searchFestivals,
              hintStyle: const TextStyle(color: AppColors.primary),
              prefixIcon: const Icon(Icons.search, color: AppColors.primary),
              filled: true,
              fillColor: AppColors.onPrimary.withOpacity(0.3),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
                borderSide: const BorderSide(color: Colors.transparent), // No border when not focused
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
                borderSide: const BorderSide(color: AppColors.onPrimary, width: 2), // ✅ White border when active
              ),
            ),

            onChanged: widget.viewModel.searchFestivals,
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
            itemCount: widget.viewModel.festivals.length,
            itemBuilder: (context, index) {
              final festival = widget.viewModel.festivals[index];
              final isFavorite = _favoriteFestivals.contains(index);
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
                    Container(
                      width: AppDimensions.imageM,
                      height: AppDimensions.imageM,
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppDimensions.avatarS),
                      ),
                      child: const Icon(
                        Icons.military_tech,
                        color: AppColors.accent,
                        size: AppDimensions.imageM,
                      ),
                    ),
                    SizedBox(width: AppDimensions.spaceM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ResponsiveText(
                            festival['title'] ?? 'Unknown Festival',
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: AppDimensions.textM,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: AppDimensions.spaceXS),
                          ResponsiveText(
                            festival['location'] ?? 'Unknown Location',
                            style: const TextStyle(
                              color: AppColors.grey600,
                              fontSize: AppDimensions.textM,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: AppDimensions.spaceXS),
                      child: IconButton(
                        onPressed: () => _toggleFavorite(index),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.transparent,
                        ),
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? AppColors.red : AppColors.white,
                          size: AppDimensions.iconL,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.more_vert,
                        color: AppColors.white,
                      ),
                      onPressed: () {
                        // Handle more options
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
