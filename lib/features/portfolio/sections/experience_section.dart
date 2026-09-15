import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/data/profile_data.dart';

class ExperienceSection extends StatelessWidget {
  final bool isMobile;

  const ExperienceSection({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final alignRight = !isMobile;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 100,
        vertical: 60,
      ),
      child: Align(
        alignment: alignRight ? Alignment.centerRight : Alignment.center,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: Column(
            crossAxisAlignment: alignRight
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Experience",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ).animate().fadeIn().slideX(begin: 0.2),
              const SizedBox(height: 10),
              Text(
                "My professional journey and career highlights.",
                textAlign: alignRight ? TextAlign.right : TextAlign.center,
                style: const TextStyle(color: Colors.white54),
              ),
              const SizedBox(height: 40),
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
                          color: AppColors.cardBg.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.35),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: alignRight
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Text(
                              exp['position']!,
                              textAlign: alignRight
                                  ? TextAlign.right
                                  : TextAlign.left,
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "${exp['company']} | ${exp['duration']}",
                              textAlign: alignRight
                                  ? TextAlign.right
                                  : TextAlign.left,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              exp['description']!,
                              textAlign: alignRight
                                  ? TextAlign.right
                                  : TextAlign.left,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      )
                      .animate()
                      .fadeIn(delay: (index * 100).ms)
                      .slideY(begin: 0.1);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
