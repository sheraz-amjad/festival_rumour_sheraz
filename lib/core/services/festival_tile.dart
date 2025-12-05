import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class FestivalTile extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const FestivalTile({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: AppColors.lightGrey),
        title: Text(title),
        trailing: SizedBox(
          width: 40,
          height: 40,
          child: IconButton(onPressed: onTap, icon: const Icon(Icons.favorite_border)),
        ),
      ),
    );
  }
}
