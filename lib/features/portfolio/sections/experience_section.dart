import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/data/profile_data.dart';

class ExperienceSection extends StatelessWidget {
  final bool isMobile;

  const ExperienceSection({
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
            "Experience",
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn().slideX(begin: -0.2),
          const SizedBox(height: 50),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: ProfileData.workExperience.length,
            itemBuilder: (context, index) {
              final exp = ProfileData.workExperience[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.cardBg.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exp['position']!,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "${exp['company']} | ${exp['duration']}",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      exp['description']!,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: (index * 100).ms).slideY(begin: 0.1);
            },
          ),
        ],
      ),
    );
  }
}
