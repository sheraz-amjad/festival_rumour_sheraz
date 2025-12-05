import 'package:flutter/material.dart';

class SettingTile extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingTile({super.key, required this.title, this.trailing, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: SizedBox(
        width: 48,
        child: Align(
          alignment: Alignment.centerRight,
          child: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
        ),
      ),
    );
  }
}
