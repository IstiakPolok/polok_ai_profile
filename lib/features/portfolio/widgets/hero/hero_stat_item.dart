import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class HeroStatItem extends StatelessWidget {
  final String label;
  final String value;
  final bool alignRight;

  const HeroStatItem({
    super.key,
    required this.label,
    required this.value,
    this.alignRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}
