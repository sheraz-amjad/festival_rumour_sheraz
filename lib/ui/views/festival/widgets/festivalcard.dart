import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../festival_model.dart';


class FestivalCard extends StatelessWidget {
  final FestivalModel festival;
  final VoidCallback? onBack;
  final VoidCallback? onTap;
  final VoidCallback? onNext;

  const FestivalCard({
    super.key,
    required this.festival,
    this.onBack,
    this.onTap,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: AppDimensions.eventCardAspectRatio,
        child: Stack(
          children: [
            // Main Event Card
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                image: DecorationImage(
                  image: AssetImage(festival.imagepath),
                  fit: BoxFit.cover,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                child: Stack(
                  children: [
                    // Overlay
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.eventOverlay,
                      ),
                    ),

                    // NOW badge
                    if (festival.isLive)
                      Positioned(
                        top: AppDimensions.paddingS,
                        left: AppDimensions.paddingS,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.paddingM,
                              vertical: AppDimensions.paddingXS),
                          decoration: BoxDecoration(
                            color: AppColors.nowBadge,
                            borderRadius:
                            BorderRadius.circular(AppDimensions.radiusS),
                          ),
                          child: const Text(
                            AppStrings.nowBadgeText,
                            style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: AppDimensions.textXL,
                            ),
                          ),
                        ),
                      ),

                    // Back icon
                    Positioned(
                      top: AppDimensions.paddingS,
                      right: AppDimensions.paddingS,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.onPrimary,
                          border: Border.all(
                            color: AppColors.primary, // border color
                            width: 2.0, // border thickness
                          ),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.primary,
                          ),
                          onPressed: onNext,
                        ),
                      ),
                    ),

                    // Bottom Info
                    Positioned(
                      left: AppDimensions.paddingL,
                      right: AppDimensions.paddingL,
                      bottom: AppDimensions.paddingL,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            festival.location,
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: AppDimensions.textS,
                              letterSpacing: 1,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppDimensions.spaceXS),
                          Text(
                            festival.title,
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: AppDimensions.textXXL,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppDimensions.spaceXS),
                          Text(
                            festival.date,
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: AppDimensions.textS,
                            ),
                            textAlign: TextAlign.center,
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
      ),
    );
  }
}
