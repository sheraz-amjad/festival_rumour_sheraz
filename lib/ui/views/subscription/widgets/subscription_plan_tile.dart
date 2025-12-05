import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';


class SubscriptionPlanTile extends StatelessWidget {
  final String label;
  final String price;
  final bool isSelected;
  final VoidCallback onTap;

  const SubscriptionPlanTile({
    super.key,
    required this.label,
    required this.price,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: AppDimensions.spaceXS + 2),
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM, vertical: AppDimensions.size14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.warning : AppColors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: Border.all(
            color: isSelected ? AppColors.warning : AppColors.black,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: TextStyle(
                  color: isSelected ? AppColors.white : AppColors.black,
                  fontWeight: FontWeight.bold,
                )),
            Text(price,
                style: TextStyle(
                  color: isSelected ? AppColors.white : AppColors.black,
                )),
          ],
        ),
      ),
    );
  }
}
