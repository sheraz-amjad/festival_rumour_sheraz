import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback onTap;

  const CustomBackButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFFEFEFEF), // light gray circle background
        ),
        child: const Icon(
          Icons.arrow_back,
          color: AppColors.onPrimary,
          size: 22,
        ),
      ),
    );
  }
}
