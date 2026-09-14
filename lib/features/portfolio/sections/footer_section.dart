import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      color: AppColors.footerBg,
      child: const Center(
        child: Text(
          "Designed by Polok AI",
          style: TextStyle(color: Colors.white24),
        ),
      ),
    );
  }
}
