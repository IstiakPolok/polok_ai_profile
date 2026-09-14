import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/data/profile_data.dart';

class SkillsSection extends StatelessWidget {
  final bool isMobile;

  const SkillsSection({
    super.key,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 100,
        vertical: 60,
      ),
      child: Column(
        children: [
          const Text(
            "Skills",
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn().slideX(begin: -0.2),
          const SizedBox(height: 50),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: ProfileData.organizedSkills.entries.map((entry) {
              return Container(
                width: isMobile ? double.infinity : 300,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardBg.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: entry.value.map((skill) {
                        return Chip(
                          label: Text(
                            skill,
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.white10,
                          side: BorderSide.none,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            }).toList(),
          ).animate().fadeIn().slideY(begin: 0.1),
        ],
      ),
    );
  }
}
